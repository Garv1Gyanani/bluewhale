import 'package:blue_whale/blue_whale_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    // Since BlueWhale cannot be instantiated directly (no public constructor),
    // we use the static method directly for testing platform version.

    // Use the BlueWhalePlatform instance directly to call the method
    final String? version = await BlueWhalePlatform.instance.getPlatformVersion();
    
    // Assert that the version string is not empty
    expect(version?.isNotEmpty, true);
  });
}
