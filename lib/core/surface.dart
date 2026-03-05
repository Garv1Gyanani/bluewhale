import 'package:flutter/widgets.dart';
import 'reef.dart'; // Assumes you have a Reef class defined for dependency management
import 'pod.dart'; // Core pod components, like PodTracker

/// Interface for objects that can listen to Pods.
abstract class WhalePodListener {
  void listenTo<T>(WhalePod<T> pod);
}

/// Internal InheritedWidget to provide the WhaleSurfaceState down the tree
/// for `WhalePod.watch(context)` to discover.
class WhaleListenerScopeProvider extends InheritedWidget {
  final WhalePodListener? surfaceState;
  final WhalePodListener? builderState; // New: for WhaleBuilder

  const WhaleListenerScopeProvider({
    super.key,
    this.surfaceState,
    this.builderState,
    required super.child,
  });

  WhalePodListener? get listener => surfaceState ?? builderState;

  @override
  bool updateShouldNotify(WhaleListenerScopeProvider oldWidget) {
    return surfaceState != oldWidget.surfaceState ||
        builderState != oldWidget.builderState;
  }
}

/// WhaleSurface: A widget that can access dependencies and rebuild reactively.
abstract class WhaleSurface extends StatefulWidget {
  const WhaleSurface({super.key});

  @override
  WhaleSurfaceState createState();

  /// Override this to define the widget's UI.
  Widget build(BuildContext context);
}

abstract class WhaleSurfaceState<T extends WhaleSurface> extends State<T>
    implements WhalePodListener {
  final Set<WhalePod<dynamic>> _listenedPods = {};

  /// Get a dependency from Reef.
  D use<D extends Object>({String? tag}) {
    return Reef.i.find<D>(tag: tag);
  }

  /// Register a pod to listen for changes and rebuild on update.
  @override
  void listenTo<V>(WhalePod<V> pod) {
    if (_listenedPods.add(pod)) {
      if (mounted) {
        pod.addListener(_rebuildListener);
      }
    }
  }

  void _rebuildListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Prepare to track which pods are accessed during this build.
    final oldPods = _listenedPods.toSet();
    _listenedPods.clear();

    // 2. Set this surface as the active listener for the PodTracker.
    final previousListener = PodTracker.currentListener;
    PodTracker.currentListener = this;

    // 3. Execute the build function. Any pod value accessed here will trigger listenTo.
    final result = widget.build(context);

    // 4. Restore the previous listener.
    PodTracker.currentListener = previousListener;

    // 5. Cleanup: Remove listeners from pods that were NOT accessed during this build.
    for (final p in oldPods) {
      if (!_listenedPods.contains(p)) {
        p.removeListener(_rebuildListener);
      }
    }

    return WhaleListenerScopeProvider(
      surfaceState: this,
      child: result,
    );
  }

  @override
  void dispose() {
    for (final pod in _listenedPods) {
      pod.removeListener(_rebuildListener);
    }
    _listenedPods.clear();
    super.dispose();
  }
}
