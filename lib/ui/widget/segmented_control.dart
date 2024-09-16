import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme_manager.dart';

import '../../theme/theme.dart';

class SegmentedControl<T extends Object> extends ConsumerWidget {
  final Map<T, Widget> values;
  final T? selectedValue;
  final Function(T?) onSelectedValueChanged;

  const SegmentedControl({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.onSelectedValueChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeManager = ref.watch(appThemeManagerProvider);

    final Color thumbColor;
    final Color backgroundColor;

    switch (appThemeManager.type) {
      case AppThemeType.light:
        thumbColor = thumbColor = const CupertinoDynamicColor.withBrightness(
          color: Color(0xFFFFFFFF),
          darkColor: Color(0xFF636366),
        );
        backgroundColor = CupertinoColors.tertiarySystemFill;
        break;
      case AppThemeType.dark:
        thumbColor = thumbColor = CupertinoColors.secondarySystemFill;
        backgroundColor = CupertinoColors.darkBackgroundGray;
        break;
    }

    return CupertinoSlidingSegmentedControl<T>(
      thumbColor: thumbColor,
      backgroundColor: backgroundColor,
      groupValue: selectedValue,
      onValueChanged: (value) {
        onSelectedValueChanged(value);
      },
      children: values,
    );
  }
}
