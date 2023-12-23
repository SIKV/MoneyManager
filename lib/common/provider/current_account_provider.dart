import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../local_preferences.dart';
import '../../service/providers.dart';

final currentAccountProvider = StreamProvider((ref) {
  final currentAccountService = ref.watch(currentAccountServiceProvider);
  final localPreferences = ref.watch(localPreferencesProvider);

  return localPreferences.onCurrentAccountIdChanged.asyncMap((_) async {
    return (await currentAccountService).getCurrentAccount();
  });
});

final currentAccountOrNullProvider = StreamProvider((ref) {
  final currentAccountService = ref.watch(currentAccountServiceProvider);
  final localPreferences = ref.watch(localPreferencesProvider);

  return localPreferences.onCurrentAccountIdChanged.asyncMap((_) async {
    return (await currentAccountService).getCurrentAccountOrNull();
  });
});
