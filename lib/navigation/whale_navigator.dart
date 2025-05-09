import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'whale_route.dart';
import '../core/reef.dart'; // To notify Reef about route changes
import '../blue_whale_facade.dart'; // For BlueWhale.navigator access in observer

class WhaleNavigatorObserver extends NavigatorObserver {
  final Reef _reef; // To notify route-aware tanks
  WhaleNavigatorObserver(this._reef);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _reef.notifyDidPush(route, previousRoute);
    try {
      BlueWhale.navigator._updateCurrentRouteInfo(route);
    } catch (_) { /* Reef might not have WhaleNavigator yet during early pushes */ }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _reef.notifyDidPop(route, previousRoute);
    try {
      if (previousRoute != null) {
        BlueWhale.navigator._updateCurrentRouteInfo(previousRoute);
      } else {
        BlueWhale.navigator._clearCurrentRouteInfo();
      }
    } catch (_) {}
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _reef.notifyDidReplace(newRoute: newRoute, oldRoute: oldRoute);
    try {
      if (newRoute != null) {
        BlueWhale.navigator._updateCurrentRouteInfo(newRoute);
      } else {
         BlueWhale.navigator._clearCurrentRouteInfo(); // If newRoute is null, something odd happened or stack cleared
      }
    } catch (_) {}
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _reef.notifyDidRemove(route, previousRoute);
    try {
      // After removal, the "current" route is typically the one now at the top.
      // This is hard to determine perfectly without inspecting the navigator's internal stack.
      // If previousRoute exists and is different, assume it might be the new top.
      if (previousRoute != null && previousRoute != route) {
        BlueWhale.navigator._updateCurrentRouteInfo(previousRoute);
      } else {
        // Fallback: attempt to get current route from navigator state if possible,
        // or clear if navigator state doesn't have active routes.
        // This part is tricky as Navigator 1.0 doesn't easily expose its stack.
        // For now, clearing if previousRoute isn't a good indicator.
        BlueWhale.navigator._clearCurrentRouteInfo();
      }
    } catch (_) {}
  }
}


/// WhaleNavigator: Handles navigation for the application.
/// Uses named routes and provides simple contextless navigation methods.
class WhaleNavigator {
  final GlobalKey<NavigatorState> navigatorKey;
  final Map<String, WhaleRoute> _routes = {};
  WhaleRouteArguments? _currentArguments;
  String? _currentRouteName;

  WhaleNavigator({required this.navigatorKey, required List<WhaleRoute> routes}) {
    for (var route in routes) {
      _routes[route.name] = route;
    }
  }

  NavigatorObserver get observer => WhaleNavigatorObserver(Reef.i);

  BuildContext? get currentContext => navigatorKey.currentContext;

  WhaleRouteArguments? get arguments => _currentArguments;
  String? get currentRouteName => _currentRouteName;

  void _updateCurrentRouteInfo(Route<dynamic> route) {
    _currentRouteName = route.settings.name;
    if (route.settings.arguments is WhaleRouteArguments) {
      _currentArguments = route.settings.arguments as WhaleRouteArguments;
    } else if (route.settings.arguments != null) {
      _currentArguments = WhaleRouteArguments(route.settings.arguments);
    } else {
      _currentArguments = null;
    }
  }

  void _clearCurrentRouteInfo() {
    _currentRouteName = null;
    _currentArguments = null;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final whaleRoute = _routes[routeName];

    if (whaleRoute == null) {
      if (kDebugMode) print("BlueWhale WARNING: Route '$routeName' not found!");
      return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text("Route '$routeName' not found"))));
    }

    WhaleRouteArguments? routeArgs;
    if (settings.arguments != null) {
      if (settings.arguments is WhaleRouteArguments) {
        routeArgs = settings.arguments as WhaleRouteArguments;
      } else {
        routeArgs = WhaleRouteArguments(settings.arguments);
      }
    }
    // _updateCurrentRouteInfo will be called by the observer on didPush
    // So, setting _currentArguments and _currentRouteName here is mainly for the initial build of the page.

    return MaterialPageRoute(
      settings: settings,
      builder: (context) => whaleRoute.pageBuilder(context, routeArgs),
    );
  }

  Future<T?>? to<T extends Object?>(String routeName, {dynamic arguments}) {
    final routeArgs = arguments != null ? WhaleRouteArguments(arguments) : null;
    return navigatorKey.currentState?.pushNamed<T>(routeName, arguments: routeArgs);
  }

  Future<T?>? off<T extends Object?, TO extends Object?>(String routeName, {dynamic arguments, TO? result}) {
    final routeArgs = arguments != null ? WhaleRouteArguments(arguments) : null;
    return navigatorKey.currentState?.popAndPushNamed<T, TO>(routeName, arguments: routeArgs, result: result);
  }

  Future<T?>? offAll<T extends Object?>(String routeName, {dynamic arguments, RoutePredicate? predicate}) {
    final routeArgs = arguments != null ? WhaleRouteArguments(arguments) : null;
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: routeArgs,
    );
  }

  void back<T extends Object?>({T? result}) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop<T>(result);
    }
  }
}