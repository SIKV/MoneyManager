import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/theme/theme.dart';

import '../../theme/spacings.dart';

class CloseCircleButton extends ConsumerWidget {

  const CloseCircleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppColors colors = ref.read(appThemeManagerProvider.notifier).theme.colors;

    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(Spacings.two),
        color: colors.colorScheme.surfaceVariant,
        child: InkWell(
          splashColor: Colors.grey,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close,
            color: colors.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
