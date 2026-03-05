import 'dart:async';
import 'reef.dart'; // For WhaleDisposable

/// WhaleCurrent: A wrapper around Dart's Stream and StreamController
/// for managing asynchronous data flows, with reactive capabilities.
class WhaleCurrent<T> implements WhaleDisposable {
  final StreamController<T> _controller;
  final bool _isBroadcast;

  /// Creates a single-subscription WhaleCurrent.
  WhaleCurrent()
      : _controller = StreamController<T>(),
        _isBroadcast = false;

  /// Creates a broadcast (multiple-subscription) WhaleCurrent.
  WhaleCurrent.broadcast()
      : _controller = StreamController<T>.broadcast(),
        _isBroadcast = true;

  /// The underlying stream.
  Stream<T> get stream => _controller.stream;

  /// Adds an event to the stream.
  void add(T event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Adds an error event to the stream.
  void addError(Object error, [StackTrace? stackTrace]) {
    if (!_controller.isClosed) {
      _controller.addError(error, stackTrace);
    }
  }

  /// Closes the stream. No more events can be added.
  @override
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }

  bool get isBroadcast => _isBroadcast;
  bool get isClosed => _controller.isClosed;
  bool get hasListener => _controller.hasListener;
}
