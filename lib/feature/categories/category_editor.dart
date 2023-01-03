import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/feature/categories/emoji/emoji_picker_content.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/utils.dart';

import '../../domain/transaction_subcategory.dart';
import '../../theme/spacings.dart';
import '../../ui/widget/close_circle_button.dart';
import 'categories_list_controller.dart';

enum CategoryEditorAction {
  add, edit
}

const _emojiContainerSize = 48.0;
const _emojiFontSize = 24.0;

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
  late TransactionCategory newCategory;

  late TextEditingController titleTextController;
  late TextEditingController subcategoryTextController;

  @override
  void initState() {
    super.initState();

    newCategory = widget.category ?? TransactionCategory(
      id: generateUniqueId(),
      title: '',
    );

    titleTextController = TextEditingController();
    titleTextController.text = newCategory.title;

    subcategoryTextController = TextEditingController();
  }

  @override
  void dispose() {
    titleTextController.dispose();
    subcategoryTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacings.four),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: CloseCircleButton(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: selectEmoji,
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
                  child: Text(newCategory.emoji ?? '',
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
                  decoration: InputDecoration(
                    labelText: Strings.categoryTitle.localized(context),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: Spacings.six),

          _Subcategories(
            subcategories: newCategory.subcategories,
            onAddSubcategoryPressed: showAddSubcategoryDialog,
            onDeleteSubcategoryPressed: deleteSubcategory,
          ),

          const SizedBox(height: Spacings.six),

          _Actions(
            action: widget.action,
            onSavePressed: saveCategory,
            onDeletePressed: deleteCategory,
          ),
        ],
      ),
    );
  }

  void selectEmoji() {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          EmojiPickerContent(
            onEmojiSelected: (emoji) {
              setState(() {
                newCategory = newCategory.copyWith(
                  emoji: emoji,
                );
              });
              Navigator.pop(context);
            },
          ),
    );
  }

  void showAddSubcategoryDialog() {
    showDialog(
      context: context,
      builder: (_) =>  AlertDialog(
        content: TextField(
          controller: subcategoryTextController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            addSubcategory();
            close();
          },
          decoration: InputDecoration(
            labelText: Strings.newSubcategory.localized(context),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              addSubcategory();
              close();
            },
            child: Text(Strings.add.localized(context)),
          ),
          OutlinedButton(
            onPressed: close,
            child: Text(Strings.cancel.localized(context)),
          ),
        ],
      ),
    );
  }

  void addSubcategory() {
    setState(() {
      final subcategory = TransactionSubcategory(
        id: generateUniqueId(),
        title: subcategoryTextController.text,
      );

      subcategoryTextController.clear();

      newCategory = newCategory.copyWith(
        subcategories: newCategory.subcategories.toList()
          ..add(subcategory),
      );
    });
  }

  void deleteSubcategory(TransactionSubcategory subcategory) {
    setState(() {
      newCategory = newCategory.copyWith(
        subcategories: newCategory.subcategories.toList()
          ..remove(subcategory),
      );
    });
  }

  void saveCategory() {
    newCategory = newCategory.copyWith(
      title: titleTextController.text,
    );

    ref.read(categoriesListControllerProvider.notifier)
        .addOrUpdateCategory(newCategory);

    close();
  }

  void deleteCategory() {
    ref.read(categoriesListControllerProvider.notifier)
        .deleteCategory(newCategory.id);

    close();
  }

  void close() {
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
