#!/usr/bin/env node

/**
 * External launcher for a live VisualSpecs canonical.
 *
 * It does not edit or patch VisualSpecs. A Playwright-controlled browser receives
 * a picker-compatible read-only handle whose getFile() reads the canonical path
 * through this Node process. VisualSpecs then uses its normal temporary-file and
 * follow-file flows.
 */

import { access, open, readFile, stat } from 'node:fs/promises';
import { constants as fsConstants } from 'node:fs';
import { spawn } from 'node:child_process';
import { basename, dirname, join, resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

function option(name, fallback = undefined) {
  const at = process.argv.indexOf(`--${name}`);
  if (at === -1) return fallback;
  const value = process.argv[at + 1];
  if (value === undefined || value.startsWith('--')) {
    throw new Error(`--${name} requires a value`);
  }
  return value;
}

const appOption = option('app');
const canonicalOption = option('canonical');
if (appOption === undefined || canonicalOption === undefined) {
  console.error(
    'Usage: node launch-visual-specs.mjs --app <VisualSpecs app dir> --canonical <document.json> [--url http://127.0.0.1:5175]',
  );
  process.exit(2);
}

const appRoot = resolve(appOption);
const canonicalPath = resolve(canonicalOption);
const canonicalName = basename(canonicalPath);
const url = option('url', 'http://127.0.0.1:5175');
const browserCache = join(appRoot, '.playwright-cache');
process.env.PLAYWRIGHT_BROWSERS_PATH ??= browserCache;

await access(join(appRoot, 'package.json'), fsConstants.R_OK);
await access(canonicalPath, fsConstants.R_OK);
const initialText = await readFile(canonicalPath, 'utf8');
const initialJson = JSON.parse(initialText);
if (
  initialJson === null ||
  typeof initialJson !== 'object' ||
  initialJson.formatVersion !== '1.0' ||
  !Array.isArray(initialJson.nodes) ||
  !Array.isArray(initialJson.edges)
) {
  throw new Error(`${canonicalPath} is not a VisualSpecs 1.0 document`);
}

const playwrightEntry = join(appRoot, 'node_modules', 'playwright', 'index.mjs');
await access(playwrightEntry, fsConstants.R_OK).catch(() => {
  throw new Error(`Playwright is not installed at ${playwrightEntry}. Run npm ci in ${appRoot}.`);
});
const { chromium } = await import(pathToFileURL(playwrightEntry).href);

async function serverResponds() {
  try {
    const response = await fetch(url, { signal: AbortSignal.timeout(1000) });
    return response.ok;
  } catch {
    return false;
  }
}

let vite = null;
if (!(await serverResponds())) {
  const logPath = join(dirname(canonicalPath), 'visual-specs-vite.log');
  const logHandle = await open(logPath, 'a');
  vite = spawn('npm', ['run', 'dev', '--', '--host', '127.0.0.1'], {
    cwd: appRoot,
    env: process.env,
    detached: false,
    // Windows cannot execute npm.cmd directly through child_process without a
    // command shell (spawn EINVAL). The command and every argument are static.
    shell: process.platform === 'win32',
    stdio: ['ignore', logHandle.fd, logHandle.fd],
    windowsHide: true,
  });
  vite.once('exit', (code) => {
    if (code !== null && code !== 0) {
      console.error(`Vite exited with code ${code}; see ${logPath}`);
    }
  });

  const deadline = Date.now() + 60_000;
  while (!(await serverResponds())) {
    if (Date.now() >= deadline) {
      vite.kill();
      throw new Error(`VisualSpecs did not become ready at ${url}; see ${logPath}`);
    }
    await new Promise((resolveWait) => setTimeout(resolveWait, 250));
  }
}

const browser = await chromium.launch({
  headless: false,
  args: ['--start-maximized'],
});
const context = await browser.newContext({ viewport: null });
const page = await context.newPage();

await page.exposeFunction('__readVisualSpecsCanonical', async () => {
  const [text, fileStat] = await Promise.all([readFile(canonicalPath, 'utf8'), stat(canonicalPath)]);
  return {
    name: canonicalName,
    text,
    lastModified: Math.trunc(fileStat.mtimeMs),
  };
});

await page.addInitScript((pickedName) => {
  const handle = {
    kind: 'file',
    name: pickedName,
    async getFile() {
      const readCanonical = globalThis.__readVisualSpecsCanonical;
      const current = await readCanonical();
      return new File([current.text], current.name, {
        type: 'application/json',
        lastModified: current.lastModified,
      });
    },
    async queryPermission() {
      return 'granted';
    },
  };

  Object.defineProperty(globalThis, 'showOpenFilePicker', {
    configurable: true,
    writable: true,
    value: async () => [handle],
  });
}, canonicalName);

page.on('pageerror', (error) => console.error(`Browser page error: ${error.message}`));
await page.goto(url, { waitUntil: 'domcontentloaded' });
await page.getByRole('button', { name: 'Open JSON temporarily' }).click();

const rootLabel =
  initialJson.nodes.find((node) => node !== null && typeof node === 'object' && node.parentId === null)?.label ??
  'Gran Idea';
await page.waitForFunction(
  ({ expectedLabel, expectedName }) => {
    const hooks = globalThis.__visualSpecs;
    const raw = hooks?.raw?.();
    return (
      Array.isArray(raw?.nodes) &&
      raw.nodes.some((node) => node?.label === expectedLabel) &&
      document.body.innerText.includes(`Following ${expectedName}`)
    );
  },
  { expectedLabel: rootLabel, expectedName: canonicalName },
  { timeout: 30_000 },
);

console.log(`READY ${url}`);
console.log(`CANONICAL ${canonicalPath}`);
console.log(`FOLLOWING ${canonicalName}`);

let shuttingDown = false;
async function shutdown() {
  if (shuttingDown) return;
  shuttingDown = true;
  await browser.close().catch(() => undefined);
  if (vite !== null) vite.kill();
}

process.once('SIGINT', () => void shutdown().finally(() => process.exit(0)));
process.once('SIGTERM', () => void shutdown().finally(() => process.exit(0)));
await new Promise((resolveClosed) => browser.once('disconnected', resolveClosed));
if (vite !== null) vite.kill();
