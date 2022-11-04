import 'package:flutter/material.dart';

import 'header_content_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderContentPage(
      headerColor: Colors.brown.shade200,
      primaryTitle: 'More',
      primarySubtitle: 'version 0.1',
      actionIcon: Icons.brightness_2_outlined,
      content: const Center(
        child: Text('More'),
      ),
    );
  }
}
