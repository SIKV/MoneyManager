import 'package:flutter/material.dart';

class ActionsGradient extends StatelessWidget {
  const ActionsGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface.withOpacity(0.0),
            Theme.of(context).colorScheme.surface.withOpacity(0.7),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
    );
  }
}
