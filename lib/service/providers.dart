import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/service/backup/backup_service.dart';

import '../data/providers.dart';
import '../service/current_account_service.dart';

final currentAccountServiceProvider = Provider((ref) async {
  final accountsRepository = await ref.watch(accountsRepositoryProvider);
  final localPreferences = ref.watch(localPreferencesProvider);

  return CurrentAccountService(accountsRepository, localPreferences);
});

final backupServiceProvider = Provider.autoDispose((ref) {
  final backupService = BackupService();

  ref.onDispose(() {
    backupService.cancel();
  });

  return backupService;
});
