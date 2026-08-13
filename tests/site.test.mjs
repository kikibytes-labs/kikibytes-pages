import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, isAbsolute, relative, resolve, sep } from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';
import { inflateSync } from 'node:zlib';

const repositoryRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const siteRoot = resolve(repositoryRoot, 'site');

function filesWithExtension(directory, extension) {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const path = resolve(directory, entry.name);
    if (entry.isDirectory()) return filesWithExtension(path, extension);
    return entry.name.endsWith(extension) ? [path] : [];
  });
}

function filesRecursively(directory) {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const path = resolve(directory, entry.name);
    if (entry.isDirectory()) return filesRecursively(path);
    return [path];
  });
}

function displayPath(path) {
  return relative(repositoryRoot, path) || '.';
}

function read(path) {
  return readFileSync(path, 'utf8');
}

const pages = filesWithExtension(siteRoot, '.html');
const stylesheets = filesWithExtension(siteRoot, '.css');
const scripts = filesWithExtension(siteRoot, '.js');
const assetRoot = resolve(siteRoot, 'assets');
const assets = filesRecursively(assetRoot);
const publicPages = pages.filter((page) => page.endsWith(`${sep}index.html`));

function canonicalUrlFor(page) {
  const route = relative(siteRoot, dirname(page)).split(sep).join('/');
  return `https://www.kikibytes.com/${route ? `${route}/` : ''}`;
}

function assertBalancedMarkup(page, html) {
  const voidElements = new Set([
    'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link',
    'meta', 'param', 'source', 'track', 'wbr',
  ]);
  const markup = html
    .replace(/<!--[\s\S]*?-->/g, '')
    .replace(/<(script|style)\b[^>]*>[\s\S]*?<\/\1>/gi, '');
  const stack = [];

  for (const match of markup.matchAll(/<(\/)?([a-z][\w:-]*)\b[^>]*(\/?)>/gi)) {
    const [, closing, rawName, selfClosing] = match;
    const name = rawName.toLowerCase();
    if (voidElements.has(name) || selfClosing) continue;

    if (!closing) {
      stack.push(name);
      continue;
    }

    const openName = stack.pop();
    assert.equal(
      openName,
      name,
      `${displayPath(page)} closes </${name}> while <${openName ?? 'nothing'}> is open`,
    );
  }

  assert.deepEqual(stack, [], `${displayPath(page)} contains unclosed elements: ${stack.join(', ')}`);
}

function isRemoteOrDocumentReference(value) {
  return value.startsWith('#')
    || value.startsWith('//')
    || /^[a-z][a-z\d+.-]*:/i.test(value);
}

