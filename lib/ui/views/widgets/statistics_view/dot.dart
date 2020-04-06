import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final double dimensions;
  final Color color;
  final Color borderColor;

  Dot({this.dimensions, this.color, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(left: 5, right: 5),
      height: dimensions,
      width: dimensions,
      decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(dimensions)),
      duration: Duration(milliseconds: 250),
    );
  }
}
