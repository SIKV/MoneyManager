import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_maker_state.dart';
import 'package:moneymanager/feature/transaction/extensions.dart';
import 'package:moneymanager/feature/transaction/provider/transaction_maker_provider.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/feature/transaction/ui/type_selector.dart';
import 'package:moneymanager/feature/transaction/ui/property_item.dart';
import 'package:moneymanager/feature/transaction/ui/selector_container.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../domain/transaction.dart';
import '../../localizations.dart';
import '../../theme/theme.dart';

const _noValuePlaceholder = '...';

class TransactionPage extends ConsumerStatefulWidget {
  final Transaction? transaction;

  const TransactionPage({
    super.key,
    this.transaction,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransactionPageState();
}

class _TransactionPageState extends ConsumerState<TransactionPage> {

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    if (transaction != null) {
      ref.read(transactionMakerProvider.notifier)
          .setTransaction(transaction);
    }
  }

  void _selectProperty(TransactionProperty value) {
    ref.read(transactionMakerProvider.notifier)
        .selectProperty(value);
  }

  void _saveTransaction() {
    // TODO: Implement
  }

  String _getCategory(TransactionMakerState state) {
    final category = state.category;

    if (category != null) {
      return '${category.emoji ?? ''}   ${category.title}';
    } else {
      return _noValuePlaceholder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);
    final state = ref.watch(transactionMakerProvider);

    final themeData = appTheme.themeData();

    final category = _getCategory(state);

    return Theme(
      data: themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(
          primary: state.type.getColor(appTheme.colors),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const TypeSelector(),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
              child: Column(
                children: [
                  PropertyItem(
                    title: Strings.date.localized(context),
                    value: '27 Jan 2023   01:37',
                    isSelected: state.selectedProperty == TransactionProperty.date,
                    onSelected: () {
                      _selectProperty(TransactionProperty.date);
                    },
                  ),

                  const SizedBox(height: Spacings.two),

                  PropertyItem(
                    title: Strings.category.localized(context),
                    value: category,
                    isSelected: state.selectedProperty == TransactionProperty.category,
                    onSelected: () {
                      _selectProperty(TransactionProperty.category);
                    },
                  ),

                  const SizedBox(height: Spacings.two),

                  PropertyItem(
                    title: Strings.amount.localized(context),
                    value: '...',
                    isSelected: state.selectedProperty == TransactionProperty.amount,
                    onSelected: () {
                      _selectProperty(TransactionProperty.amount);
                    },
                  ),

                  const SizedBox(height: Spacings.two),

                  PropertyItem(
                    title: Strings.note.localized(context),
                    value: '...',
                    isSelected: state.selectedProperty == TransactionProperty.note,
                    onSelected: () {
                      _selectProperty(TransactionProperty.note);
                    },
                  ),
                ],
              ),
            ),

            Container(
              height: 12,
              color: Colors.black26,
            ),

            const Expanded(
              child: SelectorContainer(),
            ),

            Padding(
              padding: const EdgeInsets.all(Spacings.four),
              child: FilledButton(
                onPressed: _saveTransaction,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(36),
                ),
                child: Text(
                  '${Strings.add.localized(context)} ${state.type.getTitle(context)}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}