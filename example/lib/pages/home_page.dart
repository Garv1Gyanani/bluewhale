import 'package:blue_whale_example/pods/theme_pod.dart';
import 'package:flutter/material.dart';
import 'package:blue_whale/blue_whale.dart';
import '../main.dart'; // For AppRoutes
import '../pods/counter_pod.dart';
import '../tanks/theme_tank.dart';
import '../tanks/data_tank.dart';

class HomePage extends WhaleSurface {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Pods and Tanks
    final counterPod = use<CounterPod>();
    final themeTank = use<ThemeTank>();
    final dataTank = use<DataTank>();
    final localePod = use<WhaleLocalePod>();

    return Scaffold(
      appBar: AppBar(title: Text('home_page_title'.bwTr(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Counter Example - Just use `.value`, WhaleSurface auto-tracks!
              Text('Counter Value: ${counterPod.value}',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: counterPod.decrement,
                      child: Text('decrement'.bwTr(context))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: counterPod.reset,
                      child: Text('reset'.bwTr(context))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: counterPod.increment,
                      child: Text('increment'.bwTr(context))),
                ],
              ),
              const Divider(height: 30),

              PodBuilder(() => Text(
                    'current_theme'.bwTr(context).replaceAll(
                        '{mode}',
                        (themeTank.isDarkMode ? 'dark_mode' : 'light_mode')
                            .bwTr(context)),
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
              ElevatedButton(
                  onPressed: themeTank.toggleTheme,
                  child: Text('toggle_theme'.bwTr(context))),
              const Divider(height: 30),

              // Internationalization Example
              Text('change_language'.bwTr(context),
                  style: Theme.of(context).textTheme.titleMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => localePod.setLocale(const Locale('en')),
                    child: Text('english'.bwTr(context)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => localePod.setLocale(const Locale('es')),
                    child: Text('spanish'.bwTr(context)),
                  ),
                ],
              ),
              const Divider(height: 30),

              // Overlays Example
              ElevatedButton(
                onPressed: () => Whale.showDialog(
                  builder: (ctx) => AlertDialog(
                    title: Text('sample_dialog_title'.bwTr(ctx)),
                    content: Text('sample_dialog_content'.bwTr(ctx)),
                    actions: [
                      TextButton(
                          onPressed: Whale.back, child: Text('ok'.bwTr(ctx)))
                    ],
                  ),
                ),
                child: Text('show_dialog'.bwTr(context)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    Whale.showSnackbar('sample_snackbar_text'.bwTr(context)),
                child: Text('show_snackbar'.bwTr(context)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Whale.showBottomSheet(
                  builder: (ctx) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('sample_bottom_sheet_title'.bwTr(ctx),
                            style: Theme.of(ctx).textTheme.titleLarge),
                        ListTile(
                            title: Text('bottom_sheet_option_1'.bwTr(ctx)),
                            onTap: () => Whale.back(result: 'Option 1')),
                        ListTile(
                            title: Text('bottom_sheet_option_2'.bwTr(ctx)),
                            onTap: () => Whale.back(result: 'Option 2')),
                        TextButton(
                            onPressed: Whale.back,
                            child: Text('close'.bwTr(ctx))),
                      ],
                    ),
                  ),
                ),
                child: Text('show_bottom_sheet'.bwTr(context)),
              ),
              const Divider(height: 30),

              // View() & Callable Syntax demo
              Text('Functional View() Syntax:',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              View(() => Text(
                    'Count via Callable: ${counterPod()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  )),
              const Divider(height: 30),

              // Navigation Example
              ElevatedButton(
                onPressed: () => Whale.to(
                  AppRoutes.details,
                  arguments: {'id': 123, 'message': 'Hello from Home!'},
                ),
                child: Text('go_to_details'.bwTr(context)),
              ),
              ElevatedButton(
                onPressed: () => Whale.offAll(AppRoutes.settings),
                child: Text('go_to_settings'.bwTr(context)),
              ),
              const Divider(height: 30),

              // Async Data Example with WhaleStreamBuilder
              Text('async_data_title'.bwTr(context),
                  style: Theme.of(context).textTheme.titleMedium),
              WhaleStreamBuilder<String>(
                whaleCurrent: dataTank.dataStream,
                initialData: 'loading_data'
                    .bwTr(context), // Initial data until stream emits
                builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Text(snapshot.data ?? 'No data yet',
                      style: Theme.of(context).textTheme.bodyLarge);
                },
              ),
              const Divider(height: 30),

              // Route Aware Tank Log
              Text(
                'route_aware_log'.bwTr(context).replaceAll(
                    '{event}', dataTank.routeEventLog.value), // auto-tracked!
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'current_route_info'
                    .bwTr(context)
                    .replaceAll('{routeName}', Whale.currentRouteName ?? 'N/A'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  WhaleSurfaceState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends WhaleSurfaceState<HomePage> {}
