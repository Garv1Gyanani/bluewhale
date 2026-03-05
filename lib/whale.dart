import 'package:flutter/material.dart';
import 'blue_whale_facade.dart';
import 'core/reef.dart';
import 'navigation/whale_route.dart';
import 'core/devtools.dart';

/// 'Whale' is the absolute simplest way to call Blue Whale features.
/// It works just like GetX's 'Get' class.
class Whale {
  Whale._();

  // --- Dependency Injection ---
  /// Register an instance into the dependency container.
  static void put<T extends Object>(T instance,
          {String? tag, bool override = false}) =>
      Reef.i.put<T>(instance, tag: tag, override: override);

  /// Find an instance from the dependency container.
  static T find<T extends Object>({String? tag}) => Reef.i.find<T>(tag: tag);

  /// Lazily register a factory into the dependency container.
  static void lazyPut<T extends Object>(T Function() factory,
          {String? tag, bool override = false}) =>
      Reef.i.lazyPut<T>(factory, tag: tag, override: override);

  /// Remove an instance from the dependency container.
  static bool delete<T extends Object>({String? tag, bool permanent = true}) =>
      Reef.i.delete<T>(tag: tag, permanent: permanent);

  // --- Navigation ---
  /// Navigate to a new route.
  static Future<T?>? to<T extends Object?>(String routeName,
          {dynamic arguments}) =>
      BlueWhale.navigator.to<T>(routeName, arguments: arguments);

  /// Replace the current route.
  static Future<T?>? off<T extends Object?, TO extends Object?>(
          String routeName,
          {dynamic arguments,
          TO? result}) =>
      BlueWhale.navigator
          .off<T, TO>(routeName, arguments: arguments, result: result);

  /// Clear all previous routes and navigate to a new one.
  static Future<T?>? offAll<T extends Object?>(String routeName,
          {dynamic arguments}) =>
      BlueWhale.navigator.offAll<T>(routeName, arguments: arguments);

  /// Navigate back to the previous route.
  static void back<T extends Object?>({T? result}) =>
      BlueWhale.navigator.back<T>(result: result);

  /// Get the arguments passed to the current route.
  static WhaleRouteArguments? get arguments => BlueWhale.navigator.arguments;

  /// Get the current route name.
  static String? get currentRouteName => BlueWhale.navigator.currentRouteName;

  // --- Overlays ---
  /// Show a simple dialog.
  static Future<T?> showDialog<T>(
          {required WidgetBuilder builder, bool barrierDismissible = true}) =>
      BlueWhale.overlays
          .showDialog(builder: builder, barrierDismissible: barrierDismissible);

  /// Show a snackbar quickly.
  static void showSnackbar(String message,
          {Duration duration = const Duration(seconds: 4)}) =>
      BlueWhale.overlays.showSnackbar(
          snackBar: SnackBar(content: Text(message), duration: duration));

  /// Show a bottom sheet.
  static Future<T?> showBottomSheet<T>(
          {required WidgetBuilder builder, Color? backgroundColor}) =>
      BlueWhale.overlays
          .showBottomSheet(builder: builder, backgroundColor: backgroundColor);

  // --- Diagnostics ---
  /// Enable deep diagnostic logging for Blue Whale.
  /// This will log all state mutations and UI rebuilds to the console.
  static void enableDevTools() => WhaleDevTools.enabled = true;
}
