import 'package:flutter/cupertino.dart';
import 'package:wine_cellar/core/models/profile.dart';
import 'package:wine_cellar/core/services/profile_service.dart';

import '../base_model.dart';

class CellarEditModel extends BaseModel {
  Profile _profile;
  ProfileService _profileService;

  Profile get profile => _profile;

  TextEditingController controller;

  CellarEditModel({ProfileService profileService})
      : _profileService = profileService;

  void setProfile(Profile profile) {
    _profile = profile;
    controller = TextEditingController(text: _profile.displayName);
    controller.addListener(_listener);
  }

  void _listener() {
    _profile.displayName = controller.text;
    notifyListeners();
  }

  bool changeProfile() {
    _profileService.updateProfile(_profile);
    return true;
  }

  void setColor(int color) {
    _profile.color = color;
    notifyListeners();
  }

  String getColorName(int color) {
    switch (color) {
      case 0xFFffb3ba:
        return 'Pink';
      case 0xffffdfba:
        return 'Blue';
      case 0xffffffba:
        return 'Red';
      case 0xffbaffc9:
        return 'Purple';
      case 0xffbae1ff:
        return 'Orange';
      default:
        return "";
    }
  }
}
