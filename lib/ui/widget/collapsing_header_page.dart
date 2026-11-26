import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';

Duration _titleAnimationDuration = const Duration(milliseconds: 1500);

class CollapsingHeaderPage extends ConsumerWidget {
  final AppColors colors;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget leadingWidget;
  final String title;
  final double? rawTitle; // Use this field to show title with animation.
  final String titleSuffix;
  final String upperTitle;
  final String subTitle;
  final List<Widget> actions;
  final ScrollPhysics? physics;
  final Widget sliver;

  const CollapsingHeaderPage({
    super.key,
    required this.colors,
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.leadingWidget,
    required this.title,
    this.rawTitle,
    required this.titleSuffix,
    required this.upperTitle,
    required this.subTitle,
    required this.actions,
    this.physics,
    required this.sliver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          // Never stop halfway. Snap it to fully open or fully closed when scrolling ends
          final range = expandedHeight - collapsedHeight;
          final offset = notification.metrics.pixels;
          if (notification.depth == 0 && offset > 0 && offset < range) {
            final target = offset < range / 2 ? 0.0 : range;
            // Let the finished scroll activity wrap up before starting a new one.
            Future.microtask(() => Scrollable.of(notification.context!).position
                .animateTo(target,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut));
          }
          return false; // Keep bubbling, so PullToActivate still gets notifications.
        },
        child: CustomScrollView(
          physics: physics,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _HeaderDelegate(
                colors: appTheme.colors,
                paddingTop: MediaQuery.paddingOf(context).top,
                expandedHeight: expandedHeight,
                collapsedHeight: collapsedHeight,
                leadingWidget: leadingWidget,
                title: title,
                rawTitle: rawTitle,
                titleSuffix: titleSuffix,
                upperTitle: upperTitle,
                subTitle: subTitle,
                actions: actions,
              ),
            ),
            sliver,
            // A short list can't scroll far enough to collapse the header, so the header
            // gets stuck halfway. This pads the list until the header can collapse fully.
            // Long lists get no padding. The snap in onNotification needs this too:
            // otherwise it can't reach the collapsed state and keeps retrying.
            SliverLayoutBuilder(
              builder: (context, constraints) {
                final collapseRange = expandedHeight - collapsedHeight;
                final missing = constraints.viewportMainAxisExtent
                    + collapseRange
                    - constraints.precedingScrollExtent;
                return SliverToBoxAdapter(
                  child: SizedBox(height: max(0, missing)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final AppColors colors;
  final double paddingTop;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget leadingWidget;
  final String title;
  final double? rawTitle;
  final String titleSuffix;
  final String upperTitle;
  final String subTitle;
  final List<Widget> actions;

  _HeaderDelegate({
    required this.colors,
    required this.paddingTop,
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.leadingWidget,
    required this.title,
    this.rawTitle,
    required this.titleSuffix,
    required this.upperTitle,
    required this.subTitle,
    required this.actions,
  });

  final double contentBorderHeight = 16;
  double scrollProgress = 0;

  // Without it a pinned header stays glued to the top edge while the content
  // below it rubber-bands away. With it the header grows by the over-scroll.
  @override
  final OverScrollHeaderStretchConfiguration stretchConfiguration =
      OverScrollHeaderStretchConfiguration();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
              child: Container(color: Theme.of(context).primaryColor),
            ),
            // This is needed to remove a horizontal line between CollapsingHeaderContent and its content.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 1,
              child: buildGradient(context),
            ),
            Positioned(
              top: stretch,
              left: 0,
              right: 0,
              // No bottom: the child gets unlimited height and keeps its natural size.
              child: Padding(
                padding: EdgeInsets.only(top: paddingTop),
                child: buildHeader(context),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
  double get maxExtent => paddingTop + expandedHeight;

  @override
  double get minExtent => paddingTop + collapsedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Widget buildGradient(BuildContext context) {
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
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final upperTitleTextStyle = TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 15,
    );

    final subTitleTextStyle = upperTitleTextStyle;

    final List<Widget> children = [
      Row(
        children: [
          leadingWidget,
          const Spacer(),
          ...actions
        ],
      ),

      const SizedBox(height: Spacings.four),

      Text(upperTitle,
        style: upperTitleTextStyle,
      ),

      buildTitle(context),

      Text(subTitle,
        style: subTitleTextStyle,
      )
    ];

    final padding = EdgeInsets.lerp(
      const EdgeInsets.only(left: 16, top: 16, right: 16),
      const EdgeInsets.only(left: 16, top: 16, right: 16),
      scrollProgress,
    ) ?? const EdgeInsets.all(0);


    final List<Widget> rowChildren = [
      // Bounds the title width, otherwise there is nothing to fit it into.
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      )
    ];

    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowChildren,
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    final titleTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 58,
      fontWeight: FontWeight.w900,
    );

    final titleSuffixTextStyle = titleTextStyle.copyWith(
        color: Theme.of(context).colorScheme.outline
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Measured against the final title, so that the count up animation
        // below runs at a single size instead of shrinking on its last frame.
        final scale = titleScale(context, constraints.maxWidth, titleTextStyle, titleSuffixTextStyle);

        final scaledTitleTextStyle = scaleTextStyle(titleTextStyle, scale);
        final scaledTitleSuffixTextStyle = scaleTextStyle(titleSuffixTextStyle, scale);

        final rawTitle = this.rawTitle;

        if (rawTitle == null) {
          return buildTitleText(title, scaledTitleTextStyle, titleSuffixTextStyle);
        }

        final titleInt = rawTitle.toInt();

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: rawTitle),
          duration: _titleAnimationDuration,
          builder: (context, value, child) {
            final valueInt = value.toInt();
            return buildTitleText(valueInt == titleInt ? title : '$valueInt', scaledTitleTextStyle, scaledTitleSuffixTextStyle);
          },
        );
      },
    );
  }

  /// How much the title has to be scaled down to fit into [maxWidth]. The
  /// prefix and the suffix are scaled by the same factor, so that the title
  /// keeps its proportions.
  double titleScale(BuildContext context, double maxWidth, TextStyle? titleTextStyle, TextStyle? titleSuffixTextStyle) {
    if (!maxWidth.isFinite || maxWidth <= 0) {
      return 1;
    }

    final textPainter = TextPainter(
      text: buildTitleSpan(title, titleSuffix, titleTextStyle, titleSuffixTextStyle),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();

    final width = textPainter.width;
    textPainter.dispose();

    if (width <= maxWidth || width == 0) {
      return 1;
    }

    return maxWidth / width;
  }

  TextStyle? scaleTextStyle(TextStyle? style, double scale) {
    final fontSize = style?.fontSize;
    if (style == null || fontSize == null || scale == 1) {
      return style;
    }
    return style.copyWith(fontSize: fontSize * scale);
  }

  Widget buildTitleText(String title, TextStyle? titleTextStyle, TextStyle? titleSuffixTextStyle) {
    return RichText(
      maxLines: 1,
      text: buildTitleSpan(title, titleSuffix, titleTextStyle, titleSuffixTextStyle),
    );
  }

  TextSpan buildTitleSpan(String title, String titleSuffix, TextStyle? titleTextStyle, TextStyle? titleSuffixTextStyle) {
    return TextSpan(
      children: [
        TextSpan(
          text: title,
          style: titleTextStyle,
        ),
        TextSpan(
          text: titleSuffix,
          style: titleSuffixTextStyle,
        ),
      ],
    );
  }

  Widget buildContentRoundBorder(BuildContext context) {
    return Container(
      height: lerpDouble(contentBorderHeight, 0, scrollProgress),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    );
  }
}
