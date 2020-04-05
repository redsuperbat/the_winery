import 'dart:async';

import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/services/wine_service.dart';

import '../../base_model.dart';

class VintagePickerModel extends BaseModel {
  final WineService _wineService;

  int selected = DateTime.now().year;

  bool isChecked = false;
  StreamSubscription subscription;

  Stream<Wine> get wineStream => _wineService.wineStream;

  Wine get wine => _wineService.wine;

  VintagePickerModel({WineService wineService}) : _wineService = wineService {
    subscription = wineStream.listen((wine) => setVintageFromStream(wine));
  }

  @override
  void dispose() {
    print("Disposing VintagePicker");
    subscription.cancel();
    super.dispose();
  }

  void setVintageFromStream(Wine _wine) {
    if (_wine.vintage == null) {
      wine.vintage = "NV";
      isChecked = true;
      notifyListeners();
    } else {
      isChecked = false;
      notifyListeners();
    }
  }

  void change() {
    isChecked = !isChecked;
    if (isChecked) {
      wine.vintage = "NV";
    } else {
      // Do nothing
    }
    notifyListeners();
  }

  void setYear(int year) {
    print("year was set to: $year");
    selected = year;
    wine.vintage = year.toString();
  }
}
