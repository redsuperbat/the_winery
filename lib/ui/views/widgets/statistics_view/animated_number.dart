import 'package:flutter/material.dart';

class AnimatedNumber extends StatefulWidget {
  final int number;

  AnimatedNumber({this.number});

  @override
  _AnimatedNumberState createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber>
    with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<int> _animation;

  @override
  void dispose() {
    print("disposing animated number");
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = StepTween(begin: 0, end: widget.number)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.number);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) =>  Text(
        _animation.value > 999999
            ? (_animation.value / 1000000).toStringAsFixed(1) + 'M'
            : _animation.value > 99999
                ? (_animation.value / 1000).toStringAsFixed(0) + 'K'
                : _animation.value > 999
                    ? (_animation.value / 1000).toStringAsFixed(1) + 'K'
                    : '${_animation.value}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }
}
