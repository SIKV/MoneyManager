import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_args.dart';
import 'package:moneymanager/feature/categories/ui/category_maker_actions.dart';
import 'package:moneymanager/feature/categories/ui/emoji_and_title.dart';
import 'package:moneymanager/ui/widget/delete_confirmation.dart';
import 'package:moneymanager/ui/widget/panel.dart';

import '../../theme/spacings.dart';
import '../common/transaction_type_selector.dart';
import 'controller/category_maker_controller.dart';
import 'domain/category_maker_mode.dart';
import 'emoji/emoji_picker_content.dart';

class CategoryMaker extends ConsumerStatefulWidget {
  final CategoryMakerArgs args;

  const CategoryMaker({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryMakerState();
}

class _CategoryMakerState extends ConsumerState<CategoryMaker> {
  late TextEditingController _titleTextController;

  @override
  void initState() {
    super.initState();

    ref.read(categoryMakerControllerProvider.notifier)
        .initWithArgs(widget.args);

    _titleTextController = TextEditingController();
    _initTitle(widget.args);

    _titleTextController.addListener(() {
      ref.read(categoryMakerControllerProvider.notifier)
          .setTitle(_titleTextController.text);
    });
  }

  @override
  void dispose() {
    _titleTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryMakerControllerProvider);

    _listenTitleChanged();

    String title = '';

    switch (state.mode) {
      case CategoryMakerMode.unknown:
        title = '';
        break;
      case CategoryMakerMode.add:
        title = AppLocalizations.of(context)!.categoryMakerPage_addTitle;
        break;
      case CategoryMakerMode.edit:
        title = AppLocalizations.of(context)!.categoryMakerPage_editTitle;
        break;
    }

    return Panel(
      title: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacings.four),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TransactionTypeSelector(
              selectedType: state.category.type,
              onSelectedTypeChanged: _typeChanged,
            ),

            const SizedBox(height: Spacings.five),

            EmojiAndTitle(
              state: state,
              titleTextController: _titleTextController,
              onSelectEmoji: _selectEmoji,
            ),

            const SizedBox(height: Spacings.six),

            CategoryMakerActions(
              mode: state.mode,
              onSavePressed: state.allowedToSave ? _saveCategory : null,
              onDeletePressed: _deleteCategory,
            ),
          ],
        ),
      ),
    );
  }

  void _initTitle(CategoryMakerArgs args) {
    if (args is EditCategoryMakerArgs) {
      _titleTextController.text = args.category.title;
    }
  }

  void _listenTitleChanged() {
    ref.listen(categoryMakerControllerProvider
        .select((value) => value.category.title), (previous, next) {
      _titleTextController.text = next;
    });
  }

  void _typeChanged(TransactionType? type) {
    ref.read(categoryMakerControllerProvider.notifier)
        .setType(type ?? TransactionType.income);
  }

  void _selectEmoji() {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          EmojiPickerContent(
            onEmojiSelected: (emoji) {
              ref.read(categoryMakerControllerProvider.notifier)
                  .setEmoji(emoji);
              Navigator.pop(context);
            },
          ),
    );
  }

  void _saveCategory() {
    ref.read(categoryMakerControllerProvider.notifier)
        .save();

    Navigator.pop(context);
  }

  void _deleteCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DeleteConfirmation(
          onDeletePressed: (withRelatedTransactions) {
            ref.read(categoryMakerControllerProvider.notifier)
                .delete(withRelatedTransactions);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _DeleteConfirmation extends StatefulWidget {
  final Function(bool) onDeletePressed;

  const _DeleteConfirmation({
    required this.onDeletePressed,
  });

  @override
  State<_DeleteConfirmation> createState() => _DeleteConfirmationState();
}

class _DeleteConfirmationState extends State<_DeleteConfirmation> {
  bool deleteWithRelatedTransactions = false;

  @override
  Widget build(BuildContext context) {
    return DeleteConfirmation(
      title: AppLocalizations.of(context)!.categoryMakerPage_deleteTitle,
      description: AppLocalizations.of(context)!.categoryMakerPage_deleteDescription,
      content: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: deleteWithRelatedTransactions,
              onChanged: (value) {
                setState(() {
                  deleteWithRelatedTransactions = value ?? false;
                });
              },
            ),
          ),
          const SizedBox(width: Spacings.two),
          Text(AppLocalizations.of(context)!.categoryMakerPage_deleteWithRelatedTransactions),
        ],
      ),
      onDeletePressed: () {
        widget.onDeletePressed(deleteWithRelatedTransactions);
      },
    );
  }
}
