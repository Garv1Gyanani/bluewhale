import 'package:flutter/widgets.dart';
import '../core/scope.dart';

/// Represents arguments passed during navigation.
/// `WhaleNavigator.arguments` or arguments passed to `pageBuilder` will be an instance of this.
class WhaleRouteArguments {
  final dynamic data;
  WhaleRouteArguments(this.data);

  /// Tries to cast and return the wrapped [data] as type [T].
  /// Returns null if [data] is not of type [T].
  T? get<T>() {
    if (data is T) {
      return data as T;
    }
    // Allow for common type coercions if needed, e.g. int to double
    // if (data is num && T == double) return (data as num).toDouble() as T;
    // if (data is num && T == int) return (data as num).toInt() as T;
    return null;
  }

  /// Returns the raw data.
  dynamic get rawData => data;
}

/// Defines a route for the WhaleNavigator.
class WhaleRoute {
  final String name;
  final Widget Function(BuildContext context, WhaleRouteArguments? arguments)
      pageBuilder;
  
  /// Optional setup for route-scoped dependencies using [WhaleScope].
  final void Function(WhaleScopeRegistry scope)? setup;

  const WhaleRoute({
    required this.name,
    required this.pageBuilder,
    this.setup,
  });
}
