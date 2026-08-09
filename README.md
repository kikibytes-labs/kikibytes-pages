# KikiBytes Labs website

Static HTML/CSS/JavaScript marketing site for KikiBytes Labs. The site is dependency-free and deploys directly to Cloudflare Pages.

## Structure

- `site/` — deployable website
- `site/assets/` — organized brand, banner, and project artwork
- `site/styles/` — design tokens, base styles, shared components, and page styles
- `site/scripts/` — small progressive-enhancement scripts

## Local review

Open `site/index.html` for a quick content review. Directory routes are intended to be served by Cloudflare Pages or another static server.

## Cloudflare Pages

- Build command: none
- Output directory: `site`
- Deploy command: `npx wrangler pages deploy site --project-name=kikibytes-pages`

## Analytics

Cloudflare Web Analytics is the planned free analytics option. Add the beacon snippet supplied by Cloudflare to the pages after the Web Analytics site token is created.

## Contact

The contact form uses `mailto:hello@kikibytes.com`, so the site does not require a form service or backend.
