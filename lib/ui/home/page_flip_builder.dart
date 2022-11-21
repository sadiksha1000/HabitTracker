import 'dart:math';

import 'package:flutter/material.dart';

class PageFlipBuilder extends StatefulWidget {
  final WidgetBuilder frontBuilder;
  final WidgetBuilder backBuilder;
  const PageFlipBuilder({
    Key? key,
    required this.frontBuilder,
    required this.backBuilder,
  }) : super(key: key);

  @override
  State<PageFlipBuilder> createState() => PageFlipBuilderState();
}

class PageFlipBuilderState extends State<PageFlipBuilder>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  bool _showFrontSide = true;

  @override
  void initState() {
    _controller.addStatusListener(_updateStatus);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_updateStatus);
    _controller.dispose();
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      setState(() {
        _showFrontSide = !_showFrontSide;
      });
    }
  }

  void flip() {
    if (_showFrontSide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPageFlipBuilder(
      frontBuilder: widget.frontBuilder,
      backBuilder: widget.backBuilder,
      animation: _controller,
      showFrontSide: _showFrontSide,
    );
  }
}

class AnimatedPageFlipBuilder extends AnimatedWidget {
  final bool showFrontSide;
  final WidgetBuilder frontBuilder;
  final WidgetBuilder backBuilder;

  const AnimatedPageFlipBuilder({
    Key? key,
    required this.frontBuilder,
    required this.backBuilder,
    required Animation<double> animation,
    required this.showFrontSide,
  }) : super(key: key, listenable: animation);

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    // Animation value ranges between 0 and 1 0-0.5=frontSide 0.5-1=backside
    final isAnimationfirstHalf = animation.value < 0.5;
    // decide which page do we need to show
    final child =
        isAnimationfirstHalf ? frontBuilder(context) : backBuilder(context);
    // map values between [0,1] to values between [0,pi]
    final rotationValue = animation.value * pi;
    // calculate the cirrect rotation angle depdending on the side we need to show
    final rotationAngle =
        animation.value > 0.5 ? pi - rotationValue : rotationValue;
    var tilt = (animation.value - 0.5).abs() - 0.5;
    tilt *= isAnimationfirstHalf ? -0.003 : 0.003;
    return Transform(
      transform: Matrix4.rotationX(rotationAngle)..setEntry(3, 0, tilt),
      child: child,
      alignment: Alignment.center,
    );
  }
}
