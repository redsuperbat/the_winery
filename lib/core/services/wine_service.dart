import 'dart:async';
// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:the_winery/core/models/wine.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:the_winery/core/services/user_service.dart';

class WineService {
  final UserService _userService;
  final StreamController<String> _subType = StreamController.broadcast();
  final StreamController<List<Wine>> _wines = StreamController.broadcast();
  final StreamController<Wine> _wine = StreamController.broadcast();

  static const String endpoint = 'http://rest1.dizzyhouse.com/api';

  WineService({@required UserService userService}) : _userService = userService;

  Stream<Wine> get wineStream => _wine.stream;

  Sink<Wine> get wineSink => _wine.sink;

  Sink get subTypeSink => _subType.sink;

  Stream get subType => _subType.stream;

  Stream<List<Wine>> get wines => _wines.stream;

  List<Wine> cachedWines = [];

  List<Wine> activeWines = [];

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

  void searchWine(String query) {
    List<Wine> searchWines = activeWines.where((Wine wine) {
      bool returner = false;
      Map attrsToSearch = {
        "name": wine.name,
        "vintage": wine.vintage,
        "district": wine.district,
        "grapes": wine.grapes,
        "type": wine.type,
        "size": wine.size,
        "country": wine.country
      };
      // set returner to true if the query matches any of the attributes we want to search.
      attrsToSearch.forEach((key, value) =>
          value.toString().toLowerCase().contains(query.toLowerCase())
              ? returner = true
              : null);
      return returner;
    }).toList();
    _wines.add(searchWines);
  }

  // Future changeCellar(String cellarName) async {
  //   cellar = cellarName;
  //   await getAllWine();
  // }

  // Future addCellar(String name) async {
  //   // TODO: Implement adding cellars
  //   cellar = name;
  //   // await _db.createTable(name);
  //   await getAllWine();
  // }

  Future<void> archiveAllUserWines() async {
    final response = await http.patch('$endpoint/wines',
        headers: {'Authorization': 'Bearer ${_userService.token}'},
        body: {'archived': true});
    if (response.statusCode == 200) {
      print(response.body);
      activeWines = activeWines.map<Wine>((wine) {
        wine.archived = true;
        return wine;
      }).toList();
      sinkActiveWines();
    } else {
      print(response.body);
    }
  }

  Future<void> filterWine() async {
    List<Wine> filteredWines = activeWines
        .where((wine) => wine.toJson()[category] == subCategory)
        .toList();
    _wines.add(filteredWines);
  }

  void sinkActiveWines() {
    activeWines = cachedWines.where((wine) => !wine.archived).toList();
    activeWines.sort((f, s) => f.date.compareTo(s.date));
    _wines.add(activeWines);
  }

  Future<void> addWine() async {
    var request = http.MultipartRequest("POST", Uri.parse('$endpoint/wines'));
    // only add image to request if user submits an image
    if (wineImageFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath(
          "image", wineImageFilePath,
          contentType: MediaType('image', 'jpg')));
    }
    request.headers.addAll({"Authorization": 'Bearer ${_userService.token}'});

    // Remove all values from wine that is not populated
    final Map filteredMap = wine.toJson()
      ..removeWhere((key, value) => value == null);

    // Convert all populated values to string
    final Map<String, String> map =
        filteredMap.map((key, value) => MapEntry(key, value.toString()));
    request.fields.addAll(map);
    Wine fetchedWine;

    // Send request
    final response = await request.send();
    if (response.statusCode == 201) {
      response.stream.transform(utf8.decoder).listen((res) {
        fetchedWine = Wine.fromJson(json.decode(res));
        cachedWines.add(fetchedWine);
        sinkActiveWines();
      });
    } else {
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((res) => print(res));
    }
  }

  Future<void> getAllWine() async {
    final response = await http.get('$endpoint/wines',
        headers: {'Authorization': 'Bearer ${_userService.token}'});
    final decoded = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<Wine> wines;
      if (decoded.length > 0) {
        wines = decoded.map<Wine>((wine) => Wine.fromJson(wine)).toList();
      } else {
        wines = [];
      }
      cachedWines = wines;
      // Checking if wine is archived or not, shows only archived wines.
      sinkActiveWines();
    } else {
      // If token fails, wait 2 seconds and try again..
      Future.delayed(Duration(seconds: 2), () => getAllWine());
    }
  }

  Future<void> updateWine(Map updateOps, String id) async {
    print(json.encode(updateOps));
    final response = await http.patch('$endpoint/wines/$id',
        headers: {
          'Authorization': 'Bearer ${_userService.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: json.encode(updateOps));

    // sink wines that are not archived.
    sinkActiveWines();
    print(response.body);
  }
}
