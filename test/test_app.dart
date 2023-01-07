import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestApp extends StatelessWidget {
  final List<NavigatorObserver> navigatorObservers;
  final Widget child;

  const TestApp({
    Key? key,
    this.navigatorObservers = const <NavigatorObserver>[],
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        navigatorObservers: navigatorObservers,
        home: Material(
          child: child,
        ),
      ),
    );
  }
}
