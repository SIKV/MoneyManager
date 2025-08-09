import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/spacings.dart';
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
      case CategoryMakerMode.edit:
        saveButton = PrimaryButton(
          onPressed: onSavePressed,
          title: AppLocalizations.of(context)!.actionSave,
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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DeleteButton(
            style: DeleteButtonStyle.outlined,
            onPressed: onDeletePressed,
          ),
          const SizedBox(width: Spacings.four),
          Expanded(child: saveButton),
        ],
      );
    }
  }
}
