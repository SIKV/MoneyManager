import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../theme/theme.dart';

enum MoreItemType {
  divider,
  accountSettings,
  backup,
  darkTheme,
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
class AccountSettingsMoreItem extends MoreItem {
  final String currentAccountName;

  const AccountSettingsMoreItem(this.currentAccountName)
      : super(MoreItemType.accountSettings);
}

@immutable
class DarkThemeMoreItem extends MoreItem {
  final AppThemeType appTheme;

  const DarkThemeMoreItem(this.appTheme)
      : super(MoreItemType.darkTheme);
}
