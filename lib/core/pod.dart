import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'reef.dart'; // Provides WhaleDisposable
import 'surface.dart'; // Provides _WhaleListenerScopeProvider

/// WhalePod: Reactive container for a single value of type [T].
class WhalePod<T> extends ValueNotifier<T> implements WhaleDisposable {
  WhalePod(super.initialValue);

  /// Registers context to rebuild when the pod value changes.
  T watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<WhaleListenerScopeProvider>();

    if (scope == null || scope.surfaceState == null) {
      // Fallback: print warning if outside proper scope
      bool isInWhaleBuilder = false;
      context.visitAncestorElements((element) {
        if (element.widget.runtimeType.toString().startsWith('_WhaleBuilderState')) {
          isInWhaleBuilder = true;
          return false;
        }
        if (element.widget is WhaleListenerScopeProvider) {
          return false;
        }
        return true;
      });

      if (!isInWhaleBuilder && kDebugMode) {
        print(
          'BlueWhale WARNING: WhalePod<${T.toString()}>.watch(context) was called '
          'outside of a WhaleSurface or WhaleBuilder listening scope. '
          'The widget will get the current value but might not rebuild on changes.'
        );
      }
    } else {
      scope.surfaceState!.listenTo<T>(this);
    }

    return value;
  }
}
