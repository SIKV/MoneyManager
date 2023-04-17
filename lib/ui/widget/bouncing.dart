import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  const Bouncing({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final Widget child;

  @override
  BouncingState createState() => BouncingState();
}

class BouncingState extends State<Bouncing> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double _scale;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    )
      ..addListener(() => setState(() { }));
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController.value;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
