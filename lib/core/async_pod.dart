import 'package:flutter/material.dart';
import 'package:blue_whale/blue_whale.dart';

enum AsyncStatus { initial, loading, success, error }

/// An extended WhalePod dedicated to managing asynchronous state.
/// This tracks whether a network request or heavy operation is
/// loading, successful, or failed, enabling the [obx] pattern from GetX.
class AsyncPod<T> extends WhalePod<T?> {
  AsyncStatus _status = AsyncStatus.initial;
  Object? _error;

  AsyncPod([T? initialValue]) : super(initialValue) {
    if (initialValue != null) {
      _status = AsyncStatus.success;
    }
  }

  /// Current status of the pod execution.
  AsyncStatus get status {
    PodTracker.reportRead(this); // Track if they check `.status` directly
    return _status;
  }

  /// Returns the current error object if status == error.
  Object? get error {
    PodTracker.reportRead(this);
    return _error;
  }

  /// Mark the pod as loading.
  void loading() {
    _status = AsyncStatus.loading;
    _error = null;
    notifyListeners();
  }

  /// Set success state with the new data.
  void success(T newValue) {
    _status = AsyncStatus.success;
    _error = null;
    value = newValue; // Automatically notifies
  }

  /// Set the pod to an error state.
  void setAsError(Object e) {
    _status = AsyncStatus.error;
    _error = e;
    notifyListeners();
  }

  /// A cleaner alternative to handling UI logic explicitly.
  /// Similar to GetX's `.obx` mixin!
  Widget obx(
    Widget Function(T data) onSuccess, {
    Widget Function(Object? error)? onError,
    Widget Function()? onLoading,
    Widget Function()? onInitial,
  }) {
    PodTracker.reportRead(this); // Auto-track changes inside `obx()`!

    switch (_status) {
      case AsyncStatus.initial:
        return onInitial?.call() ?? const SizedBox.shrink();
      case AsyncStatus.loading:
        return onLoading?.call() ??
            const Center(child: CircularProgressIndicator());
      case AsyncStatus.error:
        return onError?.call(_error) ??
            Center(
                child: Text("Error: $_error",
                    style: const TextStyle(color: Color(0xFFE53935))));
      case AsyncStatus.success:
        return onSuccess(value as T);
    }
  }
}

/// Extension for creating [AsyncPod] immediately from any type or value.
extension AsyncPodExt<T> on T {
  AsyncPod<T> get asyncPod => AsyncPod<T>(this);
}
