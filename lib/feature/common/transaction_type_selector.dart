import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme_manager.dart';

import '../../domain/transaction_type.dart';
import '../../theme/theme.dart';

class TransactionTypeSelector extends ConsumerWidget {
  final TransactionType selectedType;
  final Function(TransactionType) onSelectedTypeChanged;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onSelectedTypeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeManager = ref.watch(appThemeManagerProvider);

    final Color thumbColor;
    final Color backgroundColor;

    switch (appThemeManager.type) {
      case AppThemeType.light:
        thumbColor = thumbColor = const CupertinoDynamicColor.withBrightness(
          color: Color(0xFFFFFFFF),
          darkColor: Color(0xFF636366),
        );
        backgroundColor = CupertinoColors.tertiarySystemFill;
        break;
      case AppThemeType.dark:
        thumbColor = thumbColor = CupertinoColors.secondarySystemFill;
        backgroundColor = CupertinoColors.darkBackgroundGray;
        break;
    }

    return CupertinoSlidingSegmentedControl<TransactionType>(
      thumbColor: thumbColor,
      backgroundColor: backgroundColor,
      groupValue: selectedType,
      onValueChanged: (transactionType) {
        if (transactionType != null) {
          onSelectedTypeChanged(transactionType);
        }
      },
      children: <TransactionType, Widget>{
        TransactionType.income: Text(AppLocalizations.of(context)!.income),
        TransactionType.expense: Text(AppLocalizations.of(context)!.expense),
      },
    );
  }
}
