import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_maker_state.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/feature/transaction/domain/ui_mode.dart';
import 'package:moneymanager/feature/transaction/domain/validation_error.dart';
import 'package:moneymanager/feature/transaction/ui/actions_gradient.dart';
import 'package:moneymanager/feature/transaction/ui/property_item.dart';
import 'package:moneymanager/feature/transaction/ui/selector_container.dart';
import 'package:moneymanager/feature/transaction/ui/transaction_actions.dart';
import 'package:moneymanager/feature/transaction/ui/wallet_selector.dart';
import 'package:moneymanager/ui/extensions.dart';

import '../../domain/transaction_type.dart';
import '../../l10n/app_localizations.dart';
import '../../navigation/routes.dart';
import '../../navigation/transaction_page_args.dart';
import '../../theme/spacings.dart';
import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';
import '../../ui/widget/panel.dart';
import '../common/transaction_type_selector.dart';
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

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);
    final themeData = appTheme.themeData();

    final state = ref.watch(transactionMakerControllerProvider).value;

    _listenShouldShowCalculator();
    _listenTransactionSavedOrDeleted();
    _listenValidationErrors();

    final properties = _createPropertyItems(state);
    // NOTE. Be careful of note property item position.
    final notePropertyItem = properties.last;

    final shouldShowActionsGradient = state?.selectedProperty != TransactionProperty.amount
        && state?.uiMode != UiMode.view;

    final shouldShowOnlyNote = MediaQuery.of(context).viewInsets.bottom > 0.0;

    final primaryColor = state?.transaction.type.getColor(appTheme.colors) ??
        appTheme.colors.colorScheme.primary;

    final uiMode = state?.uiMode ?? UiMode.view;

    return PopScope(
      canPop: uiMode != UiMode.edit,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _setEditMode(false);
        }
      },
      child: Theme(
        data: themeData.copyWith(
          colorScheme: themeData.colorScheme.copyWith(
            primary: primaryColor,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: WalletSelector(
              isEnabled: uiMode != UiMode.view,
            ),
            centerTitle: false,
            actions: _getActions(state),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: Spacings.three,
                  left: Spacings.five,
                  right: Spacings.five,
                  bottom: Spacings.four,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: shouldShowOnlyNote ? [notePropertyItem] : properties,
                ),
              ),
              Container(
                height: Spacings.one,
                color: Theme.of(context).colorScheme.shadow,
              ),
              Expanded(
                child: Stack(
                  children: [
                    const SelectorContainer(),

                    if (shouldShowActionsGradient)
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: ActionsGradient(),
                      ),
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.only(
                  top: shouldShowActionsGradient ? 0 : Spacings.four,
                  left: Spacings.four,
                  right: Spacings.four,
                  bottom: Spacings.four,
                ),
                child: const TransactionActions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectProperty(TransactionProperty value) {
    ref.read(transactionMakerControllerProvider.notifier)
        .selectProperty(value);
  }

  List<Widget> _getActions(TransactionMakerState? state) {
    switch (state?.uiMode) {
      case null:
        return [];
      case UiMode.add:
        return [];
      case UiMode.view:
        return [
          IconButton(
            onPressed: () => _setEditMode(true),
            icon: const Icon(Icons.edit),
          )
        ];
      case UiMode.edit:
        return [];
    }
  }

  void _setEditMode(bool editMode) {
    ref.watch(transactionMakerControllerProvider.notifier)
        .setUiMode(editMode ? UiMode.edit : UiMode.view);
  }

  List<Widget> _createPropertyItems(TransactionMakerState? state) {
    if (state == null) {
      return [
        const SizedBox(height: Spacings.two),
        const ShimmerPropertyItem(),
        const SizedBox(height: Spacings.two),
        const ShimmerPropertyItem(),
        const SizedBox(height: Spacings.two),
        const ShimmerPropertyItem(),
        const SizedBox(height: Spacings.two),
        const ShimmerPropertyItem(),
      ];
    }

    final category = state.transaction.category;

    String categoryTitle = '';

    if (category != null) {
      if (category.emoji != null) {
        categoryTitle = '${category.emoji}   ${category.title}';
      } else {
        categoryTitle = category.title;
      }
    } else {
       categoryTitle = _noValuePlaceholder;
    }

    return [
      SizedBox(
        width: double.infinity,
        child: TransactionTypeSelector(
          selectedType: state.transaction.type,
          isEnabled: state.uiMode != UiMode.view,
          onSelectedTypeChanged: _setType,
        ),
      ),
      const SizedBox(height: Spacings.four),
      PropertyItem(
        title: AppLocalizations.of(context)!.date,
        value: state.transaction.formattedCreateDateTime,
        isSelected: state.selectedProperty == TransactionProperty.date,
        onSelected: state.uiMode == UiMode.view ? null : () {
          _selectProperty(TransactionProperty.date);
        },
      ),
      const SizedBox(height: Spacings.two),
      PropertyItem(
        title: AppLocalizations.of(context)!.category,
        value: categoryTitle,
        isSelected: state.selectedProperty == TransactionProperty.category,
        onSelected: state.uiMode == UiMode.view ? null : () {
          _selectProperty(TransactionProperty.category);
        },
      ),
      const SizedBox(height: Spacings.two),
      PropertyItem(
        title: AppLocalizations.of(context)!.amount,
        value: state.transaction.formattedAmount,
        isSelected: state.selectedProperty == TransactionProperty.amount,
        onSelected: state.uiMode == UiMode.view ? null : () {
          _selectProperty(TransactionProperty.amount);
        },
      ),
      const SizedBox(height: Spacings.two),
      PropertyItem(
        title: AppLocalizations.of(context)!.note,
        value: state.transaction.note ?? _noValuePlaceholder,
        isSelected: state.selectedProperty == TransactionProperty.note,
        onSelected: () {
          if (state.uiMode == UiMode.view) {
            _showFullNote(state.transaction.note);
          } else {
            _selectProperty(TransactionProperty.note);
          }
        },
      ),
    ];
  }

  void _listenShouldShowCalculator() {
    ref.listen(transactionMakerControllerProvider
        .select((state) => state.value?.shouldShowCalculator), (previous, next) async {
      if (next != null) {
        final result = await Navigator.pushNamed(context, AppRoutes.calculator,
          arguments: next,
        );
        ref.read(transactionMakerControllerProvider.notifier)
            .handleNavigationResult(result);
      }
    });
  }

  void _listenTransactionSavedOrDeleted() {
    ref.listen(transactionMakerControllerProvider
        .select((state) => state.value?.transactionSaved), (previous, next) {
      if (next == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.transactionPage_transactionSaved))
        );
        Navigator.pop(context);
      }
    });

    ref.listen(transactionMakerControllerProvider
        .select((state) => state.value?.transactionDeleted), (previous, next) {
      if (next == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.transactionPage_transactionDeleted))
        );
        Navigator.pop(context);
      }
    });
  }

  void _listenValidationErrors() {
    ref.listen(transactionMakerControllerProvider
        .select((state) => state.value?.validationError), (previous, next) {

      String? errorMessage;

      switch (next) {
        case ValidationError.emptyCategory:
          errorMessage = AppLocalizations.of(context)!.transactionPage_validationErrorCategoryNotSelected;
          break;
        case ValidationError.emptyAmount:
          errorMessage = AppLocalizations.of(context)!.transactionPage_validationErrorEmptyAmount;
          break;
        case null:
          errorMessage = null;
          break;
      }

      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
            )
        );
      }

      ref.read(transactionMakerControllerProvider.notifier)
          .resetValidationError();
    });
  }

  void _setType(TransactionType? type) {
    ref.read(transactionMakerControllerProvider.notifier)
        .setType(type ?? TransactionType.income);
  }

  void _showFullNote(String? note) {
    if (note != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Panel(
            child: Padding(
              padding: const EdgeInsets.only(left: Spacings.four, right: Spacings.four, bottom: Spacings.four),
              child: Text(note),
            ),
          );
        },
      );
    }
  }
}
