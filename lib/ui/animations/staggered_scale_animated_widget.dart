import 'package:flutter/material.dart';

class StaggeredScaleTransition extends StatelessWidget {
  StaggeredScaleTransition({
    Key? key,
    required Animation<double> animation,
    required int index,
    required this.child,
  })  : scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.1 * index,
              0.5 + 0.1 * index,
              curve: Curves.easeInOutCubic,
            ),
          ),
        ),
        super(
          key: key,
        );
  final Widget child;
  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      alignment: Alignment.center,
      child: child,
    );
  }
}
