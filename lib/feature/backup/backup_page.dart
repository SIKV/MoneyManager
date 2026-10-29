import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/backup/controller/backup_controller.dart';
import 'package:moneymanager/feature/backup/ui/backup_results_listener.dart';

import '../../l10n/app_localizations.dart';

class BackupPage extends ConsumerWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupControllerProvider);

    listenBackupResults(context, ref);

    final isBackupAllowed = !state.exportInProgress && !state.importInProgress;

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
                Builder(
                  builder: (tileContext) => ListTile(
                    enabled: isBackupAllowed,
                    onTap: () => _exportJsonFile(tileContext, ref),
                    leading: exportLeading,
                    title: Text(AppLocalizations.of(context)!.backupPage_exportBackupFileTitle),
                    subtitle: Text(AppLocalizations.of(context)!.backupPage_exportBackupFileSubtitle),
                  ),
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

  // iOS anchors the share sheet to the tapped tile and fails if no position is given.
  void _exportJsonFile(BuildContext tileContext, WidgetRef ref) {
    final box = tileContext.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;

    ref.read(backupControllerProvider.notifier)
        .exportJsonFile(sharePositionOrigin: sharePositionOrigin);
  }

  void _importJsonFile(WidgetRef ref) {
    ref.read(backupControllerProvider.notifier)
        .importJsonFile();
  }
}
