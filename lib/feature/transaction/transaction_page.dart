import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_maker_state.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/feature/transaction/ui/property_item.dart';
import 'package:moneymanager/feature/transaction/ui/selector_container.dart';
import 'package:moneymanager/feature/transaction/ui/transaction_actions.dart';
import 'package:moneymanager/feature/transaction/ui/type_selector.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../localizations.dart';
import '../../navigation/transaction_page_args.dart';
import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';
import 'controller/transaction_maker_controller.dart';

const _noValuePlaceholder = '...';

class TransactionPage extends ConsumerStatefulWidget {
  final TransactionPageArgs args;

  const TransactionPage({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransactionPageState();
}

class _TransactionPageState extends ConsumerState<TransactionPage> {

  @override
  void initState() {
    super.initState();

    ref.read(transactionMakerControllerProvider.notifier)
        .initWithArgs(widget.args);
  }

  void _selectProperty(TransactionProperty value) {
    ref.read(transactionMakerControllerProvider.notifier)
        .selectProperty(value);
  }

  String _getCategory(TransactionMakerState state) {
    final category = state.transaction.category;

    if (category != null) {
      return '${category.emoji ?? ''}   ${category.title}';
    } else {
      return _noValuePlaceholder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);
    final themeData = appTheme.themeData();

    final state = ref.watch(transactionMakerControllerProvider).value;

    if (state == null) {
      // TODO:
      return Container();
    }

    ref.listen(transactionMakerControllerProvider
        .select((state) => state.value?.transactionSaved), (previous, next) {
      if (next == true) {
        Navigator.pop(context);
      }
    });

    final category = _getCategory(state);

    final notePropertyItem = PropertyItem(
      title: Strings.note.localized(context),
      value: state.transaction.note ?? '...',
      isSelected: state.selectedProperty == TransactionProperty.note,
      onSelected: () {
        _selectProperty(TransactionProperty.note);
      },
    );

    final List<Widget> properties = [
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
        value: state.transaction.formattedAmount,
        isSelected: state.selectedProperty == TransactionProperty.amount,
        onSelected: () {
          _selectProperty(TransactionProperty.amount);
        },
      ),
      const SizedBox(height: Spacings.two),
      notePropertyItem,
    ];

    final shouldShowOnlyNote = MediaQuery.of(context).viewInsets.bottom > 0.0;

    return Theme(
      data: themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(
          primary: state.transaction.type.getColor(appTheme.colors),
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
                children: shouldShowOnlyNote ? [notePropertyItem] : properties,
              ),
            ),
            Container(
              height: Spacings.one,
              color: Theme.of(context).colorScheme.shadow,
            ),
            const Expanded(
              child: SelectorContainer(),
            ),
            const Padding(
              padding: EdgeInsets.all(Spacings.four),
              child: TransactionActions(),
            ),
          ],
        ),
      ),
    );
  }
}
