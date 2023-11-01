import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../theme/spacings.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final bool showIcon;

  const DeleteButton({Key? key,
    this.onPressed,
    required this.title,
    this.showIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      Text(title)
    ];

    if (showIcon) {
      content.insert(0, const Icon(Icons.delete_outline_rounded));
      content.insert(1, const SizedBox(width: Spacings.two));
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
    );
  }
}
