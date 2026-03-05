import 'package:flutter/material.dart';
import '../blue_whale_facade.dart';
import '../core/surface.dart';
import '../internationalization/whale_locale_pod.dart';
import '../whale.dart';

/// The ultimate zero-boilerplate entry point for Blue Whale applications.
/// It wraps MaterialApp and automatically configures routing, overlays,
/// internationalization, and theme tracking.
///
/// Simply use [WhaleApp] instead of [MaterialApp].
class WhaleApp extends WhaleSurface {
  final String title;
  final String? initialRoute;
  final Map<String, WidgetBuilder>? routes;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Locale? locale;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final bool debugShowCheckedModeBanner;
  final Widget? home;

  // Custom theme/locale pods if you want WhaleApp to track them automatically.
  // If not provided, you can still manage them externally.

  const WhaleApp({
    super.key,
    this.title = 'Blue Whale App',
    this.initialRoute,
    this.routes,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.locale,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.debugShowCheckedModeBanner = true,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    // If a WhaleLocalePod is registered in the Reef, track its changes
    Locale? currentLocale = locale;
    try {
      final localePod = Whale.find<WhaleLocalePod>();
      currentLocale = localePod.value;
    } catch (_) {
      // Not registered, fallback to provided locale
    }

    return MaterialApp(
      title: title,
      navigatorKey: BlueWhale.navigator.navigatorKey,
      onGenerateRoute: BlueWhale.navigator.onGenerateRoute,
      navigatorObservers: [BlueWhale.navigator.observer],
      initialRoute: initialRoute,
      routes: routes ?? const <String, WidgetBuilder>{},
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: currentLocale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      home: home,
    );
  }

  @override
  WhaleSurfaceState<WhaleApp> createState() => _WhaleAppState();
}

class _WhaleAppState extends WhaleSurfaceState<WhaleApp> {}
