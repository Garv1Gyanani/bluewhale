import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode

/// WhaleTranslations: Holds the translation data for the application.
/// It's a map where keys are language codes (e.g., "en", "es")
/// and values are maps of translation keys to translated strings.
///
/// Example:
/// ```dart
/// final myTranslations = WhaleTranslations({
///   'en': {
///     'greeting': 'Hello',
///     'farewell': 'Goodbye',
///   },
///   'es': {
///     'greeting': 'Hola',
///     'farewell': 'Adiós',
///   },
/// });
/// ```
class WhaleTranslations {
  final Map<String, Map<String, String>> translations;
  final Locale fallbackLocale;

  WhaleTranslations(this.translations, {this.fallbackLocale = const Locale('en')});

  String translate(String key, Locale locale) {
    final langCode = locale.languageCode;
    final countryCode = locale.countryCode;

    Map<String, String>? langMap;

    // Try full locale (e.g., en_US)
    if (countryCode != null && countryCode.isNotEmpty) {
      langMap = translations['${langCode}_$countryCode'];
      if (langMap != null && langMap.containsKey(key)) {
        return langMap[key]!;
      }
    }

    // Try language code only (e.g., en)
    langMap = translations[langCode];
    if (langMap != null && langMap.containsKey(key)) {
      return langMap[key]!;
    }

    // Try fallback locale's language code
    final fallbackLangCode = fallbackLocale.languageCode;
    final fallbackCountryCode = fallbackLocale.countryCode;

    if (fallbackCountryCode != null && fallbackCountryCode.isNotEmpty) {
        langMap = translations['${fallbackLangCode}_$fallbackCountryCode'];
         if (langMap != null && langMap.containsKey(key)) {
            if (kDebugMode && langCode != fallbackLangCode) {
                print("BlueWhale i18n: Key '$key' not found for locale '$locale'. Using fallback '$fallbackLocale'.");
            }
            return langMap[key]!;
        }
    }

    langMap = translations[fallbackLangCode];
    if (langMap != null && langMap.containsKey(key)) {
      if (kDebugMode && langCode != fallbackLangCode) {
        print("BlueWhale i18n: Key '$key' not found for locale '$locale'. Using fallback '$fallbackLocale'.");
      }
      return langMap[key]!;
    }
    
    if (kDebugMode) {
      print("BlueWhale i18n WARNING: Translation key '$key' not found for locale '$locale' or fallback '$fallbackLocale'. Returning key itself.");
    }
    return key; // Fallback to the key itself if not found anywhere
  }
}