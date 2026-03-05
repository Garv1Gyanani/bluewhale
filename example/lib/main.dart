import 'package:flutter/material.dart';
import 'package:blue_whale/blue_whale.dart';

// Import Pages
import 'pages/home_page.dart';
import 'pages/details_page.dart';
import 'pages/settings_page.dart';

// Import Pods & Tanks
import 'pods/counter_pod.dart';
import 'pods/theme_pod.dart';
import 'tanks/theme_tank.dart';
import 'tanks/data_tank.dart';

// 1. Define App Routes (using a class for organization)
class AppRoutes {
  static const String home = '/';
  static const String details = '/details';
  static const String settings = '/settings';
}

// 2. Create a GlobalKey for the Navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WhaleStorage.init();

  // 3. Define Translations
  final appTranslations = WhaleTranslations({
    'en': {
      'app_title': 'Blue Whale Showcase',
      'home_page_title': 'Home - Blue Whale',
      'details_page_title': 'Details Page',
      'settings_page_title': 'Settings',
      'increment': 'Increment',
      'decrement': 'Decrement',
      'reset': 'Reset',
      'toggle_theme': 'Toggle Theme',
      'current_theme': 'Current Theme: {mode}',
      'dark_mode': 'Dark',
      'light_mode': 'Light',
      'change_language': 'Change Language',
      'english': 'English',
      'spanish': 'Español',
      'show_dialog': 'Show Dialog',
      'sample_dialog_title': 'Blue Whale Dialog',
      'sample_dialog_content': 'This is a sample dialog!',
      'ok': 'OK',
      'show_snackbar': 'Show Snackbar',
      'sample_snackbar_text': 'Hello from Blue Whale Snackbar!',
      'show_bottom_sheet': 'Show Bottom Sheet',
      'sample_bottom_sheet_title': 'Blue Whale Bottom Sheet',
      'bottom_sheet_option_1': 'Option 1',
      'bottom_sheet_option_2': 'Option 2',
      'close': 'Close',
      'go_to_details': 'Go to Details Page',
      'go_to_settings': 'Go to Settings (offAll)',
      'page_arguments': 'Received Arguments: {args}',
      'no_arguments': 'No arguments received.',
      'async_data_title': 'Async Data Stream:',
      'loading_data': 'Loading data...',
      'route_aware_log': 'Route Log: {event}',
      'current_route_info': 'Current Route: {routeName}',
      'back': 'Back',
    },
    'es': {
      'app_title': 'Demostración de Blue Whale',
      'home_page_title': 'Inicio - Blue Whale',
      'details_page_title': 'Página de Detalles',
      'settings_page_title': 'Configuración',
      'increment': 'Incrementar',
      'decrement': 'Decrementar',
      'reset': 'Reiniciar',
      'toggle_theme': 'Cambiar Tema',
      'current_theme': 'Tema Actual: {mode}',
      'dark_mode': 'Oscuro',
      'light_mode': 'Claro',
      'change_language': 'Cambiar Idioma',
      'english': 'Inglés',
      'spanish': 'Español',
      'show_dialog': 'Mostrar Diálogo',
      'sample_dialog_title': 'Diálogo de Blue Whale',
      'sample_dialog_content': '¡Este es un diálogo de ejemplo!',
      'ok': 'OK',
      'show_snackbar': 'Mostrar Snackbar',
      'sample_snackbar_text': '¡Hola desde el Snackbar de Blue Whale!',
      'show_bottom_sheet': 'Mostrar Hoja Inferior',
      'sample_bottom_sheet_title': 'Hoja Inferior de Blue Whale',
      'bottom_sheet_option_1': 'Opción 1',
      'bottom_sheet_option_2': 'Opción 2',
      'close': 'Cerrar',
      'go_to_details': 'Ir a Detalles',
      'go_to_settings': 'Ir a Configuración (offAll)',
      'page_arguments': 'Argumentos Recibidos: {args}',
      'no_arguments': 'No se recibieron argumentos.',
      'async_data_title': 'Flujo de Datos Asíncronos:',
      'loading_data': 'Cargando datos...',
      'route_aware_log': 'Registro de Ruta: {event}',
      'current_route_info': 'Ruta Actual: {routeName}',
      'back': 'Atrás',
    },
  });

  // 4. Initialize BlueWhale (once at app startup)
  BlueWhale.initialize(
    navigatorKey: navigatorKey,
    appRoutes: [
      WhaleRoute(
          name: AppRoutes.home,
          pageBuilder: (context, args) => const HomePage()),
      WhaleRoute(
          name: AppRoutes.details,
          pageBuilder: (context, args) => DetailsPage(arguments: args)),
      WhaleRoute(
          name: AppRoutes.settings,
          pageBuilder: (context, args) => const SettingsPage()),
    ],
    initialLocale: const Locale('en'), // Default language
    translations: appTranslations,
  );

  // 5. Register Pods and Tanks with the super simple Whale syntax!
  Whale.put(CounterPod());

  // Pod and Tank for Theme
  Whale.put(ThemePod());
  Whale.lazyPut(() => ThemeTank(themePod: Whale.find<ThemePod>()));

  // Tank for Async Data and Route Awareness
  Whale.lazyPut(() => DataTank());

  runApp(const MyApp());
}

class MyApp extends WhaleSurface {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch ThemePod to adjust WhaleApp's active theme.
    // WhaleApp automatically handles Locale trackers internally if available!
    final isDarkMode = Whale.find<ThemePod>().value;

    return WhaleApp(
        title: 'app_title'.bwTr(context),
        initialRoute: AppRoutes.home,
        theme: isDarkMode
            ? ThemeData.dark(useMaterial3: true)
            : ThemeData.light(useMaterial3: true),
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
        ]);
  }

  @override
  WhaleSurfaceState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends WhaleSurfaceState<MyApp> {}
