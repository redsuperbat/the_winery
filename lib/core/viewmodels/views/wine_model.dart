import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/services/settings_service.dart';
import 'package:wine_cellar/core/services/wine_service.dart';

import 'package:wine_cellar/core/viewmodels/base_model.dart';

class WineModel extends BaseModel {
  final WineService _wineService;
  final Settings _settings;

  String get currency => _settings.currency;
  final TextEditingController cmtController = TextEditingController();
  File image;

  WineModel({@required WineService wineService, @required Settings settings})
      : _wineService = wineService,
        _settings = settings;

  void initialize(Wine wine) {
    cmtController.text = wine.comment;
  }

  @override
  void dispose() {
    print("Disposing AddModel");
    super.dispose();
  }

  Future<bool> updateWine(Wine wine) async {
    await _wineService.updateWine(newWine: wine);
    await _wineService.getAllWine();
    return true;
  }

  Future<void> getImage(Wine wine) async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      wine.image = image.path;
      print(wine.image);
      await updateWine(wine);
      notifyListeners();
    }
  }

  void setRating(double value, Wine wine) {
    wine.rating = value;
    notifyListeners();
  }

  void setComments(String value, Wine wine) {
    wine.comment = value;
  }
}
