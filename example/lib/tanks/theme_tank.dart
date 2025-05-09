import 'package:blue_whale/blue_whale.dart';
import '../pods/theme_pod.dart';

class ThemeTank extends WhaleTank {
  final ThemePod _themePod;

  ThemeTank({required ThemePod themePod}) : _themePod = themePod;

  void toggleTheme() {
    _themePod.value = !_themePod.value;
    print("ThemeTank: Theme toggled to ${_themePod.value ? 'Dark' : 'Light'}");
  }

  bool get isDarkMode => _themePod.value;

  @override
  void onInit() {
    super.onInit();
    print("ThemeTank: Initialized. Current theme is ${_themePod.value ? 'Dark' : 'Light'}");
    // Could load saved theme preference here
  }

  @override
  void onReady() {
    super.onReady();
    print("ThemeTank: Ready.");
  }

  @override
  void onClose() {
    print("ThemeTank: Closed.");
    super.onClose();
  }
}