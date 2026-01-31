import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/service/passcode/passcode_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

final passcodeServiceProvider = Provider((ref) {
  return PasscodeService(
    const FlutterSecureStorage(),
    SharedPreferencesAsync(),
    LocalAuthentication(),
  );
});
