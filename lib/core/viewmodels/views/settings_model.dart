import 'dart:async';

// import 'package:wine_cellar/core/models/profile.dart';
// import 'package:wine_cellar/core/services/database_service.dart';
// import 'package:wine_cellar/core/services/profile_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:wine_cellar/core/services/settings_service.dart';
import 'package:wine_cellar/core/services/user_service.dart';

import '../base_model.dart';

class SettingsModel extends BaseModel {
  final Settings _settings;
  TextEditingController controller;
  final UserService _userService;
  // final DatabaseService _db;
  // final ProfileService _profile;
  int index;

  bool isUserEdit = false;

  bool edited = false;

  SettingsModel({Settings settings, UserService userService})
      : _settings = settings,
        _userService = userService {
    controller = TextEditingController(text: _userService.email);
    controller.addListener(emailIsEdited);
  }

  String get currency => _settings.currency;

  // Stream<List<Profile>> get profiles => StreamController().stream;

  Future<void> deleteDb() async {
    // TODO: Implement deleting all wines
    // await _db.dropDatabase();
    // _profile.profileSink.add([]);
  }

  void toggleUserEdit() {
    isUserEdit = !isUserEdit;
    notifyListeners();
  }

  Future<void> loadProfiles() async {
    // await _profile.sinkProfiles();
  }

  void emailIsEdited() {
    edited = controller.text != _userService.email;
    notifyListeners();
  }

  void showOptions(int i) {
    index = i;
    notifyListeners();
  }

  Future<void> editEmail() async {
    Map updateOps = {'email': controller.text};
    setBusy(true);
    bool success = await _userService.editUser(updateOps);
    if (success) {
      _userService.email = controller.text;
    } else {
      controller.text = _userService.email;
    }
    setBusy(false);
  }

  void setCurrency(String value) {
    _settings.currency = value;
    _settings.setCurrency(value);
    notifyListeners();
  }
}
