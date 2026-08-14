# AGENTS.md

## Project purpose

This repository contains the public KikiBytes Labs marketing website. It is a dependency-free static site built with semantic HTML, layered CSS, and vanilla JavaScript. Cloudflare Pages publishes `site/` directly with no build or transformation step.

These instructions apply to the entire repository.

## Non-negotiable architecture

- Treat `site/` as the exact production artifact. Every file placed there is publicly reachable after deployment.
- Keep repository documentation, tests, CI configuration, and development tooling at the repository root, outside `site/`.
- Do not introduce a framework, package dependency, bundler, preprocessor, or build step unless the user explicitly approves that architectural change.
- Preserve progressive enhancement: core navigation and readable content must work without JavaScript, and the contact form must retain its HTML fallback.
- Keep `_headers` and `_redirects` in `site/`; Cloudflare reads them from the published directory.

## Repository map

- `site/index.html`: home page.
- `site/<route>/index.html`: top-level directory routes such as About, Contact, Privacy, and Terms.
- `site/projects/index.html`: project listing.
- `site/projects/<slug>/index.html`: individual project pages.
- `site/404.html`, `site/robots.txt`, and `site/sitemap.xml`: deployment and crawler support files.
- `site/styles/tokens.css`: design tokens and font declarations.
- `site/styles/base.css`: reset, document defaults, utilities, and global behavior.
- `site/styles/components.css`: reusable navigation, cards, buttons, footer, and shared UI.
- `site/styles/pages.css`: page-specific composition and responsive rules.
- `site/scripts/site.js`: shared, null-safe progressive enhancements.
- `site/assets/brand/`: logos and core brand artwork.
- `site/assets/backgrounds/`: full-page and section backgrounds.
- `site/assets/banners/`: wide hero and project banners.
- `site/assets/icons/`: interface and decorative icon artwork.
- `site/assets/illustrations/`: larger editorial illustrations.
- `site/assets/projects/<slug>/`: media owned by one project; screenshots belong in its `screenshots/` subdirectory.
- `site/favicon.ico` and `site/apple-touch-icon.png`: conventional root-level browser and device icons.
- `tests/site.test.mjs`: dependency-free static integrity checks.
- `.github/workflows/quality.yml`: CI entry point for the same local checks.

## Required commands

From the repository root:

```sh
npm run check
git diff --check
python3 -m http.server 8000 --directory site
```

The server command is for visual review. Open `http://localhost:8000/`; do not review by opening `site/index.html` as a local file because root-relative URLs and directory routes need HTTP semantics.

Run `npm run check` after any HTML, CSS, JavaScript, asset-path, redirect, header, or test change. Do not claim completion when relevant checks are failing.

## File placement and naming

- Do not place images, screenshots, exported design files, or temporary artifacts in the repository root.
- Use lowercase kebab-case filenames for new public assets and route directories.
- Put a project-specific asset under `site/assets/projects/<project-slug>/`, not in a generic root asset folder.
- Do not keep duplicate copies of an asset. Update references and retain one canonical file.
- Remove genuinely unreferenced production assets after confirming that HTML, CSS, and JavaScript do not construct their paths dynamically.
- Never commit `.DS_Store`, browser profiles, `.dart_tool`, build output, environment files, logs, credentials, cookies, or session material.

## HTML conventions

- Use semantic HTML and two-space indentation. Keep markup readable; do not collapse an entire page onto one line.
- Every page must include a doctype, `lang="en"`, UTF-8 charset, viewport metadata, a useful title and description, favicon links, one `h1`, a skip link, and `<main id="main-content">`.
- Use root-relative internal URLs such as `/about/`, `/styles/base.css`, and `/assets/brand/logo.webp`. This keeps shared markup consistent at every route depth.
- Directory routes end in `/`. New public pages belong at `<route>/index.html`, not as root-level `.html` files.
- Give each content section an accessible heading. Use `aria-labelledby` when a section's visible heading names it.
- Decorative images use `alt=""` and, when the containing element is purely decorative, `aria-hidden="true"`. Informative images need concise, contextual alt text.
- Include accurate intrinsic `width` and `height` values on images to reserve layout space. Add `loading="lazy"` to below-the-fold images, but not to the likely largest-contentful-paint image.
- When shared header, navigation, footer, analytics, or metadata markup changes, update every HTML page consistently.
- Keep external links and third-party form endpoints deliberate. Add `rel="noreferrer"` to external social links unless referrer data is intentionally required.

## CSS conventions

