import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:wine_cellar/core/services/wine_service.dart';

import '../base_model.dart';

class AddModel extends BaseModel {
  final WineService _wineService;
  File image;

  AddModel({WineService wineService}) : _wineService = wineService;

  @override
  void dispose() {
    _wineService.resetWine();
    super.dispose();
  }

  Future<void> addWine() async {
    await _wineService.addWine();
  }

  Future<void> getImage() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 30);
    _wineService.wineImageFilePath = image.path;
    print(_wineService.wineImageFilePath);
    notifyListeners();
  }
}
