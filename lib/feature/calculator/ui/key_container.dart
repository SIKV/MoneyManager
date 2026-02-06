import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyContainer extends ConsumerWidget {
  final bool isAction;
  final VoidCallback onTap;
  final Widget child;

  const KeyContainer({
    super.key,
    this.isAction = false,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RawMaterialButton(
      onPressed: onTap,
      fillColor: isAction
          ? Theme.of(context).colorScheme.tertiaryContainer
          : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
      elevation: 0,
      shape: const CircleBorder(),
      child: child,
    );
  }
}
