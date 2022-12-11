import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/theme/icons.dart';

import '../../localizations.dart';
import '../../theme/theme.dart';
import '../../ui/widget/header_content_page.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return HeaderContentPage(
      headerColor: appTheme.colors.statisticsHeader,
      primaryTitle: Strings.statisticsPageTitle.localized(context),
      primarySubtitle: '4 Nov 2022 - 30 Nov 2022',
      actionIcon: AppIcons.statisticsDateRange,
      content: Center(
        child: Text(Strings.statisticsPageTitle.localized(context)),
      ),
    );
  }
}
