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

- 🌊 **Intuitive & Thematic:** Ocean-inspired naming (`Pod`, `Tank`, `Reef`, `Surface`, `Current`) makes concepts memorable.
- 🚀 **Zero Boilerplate:** No more `watch(context)`! Just read `.value` inside a `PodBuilder` or a `WhaleSurface` and watch the magic happen.
- ⚡️ **Insanely Fast:** Benchmarked to be incredibly performant, even handling 10,000 deep UI node updates under 1s.
- ⚓️ **Robust Dependency Injection:** The `Whale` global facade lets you put/find dependencies from *literally anywhere*, identically to GetX's `Get` format.
- 🛝 **Effortless Navigation:** Contextless named routes via `Whale.to()`, `Whale.off()`, etc.
- 💬 **Simplified Overlays:** `Whale.showDialog()`, `Whale.showSnackbar()`, `Whale.showBottomSheet()`.
- 💧 **Familiar Primitives:** Build states instantly using primitives like `0.pod` or `[].pod`.
- 🛠️ **Developer-Friendly:** Designed with absolute Developer Experience (DX) as a top priority.

---

## 🧱 Core Concepts

| Concept      | Purpose                                | Blue Whale Term  | Technical Alias                   |
| ------------ | -------------------------------------- | ---------------- | --------------------------------- |
| State        | Holds reactive data                    | **Pod**          | `Signal<T>` / `State<T>`          |
| Logic/Action | Business logic tied to state           | **Tank**         | `Controller` / `Store`           |
| Binding/View | Smart stateful view / fine-grained     | **Surface**      | `ReactiveWidget` / `View`         |
| Facade       | GetX-like Global point for DI/Nav/UI   | **Whale**        | `Whale`                           |
| DI Engine    | Background Dependency Injection engine | **Reef**         | `Injector` / `Container`          |
| Navigation   | Manages app routes and navigation      | **Navigator**    | `Whale.to() / back()`             |

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

## 🛠️ Whale CLI (Code Generator)

Boost your productivity with the built-in scaffold generator.

```bash
# Generate a complete feature (Tank, State, Surface)
dart run blue_whale create tank login
```

This creates:
- `lib/features/login/login_tank.dart` (Logic)
- `lib/features/login/login_state.dart` (Pods/Signals)
- `lib/features/login/login_surface.dart` (UI with automatic `WhaleScope`)

---

## 🔍 Whale DevTools (Deep Diagnostics)

Stop wondering why a widget rebuilt. Enable DevTools to see exactly what's happening under the hood.

```dart
void main() {
  Whale.enableDevTools(); 
  runApp(const MyApp());
}
```

**What you'll see in the console:**
- `🐋 [WhaleState] Mutation: UserPod changed from "Garv" -> "Divanex"`
- `🔍 [WhaleTracker] UI Rebuild: ProfilePage automatically rebuilt because of: [UserPod]`

---

## 🛡️ WhaleScope (Memory Safety)

Blue Whale provides a global Reef for DI, but for large apps, you want memory safety. `WhaleScope` automatically destroys dependencies when the widget is disposed.

```dart
View(() {
  return WhaleScope(
    setup: (scope) => scope.lazyPut(() => MyController()),
    child: MyWidget(), // MyController is deleted automatically when MyWidget is popped!
  );
})
```

---

## 🚀 Getting Started

The simplest way to build any UI is with `state()` and `View()`:

```dart
import 'package:blue_whale/blue_whale.dart';

final count = state(0); // Signal/Pod

class Home extends StatelessWidget {
  Widget build(context) => View(() => Text("${count()}"));
}

void main() async {
   runApp(const WhaleApp(home: Home()));
}
```

---

## 🌊 Advanced Usage (Legacy Support)


```dart
import 'package:flutter/material.dart';
import 'package:blue_whale/blue_whale.dart';

// Declare a global or local primitive pod
final myCount = 0.pod;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WhaleStorage.init(); // Optional: Required only if you use `persistentState`

  // Simple global registration
  Whale.put(myCount);

  // Wrap your root with WhaleApp, which auto-configures navigation, localization, etc!
  runApp(
     const WhaleApp(
      home: CounterApp(),
    )
  );
}

// Option A: Use a stateless widget with a PodBuilder!
class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blue Whale 0-Boilerplate')),
      body: Center(
        // Automatically rebuilds when myCount.value changes!
        child: PodBuilder(() => Text('Count: ${myCount.value}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            myCount.value++;
            Whale.showSnackbar("Incremented!");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Option B: Or use a WhaleSurface (Stateful widget)!
class AlternativeSurface extends WhaleSurface {
  const AlternativeSurface({super.key});

  @override
  Widget build(BuildContext context) {
      // Direct access in `build` is auto-tracked.
      // No PodBuilder needed.
      return Text("Tracked: ${myCount.value}");
  }

  @override
  WhaleSurfaceState<AlternativeSurface> createState() => _AlternativeSurfaceState();
}
class _AlternativeSurfaceState extends WhaleSurfaceState<AlternativeSurface> {}
```

---

## 📖 Features Overview

### State Management

- `state(initialValue)`: The absolute simplest way to declare state (`final count = state(0);`).
- `persistentState('key', val)`: Magical state that instantly saves & loads using `SharedPreferences` in the background without UI lag!
- `AsyncPod<T>` and `.asyncPod`: The easy replacement for GetX's StateMixin providing native `.obx()` builder tracking states like loading/error/success.
- `View()` / `PodBuilder`: Simple reactive widget that watches any `.value` or `pod()` read inside it automatically.
- `WhalePulse` Workers: Expand reactive states natively using `.ever()`, `.once()`, `.interval()`, and `.debounce()`.
- `WhaleSurface`: Stateful wrapper where `build(context)` automatically tracks dependencies dynamically.
- `mutate()`: Batch multiple state updates perfectly to fire only a single UI repaint.
- `derive()`: Effortlessly create computed states that depend on other pods seamlessly.

### Dependency Injection (Reef)

- `Whale.put(obj)` / `Whale.lazyPut()` / `factory()`
- `Whale.find<T>()`: Retrieve dependencies anywhere.
- Scoped dispose with `WhaleTank`/`WhaleDisposable`

### Navigation

- `WhaleApp`: Removes 100% of standard Navigator tracking/key boilerplate. Use this instead of `MaterialApp`!
- Named routes with no context needed.
- `Whale.to()`, `Whale.off()`, `Whale.offAll()`, `Whale.back()`.
- `WhaleRouteAwareTank`: Lifecycle-aware tanks that synchronize with routes automatically.

### UI Overlays

- `Whale.showDialog()`, `Whale.showSnackbar()`, `Whale.showBottomSheet()`

### Internationalization (i18n)

- `WhaleTranslations`
- `"key".bwTr(context)`
- `WhaleLocalePod().setLocale()`

---

## 🔮 Future Possibilities

- AI-Assisted Debugging: "Why did this rebuild?" UI in DevTools.
- Route guards & middleware.
- Form validation signals.
- Desktop-specific window management signals.

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
