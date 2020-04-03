import 'package:flutter/material.dart';

class WineSlider extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const WineSlider(
      {Key key, this.title = "", this.color = Colors.white, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: color,
      child: Container(
        width: MediaQuery.of(context).size.width*0.25,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: child,
            ),
            Spacer(),
            Flexible(
              flex: 2,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
