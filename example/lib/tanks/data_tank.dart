import 'dart:async';
import 'package:blue_whale/blue_whale.dart';
import 'package:flutter/material.dart'; // For Route type

class DataTank extends WhaleRouteAwareTank {
  // For async data
  final _dataStreamController = WhaleCurrent<String>.broadcast();
  WhaleCurrent<String> get dataStream => _dataStreamController;

  // For route aware log
  final routeEventLog = WhalePod<String>("No route events yet.");

  DataTank() {
    // Simulate fetching data
    _fetchData();
  }

  void _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    _dataStreamController.add("Initial data loaded!");
    await Future.delayed(const Duration(seconds: 3));
    _dataStreamController.add("More data arrived after 3s!");
    await Future.delayed(const Duration(seconds: 3));
    _dataStreamController.addError("Oops! A simulated error occurred.");
    await Future.delayed(const Duration(seconds: 3));
    _dataStreamController.add("Data recovered!");
  }

  // WhaleRouteAwareTank Overrides
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final msg =
        "Pushed: ${route.settings.name}, Prev: ${previousRoute?.settings.name ?? 'none'}";
    print("DataTank (RouteAware): $msg");
    routeEventLog.value = msg;

    // Example: Fetch specific data when a certain route is pushed
    if (route.settings.name == '/details') {
      print(
          "DataTank: Details page pushed, maybe fetch detail-specific data...");
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final msg =
        "Popped: ${route.settings.name}, New Top: ${previousRoute?.settings.name ?? 'none'}";
    print("DataTank (RouteAware): $msg");
    routeEventLog.value = msg;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final msg =
        "Replaced: New: ${newRoute?.settings.name ?? 'none'}, Old: ${oldRoute?.settings.name ?? 'none'}";
    print("DataTank (RouteAware): $msg");
    routeEventLog.value = msg;
  }

  @override
  void onInit() {
    super.onInit();
    print("DataTank: Initialized.");
  }

  @override
  void onReady() {
    super.onReady();
    print("DataTank: Ready.");
  }

  @override
  void onClose() {
    print("DataTank: Closed.");
    _dataStreamController.dispose();
    routeEventLog.dispose();
    super.onClose();
  }
}
