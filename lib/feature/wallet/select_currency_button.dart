import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../l10n/app_localizations.dart';
import 'controller/add_wallet_controller.dart';

class SelectCurrencyButton extends ConsumerWidget {
  const SelectCurrencyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addWalletControllerProvider);

    final selectedCurrency = state.value?.selectedCurrency;
    String selectedCurrencyText = '';
    if (selectedCurrency != null) {
      selectedCurrencyText = '${selectedCurrency.emoji} ${selectedCurrency.name} (${selectedCurrency.symbol})';
    } else {
      selectedCurrencyText = AppLocalizations.of(context)!.addWalletPage_selectCurrencyPlaceholder;
    }

    return InkWell(
      onTap: () => _selectCurrency(context, ref),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(selectedCurrencyText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
          const SizedBox(height: Spacings.two),
          Container(
            height: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
        ],
      ),
    );
  }

  void _selectCurrency(BuildContext context, WidgetRef ref) {
    showCurrencyPicker(
      context: context,
      onSelect: (currency) {
        if (_isCurrencyAllowed(currency)) {
          ref.read(addWalletControllerProvider.notifier)
              .selectCurrency(currency);
        }
      },
      theme: CurrencyPickerThemeData(
        shape: Theme.of(context).bottomSheetTheme.shape,
        bottomSheetHeight: MediaQuery.of(context).size.height / 1.4,
      ),
    );
  }

  bool _isCurrencyAllowed(Currency currency) {
    return currency.code != "RUB";
  }
}
