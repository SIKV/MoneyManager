import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/emoji/emoji_picker_content.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/utils.dart';

import '../../domain/transaction_subcategory.dart';
import '../../theme/spacings.dart';
import '../../ui/widget/close_circle_button.dart';
import 'controller/categories_controller.dart';

enum CategoryEditorAction {
  add, edit
}

const _emojiContainerSize = 48.0;
const _emojiFontSize = 24.0;

const _defaultTransactionCategoryType = TransactionType.expense;

// TODO: Add data validation.
// TODO: Add title text limit, subcategories list size limit.
class CategoryEditor extends ConsumerStatefulWidget {
  final CategoryEditorAction action;
  final TransactionCategory? category;

  const CategoryEditor({
    Key? key,
    required this.action,
    this.category,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends ConsumerState<CategoryEditor> {
  late TransactionCategory _newCategory;

  late TextEditingController _titleTextController;
  late TextEditingController _subcategoryTextController;

  @override
  void initState() {
    super.initState();

    _newCategory = widget.category ?? TransactionCategory(
      id: generateUniqueId(),
      type: _defaultTransactionCategoryType,
      title: '',
    );

    _titleTextController = TextEditingController();
    _titleTextController.text = _newCategory.title;

    _subcategoryTextController = TextEditingController();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _subcategoryTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                groupValue: _newCategory.type,
                onValueChanged: _typeChanged,
                children: <TransactionType, Widget>{
                  TransactionType.income: Text(Strings.income.localized(context)),
                  TransactionType.expense: Text(Strings.expense.localized(context)),
                },
              ),
              const Spacer(),
              const CloseCircleButton(),
            ],
          ),

          const SizedBox(height: Spacings.five),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _selectEmoji,
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
                  child: Text(_newCategory.emoji ?? '',
                    style: const TextStyle(
                      fontSize: _emojiFontSize,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: Spacings.five),

              Expanded(
                child: TextField(
                  controller: _titleTextController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: Strings.categoryTitle.localized(context),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: Spacings.six),

          _Subcategories(
            subcategories: _newCategory.subcategories,
            onAddSubcategoryPressed: _showAddSubcategoryDialog,
            onDeleteSubcategoryPressed: _deleteSubcategory,
          ),

          const SizedBox(height: Spacings.six),

          _Actions(
            action: widget.action,
            onSavePressed: _saveCategory,
            onDeletePressed: _deleteCategory,
          ),
        ],
      ),
    );
  }

  void _typeChanged(TransactionType? type) {
    setState(() {
      _newCategory = _newCategory.copyWith(
        type: type,
      );
    });
  }

  void _selectEmoji() {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          EmojiPickerContent(
            onEmojiSelected: (emoji) {
              setState(() {
                _newCategory = _newCategory.copyWith(
                  emoji: emoji,
                );
              });
              Navigator.pop(context);
            },
          ),
    );
  }

  void _showAddSubcategoryDialog() {
    showDialog(
      context: context,
      builder: (_) =>  AlertDialog(
        content: TextField(
          controller: _subcategoryTextController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            _addSubcategory();
            _close();
          },
          decoration: InputDecoration(
            labelText: Strings.newSubcategory.localized(context),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              _addSubcategory();
              _close();
            },
            child: Text(Strings.add.localized(context)),
          ),
          OutlinedButton(
            onPressed: _close,
            child: Text(Strings.cancel.localized(context)),
          ),
        ],
      ),
    );
  }

  void _addSubcategory() {
    setState(() {
      final subcategory = TransactionSubcategory(
        id: generateUniqueId(),
        title: _subcategoryTextController.text,
      );

      _subcategoryTextController.clear();

      _newCategory = _newCategory.copyWith(
        subcategories: _newCategory.subcategories.toList()
          ..add(subcategory),
      );
    });
  }

  void _deleteSubcategory(TransactionSubcategory subcategory) {
    setState(() {
      _newCategory = _newCategory.copyWith(
        subcategories: _newCategory.subcategories.toList()
          ..remove(subcategory),
      );
    });
  }

  void _saveCategory() {
    _newCategory = _newCategory.copyWith(
      title: _titleTextController.text,
    );

    ref.read(categoriesControllerProvider.notifier)
        .addOrUpdateCategory(_newCategory);

    _close();
  }

  void _deleteCategory() {
    ref.read(categoriesControllerProvider.notifier)
        .deleteCategory(_newCategory.id);

    _close();
  }

  void _close() {
    Navigator.pop(context);
  }
}

class _Subcategories extends StatelessWidget {
  final List<TransactionSubcategory> subcategories;
  final VoidCallback onAddSubcategoryPressed;
  final Function onDeleteSubcategoryPressed;

  const _Subcategories({
    Key? key,
    required this.subcategories,
    required this.onAddSubcategoryPressed,
    required this.onDeleteSubcategoryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacings.two,
      children: [
        ...subcategories.map<Widget>((subcategory) =>
            Chip(
              label: Text(subcategory.title),
              onDeleted: () {
                onDeleteSubcategoryPressed(subcategory);
              },
            )).toList(),
        ...[
          ActionChip(
            avatar: const Icon(AppIcons.categoriesAddSubcategory),
            label: Text(Strings.addSubcategory.localized(context)),
            onPressed: onAddSubcategoryPressed,
          )
        ]
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  final CategoryEditorAction action;
  final VoidCallback onSavePressed;
  final VoidCallback onDeletePressed;

  const _Actions({
    Key? key,
    required this.action,
    required this.onSavePressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [
      FilledButton(
        onPressed: onSavePressed,
        child: Text(Strings.save.localized(context)),
      ),
    ];

    if (action == CategoryEditorAction.edit) {
      buttons.insert(0,
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .error,
          ),
          onPressed: onDeletePressed,
          child: Text(Strings.delete.localized(context)),
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
