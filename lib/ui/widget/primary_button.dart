import 'package:flutter/material.dart';

import '../../theme/spacings.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String title;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: Spacings.two),
          Text(title),
        ],
      ),
    );
  }
}
