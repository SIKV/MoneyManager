import 'package:flutter/material.dart';
import 'package:moneymanager/theme/radius.dart';
import 'package:moneymanager/theme/spacings.dart';

class NoItems extends StatelessWidget {
  final String title;

  const NoItems({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacings.three),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.two),
      ),
      child: Text(title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
