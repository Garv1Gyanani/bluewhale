# Implementation Plan - Blue Whale Framework Hardening (v0.0.3)

This plan outlines the necessary fixes and improvements for the Blue Whale framework to resolve critical bugs, improve performance, and ensure architectural consistency.

## Phase 1: Immediate Bug Fixes (The "Showstoppers")

### 1. Fix `showDialog` Infinite Recursion
- **File**: `lib/utils/whale_overlays.dart`
- **Action**: Explicitly call the Flutter Material `showDialog` by passing the `context` parameter or using a library prefix to avoid the method calling itself.
- **Goal**: Prevent application crashes when opening dialogs.

### 2. Fix DI Reset Logic in Reef
- **File**: `lib/core/reef.dart`
- **Action**: 
    - Modify `Reef.put` to store a simple factory that returns the instance, even for singletons.
    - Update `_DependencyInjector` to ensure that if an instance is disposed but the factory exists, it can be recreated.
    - Prevent non-permanent deletion of dependencies that don't have a factory.
- **Goal**: Ensure `find<T>()` works correctly after a non-permanent `delete()`.

## Phase 2: Core Reactivity & Reliability

### 3. Improve `watch(context)` Detection
- **File**: `lib/core/pod.dart` and `lib/widgets/whale_builder.dart`
- **Action**: 
    - Remove the brittle `runtimeType.toString()` check.
    - Ensure `WhaleBuilder` uses `WhaleListenerScopeProvider` so that `pod.watch(context)` can find it via the standard `InheritedWidget` mechanism.
- **Goal**: Reliable reactivity in both production (minified) and development environments.

### 4. Solve "Lazy Tank Blindness"
- **File**: `lib/navigation/whale_navigator.dart` and `lib/core/reef.dart`
- **Action**: 
    - Update `WhaleNavigator` to store the current `RouteSettings`.
    - Modify `WhaleRouteAwareTank` to fetch the current route state from the navigator during its `onInit()` check.
- **Goal**: Ensure lazy tanks are immediately aware of the current app state upon instantiation.

## Phase 3: Performance & API Polish

### 5. Prevent Listener Leaks in `WhaleSurface`
- **File**: `lib/core/surface.dart`
- **Action**: 
    - Implementation of a "rebuild guard" to ensure listeners aren't duplicated across rebuilds.
    - Clear and re-register listeners during the `build` phase to ensure only "active" Pods are being watched.
- **Goal**: Reduce unnecessary memory consumption and UI churn.

### 6. Standardize Dependency Retrieval
- **File**: `lib/utils/blue_whale_di.dart` and `lib/core/surface.dart`
- **Action**: 
    - Clearly document the difference between `use<T>()` (service locator) and `watch(context)` (reactive listener).
    - Ensure both global and member-level `use` methods are consistent.
- **Goal**: Unified developer experience.

## Phase 4: Validation & Testing
- **Task**: Run the `example` project and verify:
    - Dialogs open without crashing.
    - State updates across language changes.
    - Navigation events are captured by `DataTank` even if lazily loaded.
    - Obfuscated build check (simulated).
