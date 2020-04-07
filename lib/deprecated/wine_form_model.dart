import 'package:the_winery/core/models/wine.dart';
import 'package:the_winery/core/services/wine_service.dart';

// import '../base_model.dart';
import 'package:flutter/material.dart';

class WineFormModel {
  final WineService _wineService;

  TextEditingController districtController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController grapeController = TextEditingController();
  TextEditingController vintageController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  WineFormModel({WineService wineService}) : _wineService = wineService {
    districtController = TextEditingController(text: wine.district ?? "");
    nameController = TextEditingController(text: wine.name ?? "");
    grapeController = TextEditingController(text: wine.grapes ?? "");
    priceController = TextEditingController(
        text: wine.price == 0 ? '' : wine.price.toString());
    vintageController = TextEditingController(text: wine.vintage.toString());
    countryController = TextEditingController(text: wine.country ?? "");

    nameController.addListener(setName);
    districtController.addListener(setdistrict);
    grapeController.addListener(setGrapes);
    priceController.addListener(setPrice);
    countryController.addListener(setCountry);
    vintageController.addListener(setVintage);
  }

  Wine get wine => _wineService.wine;

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

  void setVintage() {
    wine.vintage = vintageController.text;
  }

  void setCountry() {
    wine.country = countryController.text;
  }
}
