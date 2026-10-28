import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/backup/controller/backup_controller.dart';
import 'package:moneymanager/service/backup/backup_result_status.dart';

import '../../../l10n/app_localizations.dart';

/// Shows the export/import results and asks the user to confirm an import.
/// Call it from the build method of a widget that starts backups with [backupControllerProvider].
void listenBackupResults(BuildContext context, WidgetRef ref, {
  VoidCallback? onImported,
}) {
  ref.listen(backupControllerProvider.select((state) => state.exportResult), (prev, next) {
    _handleBackupResultStatus(context, next);
    _markResultsAsHandled(ref);
  });

  ref.listen(backupControllerProvider.select((state) => state.importResult), (prev, next) {
    _handleBackupResultStatus(context, next);
    if (next == BackupResultStatus.success) {
      onImported?.call();
    }
    _markResultsAsHandled(ref);
  });

  ref.listen(backupControllerProvider.select((state) => state.importConfirmationRequired), (prev, next) {
    if (next) {
      _confirmImport(context, ref);
    }
  });
}

void _confirmImport(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const _ImportConfirmation();
    },
  );

  if (!context.mounted) {
    return;
  }

  final controller = ref.read(backupControllerProvider.notifier);
  if (confirmed == true) {
    controller.confirmImport();
  } else {
    controller.cancelImport();
  }
}

void _markResultsAsHandled(WidgetRef ref) {
  ref.read(backupControllerProvider.notifier)
      .markResultsAsHandled();
}

void _handleBackupResultStatus(BuildContext context, BackupResultStatus? status) {
  switch (status) {
    case null:
      break;
    case BackupResultStatus.success:
      _showMessage(context, AppLocalizations.of(context)!.backupPage_successMessage);
      break;
    case BackupResultStatus.error:
      _showMessage(context, AppLocalizations.of(context)!.backupPage_errorMessage);
      break;
    case BackupResultStatus.canceled:
      break;
    case BackupResultStatus.unknown:
      _showMessage(context, AppLocalizations.of(context)!.backupPage_errorMessage);
      break;
  }
}

void _showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text)));
}

class _ImportConfirmation extends StatelessWidget {

  const _ImportConfirmation();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.backupPage_importConfirmationTitle),
      content: SingleChildScrollView(
        child: Text(localizations.backupPage_importConfirmationDescription),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(localizations.backupPage_importConfirmationButton),
        ),
      ],
    );
  }
}
