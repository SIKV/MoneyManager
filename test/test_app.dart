import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestApp extends StatelessWidget {
  final List<NavigatorObserver> navigatorObservers;
  final List<Override> overrides;
  final Widget child;

  const TestApp({
    Key? key,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.overrides = const <Override>[],
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        navigatorObservers: navigatorObservers,
        home: Material(
          child: child,
        ),
      ),
    );
  }
}
