import 'package:flutter/widgets.dart';
import 'package:wine_cellar/core/services/api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:wine_cellar/core/services/wine_service.dart';
import 'package:wine_cellar/ui/constants.dart';

import '../base_model.dart';

class ExportModel extends BaseModel {
  final WineService _db;
  final Api _api;
  final TextEditingController controller = TextEditingController();
  bool export = false;
  final RegExp regExp = RegExp(r"^[a-zA-Z0-9_\s-]+$");

  ExportModel({WineService db, Api api})
      : _db = db,
        _api = api;

  List<Map<String,dynamic>> wines;

  List<List<String>> rows;

  String get text => controller.text;

  Future getCurrentDatabase() async {
    wines = await _db.getExportData();
    rows = [csvTitle];
  }

  Future postWine() async {
    await _api.exportCellar();
  }

  Future getCellar()async{
    await _api.importCellar();
  }


  void startExport() {
    export = !export;
    controller.clear();
    notifyListeners();
  }

  Future<bool> exportToCsv() async {
    if (!regExp.hasMatch(controller.text)) {
      return false;
    } else {
      final String filename = controller.text;
      await getCurrentDatabase();
      for (int i = 0; i < wines.length; i++) {
        List<String> row = List();
        row.add(wines[i]['name'] ?? "");
        row.add(wines[i]['type'] ?? "");
        row.add(wines[i]['aoo'] ?? "");
        row.add(wines[i]['country'] ?? "");
        row.add(wines[i]['vintage'].toString());
        row.add(wines[i]['grapes'] ?? "");
        row.add(wines[i]['owned'].toString());
        row.add(wines[i]['size'] ?? "");
        row.add(wines[i]['image'] ?? "");
        row.add(wines[i]['time'] ?? "");
        row.add(wines[i]['comment'] ?? "");
        row.add(wines[i]['price']?.toString() ?? "");
        row.add(wines[i]['rating']?.toString() ?? "");
        rows.add(row);
      }
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);

      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        //store file in documents folder
        final String dir =
            (await getExternalStorageDirectory()).absolute.path;
        print("The file is at: $dir/$filename.csv");
        final File f = File("$dir/$filename.csv");

        // convert rows to String and write as csv file

        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);
      }
      return true;
    }
  }
}
