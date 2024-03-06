import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/backup/controller/backup_controller.dart';

class BackupPage extends ConsumerWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupControllerProvider);

    // TODO: Handle [state.exportResult]

    final isBackupAllowed = !state.exportInProgress;

    final exportLeading = state.exportInProgress
        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator())
        : const Icon(Icons.file_upload);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(AppLocalizations.of(context)!.backup),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ListTile(
                  enabled: isBackupAllowed,
                  onTap: () => _exportJsonFile(ref),
                  leading: exportLeading,
                  title: Text(AppLocalizations.of(context)!.exportBackupFileTitle),
                  subtitle: Text(AppLocalizations.of(context)!.exportBackupFileSubtitle),
                ),
                ListTile(
                  enabled: isBackupAllowed,
                  onTap: () {
                    // TODO: Implement.
                  },
                  leading: const Icon(Icons.file_download),
                  title: Text(AppLocalizations.of(context)!.importBackupFileTitle),
                  subtitle: Text(AppLocalizations.of(context)!.importBackupFileSubtitle),
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
}
