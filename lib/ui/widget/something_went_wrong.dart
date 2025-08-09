import 'package:flutter/material.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

import '../../l10n/app_localizations.dart';

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SmallSectionText(AppLocalizations.of(context)!.generalErrorMessage),
    );
  }
}
