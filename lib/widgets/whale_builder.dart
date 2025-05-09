import 'package:flutter/widgets.dart';
import '../core/pod.dart';

/// WhaleBuilder: A widget that rebuilds when a specific `WhalePod` changes.
/// This is useful for more granular reactive updates without needing a full `WhaleSurface`.
///
/// It listens to a `WhalePod` and calls the [builder] function whenever
/// the pod's value changes. The `watch` method is implicitly handled here.
class WhaleBuilder<P extends WhalePod<V>, V> extends StatefulWidget {
  /// The `WhalePod` to listen to.
  final P pod;

  /// A builder function that constructs the widget tree.
  /// It receives the `BuildContext`, the `WhalePod` instance, and its current `value`.
  final Widget Function(BuildContext context, P pod, V value) builder;

  const WhaleBuilder({
    super.key,
    required this.pod,
    required this.builder,
  });

  @override
  State<WhaleBuilder<P, V>> createState() => _WhaleBuilderState<P, V>();
}

class _WhaleBuilderState<P extends WhalePod<V>, V> extends State<WhaleBuilder<P, V>> {
  late V _value;

  @override
  void initState() {
    super.initState();
    _value = widget.pod.value;
    widget.pod.addListener(_onPodChanged);
  }

  void _onPodChanged() {
    if (mounted) {
      final newValue = widget.pod.value;
      // Optimization: only rebuild if value actually changed,
      // especially important if T is a complex object and `==` is well-defined.
      if (!identical(_value, newValue) && _value != newValue) {
        setState(() {
          _value = newValue;
        });
      } else if (identical(_value, newValue) && _value is List || _value is Map || _value is Set) {
        // For collections, even if identical, their content might have changed
        // if the pod's value setter called notifyListeners without changing the instance.
        // This is a common pattern.
         setState(() {
          // _value is already newValue here
        });
      }
    }
  }

  @override
  void didUpdateWidget(WhaleBuilder<P, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pod != oldWidget.pod) {
      oldWidget.pod.removeListener(_onPodChanged);
      _value = widget.pod.value;
      widget.pod.addListener(_onPodChanged);
    }
  }

  @override
  void dispose() {
    widget.pod.removeListener(_onPodChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No need to call widget.pod.watch(context) here, as this widget manages listening itself.
    return widget.builder(context, widget.pod, _value);
  }
}