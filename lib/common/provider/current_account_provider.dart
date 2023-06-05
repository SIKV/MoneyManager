import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../local_preferences.dart';
import '../../service/providers.dart';

final currentAccountProvider = StreamProvider((ref) {
  final currentAccountService = ref.watch(currentAccountServiceProvider.future);
  final localPreferences = ref.watch(localPreferencesProvider);

  return localPreferences.onCurrentAccountIdChanged.asyncMap((event) async {
    return (await currentAccountService).getCurrentAccount();
  });
});
