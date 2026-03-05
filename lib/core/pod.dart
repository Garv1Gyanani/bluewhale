import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'devtools.dart';
import 'reef.dart';
import 'surface.dart';

class _Marker {
  const _Marker();
}

const _marker = _Marker();

/// State tracker for discovering reactive variables implicitly.
class PodTracker {
  static WhalePodListener? currentListener;

  // Tracking stack for derived computations (handles nested derive calls)
  static final List<Set<WhalePod>> _trackerStack = [];

  static void startTrackingReads() => _trackerStack.add({});

  static Set<WhalePod> endTrackingReads() {
    return _trackerStack.isEmpty ? {} : _trackerStack.removeLast();
  }

  /// Register a read to wire up contextual scopes or derivations.
  static void reportRead(WhalePod pod) {
    currentListener?.listenTo(pod);
    if (_trackerStack.isNotEmpty) {
      _trackerStack.last.add(pod);
    }
  }

  // Batching logic for batched mutations (prevents multiple UI rebuilds)
  static int _batchLevel = 0;
  static final Set<WhalePod> _batchedPods = {};

  static bool get isBatching => _batchLevel > 0;

  static void startBatch() => _batchLevel++;

  static void queueBatchedNotification(WhalePod pod) => _batchedPods.add(pod);

  static void endBatch() {
    _batchLevel--;
    if (_batchLevel <= 0) {
      _batchLevel = 0;
      for (var pod in _batchedPods) {
        pod.notify();
      }
      _batchedPods.clear();
    }
  }
}

/// WhalePod: Reactive container for a single value of type [T].
class WhalePod<T> extends ChangeNotifier
    implements ValueListenable<T>, WhaleDisposable {
  T _value;

  WhalePod(this._value);

  @override
  T get value {
    PodTracker.reportRead(this);
    return _value;
  }

  set value(T newValue) {
    if (_value != newValue) {
      WhaleDevTools.logMutation(this, _value, newValue);
      _value = newValue;
      if (PodTracker.isBatching) {
        PodTracker.queueBatchedNotification(this);
      } else {
        notifyListeners();
      }
    }
  }

  /// Callable support! e.g. `counter()` to get, and `counter(10)` to set.
  T call([dynamic newValue = _marker]) {
    if (newValue != _marker) {
      value = newValue as T;
    }
    return value;
  }

  /// Expose explicitly to process batched changes internally.
  void notify() => notifyListeners();

  /// Registers context to explicitly rebuild when the pod value changes.
  T watch(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<WhaleListenerScopeProvider>();

    if (scope == null || scope.listener == null) {
      if (kDebugMode) {
        print(
            'BlueWhale WARNING: WhalePod<${T.toString()}>.watch(context) was called '
            'outside of a WhaleSurface or WhaleBuilder listening scope.');
      }
    } else {
      scope.listener!.listenTo<T>(this);
    }

    return value;
  }
}
