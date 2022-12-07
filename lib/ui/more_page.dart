import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme.dart';

import '../localizations.dart';
import 'header_content_page.dart';

class MorePage extends ConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HeaderContentPage(
      headerColor: Colors.brown.shade200,
      primaryTitle: Strings.morePageTitle.localized(context),
      primarySubtitle: 'version 0.1',
      actionIcon: Icons.brightness_4,
      onActionPressed: () {
        _updateTheme(ref.read(appThemeManagerProvider.notifier));
      },
      content: Center(
        child: Text(Strings.morePageTitle.localized(context)),
      ),
    );
  }

  void _updateTheme(AppThemeManager themeManager) {
    if (themeManager.theme == AppTheme.light) {
      themeManager.setTheme(AppTheme.dark);
    } else {
      themeManager.setTheme(AppTheme.light);
    }
  }
}
