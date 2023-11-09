import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/more/domain/more_item.dart';

import '../../../common/provider/current_account_provider.dart';
import '../domain/more_state.dart';

final moreControllerProvider = AsyncNotifierProvider
    .autoDispose<MoreController, MoreState>(() {
  return MoreController();
});

class MoreController extends AutoDisposeAsyncNotifier<MoreState> {

  @override
  FutureOr<MoreState> build() async {
    return MoreState(
      items: [
        await _createAccountSettingsItem(),
      ],
    );
  }

  MoreItem _createDivider() {
    return const GeneralMoreItem(MoreItemType.divider);
  }

  Future<MoreItem> _createAccountSettingsItem() async {
    final account = await ref.watch(currentAccountProvider.future);

    return AccountSettingsMoreItem(MoreItemType.accountSettings,
      currentAccountName: account.currency.name,
    );
  }
}
