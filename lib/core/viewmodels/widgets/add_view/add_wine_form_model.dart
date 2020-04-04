import 'package:flutter/material.dart';
import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/services/settings_service.dart';
import 'package:wine_cellar/core/services/wine_service.dart';
import 'dart:async';

import '../../base_model.dart';

class AddWineFormModel extends BaseModel {
  final WineService _wineService;
  final Settings _settings;

  final FocusNode focusNode = FocusNode();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController grapeController = TextEditingController();

  bool showSearch = true;

  AddWineFormModel({WineService wineService, Settings settings})
      : _wineService = wineService,
        _settings = settings {
    nameController.addListener(listener);
    districtController.addListener(setdistrict);
    grapeController.addListener(setGrapes);
    priceController.addListener(setPrice);
  }

  String get currency => _settings.currency;

  Stream<List<Wine>> get wines => _wineService.wines;

  String get text => nameController.text;

  List<Wine> queryWines;

  Wine get wine => _wineService.wine;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    grapeController.dispose();
    districtController.dispose();
    print("Disposing AddWineFormModel");
    super.dispose();
  }

  void showWineSearch() {
    showSearch = true;
  }

  void setWine(Wine wine) {
    _wineService.wine = wine;
    nameController.text = wine.name ?? "";
    priceController.text = wine.price == null ? "" : wine.price.toString();
    grapeController.text = wine.grapes ?? "";
    districtController.text = wine.district;
    _wineService.wineSink.add(wine);
    showSearch = false;
    notifyListeners();
  }

  void listener() {
    // TODO: Implement search
    // _wineService.searchWine(nameController.text);
    setName();
  }

  void setName() {
    wine.name = nameController.text;
  }

  void setdistrict() {
    wine.district = districtController.text;
  }

  void setPrice() {
    wine.price = double.tryParse(priceController.text);
  }

  void setGrapes() {
    wine.grapes = grapeController.text;
  }
}
