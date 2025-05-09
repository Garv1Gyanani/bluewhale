import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'blue_whale_platform_interface.dart';

/// An implementation of [BlueWhalePlatform] that uses method channels.
class MethodChannelBlueWhale extends BlueWhalePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('blue_whale');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
