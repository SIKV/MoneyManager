import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/radius.dart';

import '../../theme/colors.dart';
import '../../theme/spacings.dart';
import '../../theme/theme.dart';

class HeaderContentPage extends ConsumerWidget {
  final Color headerColor;

  final String primaryTitle;
  final String primarySubtitle;

  final String? secondaryTitle;
  final String? secondarySubtitle;

  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  final Widget content;
  final Radius contentBorderRadius;

  const HeaderContentPage({
    Key? key,
    required this.headerColor,
    required this.primaryTitle,
    required this.primarySubtitle,
    this.secondaryTitle,
    this.secondarySubtitle,
    this.actionIcon,
    this.onActionPressed,
    required this.content,
    this.contentBorderRadius = AppRadius.bigger,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return ColoredBox(
      color: headerColor,
      child: Column(
        children: [
          _header(context, appTheme.colors),
          _content(appTheme.colors),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, AppColors colors) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery
            .of(context)
            .padding
            .top + 36,
        left: 24,
        right: 24,
        bottom: 36,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(primaryTitle,
                style: TextStyle(
                  color: colors.colorScheme.onPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(primarySubtitle,
                style: TextStyle(
                  color: colors.colorScheme.onPrimary.withAlpha(200),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          _actionButton(colors),
        ],
      ),
    );
  }

  Widget _actionButton(AppColors colors) {
    if (actionIcon != null) {
      return ElevatedButton(
        onPressed: onActionPressed,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(Spacings.three),
          backgroundColor: colors.colorScheme.onPrimary,
          foregroundColor: headerColor,
        ),
        child: Icon(actionIcon,
          color: colors.colorScheme.primary,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _content(AppColors colors) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: contentBorderRadius,
            topRight: contentBorderRadius,
          ),
        ),
        child: content,
      ),
    );
  }
}
