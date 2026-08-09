import assert from 'node:assert/strict';
import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import test from 'node:test';

const siteRoot = resolve('site');

function htmlFiles(directory) {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const path = resolve(directory, entry.name);
    if (entry.isDirectory()) return htmlFiles(path);
    return entry.name.endsWith('.html') ? [path] : [];
  });
}

const pages = htmlFiles(siteRoot);

function localTarget(page, value) {
  const path = value.split(/[?#]/, 1)[0];
  return value.startsWith('/') ? resolve(siteRoot, path.slice(1)) : resolve(dirname(page), path);
}

test('every page has essential document metadata and an accessible main landmark', () => {
  for (const page of pages) {
    const html = readFileSync(page, 'utf8');
    assert.match(html, /<meta name="viewport"/i, `${page} is missing a viewport meta tag`);
    assert.match(html, /<meta name="description"/i, `${page} is missing a meta description`);
    assert.match(html, /<link rel="icon"/i, `${page} is missing a favicon`);
    assert.match(html, /<main id="main-content">/i, `${page} is missing the main landmark`);
    assert.match(html, /class="skip-link"/i, `${page} is missing a skip link`);
  }
});

test('local HTML assets and links resolve', () => {
  const attributePattern = /(?:src|href)="([^"]+)"/g;
  for (const page of pages) {
    const html = readFileSync(page, 'utf8');
    for (const match of html.matchAll(attributePattern)) {
      const value = match[1];
      if (/^(?:https?:|mailto:|#)/.test(value)) continue;
      const target = localTarget(page, value);
      assert.ok(existsSync(target), `${page} references missing local path ${value}`);
    }
  }
});

test('runtime code is limited to site behavior and the contact form uses its configured endpoint', () => {
  const script = readFileSync(resolve(siteRoot, 'scripts/site.js'), 'utf8');
  assert.doesNotMatch(script, /innerHTML\s*=/i);
  assert.match(script, /fetch\('https:\/\/formsubmit\.co\/ajax\/hello@kikibytes\.com'/);
  assert.match(script, /name = '_honey'/);
  assert.match(script, /cooldownMs = 60_000/);
});

test('every local asset reference points to a file or directory', () => {
  for (const page of pages) {
    const html = readFileSync(page, 'utf8');
    for (const value of html.matchAll(/(?:src|href)="([^"]+)"/g).map((match) => match[1])) {
      if (/^(?:https?:|mailto:|#)/.test(value)) continue;
      const target = localTarget(page, value);
      assert.ok(statSync(target).isFile() || statSync(target).isDirectory());
    }
  }
});

test('content images use WebP and static assets have immutable caching', () => {
  const sources = [
    ...pages.map((page) => readFileSync(page, 'utf8')),
    readFileSync(resolve(siteRoot, 'styles/base.css'), 'utf8'),
    readFileSync(resolve(siteRoot, 'styles/components.css'), 'utf8'),
    readFileSync(resolve(siteRoot, 'styles/pages.css'), 'utf8'),
    readFileSync(resolve(siteRoot, 'scripts/site.js'), 'utf8'),
  ].join('\n');
  const legacyImages = [...sources.matchAll(/assets\/[^\s"')]+\.(?:png|jpe?g)/gi)]
    .map((match) => match[0])
    .filter((path) => !path.endsWith('icons/cat-head-favicon.png'));
  const headers = readFileSync(resolve(siteRoot, '_headers'), 'utf8');

  assert.deepEqual(legacyImages, []);
  assert.match(headers, /\/assets\/\*[\s\S]*Cache-Control: public, max-age=31536000, immutable/);
});
