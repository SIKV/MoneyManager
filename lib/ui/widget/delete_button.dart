import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme/spacings.dart';

enum DeleteButtonStyle {
  noBorder,
  outlined,
}

class DeleteButton extends StatelessWidget {
  final DeleteButtonStyle style;
  final String? title;
  final VoidCallback onPressed;
  final bool showIcon;

  const DeleteButton({super.key,
    this.style = DeleteButtonStyle.outlined,
    this.title,
    required this.onPressed,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      Text(title ?? AppLocalizations.of(context)!.delete)
    ];

    if (showIcon) {
      content.add(const SizedBox(width: Spacings.two));
      content.add(const Icon(Icons.delete_outline_rounded));
    }

    switch (style) {
      case DeleteButtonStyle.noBorder:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: content,
          ),
        );
      case DeleteButtonStyle.outlined:
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
}
