import 'package:flutter/material.dart';
import 'package:moneymanager/feature/transaction/ui/common/text_key.dart';

import '../../domain/amount_key.dart';

class FakeKey extends StatelessWidget {
  const FakeKey({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0,
      child: TextKey(amountKey: AmountKey.zero, onTap: (_, __) { }),
    );
  }
}
