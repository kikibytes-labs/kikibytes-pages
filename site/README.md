# KikiBytes Labs static site

This is a dependency-free HTML/CSS/vanilla JavaScript site intended for Cloudflare Pages.

## Local review

Open `index.html` directly for a quick content review. A local server is preferred for checking directory routes; the deployment output directory is `site`.

## Cloudflare Pages

- Build command: none
- Output directory: `site`
- Deploy: Cloudflare Pages deploys from the configured GitHub branch. No deployment CLI or paid service is required by this repository.

## Analytics

Enable Cloudflare Web Analytics from **Workers & Pages → this project → Metrics → Web Analytics**. Cloudflare Pages injects its free, privacy-focused beacon on deployment, so there is no analytics token or third-party script in this repository. Enable Cloudflare's weekly Web Analytics notification to receive visits, page views, and median load time by email.

## Quality checks

Run `npm run check` before deploying. It uses only Node's built-in test runner, so it does not install dependencies or create paid services.
