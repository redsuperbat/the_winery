import 'package:sqflite/sqflite.dart';

/*import 'package:path/path.dart';
import 'package:wine_cellar/core/models/wine.dart';*/

class WineDb {
  Database database;
  String currentTable = "one";

/*  Future<void> iniDb() async {
    if (database == null) {
      print("Im creating my database");
      database =
          await openDatabase(join(await getDatabasesPath(), 'wine_database.db'),
              onOpen: (db) => db.execute("CREATE TABLE one("
                  "id INTEGER PRIMARY KEY, "
                  "name TEXT, "
                  "vintage INTEGER, "
                  "aoo TEXT, "
                  "country TEXT, "
                  "type TEXT, "
                  "grapes TEXT, "
                  "size TEXT, "
                  "owned INTEGER, "
                  "time TEXT, "
                  "comment TEXT, "
                  "rating DOUBLE, "
                  "price DOUBLE, "
                  "nv INTEGER, "
                  "image TEXT)"),
              version: 2);
      print("im finished with creating the database");
    }
  }*/

/*  Future createNewTable(String name) async {
    await database.execute("CREATE TABLE $name("
        "id INTEGER PRIMARY KEY, "
        "name TEXT, "
        "vintage INTEGER, "
        "aoo TEXT, "
        "country TEXT, "
        "type TEXT, "
        "grapes TEXT, "
        "size TEXT, "
        "owned INTEGER, "
        "time TEXT, "
        "comment TEXT, "
        "rating DOUBLE, "
        "price DOUBLE, "
        "nv INTEGER, "
        "image TEXT)");
    changeCellar(name);
  }*/

  /*void changeCellar(String cellarName) {
    currentTable = cellarName;
    print(currentTable);
  }

  Future<void> insertWine(Wine wine) async {
    await database.insert(currentTable, wine.toJson());
  }*/

  Future<void> importDatabase(Map map) async {
    await database.insert(currentTable, map);
  }

/*  Future<double> getCellarWorth() async {
    double sum = 0;
    final data =
        await database.rawQuery("SELECT price, owned FROM $currentTable");
    data.forEach((m) => sum = sum + m['price'] * m['owned']);
    print('Data is: $data sum is $sum');
    return sum;
  }*/

/*  Future<int> getStatistics({String column, String shouldEqual}) async {
    int sum = 0;
    if (column != null && shouldEqual != null) {
      final data = await database.rawQuery(
          "SELECT type, owned FROM $currentTable WHERE $column = '$shouldEqual'");
      data.forEach((m) => sum = sum + m['owned']);
    } else {
      final data =
          await database.rawQuery("SELECT type, owned FROM $currentTable");
      data.forEach((m) => sum = sum + m['owned']);
    }
    return sum;
  }*/

  Future<List<Map>> getWinesForExport() async {
    final List<Map<String, dynamic>> _wines =
        await database.query(currentTable, orderBy: 'time DESC');
    return _wines;
  }

/*  Future<List<Wine>> getAllWines({String orderBy = 'time'}) async {
    final List<Map<String, dynamic>> _wines =
        await database.query(currentTable, orderBy: '$orderBy DESC');
    List<Wine> wines = [];
    _wines.forEach((w) => wines.add(Wine.fromJson(w)));
    wines.forEach((wine) => print(wine.image));
    return wines;
  }*/

/*  Future<int> getId() async {
    int data = Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT(*) FROM $currentTable"));
    print(data);
    return data + 1;
  }*/

/*  Future<void> updateWine(Wine wine) async {
    await database.update(currentTable, wine.toJson(),
        where: "id = ?", whereArgs: [wine.id]);
  }

  Future<List<Wine>> filterWine({String query, String column}) async {
    final List<Map<String, dynamic>> _wines = await database
        .query(currentTable, where: '$column = ?', whereArgs: [query]);
    List<Wine> wines = [];
    _wines.forEach((w) => wines.add(Wine.fromJson(w)));
    return wines;
  }

  Future<List<Wine>> searchWine(String name) async {
    final List<Map<String, dynamic>> _wines = await database
        .query(currentTable, where: "name LIKE ?", whereArgs: ['%$name%']);
    List<Wine> wines = [];
    _wines.forEach((w) => wines.add(Wine.fromJson(w)));
    return wines;
  }*/

/*  void deleteWine(int id) {
    database.delete(currentTable, where: "id = ?", whereArgs: [id]);
  }

  Future dropDatabase() async {
    await database.close();
    await deleteDatabase(database.path);
    database = null;
  }*/
}
