import 'dart:async';

import 'package:meta/meta.dart';
import 'package:wine_cellar/core/models/wine.dart';

import 'database_service.dart';

class WineService {
  final DatabaseService _db;
  final StreamController<String> _subType = StreamController.broadcast();
  final StreamController<List<Wine>> _wines = StreamController.broadcast();
  final StreamController<Wine> _wine = StreamController.broadcast();

  WineService({@required DatabaseService database}) : _db = database;

  Stream<Wine> get wineStream => _wine.stream;

  Sink<Wine> get wineSink => _wine.sink;

  Sink get subTypeSink => _subType.sink;

  Stream get subType => _subType.stream;

  Stream<List<Wine>> get wines => _wines.stream;

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
    final List<Wine> wines = [];
    final response = await _db.search(cellar, 'name', query);
    response.forEach((w) => wines.add(Wine.fromJson(w)));
    _wines.add(wines);
  }

  Future removeWine(Wine wine) async {
    _db.remove(cellar, wine.id);
  }

  Future changeCellar(String cellarName) async {
    cellar = cellarName;
    await getAllWine();
  }

  Future addCellar(String name) async {
    cellar = name;
    await _db.createTable(name);
    await getAllWine();
  }

  Future<void> filterWine() async {
    final request = await _db.filter(cellar, subCategory, category);
    final List<Wine> wines = [];
    request.forEach((w) => wines.add(Wine.fromJson(w)));
    _wines.add(wines);
  }

  Future<void> insertWine() async {
    wine.id = await _db.getId(cellar);
    wine.time = DateTime.now().toString();
    print('wine image path is: ${wine.image}');
    await _db.insert(cellar, wine.toJson());
    await getAllWine();
  }

  Future<List<Map<String, dynamic>>> getExportData() async {
    final request = await _db.getTable(cellar);
    return request;
  }

  Future<void> getAllWine() async {
    final request = await _db.getTable(cellar);
    final List<Wine> wines = [];
    request.forEach((w) => wines.add(Wine.fromJson(w)));
    _wines.add(wines);
  }

  Future<void> updateWine({Wine newWine}) async {
    await _db.update(cellar, newWine?.toJson() ?? wine.toJson());
  }

  Future<int> getStatistics({String column, String shouldEqual}) async {
    int sum = 0;
    if (column != null && shouldEqual != null) {
      final data = await _db.rawQuery(
          "SELECT type, owned FROM $cellar WHERE $column = '$shouldEqual'");
      data.forEach((m) => sum = sum + m['owned']);
    } else {
      final data = await _db.rawQuery("SELECT type, owned FROM $cellar");
      data.forEach((m) => sum = sum + m['owned']);
    }
    return sum;
  }

  Future<double> getCellarWorth() async {
    double sum = 0;
    final data = await _db.rawQuery("SELECT price, owned FROM $cellar");
    data.forEach((m) => sum = sum + m['price'] * m['owned']);
    return sum;
  }

  Future decrementWine(Wine wine) async {
    if (wine.owned == 0)
      await removeWine(wine);
    else
      await updateWine(newWine: wine);
  }
}
