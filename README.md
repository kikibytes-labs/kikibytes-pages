# KikiBytes Pages

This repository contains the **Flutter Web marketing website** for **KikiBytes Labs**, a small indie game/app studio. The site showcases projects, provides a contact form, and includes information about KikiBytes Labs.

The application is built with Flutter Web and targets modern browsers. Key features:
- Browser routing with `go_router` and preserved back/forward history
- Smooth cross‑fade page transitions with a stable white background to avoid ghosting
- Lightweight SVG asset loader (`SafeSvg`) with sanitization + caching
- Preloading of important assets so icons and illustrations render without flicker
- Responsive layout using `responsive_framework` and optional fine‑grain scaling via `flutter_screenutil`

---

**Quick Prerequisites**

- Flutter SDK (stable channel). Tested against Flutter 3.x and later.
- Chrome (for `flutter run -d chrome`) or any supported web browser.
- Git for source control.


**Getting started (development)**

1. Clone the repository

```bash
git clone https://github.com/yourusername/kikibytes-pages.git
cd kikibytes-pages
```

2. Fetch dependencies

```bash
flutter pub get
```

3. Recommended: clean stale build artifacts before a fresh run

```bash
flutter clean
flutter pub get
```

4. Run locally

```bash
flutter run -d chrome
```

If you change dependencies, run `flutter pub get` again. Use `flutter pub outdated` to inspect available upgrades.

**Build for production**

```bash
flutter build web
```

The static site output will be in `build/web`.

---

**Deploy to Cloudflare with Wrangler**

```bash
npx wrangler pages deploy build/web --project-name=kikibytes-pages
```

---

## Project highlights & architecture

- `lib/app.dart` — App entry and router configuration (uses a `ShellRoute` that contains the `Navbar` and `Footer`).
- `lib/main.dart` — App boot; preloads key SVG and PNG assets using `SafeSvg.preload` and initializes `ScreenUtil` for adaptive sizing.
- `lib/widgets/safe_svg.dart` — A small helper that sanitizes and caches SVG text, falls back to bitmap rendering for PNG/JPEG, and avoids async flicker when assets are preloaded.
- `lib/widgets/navbar.dart`, `lib/widgets/footer.dart` — Top/bottom chrome (navbar uses `ScreenUtil` for responsive sizes).
- `lib/pages/*` — Individual pages (home, about, projects, contact, lucky hall bingo, terms, privacy).
- `assets/images/` — All image and SVG assets used by the site.

---

## Responsive & adaptive design

This project uses a combination of core Flutter layout primitives and community packages:

- `responsive_framework` handles breakpoints and scaling behaviour across mobile/tablet/desktop.
- `flutter_screenutil` is initialized at app startup to provide `.sp`, `.w`, and `.h` helpers for fine‑grain responsive sizing (useful when you need relative font sizes or pixel‑accurate scaling).
- Use `MediaQuery` and `LayoutBuilder` for layout-specific behaviour when needed; prefer `Flexible`, `Expanded`, and `Wrap` for fluid reflow.

Tip: `ScreenUtilInit` is configured in `main.dart` (design size ~390×844) — adjust if you target a different base design.

---

## Asset preloading

To avoid icons and illustrations appearing a moment after the page paints, important SVG/PNG assets are preloaded in `main.dart` with `SafeSvg.preload`. If you add large images, add them to the preload list or call `precacheImage` for bitmaps.

Example preload code lives in `lib/main.dart` and includes:
- logo and social icons
- Lucky Hall Bingo icons
- hero/title images and background PNGs

---

## Editing copy & content

All visible strings are centralized in `lib/strings.dart`. Update that file to change on-screen text or to prepare for localization.

Add or edit project entries in `lib/pages/projects_page.dart`.

---

## Debugging

- Use `flutter run` for iterative development and hot reload.
- Use the browser DevTools console for runtime errors.
- If you see stale parse errors after editing, run `flutter clean` and relaunch to ensure the toolchain rebuilds from fresh sources.

---

## Contact configuration

Change destination email/address in `lib/contact_config.dart` if you want contact form messages to be routed elsewhere.

---

## License & distribution

This code is proprietary to KikiBytes LLC. Do not redistribute without permission.
