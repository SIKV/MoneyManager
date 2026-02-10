import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/amount_key.dart';
import 'key_container.dart';

class TextKey extends ConsumerWidget {
  final bool isAction;
  final AmountKey amountKey;
  final Function(WidgetRef, AmountKey) onTap;

  const TextKey({
    super.key,
    this.isAction = false,
    required this.amountKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyContainer(
      isAction: isAction,
      onTap: () => onTap(ref, amountKey),
      child: Center(
        child: Text(amountKey.char,
          style: TextStyle(
            fontSize: 28,
            fontWeight: isAction ? FontWeight.w300 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
