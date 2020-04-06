import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:wine_cellar/core/services/user_service.dart';
import '../base_model.dart';

class ExportModel extends BaseModel {
  final UserService _userService;
  final TextEditingController controller = TextEditingController();
  final RegExp regExp = RegExp(r"^[a-zA-Z0-9_\s-]+$");
  static const String _endpoint = 'http://rest1.dizzyhouse.com/api';

  ExportModel({UserService userService}) : _userService = userService;
  List<Map<String, dynamic>> wines;

  List<List<String>> rows;

  bool export = false;

  String get email => _userService.email;

  String get text => controller.text;

  Future<bool> exportWines() async {
    final response = await http.post('$_endpoint/wines/export',
        headers: {'Authorization': 'Bearer ${_userService.token}'},
        body: {'email': email, 'filename': controller.text});
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  void startExport() {
    export = !export;
    notifyListeners();
  }
}
