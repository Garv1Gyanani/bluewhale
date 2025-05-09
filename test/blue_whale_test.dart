import 'package:flutter_test/flutter_test.dart';
import 'package:blue_whale/blue_whale_platform_interface.dart';
import 'package:blue_whale/blue_whale_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBlueWhalePlatform
    with MockPlatformInterfaceMixin
    implements BlueWhalePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BlueWhalePlatform initialPlatform = BlueWhalePlatform.instance;

  test('$MethodChannelBlueWhale is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBlueWhale>());
  });

  test('getPlatformVersion', () async {
    // Mocking platform
    BlueWhalePlatform.instance = MockBlueWhalePlatform();

    // Accessing static method of BlueWhale to get the platform version
    expect(await BlueWhalePlatform.instance.getPlatformVersion(), '42');
  });
}
