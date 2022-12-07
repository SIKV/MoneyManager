import 'package:flutter/material.dart';

import '../localizations.dart';
import 'header_content_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderContentPage(
      headerColor: Colors.teal.shade200,
      primaryTitle: Strings.statisticsPageTitle.localized(context),
      primarySubtitle: '4 Nov 2022 - 30 Nov 2022',
      actionIcon: Icons.calendar_today,
      content: Center(
        child: Text(Strings.statisticsPageTitle.localized(context)),
      ),
    );
  }
}
