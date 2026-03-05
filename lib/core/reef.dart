import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'tank.dart';
import '../navigation/whale_route_aware_tank.dart';

abstract class WhaleDisposable {
  void dispose();
}

class _DependencyInjector<T> {
  final T Function()? _factory;
  T? _instance;
  final bool _isSingleton;
  bool _isInitialized = false;

  _DependencyInjector.lazySingleton(T Function() factory)
      : _factory = factory,
        _isSingleton = true;

  _DependencyInjector.factory(T Function() factory)
      : _factory = factory,
        _isSingleton = false;

  T get instance {
    if (_isSingleton) {
      if (!_isInitialized) {
        if (_factory == null && _instance == null) {
          throw Exception(
              "BlueWhale Internal Error: Singleton factory/instance is null but not initialized.");
        }
        _instance ??= _factory!();
        _isInitialized = true;
        _notifyInitialized(_instance);
      }
      return _instance!;
    } else {
      final newInstance = _factory!();
      _notifyInitialized(newInstance);
      return newInstance;
    }
  }

  void _notifyInitialized(T? inst) {
    if (inst is WhaleTank) {
      if (!inst.isInitialized) inst.onInit();
      Future.microtask(() {
        if (inst.isInitialized && !inst.isReady && !inst.isClosed) {
          inst.onReady();
        }
      });
    }
  }

  void dispose() {
    if (_instance != null) {
      if (_instance is WhaleTank) {
        (_instance as WhaleTank).markClosed();
        (_instance as WhaleTank).onClose();
      } else if (_instance is WhaleDisposable) {
        (_instance as WhaleDisposable).dispose();
      }
    }
    _instance = null;
    _isInitialized = false;
  }
}

class Reef {
  Reef._privateConstructor();
  static final Reef _instance = Reef._privateConstructor();

  static Reef get i => _instance;

  final Map<String, _DependencyInjector<dynamic>> _dependencies = {};
  final List<WhaleRouteAwareTank> _routeAwareTanks = [];

  String _generateKey<T>(String? tag) =>
      tag == null ? T.toString() : '${T.toString()}#$tag';

  void _registerRouteAware(dynamic instance) {
    if (instance is WhaleRouteAwareTank &&
        !_routeAwareTanks.contains(instance)) {
      _routeAwareTanks.add(instance);
    }
  }

  void _unregisterRouteAware(dynamic instance) {
    if (instance is WhaleRouteAwareTank) {
      _routeAwareTanks.remove(instance);
    }
  }

  // Renamed to public methods
  void notifyDidPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final tank in List<WhaleRouteAwareTank>.from(_routeAwareTanks)) {
      tank.didPush(route, previousRoute);
    }
  }

  void notifyDidPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final tank in List<WhaleRouteAwareTank>.from(_routeAwareTanks)) {
      tank.didPop(route, previousRoute);
    }
  }

  void notifyDidReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    for (final tank in List<WhaleRouteAwareTank>.from(_routeAwareTanks)) {
      tank.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    }
  }

  void notifyDidRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final tank in List<WhaleRouteAwareTank>.from(_routeAwareTanks)) {
      tank.didRemove(route, previousRoute);
    }
  }

  void put<T extends Object>(T instance, {String? tag, bool override = false}) {
    final key = _generateKey<T>(tag);
    if (!override && _dependencies.containsKey(key)) {
      if (kDebugMode) {
        print(
            'WARNING (BlueWhale): Dependency $key already registered. Use override:true if intentional.');
      }
      return;
    }
    if (_dependencies.containsKey(key)) {
      _unregisterRouteAware(_dependencies[key]?._instance);
      _dependencies[key]?.dispose();
    }
    // Use lazySingleton with a constant factory to allow recreation if disposed
    _dependencies[key] = _DependencyInjector<T>.lazySingleton(() => instance);

    // We notify initialization immediately for 'put' because the instance exists
    _dependencies[key]!.instance;

    if (kDebugMode) print('INFO (BlueWhale): $key registered.');
  }

  void lazyPut<T extends Object>(T Function() factory,
      {String? tag, bool override = false}) {
    final key = _generateKey<T>(tag);
    if (!override && _dependencies.containsKey(key)) {
      if (kDebugMode)
        print(
            'WARNING (BlueWhale): Dependency $key already registered. Use override:true if intentional.');
      return;
    }
    if (_dependencies.containsKey(key)) {
      _unregisterRouteAware(_dependencies[key]?._instance);
      _dependencies[key]?.dispose();
    }
    _dependencies[key] = _DependencyInjector<T>.lazySingleton(() {
      final instance = factory();
      _registerRouteAware(instance);
      return instance;
    });
    if (kDebugMode) print('INFO (BlueWhale): Lazy $key registered.');
  }

  void factory<T extends Object>(T Function() factory,
      {String? tag, bool override = false}) {
    final key = _generateKey<T>(tag);
    if (!override && _dependencies.containsKey(key)) {
      if (kDebugMode)
        print(
            'WARNING (BlueWhale): Factory $key already registered. Use override:true if intentional.');
      return;
    }
    _dependencies[key] = _DependencyInjector<T>.factory(() => factory());
    if (kDebugMode) print('INFO (BlueWhale): Factory $key registered.');
  }

  T find<T extends Object>({String? tag}) {
    final key = _generateKey<T>(tag);
    final injector = _dependencies[key];
    if (injector == null) {
      throw Exception('BlueWhale Error: Dependency $key not found.');
    }
    return injector.instance as T;
  }

  bool delete<T extends Object>({String? tag, bool permanent = true}) {
    final key = _generateKey<T>(tag);
    final injector = permanent ? _dependencies.remove(key) : _dependencies[key];
    if (injector != null) {
      if (permanent) {
        _unregisterRouteAware(injector._instance);
      }
      injector.dispose();
      if (kDebugMode)
        print(
            'INFO (BlueWhale): $key ${permanent ? "deleted and" : ""} disposed.');
      return true;
    }
    return false;
  }

  void reset() {
    for (final key in List<String>.from(_dependencies.keys)) {
      final injector = _dependencies.remove(key);
      if (injector != null) {
        _unregisterRouteAware(injector._instance);
        injector.dispose();
      }
    }
    _dependencies.clear();
    _routeAwareTanks.clear();
    if (kDebugMode)
      print('INFO (BlueWhale): Reef reset. All dependencies cleared.');
  }
}
