import 'package:blue_whale_example/tanks/data_tank.dart';
import 'package:flutter/material.dart';
import 'package:blue_whale/blue_whale.dart';
// import '../main.dart'; // For AppRoutes if navigating from here

class DetailsPage extends WhaleSurface {
  final WhaleRouteArguments? arguments;

  const DetailsPage({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    // Access arguments
    final id = arguments?.get<Map<String, dynamic>>()?['id'] as int?;
    final message = arguments?.get<Map<String, dynamic>>()?['message'] as String?;

    // You can also access global navigator arguments if needed, though constructor passing is cleaner
    // final navArgs = BlueWhale.navigator.arguments;
    // final idFromNav = navArgs?.get<Map<String, dynamic>>()?['id'] as int?;

    String argsDisplay;
    if (id != null && message != null) {
      argsDisplay = 'ID: $id, Message: "$message"';
    } else {
      argsDisplay = 'no_arguments'.bwTr(context);
    }
    
    final dataTank = use<DataTank>();


    return Scaffold(
      appBar: AppBar(title: Text('details_page_title'.bwTr(context))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('page_arguments'.bwTr(context).replaceAll('{args}', argsDisplay),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 20),
               Text(
                'route_aware_log'.bwTr(context).replaceAll('{event}', dataTank.routeEventLog.watch(context)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'current_route_info'.bwTr(context).replaceAll('{routeName}', BlueWhale.navigator.currentRouteName ?? 'N/A'),
                 textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => BlueWhale.navigator.back(result: "Returned from Details!"),
                child: Text('back'.bwTr(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  WhaleSurfaceState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends WhaleSurfaceState<DetailsPage> {}