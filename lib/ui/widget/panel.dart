import 'package:flutter/material.dart';

import '../../theme/spacings.dart';
import 'close_circle_button.dart';

class Panel extends StatelessWidget {
  final Widget child;
  final String? title;

  const Panel({Key? key,
    required this.child,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(Spacings.four),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const CloseCircleButton(),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
