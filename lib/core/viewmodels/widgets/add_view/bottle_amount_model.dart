import 'dart:async';

import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/services/wine_service.dart';

import '../../base_model.dart';
import 'package:flutter/material.dart';

class BottleAmountModel extends BaseModel {
  final TextEditingController _controller = TextEditingController(text: '1');
  final WineService _wineService;

  StreamSubscription subscription;

  BottleAmountModel({WineService wineService}) : _wineService = wineService{
    subscription = wineStream.listen((wine) => setPriceFromStream(wine));
  }

  TextEditingController get controller => _controller;

  Stream<Wine> get wineStream => _wineService.wineStream;

  Wine get wine => _wineService.wine;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void setPriceFromStream(Wine wine){
    controller.text = '${wine.owned}';
  }

  void increment() {
    if (wine.owned != 999) {
      wine.owned++;
      controller.text = '${wine.owned}';
    }
  }

  void decrement() {
    if (wine.owned != 0) {
      wine.owned--;
      controller.text = '${wine.owned}';
    }
  }
}