function localTarget(source, value) {
  const pathname = value.split(/[?#]/, 1)[0];
  let decodedPathname;

  try {
    decodedPathname = decodeURIComponent(pathname);
  } catch {
    assert.fail(`${displayPath(source)} contains an invalid encoded path: ${value}`);
  }

  const target = decodedPathname.startsWith('/')
    ? resolve(siteRoot, decodedPathname.slice(1))
    : resolve(dirname(source), decodedPathname);
  const targetRelativeToSite = relative(siteRoot, target);

  assert.ok(
    targetRelativeToSite !== '..'
      && !targetRelativeToSite.startsWith(`..${sep}`)
      && !isAbsolute(targetRelativeToSite),
    `${displayPath(source)} references a path outside site/: ${value}`,
  );

  return target;
}

function htmlReferences(html) {
  const references = [];
  const attributePattern = /\b(src|href|action|poster)\s*=\s*(["'])(.*?)\2/gi;
  const srcsetPattern = /\bsrcset\s*=\s*(["'])(.*?)\1/gi;

  for (const match of html.matchAll(attributePattern)) {
    references.push({ attribute: match[1].toLowerCase(), value: match[3].trim() });
  }

  for (const match of html.matchAll(srcsetPattern)) {
    for (const candidate of match[2].split(',')) {
      const value = candidate.trim().split(/\s+/, 1)[0];
      references.push({ attribute: 'srcset', value });
    }
  }

  return references;
}

function cssReferences(css) {
  const pattern = /url\(\s*(?:(["'])(.*?)\1|([^)'"\s][^)]*))\s*\)/gi;
  return [...css.matchAll(pattern)].map((match) => (match[2] ?? match[3]).trim());
}

function imageDimensions(imagePath) {
  const image = readFileSync(imagePath);
  if (image.subarray(1, 4).toString() === 'PNG') {
    return { width: image.readUInt32BE(16), height: image.readUInt32BE(20) };
  }

  if (image.subarray(0, 4).toString() !== 'RIFF' || image.subarray(8, 12).toString() !== 'WEBP') {
    assert.fail(`${displayPath(imagePath)} uses an unsupported image format`);
  }

  let offset = 12;
  while (offset + 8 <= image.length) {
    const chunkType = image.subarray(offset, offset + 4).toString();
    const chunkSize = image.readUInt32LE(offset + 4);
    const dataOffset = offset + 8;

    if (chunkType === 'VP8X') {
      return {
        width: image.readUIntLE(dataOffset + 4, 3) + 1,
        height: image.readUIntLE(dataOffset + 7, 3) + 1,
      };
    }
    if (chunkType === 'VP8 ') {
      return {
        width: image.readUInt16LE(dataOffset + 6) & 0x3fff,
        height: image.readUInt16LE(dataOffset + 8) & 0x3fff,
      };
    }
    if (chunkType === 'VP8L') {
      const packedDimensions = image.readUInt32LE(dataOffset + 1);
      return {
        width: (packedDimensions & 0x3fff) + 1,
        height: ((packedDimensions >>> 14) & 0x3fff) + 1,
      };
    }

    offset = dataOffset + chunkSize + (chunkSize % 2);
  }

  assert.fail(`${displayPath(imagePath)} has no recognizable WebP image chunk`);
}

function pngAlphaValues(png, label) {
  assert.equal(png.subarray(1, 4).toString(), 'PNG', `${label} must be a PNG`);
  assert.equal(png[24], 8, `${label} must use 8-bit channels`);
  assert.equal(png[25], 6, `${label} must use RGBA color`);
  assert.equal(png[28], 0, `${label} must not be interlaced`);

  const width = png.readUInt32BE(16);
  const height = png.readUInt32BE(20);
  const rowLength = width * 4;
  const idatChunks = [];
  let chunkOffset = 8;

  while (chunkOffset < png.length) {
    const chunkLength = png.readUInt32BE(chunkOffset);
    const chunkType = png.toString('ascii', chunkOffset + 4, chunkOffset + 8);
    if (chunkType === 'IDAT') {
      idatChunks.push(png.subarray(chunkOffset + 8, chunkOffset + 8 + chunkLength));
    }
    if (chunkType === 'IEND') break;
    chunkOffset += chunkLength + 12;
  }

  const scanlines = inflateSync(Buffer.concat(idatChunks));
  let inputOffset = 0;
  let previousRow = Buffer.alloc(rowLength);
  const alphaValues = new Set();

  const paeth = (left, above, upperLeft) => {
    const estimate = left + above - upperLeft;
    const leftDistance = Math.abs(estimate - left);
    const aboveDistance = Math.abs(estimate - above);
    const upperLeftDistance = Math.abs(estimate - upperLeft);
    if (leftDistance <= aboveDistance && leftDistance <= upperLeftDistance) return left;
    if (aboveDistance <= upperLeftDistance) return above;
    return upperLeft;
  };

  for (let y = 0; y < height; y += 1) {
    const filter = scanlines[inputOffset];
    inputOffset += 1;
    const row = Buffer.alloc(rowLength);

    for (let x = 0; x < rowLength; x += 1) {
      const raw = scanlines[inputOffset + x];
      const left = x >= 4 ? row[x - 4] : 0;
      const above = previousRow[x];
      const upperLeft = x >= 4 ? previousRow[x - 4] : 0;
      let value;

      if (filter === 0) value = raw;
      else if (filter === 1) value = raw + left;
      else if (filter === 2) value = raw + above;
      else if (filter === 3) value = raw + Math.floor((left + above) / 2);
      else if (filter === 4) value = raw + paeth(left, above, upperLeft);
      else assert.fail(`${label} uses an unsupported PNG filter`);

      row[x] = value & 255;
    }

    for (let x = 3; x < rowLength; x += 4) alphaValues.add(row[x]);
    previousRow = row;
    inputOffset += rowLength;
  }

  return alphaValues;
}

function htmlAttribute(tag, attribute) {
  return tag.match(new RegExp(`\\b${attribute}\\s*=\\s*(["'])(.*?)\\1`, 'i'))?.[2];
}

function assertLocalReferenceResolves(source, value) {
  assert.notEqual(value, '', `${displayPath(source)} contains an empty local reference`);
  if (isRemoteOrDocumentReference(value)) return;

  const target = localTarget(source, value);
  assert.ok(existsSync(target), `${displayPath(source)} references missing local path ${value}`);
  assert.ok(
    statSync(target).isFile() || statSync(target).isDirectory(),
    `${displayPath(source)} references unsupported local target ${value}`,
  );
}

test('the deployment root contains discoverable HTML, CSS, and JavaScript', () => {
  assert.ok(pages.length > 0, 'site/ must contain at least one HTML page');
  assert.ok(stylesheets.length > 0, 'site/ must contain at least one stylesheet');
  assert.ok(scripts.length > 0, 'site/ must contain at least one JavaScript file');
  assert.ok(pages.includes(resolve(siteRoot, 'index.html')), 'site/index.html is required');
});

test('every page has essential metadata and accessible document landmarks', () => {
  for (const page of pages) {
    const html = read(page);
    const pageName = displayPath(page);

    assert.match(html, /<!doctype html>/i, `${pageName} is missing an HTML doctype`);
    assert.match(html, /<html\b[^>]*\bclass=["'][^"']*no-js[^"']*["'][^>]*\blang=["']en["']/i, `${pageName} must start in the no-js state and declare lang="en"`);
    assert.match(html, /<meta\b[^>]*\bcharset=["']?utf-8["']?/i, `${pageName} must declare UTF-8`);
    assert.match(html, /<meta\b[^>]*\bname=["']viewport["']/i, `${pageName} is missing viewport metadata`);
    assert.match(html, /<meta\b(?=[^>]*\bname=["']description["'])(?=[^>]*\bcontent=["'][^"']+["'])[^>]*>/i, `${pageName} is missing a meta description`);
    assert.match(html, /<title>\s*[^<]+\s*<\/title>/i, `${pageName} is missing a document title`);
    assert.match(html, /<link\b(?=[^>]*\brel=["'][^"']*\bicon\b[^"']*["'])[^>]*>/i, `${pageName} is missing a favicon`);
    assert.match(html, /<link\b(?=[^>]*\brel=["']icon["'])(?=[^>]*\bhref=["']\/favicon\.ico\?v=3["'])(?=[^>]*\bsizes=["']16x16 32x32 48x48 96x96["'])[^>]*>/i, `${pageName} must reference the current multi-size ICO`);
    assert.match(html, /<link\b(?=[^>]*\brel=["']icon["'])(?=[^>]*\btype=["']image\/png["'])(?=[^>]*\bhref=["']\/assets\/icons\/cat-head-favicon-192\.png["'])[^>]*>/i, `${pageName} must include the sharp PNG favicon fallback`);
    assert.match(html, /<link\b(?=[^>]*\brel=["']apple-touch-icon["'])(?=[^>]*\bhref=["']\/apple-touch-icon\.png["'])[^>]*>/i, `${pageName} must include the Apple touch icon`);
    assert.match(html, /<main\b[^>]*\bid=["']main-content["'][^>]*>/i, `${pageName} is missing the main landmark`);
    assert.match(html, /<a\b(?=[^>]*\bclass=["'][^"']*\bskip-link\b[^"']*["'])(?=[^>]*\bhref=["']#main-content["'])[^>]*>/i, `${pageName} is missing a skip link to #main-content`);
    assert.equal((html.match(/<h1\b/gi) ?? []).length, 1, `${pageName} must contain exactly one h1`);
    assert.doesNotMatch(html, /\b(?:href|src)\s*=\s*["']\s*javascript:/i, `${pageName} must not use javascript: URLs`);

    const ids = [...html.matchAll(/\bid\s*=\s*(["'])(.*?)\1/gi)].map((match) => match[2]);
    assert.equal(new Set(ids).size, ids.length, `${pageName} contains duplicate id attributes`);
    assertBalancedMarkup(page, html);

    const logos = [...html.matchAll(/<img\b[^>]*\bsrc=["']\/assets\/brand\/logo\.webp["'][^>]*>/gi)];
    assert.ok(logos.length > 0, `${pageName} must include the shared brand logo`);
    for (const [logo] of logos) {
      assert.match(logo, /\bwidth=["']156["']/i, `${pageName} has an incorrect logo width`);
      assert.match(logo, /\bheight=["']55["']/i, `${pageName} has an incorrect logo height`);
    }

    assert.equal((html.match(/<footer\b/gi) ?? []).length, 1, `${pageName} must contain one footer`);
    assert.equal((html.match(/class=["'][^"']*footer-heading[^"']*["']/gi) ?? []).length, 2, `${pageName} must include Navigation and Connect footer headings`);
    assert.equal((html.match(/class=["'][^"']*social-icon-link[^"']*["']/gi) ?? []).length, 3, `${pageName} must include all three shared social links`);
    assert.match(html, /<script\b[^>]*\bdefer\b[^>]*\bsrc=["']https:\/\/static\.cloudflareinsights\.com\/beacon\.min\.js["'][^>]*\bdata-cf-beacon=/i, `${pageName} must load the shared analytics beacon`);

    const stylesheetOrder = [...html.matchAll(/<link\b[^>]*\brel=["']stylesheet["'][^>]*\bhref=["']([^"']+)["'][^>]*>/gi)]
      .map((match) => match[1]);
    assert.deepEqual(
      stylesheetOrder,
      ['/styles/tokens.css', '/styles/base.css', '/styles/components.css', '/styles/pages.css'],
      `${pageName} must load the shared style layers in canonical order`,
    );
  }
});

test('shared header and footer markup cannot drift between routes', () => {
  function normalizedFragment(page, element) {
    const fragment = read(page).match(new RegExp(`<${element}\\b[\\s\\S]*?<\\/${element}>`, 'i'))?.[0];
    assert.ok(fragment, `${displayPath(page)} is missing its ${element}`);
    return fragment
      .replace(/ class=["']is-active["']/g, '')
      .replace(/ aria-current=["']page["']/g, '')
      .replace(/>\s+</g, '><')
      .replace(/\s+/g, ' ')
      .trim();
  }

  for (const element of ['header', 'footer']) {
    const expected = normalizedFragment(pages[0], element);
    for (const page of pages.slice(1)) {
      assert.equal(normalizedFragment(page, element), expected, `${displayPath(page)} has drifted shared ${element} markup`);
    }
  }
});

test('public routes expose consistent search and social metadata', () => {
  const canonicalUrls = new Set();

  for (const page of publicPages) {
    const html = read(page);
    const pageName = displayPath(page);
    const canonicalUrl = canonicalUrlFor(page);

    assert.match(html, new RegExp(`<link\\b[^>]*\\brel=["']canonical["'][^>]*\\bhref=["']${canonicalUrl.replaceAll('/', '\\/')}["']`, 'i'), `${pageName} has an incorrect canonical URL`);
    assert.match(html, /<meta\b[^>]*\bproperty=["']og:title["'][^>]*\bcontent=["'][^"']+["']/i, `${pageName} is missing og:title`);
    assert.match(html, /<meta\b[^>]*\bproperty=["']og:description["'][^>]*\bcontent=["'][^"']+["']/i, `${pageName} is missing og:description`);
    assert.match(html, new RegExp(`<meta\\b[^>]*\\bproperty=["']og:url["'][^>]*\\bcontent=["']${canonicalUrl.replaceAll('/', '\\/')}["']`, 'i'), `${pageName} has an incorrect og:url`);
    assert.match(html, /<meta\b[^>]*\bproperty=["']og:image["'][^>]*\bcontent=["']https:\/\/www\.kikibytes\.com\/assets\/[^"']+["']/i, `${pageName} is missing a local Open Graph image`);
    assert.match(html, /<meta\b[^>]*\bname=["']twitter:card["'][^>]*\bcontent=["']summary_large_image["']/i, `${pageName} is missing its Twitter card type`);
    assert.ok(!canonicalUrls.has(canonicalUrl), `${canonicalUrl} is used by more than one page`);
    canonicalUrls.add(canonicalUrl);
  }

  const notFoundPage = read(resolve(siteRoot, '404.html'));
  assert.match(notFoundPage, /<meta\b[^>]*\bname=["']robots["'][^>]*\bcontent=["']noindex["']/i);

  const robots = read(resolve(siteRoot, 'robots.txt'));
  const sitemap = read(resolve(siteRoot, 'sitemap.xml'));
  assert.match(robots, /Sitemap: https:\/\/www\.kikibytes\.com\/sitemap\.xml/);
  for (const canonicalUrl of canonicalUrls) {
    assert.match(sitemap, new RegExp(`<loc>${canonicalUrl.replaceAll('/', '\\/')}<\\/loc>`), `sitemap.xml is missing ${canonicalUrl}`);
  }
});

test('all local HTML and CSS references stay inside site/ and resolve', () => {
  for (const page of pages) {
    for (const { value } of htmlReferences(read(page))) {
      assertLocalReferenceResolves(page, value);
    }
  }

  for (const stylesheet of stylesheets) {
    for (const value of cssReferences(read(stylesheet))) {
      assertLocalReferenceResolves(stylesheet, value);
    }
  }
});

test('every image reserves its intrinsic aspect ratio', () => {
  for (const page of pages) {
    for (const match of read(page).matchAll(/<img\b[^>]*>/gi)) {
      const tag = match[0];
      const source = htmlAttribute(tag, 'src');
      const width = Number(htmlAttribute(tag, 'width'));
      const height = Number(htmlAttribute(tag, 'height'));

      assert.notEqual(htmlAttribute(tag, 'alt'), undefined, `${displayPath(page)} contains an image without alt text`);
      assert.ok(width > 0 && height > 0, `${displayPath(page)} contains an image without positive width and height`);
      if (!source || isRemoteOrDocumentReference(source)) continue;

      const target = localTarget(page, source);
      if (!/\.(?:png|webp)$/i.test(target)) continue;
      assert.deepEqual(
        { width, height },
        imageDimensions(target),
        `${displayPath(page)} declares the wrong intrinsic dimensions for ${source}`,
      );
    }
  }
});

test('the contact form preserves its fallback, abuse controls, and AJAX endpoint', () => {
  const contactPage = read(resolve(siteRoot, 'contact/index.html'));
  const script = read(resolve(siteRoot, 'scripts/site.js'));

  assert.match(contactPage, /<form\b(?=[^>]*\bclass=["'][^"']*\bcontact-form\b[^"']*["'])(?=[^>]*\baction=["']https:\/\/formsubmit\.co\/hello@kikibytes\.com["'])(?=[^>]*\bmethod=["']post["'])[^>]*>/i);
  assert.match(contactPage, /\bname=["']_honey["']/i);
  assert.match(script, /fetch\(["']https:\/\/formsubmit\.co\/ajax\/hello@kikibytes\.com["']/);
  assert.match(script, /cooldownMs\s*=\s*60_000/);
  assert.doesNotMatch(script, /\.innerHTML\s*=/i);
});

test('Cloudflare headers and redirects preserve deployment contracts', () => {
  const headersPath = resolve(siteRoot, '_headers');
  const redirectsPath = resolve(siteRoot, '_redirects');
  assert.ok(existsSync(headersPath), 'site/_headers is required in the deployment root');
  assert.ok(existsSync(redirectsPath), 'site/_redirects is required in the deployment root');

  const headers = read(headersPath);
  for (const header of [
    'Content-Security-Policy',
    'X-Content-Type-Options',
    'Referrer-Policy',
    'Permissions-Policy',
  ]) {
    assert.match(headers, new RegExp(`^\\s+${header}:`, 'm'), `site/_headers is missing ${header}`);
  }
  assert.match(headers, /^\s+Content-Security-Policy:.*\bscript-src\b.*https:\/\/static\.cloudflareinsights\.com/m);
  assert.match(headers, /^\s+Content-Security-Policy:.*\bconnect-src\b.*https:\/\/formsubmit\.co/m);
  assert.match(headers, /^\s+Content-Security-Policy:.*\bform-action\b.*https:\/\/formsubmit\.co/m);
  assert.doesNotMatch(headers, /\bimmutable\b/, 'non-fingerprinted assets must not be cached as immutable');

  for (const page of pages) {
    const html = read(page);
    for (const match of html.matchAll(/<script type="application\/ld\+json">([\s\S]*?)<\/script>/g)) {
      assert.doesNotThrow(() => JSON.parse(match[1]), `${displayPath(page)} contains invalid JSON-LD`);
      const hash = createHash('sha256').update(match[1]).digest('base64');
      assert.ok(headers.includes(`'sha256-${hash}'`), `${displayPath(page)} JSON-LD is not allowed by the Content Security Policy`);
    }
  }

  const redirectSources = new Set();
  const redirectLines = read(redirectsPath)
    .split(/\r?\n/)
    .map((line) => line.replace(/\s+#.*$/, '').trim())
    .filter(Boolean);

  assert.ok(redirectLines.length > 0, 'site/_redirects must define at least one redirect');
  for (const line of redirectLines) {
    const fields = line.split(/\s+/);
    assert.ok(fields.length === 2 || fields.length === 3, `invalid redirect rule: ${line}`);
    const [source, destination, status = '301'] = fields;
    assert.ok(source.startsWith('/'), `redirect source must start with /: ${line}`);
    assert.notEqual(source, destination, `redirect must not loop to itself: ${line}`);
    assert.ok(/^\d{3}(?:!)?$/.test(status), `invalid redirect status: ${line}`);
    assert.ok(!redirectSources.has(source), `duplicate redirect source: ${source}`);
    redirectSources.add(source);

    if (!isRemoteOrDocumentReference(destination) && !/[*:]/.test(destination)) {
      const target = localTarget(redirectsPath, destination);
      assert.ok(existsSync(target), `redirect destination does not resolve: ${line}`);
    }
  }
});

test('referenced content images use WebP, with explicit favicon exceptions', () => {
  const sources = [...pages, ...stylesheets, ...scripts].map(read).join('\n');
  const legacyImages = [...sources.matchAll(/assets\/[^\s"')]+\.(?:png|jpe?g)/gi)]
    .map((match) => match[0])
    .filter((path) => !path.endsWith('icons/cat-head-favicon-192.png'));

  assert.deepEqual(legacyImages, []);
});

test('legal pages stay aligned with the current website and its data flows', () => {
  const privacy = read(resolve(siteRoot, 'privacy/index.html'));
  const terms = read(resolve(siteRoot, 'terms/index.html'));
  const contact = read(resolve(siteRoot, 'contact/index.html'));

  for (const [name, html] of [['privacy', privacy], ['terms', terms]]) {
    assert.match(html, /Effective and last updated: August 12, 2026/, `${name} must show its current effective date`);
    for (const match of html.matchAll(/href=["']#([^"']+)["']/g)) {
      assert.match(html, new RegExp(`\\bid=["']${match[1]}["']`), `${name} links to missing section #${match[1]}`);
    }
  }

  for (const disclosure of [
    /Cloudflare Web Analytics/,
    /unsampled Web Analytics data for seven days/,
    /aggregated dashboard metrics available for six months/,
    /FormSubmit states[^<]*<\/a> that it retains submissions for 30 days/,
    /Google reCAPTCHA/,
    /one-minute browser-side cooldown/,
    /Do Not Track/,
    /Global Privacy Control/,
    /do not sell personal information/,
    /Children under 13 should not use the contact form/,
    /single response and then promptly delete it/,
    /Privacy appeal/,
    /does not automatically apply to a future KikiBytes app or game/,
  ]) {
    assert.match(privacy, disclosure, `privacy policy is missing required disclosure ${disclosure}`);
  }

  for (const protection of [
    /doing business as KikiBytes Labs/,
    /These Terms do not automatically govern a future app, game/,
    /parent or legal guardian who reviews and agrees/,
    /public-search indexing consistent with our robots\.txt file/,
    /does not apply to personal information, support requests/,
    /release dates are illustrative and informational/,
    /fraud or fraudulent misrepresentation/,
    /gross negligence/,
    /nonwaivable protections/,
  ]) {
    assert.match(terms, protection, `terms are missing required protection ${protection}`);
  }

  assert.match(contact, /By submitting, you agree to our <a href="\/terms\/">terms of service<\/a> and acknowledge our <a href="\/privacy\/">privacy policy<\/a>/);
});

test('the repository contains no duplicate, orphaned, or misplaced public assets', () => {
  const referencedAssets = new Set();

  for (const page of pages) {
    for (const { value } of htmlReferences(read(page))) {
      if (isRemoteOrDocumentReference(value)) continue;
      const target = localTarget(page, value);
      if (target.startsWith(`${assetRoot}${sep}`)) referencedAssets.add(target);
    }
  }

  for (const stylesheet of stylesheets) {
    for (const value of cssReferences(read(stylesheet))) {
      if (isRemoteOrDocumentReference(value)) continue;
      const target = localTarget(stylesheet, value);
      if (target.startsWith(`${assetRoot}${sep}`)) referencedAssets.add(target);
    }
  }

  const intentionalSupportFiles = new Set([resolve(assetRoot, 'fonts/LICENSE.txt')]);
  for (const asset of assets) {
    assert.ok(
      referencedAssets.has(asset) || intentionalSupportFiles.has(asset),
      `${displayPath(asset)} is not referenced by the site`,
    );
  }

  const hashes = new Map();
  for (const asset of assets.filter((path) => !path.endsWith('.txt'))) {
    const hash = createHash('sha256').update(readFileSync(asset)).digest('hex');
    const existingAsset = hashes.get(hash);
    if (existingAsset) {
      assert.fail(`${displayPath(asset)} duplicates ${displayPath(existingAsset)}`);
    }
    hashes.set(hash, asset);
  }

  const rootFiles = readdirSync(repositoryRoot, { withFileTypes: true })
    .filter((entry) => entry.isFile())
    .map((entry) => entry.name);
  assert.deepEqual(rootFiles.filter((name) => /\.(?:avif|gif|jpe?g|png|svg|webp)$/i.test(name)), [], 'public images do not belong at the repository root');
  assert.ok(!existsSync(resolve(repositoryRoot, '.DS_Store')), '.DS_Store must not exist at the repository root');
  assert.ok(!existsSync(resolve(siteRoot, 'README.md')), 'repository documentation must not be deployed from site/');
  assert.deepEqual(filesRecursively(siteRoot).filter((path) => path.endsWith(`${sep}.DS_Store`)), [], '.DS_Store files must not be deployed');

  const touchIcon = readFileSync(resolve(siteRoot, 'apple-touch-icon.png'));
  assert.equal(touchIcon.subarray(1, 4).toString(), 'PNG', 'apple-touch-icon.png must be a PNG');
  assert.equal(touchIcon.readUInt32BE(16), 180, 'apple-touch-icon.png must be 180px wide');
  assert.equal(touchIcon.readUInt32BE(20), 180, 'apple-touch-icon.png must be 180px tall');
  const touchIconAlpha = pngAlphaValues(touchIcon, 'apple-touch-icon.png');
  assert.ok(touchIconAlpha.has(0), 'apple-touch-icon.png must keep a transparent background');
  assert.ok(touchIconAlpha.has(255), 'apple-touch-icon.png must keep opaque artwork');

  const pngFavicon = readFileSync(resolve(assetRoot, 'icons/cat-head-favicon-192.png'));
  assert.equal(pngFavicon.readUInt32BE(16), 192, 'the PNG favicon must retain a sharp 192px source');
  assert.equal(pngFavicon.readUInt32BE(20), 192, 'the PNG favicon must be square');
  const pngFaviconAlpha = pngAlphaValues(pngFavicon, 'the PNG favicon');
  assert.ok(pngFaviconAlpha.has(0), 'the PNG favicon must keep a transparent background');
  assert.ok(pngFaviconAlpha.has(255), 'the PNG favicon must keep opaque artwork');

  const icoFavicon = readFileSync(resolve(siteRoot, 'favicon.ico'));
  assert.equal(icoFavicon.readUInt16LE(0), 0, 'favicon.ico has an invalid header');
  assert.equal(icoFavicon.readUInt16LE(2), 1, 'favicon.ico must contain icon images');
  const icoImageCount = icoFavicon.readUInt16LE(4);
  assert.equal(icoImageCount, 4, 'favicon.ico must contain the four browser-focused icon sizes');

  const icoSizes = [];
  for (let index = 0; index < icoImageCount; index += 1) {
    const entryOffset = 6 + index * 16;
    const width = icoFavicon.readUInt8(entryOffset) || 256;
    const height = icoFavicon.readUInt8(entryOffset + 1) || 256;
    const imageOffset = icoFavicon.readUInt32LE(entryOffset + 12);
    const imageLength = icoFavicon.readUInt32LE(entryOffset + 8);
    icoSizes.push(width);

    assert.equal(height, width, `favicon.ico ${width}px image must be square`);
    assert.equal(icoFavicon.readUInt16LE(entryOffset + 4), 1, `favicon.ico ${width}px image must use one color plane`);
    assert.equal(icoFavicon.readUInt16LE(entryOffset + 6), 32, `favicon.ico ${width}px image must retain 32-bit alpha`);
    assert.equal(icoFavicon.readUInt32LE(imageOffset), 40, `favicon.ico ${width}px image must use a browser-compatible bitmap header`);
    assert.equal(icoFavicon.readInt32LE(imageOffset + 4), width, `favicon.ico ${width}px bitmap width is invalid`);
    assert.equal(icoFavicon.readInt32LE(imageOffset + 8), height * 2, `favicon.ico ${width}px bitmap height must include its transparency mask`);
    assert.ok(imageOffset + imageLength <= icoFavicon.length, `favicon.ico ${width}px image exceeds the file boundary`);

    const alphaValues = [];
    const pixelStart = imageOffset + 40;
    for (let pixel = 0; pixel < width * height; pixel += 1) {
      alphaValues.push(icoFavicon[pixelStart + pixel * 4 + 3]);
    }
    assert.ok(alphaValues.includes(0), `favicon.ico ${width}px image needs transparent background pixels`);
    assert.ok(alphaValues.includes(255), `favicon.ico ${width}px image needs opaque artwork pixels`);
  }
  assert.deepEqual(icoSizes, [16, 32, 48, 96], 'favicon.ico must provide crisp standard browser sizes');
});

test('legacy implementations are not retained alongside current components', () => {
  const css = stylesheets.map(read).join('\n');
  const html = pages.map(read).join('\n');

  assert.doesNotMatch(css, /body:has\(/, 'use stable page classes rather than relational legacy selectors');
  assert.doesNotMatch(css, /about\.png/, 'obsolete asset-coupled About selectors must not return');
  assert.doesNotMatch(css, /\.section-title-label\s+h2/, 'section titles use the shared class directly');
  assert.doesNotMatch(css, /inter-semibold/, 'the unused semibold font must not return');
  assert.doesNotMatch(html, /\b(?:src|href)=["']\.\.?\//, 'shared internal paths must remain root-relative');
  assert.doesNotMatch(html, /\bdata-lightbox=/, 'the lightbox uses its shared class hook only');
});
