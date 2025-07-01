import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/radius.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../../theme/theme_manager.dart';

class PropertyItem extends ConsumerWidget {
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback? onSelected;

  const PropertyItem({
    super.key,
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeManagerProvider);

    final borderColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : appTheme.colors.slightlyGray;

    final titleColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : (Theme.of(context).textTheme.bodySmall?.color ?? Colors.black);

    return InkWell(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.all(Spacings.four),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.one)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(title,
                style: TextStyle(
                  color: titleColor
                ),
              ),
            ),

            const SizedBox(width: Spacings.four),

            Expanded(
              flex: 2,
              child: Text(value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerPropertyItem extends ConsumerWidget {

  const ShimmerPropertyItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeManagerProvider);

    final borderColor = appTheme.colors.slightlyGray;

    return Container(
      padding: const EdgeInsets.all(Spacings.four),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.one)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(""),
          ),

          SizedBox(width: Spacings.four),

          Expanded(
            flex: 2,
            child: Text("",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
