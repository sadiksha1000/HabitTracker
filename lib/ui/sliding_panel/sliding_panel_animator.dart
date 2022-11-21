import 'package:flutter/material.dart';
import 'package:habit_tracker_flutter/ui/animations/animation_controller_state.dart';
import 'package:habit_tracker_flutter/ui/sliding_panel/sliding_panel.dart';

class SlidingPanelAnimator extends StatefulWidget {
  final SlideDirection direction;
  final Widget child;
  const SlidingPanelAnimator({
    Key? key,
    required this.child,
    required this.direction,
  }) : super(key: key);

  @override
  State<SlidingPanelAnimator> createState() =>
      SlidingPanelAnimatorState(Duration(milliseconds: 200));
}

class SlidingPanelAnimatorState
    extends AnimationControllerState<SlidingPanelAnimator> {
  SlidingPanelAnimatorState(Duration duration) : super(duration);

  late final _curveAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: animationController,
    curve: Curves.easeInOutCubic,
  ));

  void slideIn() {
    animationController.forward();
  }

  void slideOut() {
    animationController.reverse();
  }

  double _getOffsetX(double screenWidth, double animationValue) {
    final startOffSet = widget.direction == SlideDirection.rightToLeft
        ? screenWidth - SlidingPanel.leftPanelFixedWidth
        : -SlidingPanel.leftPanelFixedWidth;
    return startOffSet * (1.0 - animationValue);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curveAnimation,
      child: SlidingPanel(direction: widget.direction, child: widget.child),
      builder: (context, child) {
        final animationValue = animationController.value;
        if (animationValue == 0) {
          return Container();
        }
        final screenWidth = MediaQuery.of(context).size.width;
        final offSetX = _getOffsetX(screenWidth, animationValue);
        return Transform.translate(
          offset: Offset(offSetX, 0),
          child: child,
        );
      },
    );
  }
}
