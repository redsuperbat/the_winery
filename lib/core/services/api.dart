import 'dart:convert';

import 'package:http/http.dart' as http;

import 'wine_db_service.dart';

class Api {
  static const endPoint = "https://cubitum.serveo.net/api";
  static final client = http.Client();
  final WineDb db;

  Api(this.db);

  Future exportCellar() async {
    var rawData = await db.getWinesForExport();
    final data = json.encode({"wines": rawData});
    final response = await client.post(
      '$endPoint/cellars',
      body: data,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    print(response.statusCode);
  }

  Future<bool> importCellar() async {
    final request = await client.get('$endPoint/cellars?filter[where][id]=5d189af2488da778d8fb95ce', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    if (request.statusCode == 200) {
      final parsed = json.decode(utf8.decode(request.bodyBytes));
      final List wines = parsed[0]["wines"];
      for (int i = 0; i < wines.length; i++) {
        await db.importDatabase(wines[i]);
      }
      return true;
    } else
      return false;
  }
}
