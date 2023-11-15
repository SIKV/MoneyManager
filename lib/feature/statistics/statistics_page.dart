import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(AppLocalizations.of(context)!.statisticsPageTitle),
          ),
          SliverFillRemaining(
            child: Center(
              child: Text(AppLocalizations.of(context)!.underDevelopment),
            ),
          ),
        ],
      ),
    );
  }
}
