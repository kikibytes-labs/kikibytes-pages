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
      const target = resolve(dirname(page), value.split(/[?#]/, 1)[0]);
      assert.ok(existsSync(target), `${page} references missing local path ${value}`);
    }
  }
});

test('the site uses no third-party form endpoint or runtime content patching', () => {
  const script = readFileSync(resolve(siteRoot, 'scripts/site.js'), 'utf8');
  const allHtml = pages.map((page) => readFileSync(page, 'utf8')).join('\n');
  assert.doesNotMatch(script, /fetch\(|formsubmit|innerHTML\s*=/i);
  assert.doesNotMatch(allHtml, /formsubmit\.co/i);
});

test('every local asset reference points to a file or directory', () => {
  for (const page of pages) {
    const html = readFileSync(page, 'utf8');
    for (const value of html.matchAll(/(?:src|href)="([^"]+)"/g).map((match) => match[1])) {
      if (/^(?:https?:|mailto:|#)/.test(value)) continue;
      const target = resolve(dirname(page), value.split(/[?#]/, 1)[0]);
      assert.ok(statSync(target).isFile() || statSync(target).isDirectory());
    }
  }
});
