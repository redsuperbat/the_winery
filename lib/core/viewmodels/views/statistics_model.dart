import 'package:flutter/material.dart';
import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/services/settings_service.dart';
import 'package:wine_cellar/core/services/wine_service.dart';
import 'dart:async';
import 'package:wine_cellar/ui/constants.dart';

import '../base_model.dart';

class StatisticsModel extends BaseModel {
  final WineService _wineService;
  final Settings _settings;
  final PageController _controller = PageController(initialPage: 1);
  int _index = 1;

  final List<Map<String, double>> piechartData = [];
  final List<String> pieNames = ["Categories", "Bottle sizes", "Countires"];

  StatisticsModel({WineService wineService, Settings settings})
      : _wineService = wineService,
        _settings = settings;

  void initPieData() {
    piechartData.add(loadPieData(wineCategories, 'type'));
    piechartData.add(loadPieData(wineSizes, 'size'));
    piechartData.add(loadPieData(countryNames, 'country'));
  }

  String get currency => _settings.currency;

  int get index => _index;

  List<Wine> get activeWines => _wineService.activeWines;

  PageController get controller => _controller;

  Map<String, double> loadPieData(List<String> iniData, String dataType) {
    Map wines = {};
    for (String item in iniData) {
      int data = amountOfBottlesPerCategory(dataType, item);
      if (data != 0) wines[item] = data;
    }
    if (dataType == "country" && wines.length > 6) {
      Map temp = {"Other": 0};
      wines.forEach(
          (s, v) => v <= 1 ? temp["Other"] = temp["Other"] + v : temp[s] = v);
      print(temp);
      return (temp
          .map((s, i) => MapEntry(s, (i / getBottlesInCellar()) * 100)));
    } else {
      return (wines
          .map((s, i) => MapEntry(s, (i / getBottlesInCellar()) * 100)));
    }
  }

  int amountOfBottlesPerCategory(String category, String item) {
    int sum = 0;
    _wineService.activeWines.forEach((wine) {
      if (wine.toJson()[category] == item) {
        sum++;
      }
    });
    return sum;
  }

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

  int getBottlesInCellar() {
    int sum = 0;
    activeWines.forEach((Wine wine) => sum += wine.quantity);
    return sum;
  }

  double getCellarWorth() {
    double sum = 0;
    activeWines
        .forEach((Wine wine) => sum += (wine.quantity * wine?.price ?? 0));
    return sum;
  }
}
