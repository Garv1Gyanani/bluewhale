import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'blue_whale_method_channel.dart';

abstract class BlueWhalePlatform extends PlatformInterface {
  /// Constructs a BlueWhalePlatform.
  BlueWhalePlatform() : super(token: _token);

  static final Object _token = Object();

  static BlueWhalePlatform _instance = MethodChannelBlueWhale();

  /// The default instance of [BlueWhalePlatform] to use.
  ///
  /// Defaults to [MethodChannelBlueWhale].
  static BlueWhalePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BlueWhalePlatform] when
  /// they register themselves.
  static set instance(BlueWhalePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
