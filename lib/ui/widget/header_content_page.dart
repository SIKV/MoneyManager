import 'package:flutter/material.dart';

import '../../theme/spacings.dart';

class HeaderContentPage extends StatelessWidget {
  final Color headerColor;

  final String primaryTitle;
  final String primarySubtitle;

  final String? secondaryTitle;
  final String? secondarySubtitle;

  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  final Widget content;
  final double contentBorderRadius;

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
    this.contentBorderRadius = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: headerColor,
      child: Column(
        children: [
          _header(context),
          _content(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
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
                  style: const TextStyle( // TODO Use theme style.
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  )
              ),
              const SizedBox(
                height: 2,
              ),
              Text(primarySubtitle,
                style: TextStyle( // TODO Use theme style.
                  color: Colors.black.withAlpha(140),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          _actionButton(),
        ],
      ),
    );
  }

  Widget _actionButton() {
    if (actionIcon != null) {
      return ElevatedButton(
        onPressed: onActionPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(Spacings.three),
          backgroundColor: Colors.white,
          foregroundColor: headerColor,
        ),
        child: Icon(actionIcon,
          color: Colors.black,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _content(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor, // TODO Use theme color.
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(contentBorderRadius),
            topRight: Radius.circular(contentBorderRadius),
          ),
        ),
        child: content,
      ),
    );
  }
}
