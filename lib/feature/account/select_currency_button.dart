import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/theme/spacings.dart';

import 'controller/add_account_controller.dart';

class SelectCurrencyButton extends ConsumerWidget {
  const SelectCurrencyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addAccountControllerProvider);

    final selectedCurrency = state.value?.selectedCurrency;
    String selectedCurrencyText = '';
    if (selectedCurrency != null) {
      selectedCurrencyText = '${selectedCurrency.emoji} ${selectedCurrency.name} (${selectedCurrency.symbol})';
    } else {
      selectedCurrencyText = Strings.selectCurrencyPlaceholder.localized(context);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: InkWell(
        onTap: () => _selectCurrency(context, ref),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),
    );
  }

  void _selectCurrency(BuildContext context, WidgetRef ref) {
    showCurrencyPicker(
      context: context,
      onSelect: (currency) {
        ref.read(addAccountControllerProvider.notifier)
            .selectCurrency(currency);
      },
      theme: CurrencyPickerThemeData(
        shape: Theme.of(context).bottomSheetTheme.shape,
        bottomSheetHeight: MediaQuery.of(context).size.height / 1.4,
      ),
    );
  }
}
