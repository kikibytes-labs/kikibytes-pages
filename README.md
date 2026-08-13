# KikiBytes Labs website

The public website for KikiBytes Labs is a dependency-free static site built with HTML, CSS, and vanilla JavaScript. Cloudflare Pages publishes the contents of `site/` directly; there is no application build step.

## Requirements

- Node.js 20 or newer for repository checks
- Any local static-file server for browser review; Python 3 is used in the example below

No package installation is required.

## Local development

Serve the deployment directory from the repository root:

```sh
python3 -m http.server 8000 --directory site
```

Then open <http://localhost:8000/>. Use an HTTP server instead of opening an HTML file directly because the site uses directory routes and root-relative URLs.

Run the complete validation suite before opening a pull request or deploying:

```sh
npm run check
```

`npm test` runs the same checks. The suite syntax-checks the shared JavaScript and uses Node's built-in test runner to validate page metadata, landmarks, local HTML and CSS references, Cloudflare configuration, and the contact-form integration.

## Repository structure

```text
.
├── AGENTS.md                 # Working conventions for contributors and coding agents
├── README.md                 # Project setup and operations
├── package.json              # Dependency-free quality-check commands
├── site/                     # Cloudflare Pages deployment root; everything here is public
│   ├── _headers              # Production response headers and cache policy
│   ├── _redirects            # Extensionless route redirects
│   ├── 404.html              # Cloudflare Pages not-found document
│   ├── robots.txt            # Crawler policy and sitemap pointer
│   ├── sitemap.xml           # Canonical public-route inventory
│   ├── assets/               # Fonts, brand art, icons, illustrations, and project media
│   ├── scripts/site.js       # Shared progressive-enhancement behavior
│   ├── styles/               # Tokens, base rules, components, and page-specific styles
│   ├── index.html            # Home page
│   └── <route>/index.html    # Directory-based public routes
└── tests/site.test.mjs       # Static-site integrity tests
```

Keep source images, temporary exports, generated output, and private notes out of the repository root and the public `site/` directory. See `AGENTS.md` for placement and implementation conventions.

## Production services

### Cloudflare Pages

- Build command: none
- Build output directory: `site`
- Deployment: the configured GitHub branch is published by Cloudflare Pages
- Platform configuration: `site/_headers` and `site/_redirects`

Keep both underscore-prefixed files inside `site/`; Cloudflare only applies them when they are present in the published output.

### Analytics

Cloudflare Web Analytics is enabled with the beacon loaded from `static.cloudflareinsights.com`. Its site token is a public identifier embedded in page markup, not an authentication secret. Changes to the analytics host must also be reflected in the Content Security Policy in `site/_headers`.

### Contact form

The contact page posts to FormSubmit for delivery to `hello@kikibytes.com`. The HTML includes a honeypot and retains its `action` as a no-JavaScript fallback; JavaScript adds AJAX delivery, timeout handling, and a browser-side cooldown. FormSubmit is therefore a production dependency even though it is not an npm dependency.

Do not send test submissions to the production contact address. If the endpoint changes, update the HTML fallback, JavaScript request, privacy copy, Content Security Policy, tests, and this README together.

## Deployment checklist

1. Run `npm run check`.
2. Review all changed routes through a local HTTP server at mobile and desktop widths.
3. Check keyboard navigation, the mobile menu, the Lucky Hall screenshot dialog, and contact-form validation without sending a production message.
4. Confirm the browser console and network panel show no missing files or Content Security Policy errors.
5. Verify that `site/` contains only intentional public files.

Contribution details and the full definition of done are documented in `AGENTS.md`.
