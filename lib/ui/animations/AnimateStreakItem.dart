import 'dart:async';
import 'package:flutter/material.dart';

class AnimateStreakText extends StatefulWidget {
  final Text child;
  final int delay;

  AnimateStreakText({@required this.child, this.delay});

  @override
  _AnimateStreakTextState createState() => _AnimateStreakTextState();
}

class _AnimateStreakTextState extends State<AnimateStreakText>
    with TickerProviderStateMixin {
  AnimationController _movementAnimController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _movementAnimController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 700));
    final curve = CurvedAnimation(
        curve: Curves.decelerate, parent: _movementAnimController);

    _animOffset =
        Tween<Offset>(begin: new Offset(0, -0.5), end: Offset.zero)
            .animate(curve);

    if (widget.delay == null) {
      _movementAnimController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _movementAnimController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _movementAnimController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
          position: _animOffset,
          child: widget.child),
      opacity: _movementAnimController,
    );
  }
}
