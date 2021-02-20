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
                  child: Stack(
            children: [
              //Alignment widget?
              AnimateStreakText(
                child: "other text",
                // child: Text(
                //   'You did it!',
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 30.0,
                //       fontWeight: FontWeight.bold),
                // ),
                delay: 1000,
              ),
              AnimateStreakText(
                child: "well done",
                // child: Text(
                //   'Well Done!',
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 30.0,
                //       fontWeight: FontWeight.bold),
                // ),
                delay: 2000,
              ),
            ],
          ))),
          ShowUp(
            child: OutlineButton(
              onPressed: () => Navigator.pop(context),
              textColor: Colors.white,
              borderSide: BorderSide(color: Colors.white),
              child: Text('I know. I\'m great.'),
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
