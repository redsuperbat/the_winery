import 'package:the_winery/core/models/wine.dart';
import 'package:the_winery/core/services/wine_service.dart';

import '../base_model.dart';

class WineCardModel extends BaseModel {
  final WineService _wineService;

  WineCardModel({WineService wineService}) : _wineService = wineService;

  void removeWine(Wine wine) {
    _wineService.updateWine({'archived': true}, wine.id);
    wine.archived = true;
    notifyListeners();
  }

  void increment(Wine wine) {
    wine.quantity++;
    Map updateOps = {'quantity': wine.quantity};
    _wineService.updateWine(updateOps, wine.id);
    notifyListeners();
  }

  void injectWine(Wine wine) {
    _wineService.wine = wine;
  }

  Future decrement(Wine wine) async {
    if (wine.quantity > 1) {
      wine.quantity--;
      Map updateOps = {'quantity': wine.quantity};
      _wineService.updateWine(updateOps, wine.id);
      notifyListeners();
    } else {
      wine.archived = true;
      Map updateOps = {'archived': wine.archived};
      _wineService.updateWine(updateOps, wine.id);
      notifyListeners();
    }
  }
}
