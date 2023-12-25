import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteConfirmation extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onDeletePressed;

  const DeleteConfirmation({
    super.key,
    required this.title,
    required this.description,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
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
