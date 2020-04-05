import 'dart:io';

import 'package:flutter/material.dart';

class WineImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const WineImage({Key key, this.url, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "image",
      child: url == null
          ? Container(
              width: width,
              height: height,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.image,
                      size: height * 0.8,
                      color: Colors.grey,
                    ),
                    Text("No image"),
                  ],
                ),
              ),
            )
          : GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'image', arguments: url),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  height: height,
                  width: width,
                ),
              ),
            ),
    );
  }
}
