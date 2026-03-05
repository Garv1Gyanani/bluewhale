import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'pod.dart';

/// State DevTools for the Blue Whale framework!
/// This tracks exactly which widgets are rebuilding and why.
/// Toggle [WhaleDevTools.enabled] to view the timeline execution graph in the console.
class WhaleDevTools {
  static bool enabled = false;
  
  // Track mutations dynamically
  static void logMutation(WhalePod pod, dynamic oldValue, dynamic newValue) {
    if (!enabled || !kDebugMode) return;
    
    // Find pod name or generic type
    final typeStr = pod.runtimeType.toString();
    
    print('🐋 [WhaleState] Mutation: $typeStr changed from $oldValue -> $newValue');
  }
  
  // Track widget rebuilds due to specific Pod triggering
  static void logRebuild(Widget widget, Set<WhalePod> pods) {
    if (!enabled || !kDebugMode) return;
    
    final widgetName = widget.runtimeType.toString();
    final podNames = pods.map((p) => p.runtimeType.toString()).join(", ");
    
    print('🔍 [WhaleTracker] UI Rebuild: $widgetName automatically rebuilt because of: [$podNames]');
  }
}
