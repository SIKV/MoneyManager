import 'package:flutter/material.dart';

enum MoreItemType {
  divider,
  walletSettings,
  passcode,
  backup,
  darkTheme,
  sendFeedback,
}

@immutable
abstract class MoreItem {
  final MoreItemType type;

  const MoreItem(this.type);
}

@immutable
class GeneralMoreItem extends MoreItem {
  const GeneralMoreItem(super.type);
}

@immutable
class WalletSettingsMoreItem extends MoreItem {
  final String currentWalletName;

  const WalletSettingsMoreItem(this.currentWalletName)
      : super(MoreItemType.walletSettings);
}

@immutable
class DarkThemeMoreItem extends MoreItem {
  final ThemeMode themeMode;

  const DarkThemeMoreItem(this.themeMode)
      : super(MoreItemType.darkTheme);
}
