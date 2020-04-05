import 'package:wine_cellar/core/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

class UserService {
  // static final Dio dio =
  //     Dio(BaseOptions(baseUrl: "http://rest1.dizzyhouse.com/api"));
  static const String endpoint = "http://rest1.dizzyhouse.com/api";
  User _user;
  SharedPreferences _prefs;

  User get user => _user;
  String get token => _user.token;

  Future<void> initUser() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('token')) {
      final token = _prefs.getString('token');
      if (await verifyToken(token)) {
        print("Setting user from _prefs");
        _user = User(
            email: _prefs.getString('email'), token: _prefs.getString('token'));
      } else {
        String email = _prefs.getString('email');
        print("trying to log in user..");
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
    await http.post('$endpoint/token', headers: {
      'Authorization': 'Bearer $token'
    }).then((http.Response res) =>
        res.statusCode == 200 ? returner = true : returner = false);
    print('returning $returner');
    return returner;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    print("logging in user");
    Map<String, dynamic> decoded;
    await http
        .post('$endpoint/users/login',
            headers: {'Accept': 'application/json'},
            body: {'email': email, 'password': password})
        .then((res) => decoded = json.decode(res.body))
        .catchError((err) => decoded = json.decode(err));
    return (decoded);
  }

  Future<Map> register(String email, String password) async {
    User user;
    Map result = {"message": "Auth successful"};
    await http.post('$endpoint/users/register',
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password}).then((res) {
      print(res.body);
      user = User.fromJson(json.decode(res.body));
      _user = user;
      print(user.toJson());
      _prefs.setString('token', user.token);
      _prefs.setString('password', password);
      _prefs.setString('email', user.email);
    }).catchError((err) => result = json.decode(err));

    return result;
  }
}
