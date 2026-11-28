import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../theme/radius.dart';
import '../../../theme/spacings.dart';
import '../../../ui/widget/SvgIcon.dart';
import '../../../ui/widget/bouncing.dart';

const double _barHeight = 64;

class GlassNavigationDestination {
  final String icon;
  final String selectedIcon;
  final String label;

  const GlassNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// A floating, translucent tab bar in the style of iOS 26, with a separate
/// round action button on its right. Use it with [Scaffold.extendBody], so
/// that the page content scrolls under the glass.
class GlassNavigationBar extends StatelessWidget {
  final List<GlassNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget actionIcon;
  final String actionLabel;
  final VoidCallback onActionPressed;

  const GlassNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.actionIcon,
    required this.actionLabel,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: Spacings.four),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacings.five),
        child: SizedBox(
          height: _barHeight,
          child: Row(
            children: [
              Expanded(
                child: _Glass(
                  tint: colorScheme.surface,
                  child: _Destinations(
                    destinations: destinations,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                  ),
                ),
              ),
              const SizedBox(width: Spacings.three),
              Semantics(
                button: true,
                label: actionLabel,
                child: Bouncing(
                  onTap: onActionPressed,
                  child: SizedBox.square(
                    dimension: _barHeight,
                    child: _Glass(
                      tint: colorScheme.surface,
                      child: IconTheme(
                        data: IconThemeData(color: colorScheme.onSurface),
                        child: actionIcon,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destinations extends StatelessWidget {
  final List<GlassNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _Destinations({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(Spacings.one),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // The highlight behind the selected icon. It slides to the new tab.
          AnimatedAlign(
            alignment: Alignment(-1 + 2 * selectedIndex / (destinations.length - 1), 0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: FractionallySizedBox(
              widthFactor: 1 / destinations.length,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < destinations.length; index++)
                Expanded(
                  child: _buildDestination(colorScheme, destinations[index], index),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestination(ColorScheme colorScheme, GlassNavigationDestination destination, int index) {
    final selected = index == selectedIndex;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onDestinationSelected(index),
        child: Center(
          child: SvgIcon(
            selected ? destination.selectedIcon : destination.icon,
            color: selected ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Blurs whatever is behind it and tints it with [tint]. The thin edge and the
/// soft shadow make it read as a sheet of glass on both light and dark pages.
class _Glass extends StatelessWidget {
  final Color tint;
  final Widget child;

  const _Glass({
    required this.tint,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const borderRadius = BorderRadius.all(Radius.circular(AppRadius.five));

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              // Slightly more opaque at the top, where light catches the glass.
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  tint.withValues(alpha: 0.75),
                  tint.withValues(alpha: 0.55),
                ],
              ),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.12),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
