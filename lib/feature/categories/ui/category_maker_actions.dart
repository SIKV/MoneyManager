import 'package:flutter/material.dart';
import 'package:moneymanager/ui/widget/more_button.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/spacings.dart';
import '../../../ui/widget/primary_button.dart';
import '../domain/category_maker_mode.dart';

class CategoryMakerActions extends StatelessWidget {
  final CategoryMakerMode mode;
  final bool categoryArchived;
  final VoidCallback? onSavePressed;
  final VoidCallback onArchivePressed;
  final VoidCallback onUnarchivePressed;
  final VoidCallback onDeletePressed;

  const CategoryMakerActions({
    super.key,
    required this.mode,
    required this.categoryArchived,
    required this.onSavePressed,
    required this.onArchivePressed,
    required this.onUnarchivePressed,
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
        children: [
          Expanded(child: saveButton),
          const SizedBox(width: Spacings.three),
          MoreButton(onPressed: () => _showMoreActions(context) ),
        ],
      );
    }
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      routeSettings: const RouteSettings(name: '/category-actions-modal'),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacings.two,
            vertical: Spacings.two,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  if (categoryArchived) {
                    onUnarchivePressed();
                  } else {
                    onArchivePressed();
                  }
                },
                title: Text(categoryArchived
                    ? AppLocalizations.of(context)!.unarchive
                    : AppLocalizations.of(context)!.archive
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  onDeletePressed();
                },
                title: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
          ),
        );
      },
    );
  }
}
