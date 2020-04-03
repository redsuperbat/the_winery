import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ImageView extends StatefulWidget {
  final String path;

  const ImageView(this.path);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  File image;
  double _zoom;
  double _previousZoom;
  Offset _scrollOffset;
  Offset _previousScrollOffset;

  @override
  void initState() {
    image = File(widget.path);
    _zoom = 1.0;
    _previousZoom = null;
    _scrollOffset = Offset.zero;
    _previousScrollOffset = Offset.zero;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "image",
      child: Scaffold(
        backgroundColor: Colors.black,
        body:  GestureDetector(
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            onScaleEnd: _handleScaleEnd,
            onDoubleTap: _handleDoubleTap,
            child: Center(
              child: Transform(
                transform:
                    Matrix4.diagonal3(vector.Vector3(_zoom, _zoom, _zoom))
                      ..translate(_scrollOffset.dx, _scrollOffset.dy),
                alignment: AlignmentDirectional.center,
                child: Image.file(
                  image,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
        ),
      ),
    );
  }

  void _handleDoubleTap() {
    setState(() {
      _zoom = _zoom >= 1.5 ? 1.0 : 2.0;
    });
  }

  void _handleScaleEnd(ScaleEndDetails end) {
    if (_zoom < 1.0) {
      setState(() {
        _zoom = 1.0;
        _scrollOffset = Offset.zero;
      });
    }
  }

  void _handleScaleStart(ScaleStartDetails start) {
    setState(() {
      _previousZoom = _zoom;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails update) {
    Offset _position = _previousScrollOffset-update.focalPoint;
    _previousScrollOffset = update.focalPoint;
    setState(() {
      if(_zoom >1 && _position.distance < 20){
        _scrollOffset -= _position;
      }
      _zoom = _previousZoom * update.scale;
    });
  }
}
