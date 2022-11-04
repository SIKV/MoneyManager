import 'package:flutter/material.dart';

import 'header_content_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderContentPage(
      headerColor: Colors.teal.shade200,
      primaryTitle: 'Statistics',
      primarySubtitle: '4 Nov 2022 - 30 Nov 2022',
      actionIcon: Icons.calendar_today,
      content: const Center(
        child: Text('Statistics'),
      ),
    );
  }
}
