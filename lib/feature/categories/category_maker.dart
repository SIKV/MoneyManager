import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_args.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_mode.dart';

import '../../theme/spacings.dart';
import '../../ui/widget/close_circle_button.dart';
import 'controller/category_maker_controller.dart';
import 'domain/category_maker_state.dart';
import 'emoji/emoji_picker_content.dart';

const _emojiContainerSize = 48.0;
const _emojiFontSize = 24.0;

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

    return Padding(
      padding: EdgeInsets.only(
        top: Spacings.four,
        left: Spacings.four,
        right: Spacings.four,
        bottom: Spacings.four + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CupertinoSlidingSegmentedControl<TransactionType>(
                groupValue: state.category.type,
                onValueChanged: _typeChanged,
                children: <TransactionType, Widget>{
                  TransactionType.income: Text(AppLocalizations.of(context)!.income),
                  TransactionType.expense: Text(AppLocalizations.of(context)!.expense),
                },
              ),
              const Spacer(),
              const CloseCircleButton(),
            ],
          ),

          const SizedBox(height: Spacings.five),

          _EmojiAndTitle(
            state: state,
            titleTextController: _titleTextController,
            onSelectEmoji: _selectEmoji,
          ),

          const SizedBox(height: Spacings.six),

          _Actions(
            mode: state.mode,
            onSavePressed: state.allowedToSave ? _saveCategory : null,
            onDeletePressed: _deleteCategory,
          ),
        ],
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

class _EmojiAndTitle extends StatelessWidget {
  final CategoryMakerState state;
  final TextEditingController titleTextController;
  final VoidCallback? onSelectEmoji;

  const _EmojiAndTitle({
    Key? key,
    required this.state,
    required this.titleTextController,
    required this.onSelectEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onSelectEmoji,
          child: Container(
            height: _emojiContainerSize,
            width: _emojiContainerSize,
            padding: const EdgeInsets.all(Spacings.two),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
              shape: BoxShape.circle,
            ),
            child: Text(state.category.emoji ?? '',
              style: const TextStyle(
                fontSize: _emojiFontSize,
              ),
            ),
          ),
        ),

        const SizedBox(width: Spacings.five),

        Expanded(
          child: TextField(
            controller: titleTextController,
            autofocus: true,
            maxLength: state.titleMaxLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.categoryTitle,
            ),
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  final CategoryMakerMode mode;
  final VoidCallback? onSavePressed;
  final VoidCallback onDeletePressed;

  const _Actions({
    Key? key,
    required this.mode,
    required this.onSavePressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String saveButtonTitle;

    switch (mode) {
      case CategoryMakerMode.unknown:
        break;
      case CategoryMakerMode.add:
        saveButtonTitle = AppLocalizations.of(context)!.addCategory;
        break;
      case CategoryMakerMode.edit:
        saveButtonTitle = AppLocalizations.of(context)!.save;
        break;
    }

    List<Widget> buttons = [
      FilledButton(
        onPressed: onSavePressed,
        child: Text(saveButtonTitle),
      ),
    ];

    if (mode == CategoryMakerMode.edit) {
      buttons.insert(0,
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: onDeletePressed,
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      );
    }

    return ButtonBar(
      alignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: buttons,
    );
  }
}

class _DeleteConfirmation extends StatefulWidget {
  final Function(bool) onDeletePressed;

  const _DeleteConfirmation({
    Key? key,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  State<_DeleteConfirmation> createState() => _DeleteConfirmationState();
}

class _DeleteConfirmationState extends State<_DeleteConfirmation> {
  bool deleteWithRelatedTransactions = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.deleteCategoryTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(AppLocalizations.of(context)!.deleteCategoryDescription),
            const SizedBox(height: Spacings.five),
            Row(
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
                Text(AppLocalizations.of(context)!.deleteCategoryWithRelatedTransactions),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onDeletePressed(deleteWithRelatedTransactions);
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      ],
    );
  }
}
