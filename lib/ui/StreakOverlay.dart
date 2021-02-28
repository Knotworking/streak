import 'package:flutter/material.dart';
import 'package:streak/data/QuoteProvider.dart';
import 'package:streak/models/Quote.dart';
import 'package:streak/ui/animations/AnimateStreakItem.dart';
import 'package:streak/ui/animations/ShowUp.dart';

class StreakOverlay extends ModalRoute<void> {
  QuoteProvider quoteProvider = QuoteProvider();

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
    Quote quote = quoteProvider.random();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Center(
                  child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  child: AnimateStreakText(
                    child: Text(
                      "\"${quote.quote}\"",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                    delay: 500,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    child: AnimateStreakText(
                      child: Text(
                        "- ${quote.attribution}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      delay: 1000,
                    ),
                  ),
                ),
              ],
            ),
          ))),
          ShowUp(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: OutlineButton(
                onPressed: () => Navigator.pop(context),
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white),
                child: Text('${quote.continueLabel}'),
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
