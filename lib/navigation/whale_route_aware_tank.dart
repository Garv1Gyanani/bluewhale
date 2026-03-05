import 'package:flutter/widgets.dart';
import '../core/tank.dart';
import '../core/reef.dart';
import 'whale_navigator.dart';

/// A [WhaleTank] that is aware of route changes in the application.
/// Implement this interface in your `WhaleTank` and it will receive
/// callbacks when routes are pushed or popped if the `WhaleNavigator`
/// is correctly set up with its `WhaleNavigatorObserver`.
///
/// The Tank must be registered with `Reef.i` to be discovered.
abstract class WhaleRouteAwareTank extends WhaleTank {
  @override
  void onInit() {
    super.onInit();
    try {
      final nav = Reef.i.find<WhaleNavigator>();
      if (nav.currentRoute != null) {
        didPush(nav.currentRoute!, nav.previousRoute);
      }
    } catch (_) {
      // Navigator might not be initialized yet
    }
  }

  /// Called when a new route has been pushed, and this tank's view (if any associated)
  /// might be coming into view or the app's current route changes.
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// Called when the current route has been popped off.
  /// `previousRoute` is the route that is now on top.
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// Called when a route has been removed from the navigator.
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// Called when a route has been replaced with another.
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}
}
