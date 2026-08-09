# KikiBytes Labs static site

This is a dependency-free HTML/CSS/vanilla JavaScript site intended for Cloudflare Pages.

## Local review

Open `index.html` directly for a quick content review. A local server is preferred for checking directory routes; the deployment output directory is `site`.

## Cloudflare Pages

- Build command: none
- Output directory: `site`
- Deploy command: `npx wrangler pages deploy site --project-name=kikibytes-pages`

## Analytics

Cloudflare Web Analytics is intentionally not hard-coded until the site token is available. Once enabled in the Cloudflare dashboard, add the provided beacon snippet to each page before launch.
