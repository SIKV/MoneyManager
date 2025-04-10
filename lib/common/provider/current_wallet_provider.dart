import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../local_preferences.dart';
import '../../service/providers.dart';

final currentWalletProvider = StreamProvider((ref) {
  final currentWalletService = ref.watch(currentWalletServiceProvider);
  final localPreferences = ref.watch(localPreferencesProvider);

  return localPreferences.onCurrentWalletIdChanged.asyncMap((_) async {
    return (await currentWalletService).getCurrentWallet();
  });
});

final currentWalletOrNullProvider = StreamProvider((ref) {
  final currentAccountService = ref.watch(currentWalletServiceProvider);
  final localPreferences = ref.watch(localPreferencesProvider);

  return localPreferences.onCurrentWalletIdChanged.asyncMap((_) async {
    return (await currentAccountService).getCurrentWalletOrNull();
  });
});
