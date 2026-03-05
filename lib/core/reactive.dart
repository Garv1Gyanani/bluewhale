import 'pod.dart';
import 'persistent.dart';
import 'tank.dart'; // Needed for Controller typedef
import 'reef.dart'; // Needed for Injector/Container typedefs
import '../widgets/pod_builder.dart';

/// ---- Standard Technical Naming Aliases ----
/// For developers who prefer standard framework conceptual naming:
typedef Signal<T> = WhalePod<T>;
typedef Controller = WhaleTank;
typedef Store = WhaleTank;
typedef Injector = Reef;
typedef ReactiveWidget = PodBuilder;
typedef ReactiveView = View;

/// The simplest way to declare state. Alias for creating a WhalePod.
/// Example: `final counter = state(0);`
WhalePod<T> state<T>(T initialValue) => WhalePod<T>(initialValue);

/// The simplest way to declare automatically persisting state using SharedPreferences.
/// It syncs changes asynchronously without halting the UI thread!
/// Note: Call `await WhaleStorage.init();` in main() before declaring!
WhalePod<T> persistentState<T>(String key, T defaultValue) {
  return PersistentPod<T>(key, defaultValue);
}

/// Run multiple state updates in a single batch, triggering only one UI rebuild.
/// Prevents redundant repaints when updating multiple tightly coupled states.
void mutate(void Function() updates) {
  PodTracker.startBatch();
  try {
    updates();
  } finally {
    PodTracker.endBatch();
  }
}

/// Helper alias to batch mutations. Exactly the same as [mutate].
void set(void Function() updates) => mutate(updates);

/// The simplest possible way to render reactive widgets.
/// An exact alias for [PodBuilder], aligning perfectly with the minimalist paradigm.
class View extends PodBuilder {
  const View(super.builder, {super.key});
}

/// A computed state that derives its value from other reactive states.
/// It automatically tracks dependencies and updates when they change.
WhalePod<T> derive<T>(T Function() compute) {
  return DerivedPod<T>(compute);
}

class DerivedPod<T> extends WhalePod<T> {
  final T Function() _compute;
  Set<WhalePod> _dependencies = {};

  DerivedPod._(this._compute, super.initialValue);

  factory DerivedPod(T Function() compute) {
    PodTracker.startTrackingReads();
    final initialValue = compute();
    final deps = PodTracker.endTrackingReads();

    final pod = DerivedPod._(compute, initialValue);
    pod._dependencies = deps;
    for (var dep in deps) {
      dep.addListener(pod._onDependencyChanged);
    }
    return pod;
  }

  void _updateAndTrack() {
    PodTracker.startTrackingReads();
    final newValue = _compute();
    final newDeps = PodTracker.endTrackingReads();

    // Remove old listeners
    for (var dep in _dependencies) {
      if (!newDeps.contains(dep)) {
        dep.removeListener(_onDependencyChanged);
      }
    }
    // Add new listeners
    for (var dep in newDeps) {
      if (!_dependencies.contains(dep)) {
        dep.addListener(_onDependencyChanged);
      }
    }

    _dependencies = newDeps;

    // Use property setter to notify listeners safely, batched if necessary
    if (value != newValue) {
      value =
          newValue; // Automatically triggers batched notification properly mapped in WhalePod
    }
  }

  void _onDependencyChanged() {
    _updateAndTrack();
  }

  @override
  void dispose() {
    for (var dep in _dependencies) {
      dep.removeListener(_onDependencyChanged);
    }
    super.dispose();
  }

  @override
  set value(T newValue) {
    // Derived states should only be internally mutated
    if (_dependencies.isEmpty) {
      // Edge case during super constructor
      super.value = newValue;
      return;
    }
    throw UnsupportedError(
        'Cannot manually set the value of a DerivedPod. It is computed automatically.');
  }
}
