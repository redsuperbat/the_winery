import 'package:wine_cellar/core/services/user_service.dart';
import 'package:wine_cellar/core/viewmodels/base_model.dart';

class StartupModel extends BaseModel {
  String _starterView;
  UserService _userService;

  StartupModel({starterView, userService}) : _userService = userService;

  Future<void> init() async {
    await _userService.initUser();
  }
}
