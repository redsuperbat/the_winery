import 'package:the_winery/core/models/wine.dart';
import 'package:the_winery/core/services/wine_service.dart';

import '../base_model.dart';

class WineListModel extends BaseModel {
  final WineService _wineService;

  WineListModel({WineService wineService}) : _wineService = wineService;

  Stream<List<Wine>> get wines => _wineService.wines;

  Future<void> getWines() async {
    _wineService.getAllWine();
  }

  Future<void> onRefresh() async {
    _wineService.subTypeSink.add("show all");
    await _wineService.getAllWine();
  }

  // Deprecated Method
  Future<void> removeWine(Wine wine) async {
    // await _wineService.removeWine(wine);
    notifyListeners();
  }
}
