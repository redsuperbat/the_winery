import 'package:wine_cellar/core/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:dio/dio.dart';

class UserService {
  static final Dio dio =
      Dio(BaseOptions(baseUrl: "http://rest1.dizzyhouse.com/api"));

  User _user;
  SharedPreferences _prefs;

  User get user => _user;
  String get token => _user.token;

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
        _prefs.setString('token', _user.token);
      }
    }
  }

  bool isLoggedIn() {
    print("checking if user is logged in");
    if (user == null) {
      return false;
    } else {
      print("returning true");
      return true;
    }
  }

  Future<bool> verifyToken(String token) async {
    bool returner;
    await dio
        .post('/token',
            options: Options(headers: {'Authorization': 'Bearer $token'}))
        .then((res) => returner = true)
        .catchError((err) => returner = false);
    return returner;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    Map<String, dynamic> decoded;
    await dio
        .post('/users/login',
            options: Options(headers: {'Accept': 'application/json'}),
            data: {'email': email, 'password': password})
        .then((res) => decoded = res.data)
        .catchError((err) => decoded = err);
    return (decoded);
  }

  Future<Map> register(String email, String password) async {
    User user;
    Map result = {"message": "Auth successful"};
    await dio
        .post('/users/register',
            options: Options(headers: {'Accept': 'application/json'}),
            data: {'email': email, 'password': password})
        .then((res) => user = User.fromJson(res.data))
        .catchError((err) => result = err);
    _user = user;
    print(user);
    _prefs.setString('token', user.token);
    _prefs.setString('password', password);
    _prefs.setString('email', user.email);
    return result;
  }
}
