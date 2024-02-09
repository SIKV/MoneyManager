import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackupPage extends ConsumerWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  onTap: () {
                    // TODO: Implement.
                  },
                  leading: const Icon(Icons.file_upload),
                  title: Text(AppLocalizations.of(context)!.exportBackupFileTitle),
                  subtitle: Text(AppLocalizations.of(context)!.exportBackupFileSubtitle),
                ),
                ListTile(
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
}
