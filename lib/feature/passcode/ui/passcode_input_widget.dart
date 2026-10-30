import 'dart:math';

import 'package:flutter/material.dart';

import '../../../theme/spacings.dart';
import '../../calculator/domain/amount_key.dart';

const int _errorAnimationMillis = 400;
const double _keySize = 76;

class PasscodeInputWidget extends StatelessWidget {
  final String title;
  final int passcodeLength;
  final int numberOfEntered;
  final String? error;
  final ValueChanged<AmountKey> onTap;

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: Spacings.six),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FittedBox( // Shrink the header on short screens.
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primaryContainer,
                          ),
                          child: Icon(
                            Icons.lock_rounded,
                            size: 32,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),

                        const SizedBox(height: Spacings.five),

                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),

                        const SizedBox(height: Spacings.five),

                        _PasscodeRow(
                          passcodeLength: passcodeLength,
                          numberOfEntered: numberOfEntered,
                          showError: error != null,
                        ),

                        const SizedBox(height: Spacings.four),

                        AnimatedOpacity(
                          opacity: error == null ? 0 : 1,
                          duration: const Duration(milliseconds: _errorAnimationMillis),
                          child: Text(
                            error ?? "",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              _Keypad(onTap: onTap),
            ],
          ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final dotColor = showError ? colorScheme.error : colorScheme.primary;

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
        mainAxisSize: MainAxisSize.min,
        children: List.generate(passcodeLength, (index) =>
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: Spacings.three),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < numberOfEntered ? dotColor : Colors.transparent,
                border: Border.all(
                  width: 1.5,
                  color: dotColor,
                ),
              ),
            ),
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<AmountKey> onTap;

  const _Keypad({required this.onTap});

  static const _rows = [
    [AmountKey.one, AmountKey.two, AmountKey.three],
    [AmountKey.four, AmountKey.five, AmountKey.six],
    [AmountKey.seven, AmountKey.eight, AmountKey.nine],
    [null, AmountKey.zero, AmountKey.backspace],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _rows.map((row) =>
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacings.two),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: row.map((key) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacings.three),
                    child: key == null
                        ? const SizedBox.square(dimension: _keySize)
                        : _Key(amountKey: key, onTap: () => onTap(key)),
                  ),
              ).toList(),
            ),
          ),
      ).toList(),
    );
  }
}

class _Key extends StatelessWidget {
  final AmountKey amountKey;
  final VoidCallback onTap;

  const _Key({
    required this.amountKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBackspace = amountKey == AmountKey.backspace;

    return SizedBox.square(
      dimension: _keySize,
      child: Material(
        color: isBackspace
            ? Colors.transparent
            : colorScheme.secondaryContainer.withValues(alpha: 0.5),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: isBackspace
                ? Icon(Icons.backspace_outlined, color: colorScheme.onSurface)
                : Text(
                    amountKey.char,
                    style: TextStyle(
                      fontSize: 30,
                      color: colorScheme.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
