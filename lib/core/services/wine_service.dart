import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wine_cellar/core/models/wine.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wine_cellar/core/services/user_service.dart';

class WineService {
  // final DatabaseService _db;
  final UserService _userService;
  final StreamController<String> _subType = StreamController.broadcast();
  final StreamController<List<Wine>> _wines = StreamController.broadcast();
  final StreamController<Wine> _wine = StreamController.broadcast();

  static const String endpoint = 'http://rest1.dizzyhouse.com/api';

  static final Dio dio =
      Dio(BaseOptions(baseUrl: 'http://rest1.dizzyhouse.com/api'));

  WineService({@required UserService userService}) : _userService = userService;

  Stream<Wine> get wineStream => _wine.stream;

  Sink<Wine> get wineSink => _wine.sink;

  Sink get subTypeSink => _subType.sink;

  Stream get subType => _subType.stream;

  Stream<List<Wine>> get wines => _wines.stream;

  List<Wine> cachedWines;

  String wineImageFilePath;

  Wine wine = Wine();

  String category;
  String subCategory;
  String cellar;

  void closeControllers() {
    _subType.close();
    _wines.close();
    _wine.close();
  }

  void resetWine() {
    wine = Wine();
  }

  Future<void> initializeDb(String cellarName) async {
    cellar = cellarName;
    if (cellar != null) {
      await getAllWine();
    }
  }

  Future<void> searchWine(String query) async {
    // TODO: IMPLEMENT search wines
    final List<Wine> wines = [];
    // final response = await _db.search(cellar, 'name', query);
    // response.forEach((w) => wines.add(Wine.fromJson(w)));
    _wines.add(wines);
  }

  Future removeWine(Wine wine) async {
    // TODO: Implement
    // _db.remove(cellar, wine.id);
  }

  Future changeCellar(String cellarName) async {
    cellar = cellarName;
    await getAllWine();
  }

  Future addCellar(String name) async {
    // TODO: Implement adding cellars
    cellar = name;
    // await _db.createTable(name);
    await getAllWine();
  }

  Future<void> filterWine() async {
    // TODO: Filter wines implement
    // final request = await _db.filter(cellar, subCategory, category);
    final List<Wine> wines = [];
    // request.forEach((w) => wines.add(Wine.fromJson(w)));
    _wines.add(wines);
  }

  Future<void> addWine() async {
    var request = http.MultipartRequest("POST", Uri.parse('$endpoint/wines'));
    request.files.add(await http.MultipartFile.fromPath(
        "image", wineImageFilePath,
        contentType: MediaType('image', 'jpg')));
    request.headers.addAll({"Authorization": 'Bearer ${_userService.token}'});
    final Map filteredMap = wine.toJson()
      ..removeWhere((key, value) => value == null);
    final Map<String, String> map =
        filteredMap.map((key, value) => MapEntry(key, value.toString()));
    request.fields.addAll(map);
    Wine fetchedWine;
    final response = await request.send();
    if (response.statusCode == 200) {
      response.stream
          .transform(utf8.decoder)
          .listen((res) => fetchedWine = Wine.fromJson(json.decode(res)));
      cachedWines.add(fetchedWine);
      _wines.add(cachedWines);
    } else {
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((res) => print(res));
    }
  }

  Future<List<Map<String, dynamic>>> getExportData() async {
    // TODO: Implement this
    // final request = await _db.getTable(cellar);
    return [];
  }

  Future<void> getAllWine() async {
    final response = await dio.get('/wines',
        options: Options(
            headers: {'Authorization': 'Bearer ${_userService.token}'}));
    if (response.statusCode == 200) {
      List<Wine> wines;
      if (response.data.length > 0) {
        wines = response.data.map<Wine>((wine) => Wine.fromJson(wine)).toList();
      } else {
        wines = [];
      }
      cachedWines = wines;
      _wines.add(cachedWines);
    } else {
      // If token fails, get new token and try again..
      _userService.initUser().then((value) => getAllWine());
    }
  }

  Future<void> updateWine({Wine newWine}) async {
    // TODO: Implement updating wine
    // await _db.update(cellar, newWine?.toJson() ?? wine.toJson());
  }

  Future<int> getStatistics({String column, String shouldEqual}) async {
    int sum = 0;
    // TODO: Implement frontend calculations of this
    // if (column != null && shouldEqual != null) {
    //   final data = await _db.rawQuery(
    //       "SELECT type, quantity FROM $cellar WHERE $column = '$shouldEqual'");
    //   data.forEach((m) => sum = sum + m['quantity']);
    // } else {
    //   final data = await _db.rawQuery("SELECT type, quantity FROM $cellar");
    //   data.forEach((m) => sum = sum + m['quantity']);
    // }
    return sum;
  }

  Future<double> getCellarWorth() async {
    double sum = 0;
    // TODO: get cellar worth
    // final data = await _db.rawQuery("SELECT price, quantity FROM $cellar");
    // data.forEach((m) => sum = sum + m['price'] * m['quantity']);
    return sum;
  }

  Future decrementWine(Wine wine) async {
    // TODO: IMPLEMENT decrement wine
    // if (wine.quantity == 0)
    //   await removeWine(wine);
    // else
    //   await updateWine(newWine: wine);
  }
}
