import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';

import '../../localizations.dart';
import '../../theme/theme.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return CollapsingHeaderPage(
      colors: appTheme.colors,
      startColor: appTheme.colors.statisticsHeaderStart,
      endColor: appTheme.colors.statisticsHeaderEnd,
      collapsedHeight: 78,
      expandedHeight: 236,
      title: Strings.statisticsPageTitle.localized(context),
      subtitle: '4 Nov 2022 - 30 Nov 2022',
      primaryAction: AppIcons.statisticsDateRange,
      onPrimaryActionPressed: () {},
      sliver: SliverToBoxAdapter(
        child: Container(),
      ),
    );
  }
}
