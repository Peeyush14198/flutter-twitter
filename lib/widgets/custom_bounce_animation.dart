import 'package:flutter/material.dart';

class CustomBounceButtonAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  CustomBounceButtonAnimation({this.child, this.onTap});
  @override
  _CustomBounceButtonAnimationState createState() =>
      _CustomBounceButtonAnimationState();
}

class _CustomBounceButtonAnimationState
    extends State<CustomBounceButtonAnimation> with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void onTapDown(TapDownDetails details) {
    animationController.forward();
  }

  void onTapUp(TapUpDetails details) {
    animationController.reverse();
  }

  void onTap() {
    animationController.forward().then((f) {
      animationController.reverse();
       widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      child: Transform.scale(
        scale: 1 - animationController.value,
        child: widget.child,
      ),
    );
  }
}
