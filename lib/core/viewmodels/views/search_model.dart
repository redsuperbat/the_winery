import 'package:the_winery/core/services/wine_service.dart';

import 'package:the_winery/core/viewmodels/base_model.dart';

class SearchModel extends BaseModel {
  final WineService _wineService;

  SearchModel({WineService wineService}) : _wineService = wineService;

  Future<bool> getAllWine() async {
    await _wineService.getAllWine();
    return true;
  }

  @override
  void dispose() {
    print("Disposing SearchModel");
    getAllWine();
    super.dispose();
  }

  void search(String query) {
    _wineService.searchWine(query);
  }
}
