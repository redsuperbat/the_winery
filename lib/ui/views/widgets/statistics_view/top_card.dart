import 'package:flutter/material.dart';
import 'package:wine_cellar/core/viewmodels/views/statistics_model.dart';

import 'animated_number.dart';

class TopCard extends StatelessWidget {
  final StatisticsModel model;

  TopCard({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6, right: 6, left: 6, bottom: 15),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.red[800],
                    Colors.red[600],
                    Colors.red[500],
                    Colors.red
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    "Cellar statistics",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      TopCardCircles(
                        top: Image.asset(
                          'assets/wines/wine_bottle_icon.png',
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        middle: model.totalWines,
                        bottom: "Bottles in\ncellar",
                      ),
                      TopCardCircles(
                        top: Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.07,
                        ),
                        middle: model.cellarWorth.toInt(),
                        bottom: "Cellar net\nworth",
                        extra: model.currency,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.grey, offset: Offset(0, 1))
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.red[400],
                    Colors.red[300],
                    Colors.red[200],
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopCardCircles extends StatelessWidget {
  final Widget top;
  final int middle;
  final String extra;
  final String bottom;

  TopCardCircles({this.top, this.middle, this.bottom, this.extra});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.height * 0.18;
    return Expanded(
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.white),
         /*   gradient: LinearGradient(
              colors: [accentColor, mainColor],
              stops: [0.1,0.8],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),*/
            borderRadius: BorderRadius.circular(150),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              top,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedNumber(
                    number: middle,
                  ),
                  Text(
                    extra ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Text(
                  bottom,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
