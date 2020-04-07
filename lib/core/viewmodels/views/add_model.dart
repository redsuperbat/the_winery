import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:the_winery/core/services/wine_service.dart';

import '../base_model.dart';

class AddModel extends BaseModel {
  final WineService _wineService;
  File image;
  bool adding = false;
  AddModel({WineService wineService}) : _wineService = wineService;

  @override
  void dispose() {
    _wineService.resetWine();
    deleteCachedImage();
    super.dispose();
  }

  Future<void> addWine() async {
    adding = !adding;
    notifyListeners();
    await _wineService.addWine();
    await deleteCachedImage();
    adding = !adding;
    notifyListeners();
  }

  Future<void> deleteCachedImage() async {
    if (_wineService.wineImageFilePath != null) {
      print(["Deleting: ", _wineService.wineImageFilePath.toString()]);
      await File(_wineService.wineImageFilePath).delete();
      _wineService.wineImageFilePath = null;
    }
  }

  Future<void> getImage() async {
    setBusy(true);
    await deleteCachedImage();
    image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 15);
    _wineService.wineImageFilePath = image.path;
    setBusy(false);
  }
}
