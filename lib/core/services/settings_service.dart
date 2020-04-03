import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  String currency = "SEK";
  bool hasCreated = false;
  SharedPreferences _prefs;

  Future<void> iniSettings() async {
    if (_prefs == null) {
      print("Initializing settings");
      _prefs = await SharedPreferences.getInstance();
      currency = _prefs.getString('currency') ?? "SEK";
      hasCreated = _prefs.getBool('hasCreated') ?? false;
      print(hasCreated);
    }
  }

  void setCurrency(String currency) {
    _prefs.setString('currency', currency);
  }

  void setHasCreated(bool bool) {
    _prefs.setBool('hasCreated', bool);
  }

  Future<void> clearPrefs() async {
    await _prefs.clear();
  }
}
