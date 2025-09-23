import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../theme/theme.dart';

enum MoreItemType {
  divider,
  walletSettings,
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
  final AppThemeType appTheme;

  const DarkThemeMoreItem(this.appTheme)
      : super(MoreItemType.darkTheme);
}
