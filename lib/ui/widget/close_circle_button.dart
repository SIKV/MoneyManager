import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/spacings.dart';

class CloseCircleButton extends ConsumerWidget {
  final VoidCallback? onTap;

  const CloseCircleButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(Spacings.two),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: InkWell(
          splashColor: Colors.grey,
          onTap: () {
            if (onTap != null) {
              onTap?.call();
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.close,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
