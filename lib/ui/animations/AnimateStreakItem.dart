import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimateStreakText extends StatefulWidget {
  final String child;
  final int delay;

  AnimateStreakText({@required this.child, this.delay});

  @override
  _AnimateStreakTextState createState() => _AnimateStreakTextState();
}

class _AnimateStreakTextState extends State<AnimateStreakText>
    with TickerProviderStateMixin {
  AnimationController _movementAnimController;
  Animation<Offset> _animOffset;
  Animation<TextStyle> _animText;
  AnimationController _opacityAnimController;

  @override
  void initState() {
    super.initState();

    _movementAnimController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    final curve = CurvedAnimation(
        curve: Curves.decelerate, parent: _movementAnimController);

    _opacityAnimController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    final opacityCurve = CurvedAnimation(
        curve: Curves.easeInOut, parent: _opacityAnimController);

    var random = new Random();
    var endY = random.nextDouble() * -5;

    _animOffset =
        Tween<Offset>(begin: new Offset(0, 5), end: new Offset(0, endY))
            .animate(curve);

    _animText = TextStyleTween(
            begin: TextStyle(
                fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
            end: TextStyle(
                fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold))
        .animate(curve);

    _animText.addListener(() {
      setState(() {});
    });

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
          child: Text(widget.child, style: _animText.value)),
      opacity: _movementAnimController,
    );
  }
}
