# KikiBytes Pages

This repository contains the **Flutter Web marketing website** for **KikiBytes
Labs**, a small indie game/app studio. The site showcases upcoming and currently available projects, provides a contact form, and includes information about KikiBytes Labs.

The application is built with Flutter web and targets modern browsers. It uses
- go-router for browser navigation
- smooth fade transitions between pages (implemented via `smooth_transition`
  but with an additional white background layer to prevent ghosting),
- a lightweight SVG asset loader, and
- a responsive layout suitable for desktop and mobile.

---

## 🛠 Prerequisites

- [Flutter SDK ≥3.3](https://flutter.dev/docs/get-started/install)
- A web-capable device (Chrome is used during development)
- Git for source control

## 📦 Getting started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/kikibytes-pages.git
   cd kikibytes-pages
   ```
2. **Fetch dependencies**
   ```bash
   flutter pub get
   ```
3. **Run locally**
   ```bash
   flutter run -d chrome
   ```
   Navigate the site and use the browser back/forward buttons to verify
   history integration.

4. **Build for production**
   ```bash
   flutter build web
   ```
   Output will be in `build/web`; serve the files with any static host.

## 🧱 Project structure

```
lib/
  app.dart                # Main application & routing shell
  routes.dart             # Route path constants
  strings.dart            # All user-visible text
  theme.dart              # App theme definitions
  widgets/                # Reusable UI components
    navbar.dart
    hero_banner.dart
    footer.dart
    project_card.dart
    safe_svg.dart         # SVG loader with caching
    ...
  pages/                  # Individual page widgets
    home_page.dart
    about_page.dart
    projects_page.dart
    lucky_hall_bingo_page.dart
    contact_page.dart
    terms_page.dart
    privacy_page.dart
assets/
  images/                 # SVGs & raster assets used by the site
pubspec.yaml              # Flutter configuration, assets listing
```

## 🖼 Assets

SVGs live under `assets/images` and are referenced via `SafeSvg.asset`. The
loader sanitizes and caches each file to avoid asynchronous loading glitches.
Preload important icons in `main.dart` (e.g. logo, social icons, Lucky Hall
icons).

## ✍️ Editing copy

All on‑screen text is defined in `lib/strings.dart`. This makes it easy to
update wording or add internationalization later — just modify or replace the
strings file.

## 🧪 Testing & debugging

- Hot reload is supported when running with `flutter run`.
- Use the browser console to inspect errors.

## 📩 Contact configuration

Modify `contact_config.dart` to set the destination email or API endpoint for
messages sent through the contact form.

## 📄 License

This code is proprietary to KikiBytes LLC. Do not redistribute without
permission.

---

*Happy hacking!*