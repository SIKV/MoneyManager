import 'package:flutter/material.dart';
import 'package:moneymanager/theme/radius.dart';
import 'package:moneymanager/theme/spacings.dart';

class PropertyItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onSelected;

  const PropertyItem({
    Key? key,
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Theme.of(context).colorScheme.primary : Colors.black26;

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
