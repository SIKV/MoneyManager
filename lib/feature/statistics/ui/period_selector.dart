import 'package:flutter/material.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

class PeriodSelector extends StatelessWidget {
  final String formattedPeriod;
  final VoidCallback onGoToPrevious;
  final VoidCallback onGoToNext;

  const PeriodSelector({
    super.key,
    required this.formattedPeriod,
    required this.onGoToPrevious,
    required this.onGoToNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onGoToPrevious,
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
        SmallSectionText(formattedPeriod),
        IconButton(
          onPressed: onGoToNext,
          icon: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}
