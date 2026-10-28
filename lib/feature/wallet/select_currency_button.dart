import 'package:currency_picker/currency_picker.dart' as currency_picker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/theme/radius.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../l10n/app_localizations.dart';
import 'controller/add_wallet_controller.dart';

class SelectCurrencyButton extends ConsumerWidget {
  const SelectCurrencyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addWalletControllerProvider).value;
    final selectedCurrency = state?.selectedCurrency;
    final alreadyExists = state?.alreadyExists == true;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    final Color borderColor;
    if (alreadyExists) {
      borderColor = colorScheme.error;
    } else if (selectedCurrency != null) {
      borderColor = colorScheme.primary;
    } else {
      borderColor = Colors.transparent;
    }

    final String title;
    final String subtitle;
    if (selectedCurrency != null) {
      title = selectedCurrency.code;
      subtitle = selectedCurrency.symbol == selectedCurrency.code
          ? selectedCurrency.name
          : '${selectedCurrency.name} · ${selectedCurrency.symbol}';
    } else {
      title = localizations.addWalletPage_selectCurrencyPlaceholder;
      subtitle = localizations.addWalletPage_selectCurrencyHint;
    }

    return Material(
      color: colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.three),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      child: InkWell(
        onTap: () => _selectCurrency(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(Spacings.four),
          child: Row(
            children: [
              _CurrencyAvatar(currency: selectedCurrency),
              const SizedBox(width: Spacings.four),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: Spacings.half),
                    Text(subtitle,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacings.two),
              Icon(Icons.keyboard_arrow_down_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectCurrency(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    currency_picker.showCurrencyPicker(
      context: context,
      onSelect: (currency) {
        if (_isCurrencyAllowed(currency)) {
          ref.read(addWalletControllerProvider.notifier)
              .selectCurrency(currency);
        }
      },
      theme: currency_picker.CurrencyPickerThemeData(
        shape: Theme.of(context).bottomSheetTheme.shape,
        bottomSheetHeight: MediaQuery.of(context).size.height / 1.4,
        inputDecoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.addWalletPage_searchCurrencyHint,
          prefixIcon: const Icon(Icons.search_rounded),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.three),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  bool _isCurrencyAllowed(currency_picker.Currency currency) {
    return currency.code != "RUB";
  }
}

class _CurrencyAvatar extends StatelessWidget {
  final Currency? currency;

  const _CurrencyAvatar({required this.currency});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currency = this.currency;

    final Widget child;
    if (currency == null) {
      child = Icon(Icons.currency_exchange_rounded,
        key: const ValueKey('placeholder'),
        size: 32,
        color: colorScheme.primary,
      );
    } else if (currency.emoji?.isNotEmpty == true) {
      child = Text(currency.emoji!,
        key: ValueKey(currency.code),
        style: const TextStyle(fontSize: 32),
      );
    } else {
      child = Text(currency.symbol,
        key: ValueKey(currency.code),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      );
    }

    return SizedBox(
      width: 40,
      height: 40,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: child,
      ),
    );
  }
}
