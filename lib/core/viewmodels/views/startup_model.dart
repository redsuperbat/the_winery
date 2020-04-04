import 'dart:async';

import 'package:wine_cellar/core/services/user_service.dart';
import 'package:wine_cellar/core/viewmodels/base_model.dart';

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
  }

  @override
  void dispose() {
    print("disposing startup model");
    _starterView.close();
    super.dispose();
  }

  Future<void> test() async {
    setBusy(true);
    print(await _userService.login("admin@admn.com", "password"));
    setBusy(false);
  }
}
