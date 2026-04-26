# Awkward Sky Projects

Flutter web homepage for `https://awkwardsky.github.io/`.

This site is the public index for independent GitHub Pages projects and selected
private-project showcases, including:

- `ReactionSpeedLab`: https://awkwardsky.github.io/ReactionSpeedLab/
- `DashboardLab`: https://awkwardsky.github.io/DashboardLab/
- `Kagerune Color`: video showcase only; source code and playable builds are
  private.

## Local Development

```bash
flutter pub get
flutter run -d chrome
```

## Build

```bash
flutter build web --release --base-href /
```

## Deployment

GitHub Actions builds and deploys the Flutter web output to GitHub Pages on every push to `master`.
