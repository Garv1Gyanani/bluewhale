library blue_whale;

// Core
export 'core/reef.dart';
export 'core/pod.dart';
export 'core/pod_extensions.dart'; // Simple primitive extensions (e.g., 0.pod)
export 'core/persistent.dart'; // WhaleStorage & persistentState capabilities
export 'core/scope.dart'; // WhaleScope for scoped dependency injection
export 'core/reactive.dart'; // Simple reactive APIs: state(), View(), mutate(), derive(), set()
export 'core/async_pod.dart'; // Handles async states directly (.obx()!)
export 'core/workers.dart'; // Adds debounce, interval, once, ever to pods
export 'core/tank.dart';
export 'core/surface.dart';
export 'core/current.dart';
export 'core/devtools.dart'; // WhaleDevTools toggle for deep logging

// Widgets
export 'widgets/whale_app.dart'; // Overarching Flutter app encapsulator widget
export 'widgets/pod_builder.dart'; // Easiest reactive builder
export 'widgets/whale_builder.dart';
export 'widgets/whale_stream_builder.dart';

// Utilities / DI Access
export 'utils/blue_whale_di.dart';
export 'utils/whale_overlays.dart';

// Navigation
export 'navigation/whale_navigator.dart';
export 'navigation/whale_route.dart';
export 'navigation/whale_route_aware_tank.dart';

// Internationalization
export 'internationalization/whale_locale_pod.dart';
export 'internationalization/whale_translations.dart';
export 'internationalization/whale_string_extensions.dart';

// Global Access Points (Facade)
export 'blue_whale_facade.dart';
export 'whale.dart'; // GetX style alias wrapper
