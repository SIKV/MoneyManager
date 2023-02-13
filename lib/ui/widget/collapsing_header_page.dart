import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/ui/widget/header_circle_button.dart';

import '../../theme/theme.dart';

class CollapsingHeaderPage extends ConsumerWidget {
  final AppColors colors;
  final Color startColor;
  final Color endColor;
  final double collapsedHeight;
  final double expandedHeight;
  final String? titlePrefix;
  final String title;
  final String? titleSuffix;
  final String? subtitle;
  final String? tertiaryTitle;
  final Widget? primaryAction;
  final List<HeaderCircleButton>? secondaryActions;
  final Widget sliver;

  const CollapsingHeaderPage({
    Key? key,
    required this.colors,
    required this.startColor,
    required this.endColor,
    required this.collapsedHeight,
    required this.expandedHeight,
    this.titlePrefix,
    required this.title,
    this.titleSuffix,
    this.subtitle,
    this.tertiaryTitle,
    this.primaryAction,
    this.secondaryActions,
    required this.sliver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return Material(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _HeaderDelegate(
              colors: appTheme.colors,
              startColor: startColor,
              endColor: endColor,
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              titlePrefix: titlePrefix,
              title: title,
              titleSuffix: titleSuffix,
              subtitle: subtitle,
              tertiaryTitle: tertiaryTitle,
              primaryAction: primaryAction,
              secondaryActions: secondaryActions,
            ),
          ),
          sliver,
        ],
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final AppColors colors;
  final Color startColor;
  final Color endColor;
  final double collapsedHeight;
  final double expandedHeight;
  final String? titlePrefix;
  final String title;
  final String? titleSuffix;
  final String? subtitle;
  final String? tertiaryTitle;
  final Widget? primaryAction;
  final List<HeaderCircleButton>? secondaryActions;

  _HeaderDelegate({
    required this.colors,
    required this.startColor,
    required this.endColor,
    required this.collapsedHeight,
    required this.expandedHeight,
    this.titlePrefix,
    required this.title,
    this.titleSuffix,
    this.subtitle,
    this.tertiaryTitle,
    this.primaryAction,
    this.secondaryActions,
  });

  final double contentBorderHeight = 16;
  double paddingTop = 0;
  double scrollProgress = 0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    paddingTop = MediaQuery.of(context).padding.top;

    final scrollProgress = shrinkOffset / (maxExtent - minExtent);
    this.scrollProgress = (scrollProgress > 1.0) ? 1.0 : scrollProgress;

    return Stack(
      children: [
        // This is needed to remove a horizontal line between CollapsingHeaderContent and its content.
        Positioned(
          height: expandedHeight,
          left: 0,
          right: 0,
          bottom: 1,
          child: Container(color: startColor),
        ),
        // This is needed to remove a horizontal line between CollapsingHeaderContent and its content.
        Positioned(
          height: expandedHeight,
          left: 0,
          right: 0,
          bottom: 1,
          child: buildGradient(),
        ),
        Container(
          padding: EdgeInsets.only(top: paddingTop),
          child: buildHeader(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSecondaryActions(),
              buildContentRoundBorder(context),
            ],
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => paddingTop + collapsedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Widget buildGradient() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: 1 - scrollProgress,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [
              0.1,
              1.0,
            ],
            colors: [
              startColor,
              endColor,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    final titleTextStyle = TextStyle.lerp(
        TextStyle(
          color: colors.alwaysWhite,
          fontSize: 46,
          fontWeight: FontWeight.w700,
        ),
        TextStyle(
          color: colors.alwaysWhite,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        scrollProgress
    );

    final titleSuffixTextStyle = TextStyle.lerp(
        TextStyle(
          color: colors.alwaysWhite,
          fontSize: 32,
          fontWeight: FontWeight.w400,
        ),
        TextStyle(
          color: colors.alwaysWhite,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        scrollProgress
    );

    final subtitleTextStyle = TextStyle.lerp(
        TextStyle(
          color: colors.alwaysBlack,
          fontSize: 15,
        ),
        TextStyle(
          color: colors.alwaysBlack,
          fontSize: 13,
        ),
        scrollProgress
    );

    final tertiaryTitleTextStyle = TextStyle.lerp(
        TextStyle(
          color: colors.alwaysBlack,
          fontSize: 15,
        ),
        const TextStyle(
          color: Colors.transparent,
          fontSize: 0,
        ),
        scrollProgress
    );

    List<InlineSpan> spanChildren = [
      TextSpan(
        text: title,
        style: titleTextStyle,
      ),
    ];

    final titlePrefix = this.titlePrefix;
    if (titlePrefix != null) {
      spanChildren.insert(0,
        TextSpan(
          text: titlePrefix,
          style: titleTextStyle,
        ),
      );
    }

    final titleSuffix = this.titleSuffix;
    if (titleSuffix != null) {
      spanChildren.add(
        TextSpan(
          text: titleSuffix,
          style: titleSuffixTextStyle,
        ),
      );
    }

    final List<Widget> children = [
      RichText(
        text: TextSpan(
          children: spanChildren,
        ),
      ),
    ];

    final subtitle = this.subtitle;
    if (subtitle != null) {
      children.add(
        Padding(
          padding: EdgeInsets.lerp(
            const EdgeInsets.only(top: 6),
            const EdgeInsets.only(top: 0),
            scrollProgress,
          ) ?? const EdgeInsets.only(top: 0),
          child: Text(subtitle,
            style: subtitleTextStyle,
          ),
        ),
      );
    }

    final tertiaryTitle = this.tertiaryTitle;
    if (tertiaryTitle != null) {
      children.add(
        Text(tertiaryTitle,
          style: tertiaryTitleTextStyle,
        ),
      );
    }

    final padding = EdgeInsets.lerp(
      const EdgeInsets.only(left: 36, top: 48, right: 36),
      const EdgeInsets.only(left: 24, top: 16, right: 16),
      scrollProgress,
    ) ?? const EdgeInsets.all(0);

    final List<Widget> rowChildren = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      )
    ];

    final primaryAction = this.primaryAction;
    if (primaryAction != null) {
      rowChildren.add(primaryAction);
    }

    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowChildren,
      ),
    );
  }

  Widget buildContentRoundBorder(BuildContext context) {
    return Container(
      height: lerpDouble(contentBorderHeight, 0, scrollProgress),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    );
  }

  Widget buildSecondaryActions() {
    final actions = secondaryActions;
    if (actions != null && actions.isNotEmpty) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: (scrollProgress > 0.2) ? 0 : 1,
        child: Container(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
