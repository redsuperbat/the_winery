import 'package:flutter/material.dart';
import 'package:wine_cellar/core/services/settings_service.dart';
import 'package:wine_cellar/core/services/wine_service.dart';
import 'dart:async';
import 'package:wine_cellar/ui/constants.dart';

import '../base_model.dart';

class StatisticsModel extends BaseModel {
  final WineService _db;
  final Settings _settings;
  final PageController _controller = PageController(initialPage: 1);
  final List<Map<String, double>> stats = [];
  int _index = 1;

  StatisticsModel({WineService db, Settings settings})
      : _db = db,
        _settings = settings;

  String get currency => _settings.currency;

  int get index => _index;

  PageController get controller => _controller;

  int totalWines = 0;
  double cellarWorth = 0;



  Future loadAllStatistics() async {
    setBusy(true);
    totalWines = await _db.getStatistics();
    cellarWorth = await _db.getCellarWorth();
    await loadPieData(wineCategories, 'type');
    await loadPieData(wineSizes, 'size');
    await loadPieData(countryNames, 'country');
    setBusy(false);
  }

  Future loadPieData(List iniData, String dataType) async {
    Map wines = {};
    for (String item in iniData) {
      int data = await _db.getStatistics(column: dataType, shouldEqual: item);
      if (data != 0) wines[item] = data;
    }
    if (dataType == "country" && wines.length > 6) {
      Map temp = {"Other": 0};
      wines.forEach(
          (s, v) => v <= 1 ? temp["Other"] = temp["Other"] + v : temp[s] = v);
      print(temp);
      stats.add(temp.map((s, i) => MapEntry(s, (i / totalWines) * 100)));
    } else {
      stats.add(wines.map((s, i) => MapEntry(s, (i / totalWines) * 100)));
    }
  }

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
