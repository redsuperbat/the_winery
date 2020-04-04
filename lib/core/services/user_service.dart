import 'package:wine_cellar/core/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  static const endPoint = "http://rest1.dizzyhouse.com/api";

  User _user;
  SharedPreferences _prefs;

  Future<void> initUser() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('token')) {
      final token = _prefs.getString('token');
      if (await verifyToken(token)) {
        _user = User(
            email: _prefs.getString('email'), token: _prefs.getString('token'));
      } else {
        String email = _prefs.getString('email');
        Map<String, dynamic> response =
            await login(email, _prefs.getString("password"));
        _user = User.fromJson(response);
      }
    }
  }

  User get user => _user;

  bool isLoggedIn() {
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> verifyToken(String token) async {
    final res = await http
        .get('$endPoint/wines', headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      return (true);
    } else {
      return (false);
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    Map<String, dynamic> decoded;
    await http
        .post('$endPoint/users/login',
            headers: {'Accept': 'application/json'},
            body: {'email': email, 'password': password})
        .then((res) => decoded = json.decode(res.body))
        .catchError((err) => decoded = json.decode(err));
    return (decoded);
  }

  Future<Map> register(String email, String password) async {
    User user;
    Map result = {"message": "Auth successful"};
    await http
        .post('$endPoint/users/register',
            headers: {'Accept': 'application/json'},
            body: {'email': email, 'password': password})
        .then((res) => user = User.fromJson(json.decode(res.body)))
        .catchError((err) => result = json.decode(err));
    _user = user;
    _prefs.setString('token', user.token);
    _prefs.setString('password', password);
    _prefs.setString('email', user.email);
    return result;
  }
}
