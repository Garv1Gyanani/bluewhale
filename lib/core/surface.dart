import 'package:flutter/widgets.dart';
import 'reef.dart'; // Assumes you have a Reef class defined for dependency management

/// Internal InheritedWidget to provide the WhaleSurfaceState down the tree
/// for `WhalePod.watch(context)` to discover.
class WhaleListenerScopeProvider extends InheritedWidget {
  final WhaleSurfaceState? surfaceState;

  const WhaleListenerScopeProvider({
    super.key,
    required this.surfaceState,
    required super.child,
  });

  @override
  bool updateShouldNotify(WhaleListenerScopeProvider oldWidget) {
    return surfaceState != oldWidget.surfaceState;
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

abstract class WhaleSurfaceState<T extends WhaleSurface> extends State<T> {
  final Set<ValueNotifier<dynamic>> _listenedPods = {};

  /// Get a dependency from Reef.
  D use<D extends Object>({String? tag}) {
    return Reef.i.find<D>(tag: tag);
  }

  /// Register a pod to listen for changes and rebuild on update.
  void listenTo<V>(ValueNotifier<V> pod) {
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
    return WhaleListenerScopeProvider(
      surfaceState: this,
      child: widget.build(context),
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
