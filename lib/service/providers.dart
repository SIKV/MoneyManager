import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';

import '../data/providers.dart';
import '../service/current_wallet_service.dart';
import 'backup/backup_service.dart';

final currentWalletServiceProvider = Provider((ref) async {
  final accountsRepository = await ref.watch(walletsRepositoryProvider);
  final localPreferences = ref.watch(localPreferencesProvider);

  return CurrentWalletService(accountsRepository, localPreferences);
});

final backupServiceProvider = Provider.autoDispose((ref) {
  final backupService = BackupService();

  ref.onDispose(() {
    backupService.cancel();
  });

  return backupService;
});
