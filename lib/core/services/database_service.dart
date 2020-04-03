import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database _db;
  static const cellarTable = "(id INTEGER PRIMARY KEY, "
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
      "image TEXT)";

  Future<void> iniDb() async {
    if (_db == null) {
      print("Opening database and creating required tables");
      _db = await openDatabase(
          join(await getDatabasesPath(), 'wine_database.db'),
          onCreate: (db, version) async => await createTables(db),
          version: 1);
      print("Finished with opening database");
    }
  }

  Future<List<Map<String, dynamic>>> getTable(String table) async {
    final response = await _db.query(table);
    return response;
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    final response = await _db.rawQuery(query);
    return response;
  }

  Future<void> insert(String table, Map<String, dynamic> map) async {
    await _db.insert(table, map);
  }

  Future<void> update(String table, Map<String, dynamic> map) async {
    await _db.update(table, map, where: "id = ?", whereArgs: [map['id']]);
  }

  Future<void> remove(String table, int id) async {
    await _db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getId(String table) async {
    int data = Sqflite.firstIntValue(
        await _db.rawQuery("SELECT COUNT(*) FROM $table"));
    return data + 1;
  }

/*  Future<int> getStatistics(String table,
      {String column, String shouldEqual}) async {
    int sum = 0;
    if (column != null && shouldEqual != null) {
      final data = await _db.rawQuery(
          "SELECT type, owned FROM $table WHERE $column = '$shouldEqual'");
      data.forEach((m) => sum = sum + m['owned']);
    } else {
      final data = await _db.rawQuery("SELECT type, owned FROM $table");
      data.forEach((m) => sum = sum + m['owned']);
    }
    return sum;
  }*/

  Future<List<Map<String, dynamic>>> search(
      String table, String column, String query) async {
    final List<Map<String, dynamic>> request = await _db
        .query(table, where: "$column LIKE ?", whereArgs: ['%$query%']);

    return request;
  }

  Future<List<Map<String, dynamic>>> filter(
      String table, String query, String column) async {
    final List<Map<String, dynamic>> filter =
        await _db.query(table, where: '$column = ?', whereArgs: [query]);

    return filter;
  }

  Future<void> createTable(String name) async {
    await _db.execute('CREATE TABLE $name$cellarTable');
  }

  Future<void> createTables(Database db) async {
    await db.execute("CREATE TABLE profiles("
        "id INTEGER PRIMARY KEY, "
        "cellarName TEXT, "
        "isDefault INTEGER, "
        "databaseKey TEXT, "
        "displayName TEXT, "
        "color INTEGER)");
  }

  Future<void> deleteTable(String table) async {
    await _db.execute("DROP TABLE $table");
  }

  Future dropDatabase() async {
    await _db.close();
    await deleteDatabase(_db.path);
    _db = null;
  }
}
