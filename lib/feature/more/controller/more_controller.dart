import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/more/domain/more_item.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../common/provider/current_account_provider.dart';
import '../../../domain/account.dart';
import '../../../theme/theme_manager.dart';
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
        _createDivider(),
        await _createDarkThemeItem(),
        _createDivider(),
      ],
      appVersion: await _getAppVersion(),
    );
  }

  MoreItem _createDivider() {
    return const GeneralMoreItem(MoreItemType.divider);
  }

  Future<MoreItem> _createAccountSettingsItem() async {
    final Account account = await ref.watch(currentAccountProvider.future);

    return AccountSettingsMoreItem(MoreItemType.accountSettings,
      currentAccountName: account.currency.name,
    );
  }

  Future<MoreItem> _createDarkThemeItem() async {
    final AppThemeManager themeManager = ref.read(appThemeManagerProvider.notifier);

    return DarkThemeMoreItem(MoreItemType.darkTheme,
      appTheme: themeManager.getType(),
    );
  }

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
