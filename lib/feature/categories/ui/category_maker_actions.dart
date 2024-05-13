import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../ui/widget/delete_button.dart';
import '../../../ui/widget/primary_button.dart';
import '../domain/category_maker_mode.dart';

class CategoryMakerActions extends StatelessWidget {
  final CategoryMakerMode mode;
  final VoidCallback? onSavePressed;
  final VoidCallback onDeletePressed;

  const CategoryMakerActions({
    super.key,
    required this.mode,
    required this.onSavePressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget saveButton;

    switch (mode) {
      case CategoryMakerMode.unknown:
        saveButton = Container();
        break;
      case CategoryMakerMode.add:
        saveButton = PrimaryButton(
          onPressed: onSavePressed,
          title: AppLocalizations.of(context)!.save,
        );
        break;
      case CategoryMakerMode.edit:
        saveButton = PrimaryButton(
          onPressed: onSavePressed,
          title: AppLocalizations.of(context)!.saveChanges,
        );
        break;
    }

    if (mode == CategoryMakerMode.add) {
      return SizedBox(
        width: double.infinity,
        child: saveButton,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DeleteButton(
            style: DeleteButtonStyle.noBorder,
            showIcon: true,
            onPressed: onDeletePressed,
          ),
          saveButton,
        ],
      );
    }
  }
}