- Preserve stylesheet order: `tokens.css`, `base.css`, `components.css`, then `pages.css`.
- Reuse design tokens and shared classes before adding page-specific declarations.
- Use shared composition styles consistently across routes. Page heroes, containers, banners, navigation, and other repeated UI must inherit the common component treatment at desktop and mobile, including typography (font family, size, weight, line height, and color), spacing, borders, radii, backgrounds, and responsive behavior; add a page-specific override only when the design genuinely differs.
- Place reusable UI in `components.css`; reserve `pages.css` for composition unique to a route or page family.
- Prefer page classes and semantic component classes over selectors coupled to asset filenames or text content.
- Maintain responsive behavior at narrow mobile, tablet, and desktop widths. Avoid fixed dimensions that cause clipping or horizontal page overflow.
- For pages with custom backgrounds, set the root `html` background to the same or a closely matching page color so mobile elastic overscroll never reveals a white strip; apply this to every new project page as well.
- Mobile page backgrounds must remain fixed while content scrolls above them and must not be enlarged against the document height; use viewport-appropriate sizing such as `cover` or `100% auto`, and apply the same behavior to every new project page. If mobile browsers do not reliably honor a body-level fixed background, use a fixed viewport pseudo-layer or equivalent.
- Respect `prefers-reduced-motion`. Motion must not be required to understand or operate the site.
- Do not add inline styles. The production Content Security Policy intentionally limits style sources.
- Remove obsolete rules when replacing an implementation; do not leave unreachable selectors as a second competing version.

## JavaScript conventions

- Keep behavior framework-free, small, and page-safe. Shared code must tolerate elements being absent on routes where a feature is not used.
- Use DOM APIs and `textContent`; do not inject untrusted strings through `innerHTML`.
- Preserve native semantics and fallbacks. Enhancements should attach to existing links, buttons, forms, and dialogs rather than replacing their baseline behavior.
- Support keyboard use, Escape-to-close where appropriate, focus restoration, back-forward cache navigation, and reduced-motion preferences.
- Never place secrets in client-side JavaScript. Everything under `site/` is public.
- Do not send an automated or manual test submission to the production contact endpoint. Validate structure and client-side states without delivering mail.

## Assets and performance

- Use WebP for content imagery unless a format-specific requirement justifies another format. Favicon and touch-icon formats are explicit exceptions.
- Optimize new images before committing them and avoid serving dimensions far larger than their rendered use without a responsive-image reason.
- Self-hosted fonts must include their applicable license and attribution. Prefer web-optimized formats when changing font assets.
- Keep asset references valid in HTML, CSS `url(...)`, and JavaScript-created elements.
- Do not apply a long-lived `immutable` cache directive to stable, non-fingerprinted filenames. Either fingerprint the filename or use a cache policy that allows revalidation.

## Cloudflare, security, and privacy

- `site/_headers` owns production security and cache headers. Preserve the Content Security Policy, `X-Content-Type-Options`, referrer policy, permissions policy, and framing protection unless a deliberate reviewed change requires otherwise.
- Keep Content Security Policy origins synchronized with actual third-party usage. Cloudflare Web Analytics needs its script and connection origins; FormSubmit needs its form and connection origins.
- `site/_redirects` uses Cloudflare Pages syntax. Redirect destinations must resolve, avoid loops, and use permanent status codes only when the move is truly permanent.
- Analytics, the contact email, FormSubmit endpoints, and legal-page claims are production configuration. Update related markup, scripts, headers, privacy text, documentation, and tests together.
- Do not weaken security headers merely to silence a browser error. Determine which resource is intended, then make the narrowest necessary policy change.

## Testing expectations

The automated suite is a fast integrity gate, not a substitute for browser review. When applicable, verify:

- every internal link and asset loads without a 404;
- keyboard navigation and visible focus states;
- mobile-menu open, close, outside-click, and Escape behavior;
- Lucky Hall screenshot dialog open, close, caption, and focus behavior;
- contact-form native validation, cooldown, timeout, success, and error messaging without sending production mail;
- layouts at approximately 320 px, 768 px, and 1440 px widths;
- no unexpected horizontal scrolling;
- no console errors, mixed content, or Content Security Policy violations;
- reduced-motion behavior;
- production `_headers` and `_redirects` remain in the deployment root.

## Working method

- Inspect existing patterns before editing and keep unrelated user changes intact.
- Make the smallest cohesive change that fully solves the request.
- Do not rewrite legal copy, business dates, launch dates, analytics identifiers, email addresses, or external service configuration as incidental cleanup.
- If a shared fragment changes, search the entire site for every copy before finishing.
- Before removing an asset, search HTML, CSS, and JavaScript, including dynamically assembled paths.
- After editing, review `git diff`, run `npm run check`, run `git diff --check`, and report any browser checks that were not possible.

## Definition of done

A change is complete when files are in their canonical locations, markup remains semantic and accessible, responsive and no-JavaScript behavior is preserved, production integrations and security policy agree, automated checks pass, relevant routes have been reviewed over HTTP, and no generated files, duplicates, orphaned assets, credentials, or unrelated changes were introduced.
