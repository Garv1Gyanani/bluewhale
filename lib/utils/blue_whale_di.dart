import '../core/reef.dart';

/// Convenience function to find a dependency from the global Reef.
/// Same as `Reef.i.find<T>()`.
T use<T extends Object>({String? tag}) {
  return Reef.i.find<T>(tag: tag);
}

/// Convenience function to put a dependency into the global Reef.
/// Same as `Reef.i.put<T>()`.
void put<T extends Object>(T instance, {String? tag, bool override = false}) {
  Reef.i.put<T>(instance, tag: tag, override: override);
}

/// Convenience function to lazily put a dependency into the global Reef.
/// Same as `Reef.i.lazyPut<T>()`.
void lazyPut<T extends Object>(T Function() factory, {String? tag, bool override = false}) {
  Reef.i.lazyPut<T>(factory, tag: tag, override: override);
}

/// Convenience function to register a factory into the global Reef.
/// Same as `Reef.i.factory<T>()`.
void factory<T extends Object>(T Function() factory, {String? tag, bool override = false}) {
  Reef.i.factory<T>(factory, tag: tag, override: override);
}

/// Convenience function to delete a dependency from the global Reef.
/// Same as `Reef.i.delete<T>()`.
bool delete<T extends Object>({String? tag, bool permanent = true}) {
  return Reef.i.delete<T>(tag: tag, permanent: permanent);
}