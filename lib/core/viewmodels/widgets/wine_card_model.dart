import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/services/wine_service.dart';

import '../base_model.dart';

class WineCardModel extends BaseModel {
  final WineService _wineService;

  WineCardModel({WineService wineService}) : _wineService = wineService;

  void removeWine(Wine wine) {
    _wineService.removeWine(wine);
  }

  Future increment(Wine wine)async {
    wine.owned++;
    await _wineService.updateWine(newWine: wine);
    notifyListeners();
  }

  void injectWine(Wine wine) {
    _wineService.wine = wine;
  }

  Future decrement(Wine wine)async {
    wine.owned--;
   await _wineService.decrementWine(wine);
   notifyListeners();
  }
}
