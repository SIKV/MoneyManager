import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String asset;
  final double size;
  final Color? color;

  const SvgIcon(this.asset, {
    Key? key,
    this.size = 24,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(asset,
      width: size,
      height: size,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }
}
