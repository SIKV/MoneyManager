import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Money Manager',
      home: Scaffold(
          body: Center(
            child: Text('Money Manager'),
          )
      ),
    );
  }
}
