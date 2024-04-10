import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/spacings.dart';
import '../domain/period_type.dart';

class PeriodTypeSelector extends StatelessWidget {
  final List<PeriodType> types;
  final PeriodType selectedType;
  final Function(PeriodType) onSelectedTypeChanged;

  const PeriodTypeSelector({
    super.key,
    required this.types,
    required this.selectedType,
    required this.onSelectedTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PeriodType>(
      onSelected: onSelectedTypeChanged,
      itemBuilder: (BuildContext context) {
        return types.map((PeriodType type) {
          return PopupMenuItem<PeriodType>(
            value: type,
            child: Text(_getTitle(context, type)),
          );
        }).toList();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: Spacings.two),
        child: Chip(
          label: Row(
            children: [
              Text(_getTitle(context, selectedType)),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
          labelPadding: const EdgeInsets.only(left: Spacings.two),
        ),
      ),
    );
  }

  String _getTitle(BuildContext context, PeriodType periodType) {
    switch (periodType) {
      case PeriodType.monthly:
        return AppLocalizations.of(context)!.monthly;
      case PeriodType.annually:
        return AppLocalizations.of(context)!.annually;
    }
  }
}
