import 'package:blue_whale/navigation/whale_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'navigation/whale_navigator.dart';
import 'utils/whale_overlays.dart';
import 'core/reef.dart';
import 'internationalization/whale_locale_pod.dart';
import 'internationalization/whale_translations.dart';

/// BlueWhale: A global facade for accessing common Blue Whale utilities.
/// This simplifies access to navigation, overlays, and other global services.
class BlueWhale {
  BlueWhale._(); // Private constructor

  /// Access to the navigation system.
  /// Ensure `WhaleNavigator.navigatorKey` is set on your `MaterialApp`.
  static WhaleNavigator get navigator => Reef.i.find<WhaleNavigator>();

  /// Access to overlay utilities (dialogs, snackbars, bottom sheets).
  /// Requires `WhaleNavigator.navigatorKey` to be set.
  static WhaleOverlays get overlays => Reef.i.find<WhaleOverlays>();

  /// Initializes key Blue Whale services.
  /// Call this in your `main()` function before `runApp()`.
  ///
  /// [navigatorKey] is the GlobalKey<NavigatorState> used by your MaterialApp.
  /// [appRoutes] is a list of `WhaleRoute` for your application's navigation.
  /// [initialLocale] is the starting locale for i18n.
  /// [translations] are your app's translations.
  static void initialize({
    required GlobalKey<NavigatorState> navigatorKey,
    required List<WhaleRoute> appRoutes,
    Locale initialLocale = const Locale('en'),
    WhaleTranslations? translations,
  }) {
    // Register Navigator
    final whaleNavigator = WhaleNavigator(navigatorKey: navigatorKey, routes: appRoutes);
    Reef.i.put<WhaleNavigator>(whaleNavigator);

    // Register Overlay Utilities
    Reef.i.put<WhaleOverlays>(WhaleOverlays(navigator: whaleNavigator));

    // Register i18n services
    if (translations != null) {
      Reef.i.put<WhaleTranslations>(translations);
      Reef.i.put<WhaleLocalePod>(WhaleLocalePod(initialLocale));
    } else {
      // Register a dummy WhaleLocalePod if no translations, so .tr doesn't crash
      // but warns.
      Reef.i.put<WhaleLocalePod>(WhaleLocalePod(initialLocale, isDummy: true));
    }
     if (kDebugMode) {
        print("BlueWhale initialized. Navigator, Overlays, and i18n (if provided) are ready.");
    }
  }

  /// Translates a key using the registered `WhaleTranslations` and `WhaleLocalePod`.
  /// Requires `BuildContext` to watch for locale changes.
  /// Throws an error if i18n services are not initialized properly.
  static String tr(String key, BuildContext context) {
    try {
      final localePod = Reef.i.find<WhaleLocalePod>();
      if (localePod.isDummy) {
        if (kDebugMode) {
          print("BlueWhale WARNING: Attempting to translate '$key' but WhaleTranslations not provided during BlueWhale.initialize().");
        }
        return key; // Return key if translations are not set up
      }
      final currentLocale = localePod.watch(context); // Makes widget reactive to locale changes
      final translations = Reef.i.find<WhaleTranslations>();
      return translations.translate(key, currentLocale);
    } catch (e) {
      // This typically means WhaleLocalePod or WhaleTranslations wasn't found in Reef
      if (kDebugMode) {
        print("BlueWhale ERROR in tr('$key'): $e. Ensure BlueWhale.initialize() was called with translations, and Reef is accessible.");
      }
      return key; // Fallback to key
    }
  }
}