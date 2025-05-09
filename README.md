# 🌊 Blue Whale: Intuitive State Management for Flutter

[![pub package](https://img.shields.io/pub/v/blue_whale.svg?label=blue_whale&color=0175C2)](https://pub.dev/packages/blue_whale)
[![likes](https://img.shields.io/pub/likes/blue_whale.svg?logo=flutter)](https://pub.dev/packages/blue_whale/score)
[![pub points](https://img.shields.io/pub/points/blue_whale.svg?logo=flutter)](https://pub.dev/packages/blue_whale/score)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter Version](https://img.shields.io/badge/flutter-%3E%3D3.10.0-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/dart-%3E%3D3.0.0-blue.svg?logo=dart)](https://dart.dev)

<!-- Optional: Add a nice SVG image of a blue whale here -->

<!-- <p align="center">
  <img src="https://www.svgrepo.com/show/your-chosen-whale.svg" alt="Blue Whale Logo" width="150"/>
</p> -->

**Blue Whale** is a clean, scalable, and refreshingly intuitive state management, dependency injection, and navigation plugin for Flutter. Designed to be _more intuitive than GetX_, it aims for an easy learning curve, rapid implementation, and the flexibility needed for real-world applications. Dive into a smoother development experience!

---

## ✨ Why Blue Whale?

- 🌊 **Intuitive & Thematic:** Ocean-inspired naming (`Pod`, `Tank`, `Reef`, `Surface`, `Current`) makes concepts memorable and easy to grasp.
- 🚀 **Fast to Implement:** Get up and running quickly with minimal boilerplate.
- 🌟 **Clear Separation of Concerns:** Distinct roles for state (`Pod`), logic (`Tank`), UI (`Surface`), and DI (`Reef`).
- ⚓️ **Robust Dependency Injection:** Simple yet powerful DI with `Reef.i.put()`, `lazyPut()`, and `find()` (or `use<T>()`).
- 🛝 **Effortless Navigation:** Contextless named routes, argument passing, and route-aware capabilities.
- 💬 **Simplified Overlays:** Easy API for showing dialogs, snackbars, and bottom sheets via `BlueWhale.overlays`.
- 🌐 **Built-in i18n:** Simple internationalization setup with reactive locale changes.
- 💧 **Reactive Primitives:** `WhalePod` for reactive state and `WhaleCurrent` for streams, integrating seamlessly with Flutter.
- 🛠️ **Developer-Friendly:** Designed with Developer Experience (DX) as a top priority.

---

## 🧱 Core Concepts

| Concept      | Purpose                                | Blue Whale Term  | Class Name                        |
| ------------ | -------------------------------------- | ---------------- | --------------------------------- |
| State        | Holds reactive data                    | **Pod**          | `WhalePod<T>`                     |
| Logic/Action | Business logic tied to state           | **Tank**         | `WhaleTank`                       |
| Binding/View | Accesses state & logic in UI           | **Surface**      | `WhaleSurface`                    |
| DI / Global  | Dependency Injection & global registry | **Reef**         | `Reef.i` / `BlueWhale.initialize` |
| Navigation   | Manages app routes and navigation      | **Navigator**    | `BlueWhale.navigator`             |
| Overlays     | Shows dialogs, snackbars, etc.         | **Overlays**     | `BlueWhale.overlays`              |
| Async Stream | Reactive stream of data                | **Current**      | `WhaleCurrent<T>`                 |
| Translations | Manages localized strings              | **Translations** | `WhaleTranslations`, `.bwTr()`    |

> **The Analogy:** _Pods_ (state units) are managed by _Tanks_ (logic containers). Tanks and Pods are registered in the global _Reef_. UI _Surfaces_ display what's happening. Data flows through _Currents_.

---

## 📦 Installation

Add `blue_whale` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  blue_whale: ^0.0.2 # Replace with latest version
```

**Or use a Git reference (before publishing):**

```yaml
dependencies:
  blue_whale:
    git:
      url: https://github.com/your-username/blue_whale.git
```

Then:

```bash
flutter pub get
```

Import:

```dart
import 'package:blue_whale/blue_whale.dart';
```

---

## 🚀 Getting Started

See a complete `main.dart`, `CounterPod`, and `HomePage` example in the description above.

---

## 📖 Features Overview

### State Management

- `WhalePod<T>`: Reactive state.
- `watch(context)`: Widget rebuild on change.
- `WhaleTank`: Business logic abstraction.
- `WhaleBuilder<P, V>`: Fine-grained rebuilds.
- `WhaleCurrent<T>`: Stream integration.

### Dependency Injection (Reef)

- `Reef.i.put(obj)` / `lazyPut()` / `factory()`
- `use<T>()`: Retrieve dependencies easily.
- Auto-dispose with `WhaleTank`/`WhaleDisposable`

### Navigation

- Named routes with no context needed.
- `to()`, `off()`, `offAll()`, `back()`.
- `WhaleRouteAwareTank`: Lifecycle-aware tanks.

### UI Overlays

- `showDialog()`, `showSnackbar()`, `showBottomSheet()`

### Internationalization (i18n)

- `WhaleTranslations`
- `"key".bwTr(context)`
- `WhaleLocalePod().setLocale()`

---

## 🔮 Future Possibilities

- `WhaleScope`: Scoped state/DI.
- DevTools integration.
- CLI for codegen and scaffolding.
- Route guards & middleware.
- Forms & local persistence.

---

## 🤝 Contributing

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit (`git commit -m 'Add feature'`)
4. Push (`git push origin feature/AmazingFeature`)
5. Open a PR

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for details.

---

**Happy Fluttering with Blue Whale! 🐳**
