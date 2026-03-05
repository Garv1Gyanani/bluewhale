import 'package:blue_whale_example/tanks/theme_tank.dart';
import 'package:flutter/material.dart';
import 'package:blue_whale/blue_whale.dart';
import '../main.dart'; // For AppRoutes

class SettingsPage extends WhaleSurface {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeTank = use<ThemeTank>();
    final localePod = use<WhaleLocalePod>();

    return Scaffold(
      appBar: AppBar(title: Text('settings_page_title'.bwTr(context))),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('toggle_theme'.bwTr(context)),
            trailing: Switch(
              value: themeTank.isDarkMode,
              onChanged: (_) => themeTank.toggleTheme(),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text('change_language'.bwTr(context)),
          ),
          RadioListTile<Locale>(
            title: Text('english'.bwTr(context)),
            value: const Locale('en'),
            groupValue: localePod.value,
            onChanged: (Locale? value) {
              if (value != null) localePod.setLocale(value);
            },
          ),
          RadioListTile<Locale>(
            title: Text('spanish'.bwTr(context)),
            value: const Locale('es'),
            groupValue:
                localePod.value, // Re-watch for Radio state using .value
            onChanged: (Locale? value) {
              if (value != null) localePod.setLocale(value);
            },
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () => Whale.offAll(AppRoutes.home),
            child: Text('Go to Home (offAll)'),
          )
        ],
      ),
    );
  }

  @override
  WhaleSurfaceState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends WhaleSurfaceState<SettingsPage> {}
