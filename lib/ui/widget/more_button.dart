import 'package:flutter/material.dart';

class MoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MoreButton({super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(),
      child: const Icon(Icons.more_horiz_rounded),
    );
  }
}
