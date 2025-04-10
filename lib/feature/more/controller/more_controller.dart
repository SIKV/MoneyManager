import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/more/domain/more_item.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../common/provider/current_wallet_provider.dart';
import '../../../domain/wallet.dart';
import '../../../theme/theme_manager.dart';
import '../domain/more_state.dart';

final moreControllerProvider = AsyncNotifierProvider
    .autoDispose<MoreController, MoreState>(() {
  return MoreController();
});

class MoreController extends AutoDisposeAsyncNotifier<MoreState> {
  final _divider = const GeneralMoreItem(MoreItemType.divider);

  @override
  FutureOr<MoreState> build() async {
    return MoreState(
      items: [
        await _createWalletSettingsItem(),
        _divider,
        _createBackupItem(),
        _divider,
        await _createDarkThemeItem(),
        _divider,
      ],
      appVersion: await _getAppVersion(),
    );
  }

  Future<MoreItem> _createWalletSettingsItem() async {
    final Wallet wallet = await ref.watch(currentWalletProvider.future);
    return WalletSettingsMoreItem(wallet.currency.name);
  }

  MoreItem _createBackupItem() {
    return const GeneralMoreItem(MoreItemType.backup);
  }

  Future<MoreItem> _createDarkThemeItem() async {
    final AppThemeManager themeManager = ref.read(appThemeManagerProvider.notifier);
    return DarkThemeMoreItem(themeManager.getType());
  }

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
