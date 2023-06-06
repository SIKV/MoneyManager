import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';

import '../data/providers.dart';
import '../service/current_account_service.dart';

final currentAccountServiceProvider = Provider((ref) async {
  final accountsRepository = await ref.watch(accountsRepositoryProvider);
  final localPreferences = ref.watch(localPreferencesProvider);

  return CurrentAccountService(accountsRepository, localPreferences);
});
