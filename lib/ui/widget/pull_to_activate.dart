import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef PullIndicatorBuilder = Widget Function(
  BuildContext context,
  double progress, // From 0 to 1.
  bool armed,
);

/// Detects an over-scroll drag at the very top of [child]'s scroll view and
/// calls [onActivate] when the finger is released past [threshold].
///
/// The indicator built by [indicatorBuilder] is placed at the top center,
/// above [child].
class PullToActivate extends StatefulWidget {
  final double threshold;
  final VoidCallback onActivate;
  final PullIndicatorBuilder indicatorBuilder;
  final Widget child;

  const PullToActivate({
    super.key,
    this.threshold = 96,
    required this.onActivate,
    required this.indicatorBuilder,
    required this.child,
  });

  @override
  State<PullToActivate> createState() => _PullToActivateState();
}

class _PullToActivateState extends State<PullToActivate> {
  double _pull = 0;
  bool _armed = false;

  @override
  Widget build(BuildContext context) {
    final progress = (_pull / widget.threshold).clamp(0.0, 1.0);

    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: Stack(
        children: [
          widget.child,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SafeArea(
                bottom: false,
                child: widget.indicatorBuilder(context, progress, _armed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _onNotification(ScrollNotification notification) {
    // Ignore nested scrollables, e.g. modals shown on top of the page.
    if (notification.depth != 0) {
      return false;
    }

    if (notification is ScrollStartNotification) {
      _armed = false;
      return false;
    }

    // Fired the moment the finger leaves the screen. ScrollEndNotification is
    // too late: the list has already sprung back by then.
    if (notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        _armed) {
      _armed = false;
      HapticFeedback.selectionClick();
      widget.onActivate();
    }

    final metrics = notification.metrics;
    final pull = max(0.0, metrics.minScrollExtent - metrics.pixels);

    // Arm only while the user is dragging, so that pulling back below the
    // threshold cancels, and the spring back after the release doesn't disarm.
    final dragging = notification is ScrollUpdateNotification
        && notification.dragDetails != null;
    final armed = dragging ? pull >= widget.threshold : _armed;

    if (pull != _pull || armed != _armed) {
      if (armed && !_armed) {
        HapticFeedback.mediumImpact();
      }

      setState(() {
        _pull = pull;
        _armed = armed;
      });
    }

    return false;
  }
}
