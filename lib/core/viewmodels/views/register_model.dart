import 'package:flutter/cupertino.dart';
import 'package:wine_cellar/core/services/user_service.dart';
import 'package:wine_cellar/core/viewmodels/base_model.dart';

class RegisterModel extends BaseModel {
  UserService _userService;
  RegisterModel({userService}) : _userService = userService;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPwdController = TextEditingController();

  Future<Map> register() async {
    setBusy(true);
    Map<dynamic, dynamic> result = await _userService.register(
        emailController.text, passwordController.text);
    setBusy(false);
    if (result['message'].contains("successful")) {
      return {'message': result['message'], 'success': true};
    }
    return {'message': result['message'], 'success': false};
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    verifyPwdController.dispose();
    print("Disposing Register Model");
    super.dispose();
  }
}
