import 'package:flutter/widgets.dart';
import '../core/pod.dart';
import '../core/devtools.dart';
import '../core/surface.dart';

/// PodBuilder: The easiest way to make reactive UI in Blue Whale.
/// Just access `yourVariable.value` inside this builder, and it will magically rebuild!
class PodBuilder extends StatefulWidget {
  final Widget Function() builder;
  const PodBuilder(this.builder, {super.key});

  @override
  State<PodBuilder> createState() => _PodBuilderState();
}

class _PodBuilderState extends State<PodBuilder> implements WhalePodListener {
  final Set<WhalePod> _pods = {};

  @override
  void listenTo<T>(WhalePod<T> pod) {
    if (_pods.add(pod)) {
      pod.addListener(_onChange);
    }
  }

  void _onChange() {
    if (mounted) {
      WhaleDevTools.logRebuild(widget, _pods);
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (final p in _pods) {
      p.removeListener(_onChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oldPods = _pods.toSet();
    _pods.clear();

    final previousListener = PodTracker.currentListener;
    PodTracker.currentListener = this;

    final result = widget.builder();

    PodTracker.currentListener = previousListener;

    for (final p in oldPods) {
      if (!_pods.contains(p)) {
        p.removeListener(_onChange);
      }
    }

    return result;
  }
}
