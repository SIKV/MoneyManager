import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/ui/widget/header_circle_button.dart';

import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';

// TODO: Make title auto-resizable.

Duration _titleAnimationDuration = const Duration(milliseconds: 1500);

class CollapsingHeaderPage extends ConsumerWidget {
  final AppColors colors;
  final Color startColor;
  final Color endColor;
  final double collapsedHeight;
  final double expandedHeight;
  final String? titlePrefix;
  final String title;
  final double? rawTitle; // Use this field to show title with animation.
  final String? titleSuffix;
  final String? subtitle;
  final String? tertiaryTitle;
  final VoidCallback? onTitlePressed;
  final Widget? primaryAction;
  final List<HeaderCircleButton>? secondaryActions;
  final ScrollPhysics? physics;
  final Widget sliver;

  const CollapsingHeaderPage({
    super.key,
    required this.colors,
    required this.startColor,
    required this.endColor,
    required this.collapsedHeight,
    required this.expandedHeight,
    this.titlePrefix,
    required this.title,
    this.rawTitle,
    this.titleSuffix,
    this.subtitle,
    this.tertiaryTitle,
    this.onTitlePressed,
    this.primaryAction,
    this.secondaryActions,
    this.physics,
    required this.sliver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return Material(
      child: CustomScrollView(
        physics: physics,
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
              rawTitle: rawTitle,
              titleSuffix: titleSuffix,
              subtitle: subtitle,
              tertiaryTitle: tertiaryTitle,
              onTitlePressed: onTitlePressed,
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
  final double? rawTitle;
  final String? titleSuffix;
  final String? subtitle;
  final String? tertiaryTitle;
  final VoidCallback? onTitlePressed;
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
    this.rawTitle,
    this.titleSuffix,
    this.subtitle,
    this.tertiaryTitle,
    this.onTitlePressed,
    this.primaryAction,
    this.secondaryActions,
  });

  final double contentBorderHeight = 16;
  double paddingTop = 0;
  double scrollProgress = 0;

  // Without it a pinned header stays glued to the top edge while the content
  // below it rubber-bands away. With it the header grows by the over-scroll.
  @override
  final OverScrollHeaderStretchConfiguration stretchConfiguration =
      OverScrollHeaderStretchConfiguration();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    paddingTop = MediaQuery.of(context).padding.top;

    final scrollProgress = shrinkOffset / (maxExtent - minExtent);
    this.scrollProgress = (scrollProgress > 1.0) ? 1.0 : scrollProgress;

    // The header is only rebuilt when it collapses, but it is laid out again on
    // every over-scroll, so the stretch can only be measured here.
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = max(minExtent, maxExtent - shrinkOffset);
        final stretch = max(0.0, constraints.maxHeight - height);

        return Stack(
          children: [
            // This is needed to remove a horizontal line between CollapsingHeaderContent and its content.
            // Filling the whole header, so that it keeps its color when stretched.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 1,
              child: Container(color: startColor),
            ),
            // This is needed to remove a horizontal line between CollapsingHeaderContent and its content.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 1,
              child: buildGradient(),
            ),
            // The rest of the header is aligned to the bottom, so the stretch
            // moves it on its own. This one has to follow the over-scroll too.
            Transform.translate(
              offset: Offset(0, stretch),
              child: Container(
                padding: EdgeInsets.only(top: paddingTop),
                child: buildHeader(),
              ),
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
      },
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

    final titleActionPaddings = EdgeInsets.lerp(
        const EdgeInsets.only(left: 4, top: 9),
        const EdgeInsets.only(left: 4, top: 4),
        scrollProgress
    );

    final List<Widget> children = [
      InkWell(
        onTap: () {
          onTitlePressed?.call();
        },
        child: Row(
          children: [
            buildTitle(),
            if (onTitlePressed != null) ...[
              Padding(
                padding: titleActionPaddings ?? const EdgeInsets.only(),
                child: Icon(Icons.arrow_drop_down,
                  color: colors.alwaysWhite,
                ),
              ),
            ],
          ],
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

  Widget buildTitle() {
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
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        scrollProgress
    );

    final rawTitle = this.rawTitle;

    if (rawTitle == null) {
      return buildTitleText(title, titleTextStyle, titleSuffixTextStyle);
    }

    final titleInt = rawTitle.toInt();

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: rawTitle),
      duration: _titleAnimationDuration,
      builder: (context, value, child) {
        final valueInt = value.toInt();

        return buildTitleText(valueInt == titleInt ? title : '$valueInt',
          titleTextStyle,
          titleSuffixTextStyle,
        );
      },
    );
  }

  Widget buildTitleText(String title, TextStyle? titleTextStyle,
      TextStyle? titleSuffixTextStyle) {
    return RichText(
      text: TextSpan(
        children: [
          if (titlePrefix != null) TextSpan(
            text: titlePrefix,
            style: titleTextStyle,
          ),

          TextSpan(
            text: title,
            style: titleTextStyle,
          ),

          if (titleSuffix != null) TextSpan(
            text: titleSuffix,
            style: titleSuffixTextStyle,
          ),
        ],
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
      final double opacity = 1 - scrollProgress;
      return Opacity(
        opacity: opacity,
        child: Visibility(
          visible: opacity > 0.4,
          child: Container(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
