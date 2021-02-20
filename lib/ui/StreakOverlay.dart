import 'package:flutter/material.dart';
import 'package:streak/ui/animations/AnimateStreakItem.dart';
import 'package:streak/ui/animations/ShowUp.dart';

class StreakOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.7);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Alignment widget?
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimateStreakText(
                  child: "other text",
                  delay: 500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimateStreakText(
                  child: "well done",
                  delay: 1000,
                ),
              ),
            ],
          ))),
          ShowUp(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: OutlineButton(
                onPressed: () => Navigator.pop(context),
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white),
                child: Text('I know. I\'m great.'),
              ),
            ),
            delay: 1500,
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
