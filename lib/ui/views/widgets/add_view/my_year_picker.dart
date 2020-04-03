import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MyYearPicker extends StatefulWidget {
  final int selectedYear;
  final int firstYear;
  final int lastYear;
  final ValueChanged<int> onChanged;
  final Stream wineStream;

  MyYearPicker(
      {@required this.selectedYear,
      @required this.onChanged,
      @required this.firstYear,
      @required this.lastYear,
      this.wineStream});

  @override
  _MyYearPickerState createState() => _MyYearPickerState();
}

class _MyYearPickerState extends State<MyYearPicker> {
  double _position;
  double otherPosition = 0;
  ScrollController scrollController;
  StreamSubscription _sub;
  int selectedYear;
  static const _itemExtent = 50.0;

  @override
  void initState() {
    _position = (widget.selectedYear - widget.firstYear - 0.5) * _itemExtent;
    scrollController = ScrollController(
      initialScrollOffset:
          (widget.selectedYear - widget.firstYear - 0.5) * _itemExtent,
    );
    selectedYear = widget.selectedYear;
    _sub = widget.wineStream.listen((w) {
      selectedYear = w.vintage;
      autoScroll();
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void listener() {
    if ((_position - 24) > scrollController.position.pixels ||
        (_position + 24) < scrollController.position.pixels) {
      setState(() {
        _position = scrollController.position.pixels;
      });
    }
  }

  void autoScroll() {
    if (scrollController.hasClients) {
      for (int i = 0; i < (widget.lastYear - widget.firstYear + 1); i++) {
        final int year = widget.firstYear + i;
        if (year == selectedYear) {
          _position = (i - 0.5) * _itemExtent;
          otherPosition = _position;
          scrollController.jumpTo(_position);
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _itemCount = widget.lastYear - widget.firstYear + 1;
    return NotificationListener(
      onNotification: (n) {
        if (n is ScrollUpdateNotification) {
          listener();
        }
        if (n is ScrollEndNotification &&
            _position.floor() != otherPosition.floor()) {
          autoScroll();
        }
        return true;
      },
      child: ListView.builder(
        dragStartBehavior: DragStartBehavior.start,
        controller: scrollController,
        itemExtent: _itemExtent,
        itemCount: _itemCount,
        itemBuilder: (context, index) {
          final int year = widget.firstYear + index;
          final double position = (index * _itemExtent) - 25;
          final bool isSelected =
              (position > _position - 25 && position < _position + 25);
          final TextStyle itemStyle = isSelected
              ? TextStyle(fontSize: 25, color: Colors.red)
              : TextStyle(fontSize: 20, color: Colors.black54);
          if (isSelected) {
            selectedYear = year;
            widget.onChanged(year);
          }
          return Center(
            child: Semantics(
              selected: isSelected,
              child: Container(
                child: Text('$year', style: itemStyle),
              ),
            ),
          );
        },
      ),
    );
  }
}
