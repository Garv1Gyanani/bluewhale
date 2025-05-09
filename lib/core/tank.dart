import 'package:flutter/foundation.dart';
import 'reef.dart'; // For WhaleDisposable

/// WhaleTank: A container for business logic, managing one or more WhalePods.
abstract class WhaleTank implements WhaleDisposable {
  bool _isInitialized = false;
  bool _isReady = false;
  bool _isClosed = false;

  @mustCallSuper
  void onInit() {
    _isInitialized = true;
    _isClosed = false;
  }

  @mustCallSuper
  void onReady() {
    if (_isClosed || !_isInitialized) return;
    _isReady = true;
  }

  @override
  void dispose() {
    onClose();
  }

  @mustCallSuper
  void onClose() {
    _isClosed = true;
    _isInitialized = false;
    _isReady = false;
  }

  /// Public method to allow Reef to mark the tank as closed before disposal.
  @mustCallSuper
  void markClosed() {
    _isClosed = true;
  }

  bool get isInitialized => _isInitialized && !_isClosed;
  bool get isReady => _isReady && !_isClosed;
  bool get isClosed => _isClosed;
}
