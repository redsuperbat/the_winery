import 'package:meta/meta.dart';
import 'package:wine_cellar/core/models/profile.dart';
import 'package:wine_cellar/core/services/profile_service.dart';
import 'package:wine_cellar/core/services/settings_service.dart';
import 'package:wine_cellar/core/services/wine_service.dart';

import 'package:wine_cellar/core/viewmodels/base_model.dart';

class HomeModel extends BaseModel {
  final WineService _wineService;
  final Settings _settings;
  final ProfileService _profileService;

  HomeModel(
      {@required WineService wineService,
      Settings settings,
      ProfileService profileService})
      : _wineService = wineService,
        _settings = settings,
        _profileService = profileService;

  Stream<String> get subType => _wineService.subType;

  Stream get profiles => _profileService.profileStream;

  int counter = 0;

  bool get hasCreated => _settings.hasCreated;

  bool search = false;

  void beginSearch() {
    search = !search;
    notifyListeners();
  }

  void increment() {
    counter++;
  }

  void setHasCreated(bool bool) {
    _settings.setHasCreated(bool);
  }

  Future<void> iniDb() async {
    //setBusy(true);
    await _wineService.initializeDb(await _profileService.getDefaultCellar());
    //setBusy(false);
  }

  Future iniAppData() async {
    print("Initializing the app data");
    await _settings.iniSettings();
    await loadProfiles();
  }

  Future changeCellar(Profile profile) async {
    await _profileService.setDefault(profile);
    _wineService.cellar = await _profileService.getDefaultCellar();
    await _wineService.getAllWine();
  }

  Future<void> createProfile(String displayName, String cellarName) async {
    await _profileService.addProfile(displayName, cellarName);
  }

  Future<void> loadProfiles() async {
    print("loading profiles");
    await _profileService.iniDb();
    await _profileService.sinkProfiles();
  }

  Future createCellar(String displayName) async {
    print(displayName);
    final cellarName = displayName.replaceAll(RegExp(r"[^\S\W]"), "");
    await createProfile(displayName, cellarName);
    print(cellarName);
    await _wineService.addCellar(cellarName);
  }
}
