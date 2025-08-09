import 'package:flutter/material.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../l10n/app_localizations.dart';

class DeleteConfirmation extends StatelessWidget {
  final String title;
  final String description;
  final Widget? content;
  final VoidCallback onDeletePressed;

  const DeleteConfirmation({
    super.key,
    required this.title,
    required this.description,
    this.content,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(description),
            if (content != null) const SizedBox(height: Spacings.four),
            if (content != null) content!,
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            onDeletePressed();
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      ],
    );
  }
}
