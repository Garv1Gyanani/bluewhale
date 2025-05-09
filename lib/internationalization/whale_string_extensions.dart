import 'package:flutter/widgets.dart';
import '../blue_whale_facade.dart'; // For BlueWhale.tr

/// Extension on String for easy internationalization access.
extension WhaleStringTranslateExtension on String {
  /// Translates this string (used as a key) using BlueWhale's i18n system.
  /// Requires `BuildContext` to watch for locale changes, ensuring the widget
  /// rebuilds when the application's locale is updated.
  ///
  /// Example: `Text('greeting_key'.bwTr(context))`
  String bwTr(BuildContext context) {
    return BlueWhale.tr(this, context);
  }
}