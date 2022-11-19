import 'package:flutter/material.dart';

import '../theme/spacings.dart';

class CloseCircleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CloseCircleButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(Spacings.two),
        color: Colors.grey.shade200,
        child: InkWell(
          splashColor: Colors.grey,
          onTap: onPressed,
          child: const Icon(Icons.close),
        ),
      ),
    );
  }
}
