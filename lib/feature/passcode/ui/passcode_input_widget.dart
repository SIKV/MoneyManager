import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/spacings.dart';
import '../../transaction/domain/amount_key.dart';
import '../../transaction/ui/common/fake_key.dart';
import '../../transaction/ui/common/key_container.dart';
import '../../transaction/ui/common/text_key.dart';

const int _errorAnimationMillis = 400;

class PasscodeInputWidget extends StatelessWidget {
  final String title;
  final int passcodeLength;
  final int numberOfEntered;
  final String? error;
  final Function(WidgetRef?, AmountKey) onTap;

  const PasscodeInputWidget({
    super.key,
    required this.title,
    required this.passcodeLength,
    required this.numberOfEntered,
    this.error,
    required this.onTap,
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

                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: Spacings.five),

                  _PasscodeRow(
                    passcodeLength: passcodeLength,
                    numberOfEntered: numberOfEntered,
                    showError: error != null,
                  ),

                  const SizedBox(height: Spacings.five),

                  AnimatedOpacity(
                    opacity: error == null ? 0 : 1,
                    duration: const Duration(milliseconds: _errorAnimationMillis),
                    child: Text(
                      error ?? "",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
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

class _PasscodeRow extends StatelessWidget {
  final int passcodeLength;
  final int numberOfEntered;
  final bool showError;

  const _PasscodeRow({
    required this.passcodeLength,
    required this.numberOfEntered,
    required this.showError,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      key: ValueKey(showError),
      tween: Tween(begin: 0.0, end: showError ? 1.0 : 0.0),
      duration: const Duration(milliseconds: _errorAnimationMillis),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(sin(value * pi * 6) * 10, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(passcodeLength, (index) =>
            Container(
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
    );
  }
}
