## 0.0.3

A massive update introducing the "Signals" paradigm, a CLI tool, memory safety with WhaleScope, and deep DevTools diagnostics.

### New Features

- **Functional Reactivity:** Introduced `state()`, `View()`, `mutate()`, and `derive()` for a minimalist, signal-based DX.
- **Whale CLI:** New command-line tool for scaffolding features (`dart run blue_whale create tank <name>`).
- **WhaleScope:** Scoped dependency injection that automatically cleans up memory when widgets are disposed.
- **Whale DevTools:** Real-time console diagnostics for tracking state mutations and UI rebuilds (`Whale.enableDevTools()`).
- **Persistent State:** Automatic local storage syncing with `persistentState('key', value)`.
- **Naming Aliases:** Standard technical aliases like `Signal`, `Controller`, `Store`, and `Injector` for easier adoption.

### Improvements & Fixes

- **Performance:** Optimized the dependency graph to O(affected nodes) for lightning-fast UI updates.
- **Batching:** Implemented `mutate()` to suppress redundant UI repaints during multiple state updates.
- **Async Handling:** Simplified `AsyncPod` with `.obx()` for cleaner loading/error states.
- **Architecture:** Refined the internal `Reef` engine for better stability and predictable teardowns.

## 0.0.1

Initial release of Blue Whale – Intuitive State Management for Flutter.

### Features

- State management using `WhalePod<T>` for reactive state and `WhaleCurrent<T>` for stream-based state.
- Dependency injection with `Reef.i.put()`, `lazyPut()`, `factory()`, and `use<T>()`.
- Navigation via `BlueWhale.navigator` using contextless named routes with argument support.
- Overlays using `BlueWhale.overlays` to display dialogs, snackbars, and bottom sheets.
- UI composition with `WhaleSurface`, `WhaleBuilder`, and lifecycle-aware `WhaleTank`.
- Internationalization (i18n) support using `WhaleTranslations` and the `.bwTr()` extension.
- Clean and intuitive architecture with minimal boilerplate.

### Testing

- Core features are covered by integration tests.
- A sample app is included in the `/example` directory.
