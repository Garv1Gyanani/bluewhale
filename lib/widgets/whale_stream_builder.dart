import 'package:flutter/widgets.dart';
import '../core/current.dart'; // For WhaleCurrent

/// WhaleStreamBuilder: A widget that rebuilds based on the latest snapshot
/// from a `WhaleCurrent` (which wraps a Dart Stream).
///
/// Similar to Flutter's `StreamBuilder` but specifically for `WhaleCurrent`.
class WhaleStreamBuilder<T> extends StreamBuilder<T> {
  WhaleStreamBuilder({
    super.key,
    required WhaleCurrent<T> whaleCurrent,
    required super.builder,
    super.initialData,
  }) : super(stream: whaleCurrent.stream);
}