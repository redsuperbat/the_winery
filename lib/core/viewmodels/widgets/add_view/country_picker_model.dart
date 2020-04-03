import 'dart:async';

import 'package:meta/meta.dart';
import 'package:wine_cellar/core/models/country.dart';
import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/services/json_service.dart';
import 'package:wine_cellar/core/services/wine_service.dart';

import '../../base_model.dart';

class CountryPickerModel extends BaseModel {
  final JsonService _json;
  final WineService _wineService;
  StreamSubscription subscription;
  Country _country;
  final StreamController<bool> suggestionController =
      StreamController.broadcast();
  final StreamController<bool> otherController = StreamController.broadcast();

  CountryPickerModel(
      {@required JsonService json, @required WineService wineService})
      : _json = json,
        _wineService = wineService {
    subscription = wineStream.listen((wine) => setWineCountry(wine));
  }

  Stream<Wine> get wineStream => _wineService.wineStream;

  Stream<bool> get suggestionStream => suggestionController.stream;

  Stream<bool> get otherStream => otherController.stream;

  List<Country> get countries => _json.countries;

  List<Country> get suggestedCountries => _json.suggestedCountries;

  Country get country => _country;

  @override
  void dispose() {
    print("Disposing Countrypicker");
    subscription.cancel();
    suggestionController.close();
    otherController.close();
    super.dispose();
  }

  void setWineCountry(Wine wine) {
    _country =
        countries.firstWhere((c) => wine.country == c.name, orElse: () => null);
    notifyListeners();
  }

  void toggleSuggestions(bool show) {
    suggestionController.sink.add(show);
    if (show) {
      otherController.sink.add(!show);
    }
  }

  void toggleOther(bool show) {
    otherController.sink.add(show);
    if (show) {
      suggestionController.sink.add(!show);
    }
  }

  Future loadAssets() async {
    setBusy(true);
    _json.loadAssets();
    setBusy(false);
  }

  void setCountry(Country country) {
    _country = country;
    _wineService.wine.country = _country.name;
    notifyListeners();
  }
}
