import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum MoreItemType {
  divider,
  accountSettings,
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

  const AccountSettingsMoreItem(super.type, {
    required this.currentAccountName,
  });
}
