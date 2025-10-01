import 'package:flutter/material.dart';
import 'package:moneymanager/analytics/Analytics.dart';

class AnalyticsNavigatorObserver extends NavigatorObserver {

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    Analytics.logScreenView(
      currentScreen: _getRouteName(route) ?? "Unknown",
      previousScreen: _getRouteName(previousRoute) ?? "Unknown",
    );
  }

  String? _getRouteName(Route? route) {
    return route?.settings.name;
  }
}
