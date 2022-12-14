import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/theme/theme.dart';

import '../../theme/spacings.dart';

class HeaderCircleButton extends ConsumerWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const HeaderCircleButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppColors colors = ref
        .read(appThemeManagerProvider.notifier)
        .theme
        .colors;

    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacings.three),
            decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle
            ),
            child: Icon(icon,
              color: colors.alwaysWhite,
            ),
          ),
          const SizedBox(height: Spacings.two),
          Text(title,
            style: TextStyle(
              color: colors.alwaysWhite,
            ),
          ),
        ],
      ),
    );
  }
}
