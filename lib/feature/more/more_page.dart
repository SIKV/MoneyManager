import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme.dart';

import '../../localizations.dart';
import '../../ui/widget/header_content_page.dart';

class MorePage extends ConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return HeaderContentPage(
      headerColor: appTheme.colors.moreHeader,
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
    if (themeManager.theme.type == AppThemeType.light) {
      themeManager.setTheme(AppThemeType.dark);
    } else {
      themeManager.setTheme(AppThemeType.light);
    }
  }
}
