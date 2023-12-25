import 'package:flutter/material.dart';

import '../../theme/spacings.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String title;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon),
          if (icon != null) const SizedBox(width: Spacings.two),
          Text(title),
        ],
      ),
    );
  }
}
