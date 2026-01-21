import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/spacings.dart';
import '../../transaction/domain/amount_key.dart';
import '../../transaction/ui/common/fake_key.dart';
import '../../transaction/ui/common/key_container.dart';
import '../../transaction/ui/common/text_key.dart';

class PasscodeInputWidget extends StatelessWidget {
  final Function(WidgetRef?, AmountKey) onTap;
  final String title;
  final int passcodeLength;
  final int numberOfEntered;

  const PasscodeInputWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.passcodeLength,
    required this.numberOfEntered,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: Spacings.four),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: Spacings.seven),

                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 64,
                  ),

                  const SizedBox(height: Spacings.five),

                  Text(title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: Spacings.five),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(passcodeLength, (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: Spacings.two),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < numberOfEntered ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
                        border: Border.all(
                            width: 1.5,
                            color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /**
                   * [1] [2] [3]
                   */
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextKey(amountKey: AmountKey.one, onTap: onTap),
                        TextKey(amountKey: AmountKey.two, onTap: onTap),
                        TextKey(amountKey: AmountKey.three, onTap: onTap),
                      ],
                    ),
                  ),
                  /**
                   * [4] [5] [6]
                   */
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextKey(amountKey: AmountKey.four, onTap: onTap),
                        TextKey(amountKey: AmountKey.five, onTap: onTap),
                        TextKey(amountKey: AmountKey.six, onTap: onTap),
                      ],
                    ),
                  ),
                  /**
                   * [7] [8] [9]
                   */
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextKey(amountKey: AmountKey.seven, onTap: onTap),
                        TextKey(amountKey: AmountKey.eight, onTap: onTap),
                        TextKey(amountKey: AmountKey.nine, onTap: onTap),
                      ],
                    ),
                  ),
                  /**
                   * [0] [Backspace]
                   */
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const FakeKey(),
                        TextKey(amountKey: AmountKey.zero, onTap: onTap),
                        KeyContainer(
                          isAction: true,
                          onTap: () => onTap(null, AmountKey.backspace),
                          child: const Center(
                            child: Icon(Icons.backspace_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
