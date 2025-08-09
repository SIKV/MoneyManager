import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/backup/controller/backup_controller.dart';
import 'package:moneymanager/service/backup/backup_result_status.dart';

import '../../l10n/app_localizations.dart';

class BackupPage extends ConsumerWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupControllerProvider);

    _listenResults(ref, context);

    final isBackupAllowed = !state.exportInProgress;

    final exportLeading = state.exportInProgress
        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator())
        : const Icon(Icons.file_upload);

    final importLeading = state.importInProgress
        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator())
        : const Icon(Icons.file_upload);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(AppLocalizations.of(context)!.backupPage_title),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ListTile(
                  enabled: isBackupAllowed,
                  onTap: () => _exportJsonFile(ref),
                  leading: exportLeading,
                  title: Text(AppLocalizations.of(context)!.backupPage_exportBackupFileTitle),
                  subtitle: Text(AppLocalizations.of(context)!.backupPage_exportBackupFileSubtitle),
                ),
                ListTile(
                  enabled: isBackupAllowed,
                  onTap: () => _importJsonFile(ref),
                  leading: importLeading,
                  title: Text(AppLocalizations.of(context)!.backupPage_importBackupFileTitle),
                  subtitle: Text(AppLocalizations.of(context)!.backupPage_importBackupFileSubtitle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _exportJsonFile(WidgetRef ref) {
    ref.read(backupControllerProvider.notifier)
        .exportJsonFile();
  }

  void _importJsonFile(WidgetRef ref) {
    ref.read(backupControllerProvider.notifier)
        .importJsonFile();
  }

  void _listenResults(WidgetRef ref, BuildContext context) {
    ref.listen(backupControllerProvider.select((state) => state.exportResult), (prev, next) {
      _handleBackupResultStatus(context, next);
      _markResultsAsHandled(ref);
    });

    ref.listen(backupControllerProvider.select((state) => state.importResult), (prev, next) {
      _handleBackupResultStatus(context, next);
      _markResultsAsHandled(ref);
    });
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
}
