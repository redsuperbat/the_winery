import 'dart:async';

import 'package:meta/meta.dart';
// import 'package:the_winery/core/models/profile.dart';
// import 'package:the_winery/core/services/profile_service.dart';
import 'package:the_winery/core/services/settings_service.dart';
import 'package:the_winery/core/services/wine_service.dart';

import 'package:the_winery/core/viewmodels/base_model.dart';

class HomeModel extends BaseModel {
  final WineService _wineService;
  final Settings _settings;
  // final ProfileService _profileService;

  HomeModel({@required WineService wineService, Settings settings})
      : _wineService = wineService,
        _settings = settings;

  Stream<String> get subType => _wineService.subType;

  Stream get profiles => StreamController().stream;

  int counter = 0;

  bool search = false;

  void beginSearch() {
    search = !search;
    notifyListeners();
  }

  void increment() {
    counter++;
  }

  Future iniAppData() async {
    print("Initializing the app data");
    await _settings.iniSettings();
    // await loadProfiles();
  }

  // Future changeCellar(Profile profile) async {
  //   // TODO: implement changing cellars
  //   // await _profileService.setDefault(profile);
  //   // _wineService.cellar = await _profileService.getDefaultCellar();
  //   await _wineService.getAllWine();
  // }

  Future createCellar(String displayName) async {
    print(displayName);
    final cellarName = displayName.replaceAll(RegExp(r"[^\S\W]"), "");
    print(cellarName);
    await _wineService.addCellar(cellarName);
  }
}
