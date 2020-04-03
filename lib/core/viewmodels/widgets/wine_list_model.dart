import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/services/wine_service.dart';

import '../base_model.dart';

class WineListModel extends BaseModel {
  final WineService _wineService;

  WineListModel({WineService wineService})
      : _wineService = wineService;

  Stream<List<Wine>> get wines => _wineService.wines;


  Future<void> onRefresh() async {
    _wineService.subTypeSink.add("show all");
    await _wineService.getAllWine();
  }

  Future<void> removeWine(Wine wine) async{
    await _wineService.removeWine(wine);
    notifyListeners();
}

}
