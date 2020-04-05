import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  String currency = "SEK";
  SharedPreferences _prefs;

  Future<void> iniSettings() async {
    if (_prefs == null) {
      print("Initializing settings");
      _prefs = await SharedPreferences.getInstance();
      currency = _prefs.getString('currency') ?? "SEK";
    }
  }

  void setCurrency(String currency) {
    _prefs.setString('currency', currency);
  }

  Future<void> clearPrefs() async {
    await _prefs.clear();
  }
}
