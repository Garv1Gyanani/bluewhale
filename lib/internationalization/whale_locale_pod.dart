import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../core/pod.dart';

/// WhaleLocalePod: Manages the current application Locale for internationalization.
/// Widgets can `watch(context)` this pod to rebuild when the locale changes.
class WhaleLocalePod extends WhalePod<Locale> {
  final bool isDummy; // True if translations weren't provided

  WhaleLocalePod(Locale initialLocale, {this.isDummy = false}) : super(initialLocale);

  void setLocale(Locale newLocale) {
    if (isDummy && kDebugMode) {
      print("BlueWhale WARNING: setLocale called, but translations were not provided during BlueWhale.initialize(). Locale change might not reflect in UI via .bwTr().");
    }
    if (value != newLocale) { // Only update if the locale is actually different
        value = newLocale;
    }
  }
}