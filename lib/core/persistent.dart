import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pod.dart';

/// Manage automatic storage syncing for [persistentState].
class WhaleStorage {
  static SharedPreferences? _prefs;

  /// Initializes the local persistence engine (SharedPreferences).
  /// Required before accessing [persistentState].
  /// E.g., `await WhaleStorage.init();` early in `main()`.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      if (kDebugMode) {
        print(
            'BlueWhale WARNING: WhaleStorage.init() was not called before reading '
            'a persistentState. Default values will be used synchronously during this read.');
      }
      throw StateError(
          'WhaleStorage not initialized. Call await WhaleStorage.init() in main() before using persistentState.');
    }
    return _prefs!;
  }

  static bool get isInitialized => _prefs != null;

  /// Clear all data stored by WhaleStorage in SharedPreferences.
  static Future<void> clearAll() async {
    if (_prefs != null) {
      await _prefs!.clear();
    }
  }
}

/// A specialized WhalePod that automatically syncs its value to device local storage.
/// Supported Types: [String], [int], [double], [bool], and [List<String>].
class PersistentPod<T> extends WhalePod<T> {
  final String key;
  final T defaultValue;

  PersistentPod(this.key, this.defaultValue)
      : super(_loadInitialValue(key, defaultValue));

  static T _loadInitialValue<T>(String key, T defaultValue) {
    if (!WhaleStorage.isInitialized) return defaultValue;

    final prefs = WhaleStorage.prefs;
    if (!prefs.containsKey(key)) return defaultValue;

    if (T == String) return prefs.getString(key) as T;
    if (T == int) return prefs.getInt(key) as T;
    if (T == double) return prefs.getDouble(key) as T;
    if (T == bool) return prefs.getBool(key) as T;
    if (T == List<String>) return prefs.getStringList(key) as T;

    return defaultValue;
  }

  @override
  set value(T newValue) {
    super.value =
        newValue; // Updates memory graph & triggers batching sync naturally
    _persistValue(newValue);
  }

  void _persistValue(T newValue) {
    if (!WhaleStorage.isInitialized) return;

    final prefs = WhaleStorage.prefs;
    if (newValue is String) {
      prefs.setString(key, newValue);
    } else if (newValue is int) {
      prefs.setInt(key, newValue);
    } else if (newValue is double) {
      prefs.setDouble(key, newValue);
    } else if (newValue is bool) {
      prefs.setBool(key, newValue);
    } else if (newValue is List<String>) {
      prefs.setStringList(key, newValue);
    }
  }
}
