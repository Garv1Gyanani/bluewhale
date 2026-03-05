import 'package:flutter/widgets.dart';
import '../whale.dart';

/// A scoped dependency injection container for Blue Whale.
/// Dependencies registered in this scope will be automatically destroyed and removed
/// from memory when this widget is removed from the widget tree (e.g., navigating away).
/// 
/// This completely solves memory leaks associated with global Dependency Injection.
class WhaleScope extends StatefulWidget {
  final Widget child;
  
  /// A builder where you can register dependencies specific to this scope.
  /// E.g. `setup: (scope) => scope.put(LoginController())`
  final void Function(WhaleScopeRegistry scope)? setup;

  const WhaleScope({
    super.key,
    required this.child,
    this.setup,
  });

  @override
  State<WhaleScope> createState() => _WhaleScopeState();
}

/// Registry passed to [WhaleScope.setup] that tracks all allocations.
class WhaleScopeRegistry {
  final List<void Function()> _teardowns = [];

  /// Injects a dependency synchronously and tracks it for scoped cleanup.
  void put<T extends Object>(T dependency, {String? tag}) {
    Whale.put<T>(dependency, tag: tag);
    _teardowns.add(() => Whale.delete<T>(tag: tag));
  }

  /// Injects a lazily evaluated dependency and tracks it for scoped cleanup.
  void lazyPut<T extends Object>(T Function() builder, {String? tag}) {
    Whale.lazyPut<T>(builder, tag: tag);
    _teardowns.add(() => Whale.delete<T>(tag: tag));
  }

  /// Cleans up all tracked dependencies from the global Reef.
  void disposeAll() {
    for (var teardown in _teardowns) {
      teardown();
    }
    _teardowns.clear();
  }
}

class _WhaleScopeState extends State<WhaleScope> {
  late final WhaleScopeRegistry _registry;

  @override
  void initState() {
    super.initState();
    _registry = WhaleScopeRegistry();
    widget.setup?.call(_registry);
  }

  @override
  void dispose() {
    _registry.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
