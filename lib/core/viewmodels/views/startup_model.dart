import 'dart:async';

import 'package:the_winery/core/services/user_service.dart';
import 'package:the_winery/core/viewmodels/base_model.dart';

class StartupModel extends BaseModel {
  StreamController<String> _starterView = StreamController();
  UserService _userService;

  StartupModel({starterView, userService}) : _userService = userService;

  Stream get stream => _starterView.stream;

  Sink get sink => _starterView.sink;

  Future<void> init() async {
    print("Initing startup");
    await _userService.initUser();
    if (_userService.isLoggedIn()) {
      sink.add("home");
    } else {
      sink.add("register");
    }
    _userService.updateToken();
  }

  @override
  void dispose() {
    print("disposing startup model");
    _starterView.close();
    super.dispose();
  }
}
