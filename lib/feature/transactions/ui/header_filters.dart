import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type_filter.dart';
import 'package:moneymanager/feature/transactions/controller/header_controller.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';
import 'package:moneymanager/ui/widget/panel.dart';
import 'package:moneymanager/ui/widget/segmented_control.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/spacings.dart';
import '../domain/transaction_range_filter.dart';

class HeaderFilters extends ConsumerWidget {
  const HeaderFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(headerControllerProvider);

    return state.when(
      loading: () => Container(),
      error: (_, __) =>
          SizedBox(
            height: 124,
            child: Center(
              child: Text(AppLocalizations.of(context)!.generalErrorMessage),
            ),
          ),
      data: (state) =>
          Panel(
            title: AppLocalizations.of(context)!.transactionsPage_applyFiltersTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Section(title: AppLocalizations.of(context)!.type),
                const SizedBox(height: Spacings.four),

                Padding(
                  padding: const EdgeInsets.only(
                    left: Spacings.three,
                    bottom: Spacings.three,
                  ),
                  child: SegmentedControl<TransactionTypeFilter>(
                    selectedValue: state.typeFilter,
                    onSelectedValueChanged: (value) {
                      if (value != null) {
                        ref.read(headerControllerProvider.notifier)
                            .setTypeFilter(value);
                      }
                    },
                    values: <TransactionTypeFilter, Widget>{
                      TransactionTypeFilter.income: Text(
                          AppLocalizations.of(context)!.income),
                      TransactionTypeFilter.expenses: Text(
                          AppLocalizations.of(context)!.expenses),
                      TransactionTypeFilter.all: Text(
                          AppLocalizations.of(context)!.all),
                    },
                  ),
                ),

                const SizedBox(height: Spacings.four),
                _Section(title: AppLocalizations.of(context)!.range),
                const SizedBox(height: Spacings.two),

                _ValuesList(
                  values: state.rangeFilters,
                  selectedValue: state.rangeFilter,
                  onSelectValue: (value) {
                    ref.read(headerControllerProvider.notifier)
                        .setRangeFilter(value);
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(Spacings.four),
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.done),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;

  const _Section({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Spacings.four,
      ),
      child: SmallSectionText(title),
    );
  }
}

class _ValuesList extends StatelessWidget {
  final List<TransactionRangeFilter> values;
  final TransactionRangeFilter selectedValue;
  final Function onSelectValue;

  const _ValuesList({
    Key? key,
    required this.values,
    required this.selectedValue,
    required this.onSelectValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const valueTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
    );

    final selectedValueTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    final selectedValueIcon = Icon(
      Icons.check_rounded,
      size: 32,
      color: Theme.of(context).colorScheme.primary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: values.map((value) =>
          ListTile(
            onTap: () => onSelectValue(value),
            title: Text(value.getTitle(context),
              style: (value == selectedValue) ? selectedValueTextStyle : valueTextStyle,
            ),
            trailing: value == selectedValue ? selectedValueIcon : null,
          ),
      ).toList(),
    );
  }
}
