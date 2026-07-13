[CmdletBinding()]
param(
    [string]$AppPath = 'C:\Users\maria\0_repos\CodebaseConstellation_iac\.ac\wg-4-vs-dev-team\repo-CodebaseConstellation\CodebaseGuide',
    [string]$Url = 'http://localhost:5175/',
    [ValidateRange(5, 300)]
    [int]$TimeoutSeconds = 30,
    [switch]$NoOpen
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-ExpectedProbe {
    param(
        [Parameter(Mandatory)]
        [string]$TargetUrl
    )

    try {
        $response = Invoke-WebRequest -Uri $TargetUrl -UseBasicParsing -TimeoutSec 3
        $entryUrl = [uri]::new([uri]$TargetUrl, 'src/main.ts').AbsoluteUri
        $entryResponse = Invoke-WebRequest -Uri $entryUrl -UseBasicParsing -TimeoutSec 3
    }
    catch {
        return $null
    }

    $title = [regex]::Match(
        $response.Content,
        '<title>(.*?)</title>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    ).Groups[1].Value

    $contentType = $response.Headers['Content-Type'] -join ';'
    $entryContentType = $entryResponse.Headers['Content-Type'] -join ';'
    [pscustomobject]@{
        Status = [int]$response.StatusCode
        ContentType = $contentType
        EntryStatus = [int]$entryResponse.StatusCode
        EntryContentType = $entryContentType
        Title = $title
        Expected = (
            [int]$response.StatusCode -eq 200 -and
            $contentType -like 'text/html*' -and
            $title -ceq 'CodebaseGuide — AgentsCommander' -and
            [int]$entryResponse.StatusCode -eq 200 -and
            $entryContentType -like 'text/javascript*'
        )
    }
}

function Get-Listener {
    param(
        [Parameter(Mandatory)]
        [int]$Port
    )

    @(Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue) |
        Sort-Object OwningProcess -Unique |
        Select-Object -First 1
}

function Get-ListenerProcess {
    param(
        [Parameter(Mandatory)]
        [int]$ProcessId
    )

    Get-CimInstance Win32_Process -Filter "ProcessId = $ProcessId" -ErrorAction SilentlyContinue
}

function Test-ListenerOwnership {
    param(
        [Parameter(Mandatory)]
        [object]$Listener,
        [Parameter(Mandatory)]
        [string]$ResolvedAppPath
    )

    $process = Get-ListenerProcess -ProcessId ([int]$Listener.OwningProcess)
    if ($null -eq $process -or [string]::IsNullOrWhiteSpace($process.CommandLine)) {
        return $false
    }

    $normalizedCommand = $process.CommandLine.Replace('/', '\')
    $normalizedApp = $ResolvedAppPath.TrimEnd('\').Replace('/', '\')
    return $normalizedCommand.IndexOf($normalizedApp, [System.StringComparison]::OrdinalIgnoreCase) -ge 0
}

function Open-VerifiedApp {
    param(
        [Parameter(Mandatory)]
        [string]$TargetUrl
    )

    if (-not $NoOpen) {
        Start-Process $TargetUrl
    }
}

if (-not (Test-Path -LiteralPath $AppPath -PathType Container)) {
    throw "VisualSpecs app directory not found: $AppPath"
}

$resolvedAppPath = (Resolve-Path -LiteralPath $AppPath).Path
$packagePath = Join-Path $resolvedAppPath 'package.json'
if (-not (Test-Path -LiteralPath $packagePath -PathType Leaf)) {
    throw "package.json not found under VisualSpecs app path: $packagePath"
}

$package = Get-Content -Raw -LiteralPath $packagePath | ConvertFrom-Json
if ($package.name -ne 'codebaseguide') {
    throw "Expected package name 'codebaseguide' at $packagePath; found '$($package.name)'."
}

$targetUri = [uri]$Url
if ($targetUri.Scheme -ne 'http' -and $targetUri.Scheme -ne 'https') {
    throw "VisualSpecs URL must use HTTP or HTTPS: $Url"
}
$port = $targetUri.Port

$repoRoot = Split-Path -Parent $resolvedAppPath
$stateRoot = Join-Path $repoRoot '.local\visualspecs-launcher'
$logsRoot = Join-Path $stateRoot 'logs'
$cacheRoot = Join-Path $stateRoot 'npm-cache'
New-Item -ItemType Directory -Force -Path $logsRoot, $cacheRoot | Out-Null

$pathBytes = [System.Text.Encoding]::UTF8.GetBytes($resolvedAppPath.ToLowerInvariant())
$pathHash = [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($pathBytes)).Substring(0, 16)
$mutex = [System.Threading.Mutex]::new($false, "Local\VisualSpecsLauncher-$pathHash")
$hasMutex = $false

try {
    try {
        $hasMutex = $mutex.WaitOne([TimeSpan]::FromSeconds($TimeoutSeconds))
    }
    catch [System.Threading.AbandonedMutexException] {
        $hasMutex = $true
    }

    if (-not $hasMutex) {
        throw "Another VisualSpecs launcher is still active after $TimeoutSeconds seconds."
    }

    $probe = Get-ExpectedProbe -TargetUrl $Url
    $listener = Get-Listener -Port $port
    if ($null -ne $probe -and $probe.Expected -and $null -ne $listener) {
        if (-not (Test-ListenerOwnership -Listener $listener -ResolvedAppPath $resolvedAppPath)) {
            throw "Port $port serves CodebaseGuide, but its listener does not belong to $resolvedAppPath."
        }

        Open-VerifiedApp -TargetUrl $Url
        [pscustomobject]@{
            Url = $Url
            Reused = $true
            Status = $probe.Status
            ContentType = $probe.ContentType
            EntryStatus = $probe.EntryStatus
            Title = $probe.Title
            ListenerPid = [int]$listener.OwningProcess
            StdoutLog = $null
            StderrLog = $null
        }
        return
    }

    if ($null -ne $listener) {
        $listenerProcess = Get-ListenerProcess -ProcessId ([int]$listener.OwningProcess)
        $commandLine = if ($null -eq $listenerProcess) { '<unavailable>' } else { $listenerProcess.CommandLine }
        throw "Port $port is already occupied by PID $($listener.OwningProcess), but it did not pass the VisualSpecs health check. Command: $commandLine"
    }

    $viteBin = Join-Path $resolvedAppPath 'node_modules\vite\bin\vite.js'
    if (-not (Test-Path -LiteralPath $viteBin -PathType Leaf)) {
        $npm = (Get-Command npm.cmd -ErrorAction Stop).Source
        Push-Location $resolvedAppPath
        try {
            & $npm ci --cache $cacheRoot --no-audit --no-fund
            if ($LASTEXITCODE -ne 0) {
                throw "npm ci failed with exit code $LASTEXITCODE."
            }
        }
        finally {
            Pop-Location
        }

        if (-not (Test-Path -LiteralPath $viteBin -PathType Leaf)) {
            throw "npm ci completed without installing Vite at $viteBin."
        }
    }

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $stdoutLog = Join-Path $logsRoot "$timestamp.stdout.log"
    $stderrLog = Join-Path $logsRoot "$timestamp.stderr.log"
    $npm = (Get-Command npm.cmd -ErrorAction Stop).Source
    $launcher = Start-Process -FilePath $npm `
        -ArgumentList @('run', 'dev') `
        -WorkingDirectory $resolvedAppPath `
        -RedirectStandardOutput $stdoutLog `
        -RedirectStandardError $stderrLog `
        -WindowStyle Hidden `
        -PassThru

    $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    do {
        Start-Sleep -Milliseconds 250
        $probe = Get-ExpectedProbe -TargetUrl $Url
        $listener = Get-Listener -Port $port
        if ($null -ne $probe -and $probe.Expected -and $null -ne $listener) {
            break
        }
        if ($launcher.HasExited) {
            $stderr = if (Test-Path -LiteralPath $stderrLog) { Get-Content -Raw -LiteralPath $stderrLog } else { '' }
            throw "VisualSpecs launcher exited with code $($launcher.ExitCode). $stderr"
        }
    } while ([DateTime]::UtcNow -lt $deadline)

    if ($null -eq $probe -or -not $probe.Expected -or $null -eq $listener) {
        if (-not $launcher.HasExited) {
            Stop-Process -Id $launcher.Id -Force -ErrorAction SilentlyContinue
        }
        throw "VisualSpecs did not become healthy at $Url within $TimeoutSeconds seconds. Logs: $stdoutLog ; $stderrLog"
    }

    if (-not (Test-ListenerOwnership -Listener $listener -ResolvedAppPath $resolvedAppPath)) {
        throw "VisualSpecs responded, but listener PID $($listener.OwningProcess) does not belong to $resolvedAppPath."
    }

    Open-VerifiedApp -TargetUrl $Url
    [pscustomobject]@{
        Url = $Url
        Reused = $false
        Status = $probe.Status
        ContentType = $probe.ContentType
        EntryStatus = $probe.EntryStatus
        Title = $probe.Title
        ListenerPid = [int]$listener.OwningProcess
        StdoutLog = $stdoutLog
        StderrLog = $stderrLog
    }
}
finally {
    if ($hasMutex) {
        $mutex.ReleaseMutex()
    }
    $mutex.Dispose()
}
