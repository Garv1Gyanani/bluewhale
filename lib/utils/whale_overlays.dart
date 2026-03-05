import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide showDialog, showModalBottomSheet;
import 'package:flutter/material.dart' as material
    show showDialog, showModalBottomSheet;
import '../navigation/whale_navigator.dart'; // For type

/// WhaleOverlays: Provides easy methods to show dialogs, snackbars, and bottom sheets.
/// Requires `BlueWhale.initialize()` to have been called with a `navigatorKey`.
class WhaleOverlays {
  final WhaleNavigator
      _navigator; // Keep a direct reference if passed during construction

  WhaleOverlays({required WhaleNavigator navigator}) : _navigator = navigator;

  BuildContext? get _context => _navigator.currentContext;

  /// Shows a Material Design dialog.
  Future<T?> showDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color? barrierColor = Colors.black54,
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    bool useSafeArea = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint, // Added from Flutter's showDialog
  }) {
    final activeContext = _context;
    if (activeContext == null) {
      if (kDebugMode)
        print(
            "BlueWhale ERROR: Attempted to showDialog but navigator context is null. Ensure BlueWhale.initialize() was called and a page is visible.");
      return Future.value(null);
    }
    // Use the top-level showDialog from Flutter (already imported via material.dart)
    // To avoid name collision with this method, we must be explicit about the context.
    return material.showDialog<T>(
      context: activeContext,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
    );
  }

  /// Shows a SnackBar.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar({
    required SnackBar snackBar,
  }) {
    final activeContext = _context;
    if (activeContext == null) {
      if (kDebugMode)
        print(
            "BlueWhale ERROR: Attempted to showSnackbar but navigator context is null.");
      throw Exception("Navigator context is null, cannot show Snackbar.");
    }
    return ScaffoldMessenger.of(activeContext).showSnackBar(snackBar);
  }

  /// Shows a Material Design bottom sheet.
  Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    bool isScrollControlled = false,
    bool useRootNavigator =
        false, // Usually false when using WhaleNavigator's key
    bool isDismissible = true,
    bool enableDrag = true,
    AnimationController?
        transitionAnimationController, // Advanced: manage your own animation
    RouteSettings? routeSettings,
    Color? barrierColor, // Added from showModalBottomSheet
    bool useSafeArea = false, // Added from showModalBottomSheet
  }) {
    final activeContext = _context;
    if (activeContext == null) {
      if (kDebugMode)
        print(
            "BlueWhale ERROR: Attempted to showModalBottomSheet but navigator context is null.");
      return Future.value(null);
    }
    return material.showModalBottomSheet<T>(
      context: activeContext, // Corrected to use showModalBottomSheet function
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      transitionAnimationController: transitionAnimationController,
      routeSettings: routeSettings,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
    );
  }
}
