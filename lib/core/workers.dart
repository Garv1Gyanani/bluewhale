import 'dart:async';
import 'package:flutter/foundation.dart';
import 'pod.dart';

/// Extension methods for [WhalePod] to provide advanced reactive programming patterns like debounce,
/// interval, once, and ever.
extension PodWorkers<T> on WhalePod<T> {
  /// Calls [callback] every time the value changes.
  /// Returns a function that cancels the listener.
  VoidCallback ever(void Function(T value) callback) {
    void listener() => callback(value);
    addListener(listener);
    return () => removeListener(listener);
  }

  /// Calls [callback] only once, the next time the value changes.
  VoidCallback once(void Function(T value) callback) {
    late void Function() listener;
    listener = () {
      callback(value);
      removeListener(listener);
    };
    addListener(listener);
    return () => removeListener(listener);
  }

  /// Calls [callback] when the value changes, but only after [duration]
  /// has passed without any further changes.
  /// Extremely useful for search fields to avoid spamming an API.
  VoidCallback debounce(Duration duration, void Function(T value) callback) {
    Timer? debounceTimer;
    void listener() {
      debounceTimer?.cancel();
      debounceTimer = Timer(duration, () => callback(value));
    }

    addListener(listener);
    return () {
      debounceTimer?.cancel();
      removeListener(listener);
    };
  }

  /// Calls [callback] at most once every [duration] upon changes.
  /// Useful to restrict the firing rate of rapid events (e.g. scroll metrics).
  VoidCallback interval(Duration duration, void Function(T value) callback) {
    Timer? intervalTimer;
    bool canFire = true;

    void listener() {
      if (canFire) {
        callback(value);
        canFire = false;
        intervalTimer = Timer(duration, () => canFire = true);
      }
    }

    addListener(listener);
    return () {
      intervalTimer?.cancel();
      removeListener(listener);
    };
  }
}
