import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:wine_cellar/core/services/user_service.dart';
import '../base_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportModel extends BaseModel {
  final UserService _userService;
  final TextEditingController controller = TextEditingController();
  static const String _endpoint = 'http://rest1.dizzyhouse.com/api';

  final RegExp filenameRegExp = RegExp(r"[^A-Za-z0-9]");

  ExportModel({UserService userService}) : _userService = userService;
  List<Map<String, dynamic>> wines;

  List<List<String>> rows;

  bool export = false;

  String get email => _userService.email;

  String get text => controller.text;

  Future<bool> exportWines() async {
    final response = await http.post('$_endpoint/wines/export', headers: {
      'Authorization': 'Bearer ${_userService.token}'
    }, body: {
      'email': email,
      'filename': controller.text.replaceAll(filenameRegExp, '')
    });
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<void> openGmail() async {
    const url = "https://gmail.com";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // do nothing...
    }
  }

  void startExport() {
    export = !export;
    notifyListeners();
  }
}
