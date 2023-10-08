import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type_filter.dart';
import 'package:moneymanager/feature/transactions/controller/header_controller.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';
import 'package:moneymanager/theme/icons.dart';

import '../../../theme/spacings.dart';
import '../../../ui/widget/close_circle_button.dart';
import '../domain/transaction_range_filter.dart';

class HeaderFilters extends ConsumerWidget {
  const HeaderFilters({Key? key}) : super(key: key);

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(Spacings.four),
                  child: CloseCircleButton(),
                ),
              ),

              _Section(title: AppLocalizations.of(context)!.type),
              const SizedBox(height: Spacings.four),

              Padding(
                padding: const EdgeInsets.only(
                  left: Spacings.three,
                  bottom: Spacings.three,
                ),
                child: CupertinoSlidingSegmentedControl<TransactionTypeFilter>(
                  groupValue: state.typeFilter,
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(headerControllerProvider.notifier)
                          .setTypeFilter(value);
                    }
                  },
                  children: <TransactionTypeFilter, Widget>{
                    TransactionTypeFilter.income: Text(
                        AppLocalizations.of(context)!.income),
                    TransactionTypeFilter.expense: Text(
                        AppLocalizations.of(context)!.expense),
                    TransactionTypeFilter.total: Text(
                        AppLocalizations.of(context)!.total),
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
                    child: Text(AppLocalizations.of(context)!.apply),
                  ),
                ),
              ),
            ],
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
      child: Text(title,
        style: Theme.of(context).textTheme.bodySmall,
      ),
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
      AppIcons.transactionsHeaderSettingsSelectedValue,
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
