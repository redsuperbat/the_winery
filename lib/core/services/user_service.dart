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
      } else {
        _user = await login(
            _prefs.getString('email'), _prefs.getString('password'));
      }
    }
  }

  User get user => _user;

  Future<bool> verifyToken(String token) async {
    final res = await http
        .get('$endPoint/wines', headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      return (true);
    } else {
      return (false);
    }
  }

  Future<User> login(String email, String password) async {
    User user;
    await http
        .post('$endPoint/users/login',
            headers: {'Accept': 'application/json'},
            body: {'email': email, 'password': password})
        .then((res) => user = User.fromJson(json.decode(res.body)[0]))
        .catchError((err) => print(err));
    return (user);
  }

  Future<User> register(String email, String password, String username) async {
    User user;
    await http
        .post('$endPoint/users/register',
            headers: {'Accept': 'application/json'},
            body: {'email': email, 'password': password, 'username': username})
        .then((res) => user = User.fromJson(json.decode(res.body)[0]))
        .catchError((err) => print(err));
    return (user);
  }

  Future<bool> isLoggedin() async {}
}
