import 'package:wine_cellar/core/services/user_service.dart';
import 'package:wine_cellar/core/viewmodels/base_model.dart';

class StartupModel extends BaseModel {
  String _starterView;
  UserService _userService;

  StartupModel({starterView, userService}) : _userService = userService;

  String get starterView => _starterView;

  Future<void> init() async {
    print("Initing startup");
    await _userService.initUser();
    if (_userService.isLoggedIn()) {
      _starterView = "home";
    } else {
      _starterView = "register";
    }
  }

  Future<void> test() async {
    setBusy(true);
    print(await _userService.login("admin@admn.com", "password"));
    setBusy(false);
  }
}
