import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tugas_paa/models/user_model.dart';

class UserDB {
  static Database? _database;

  // * CREATE TABLE
  static Future<Database> initDatabase() async {
    _database = await openDatabase(join(await getDatabasesPath(), "user_db.db"),
        onCreate: (db, version) {
      return db.execute("CREATE TABLE USERS("
          "id INTEGER PRIMARY KEY,"
          "username VARCHAR(100) NOT NULL,"
          "email VARCHAR(100) NOT NULL,"
          "password VARCHAR(255) NOT NULL,"
          "image VARCHAR(255) NOT NULL,"
          "create_at VARCHAR(100) NOT NULL,"
          "update_at VARCHAR(100) NOT NULL);");
    }, version: 1);

    return _database!;
  }

  // ! CONNECT DB
  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDatabase();
    }
  }

  // ? CREATE
  static Future<void> insertData(UserModel user) async {
    final Database db = await getDatabase();
    await db.insert(
      "USERS",
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ? CREATE
  static Future<void> insertToken(UserModel user) async {
    final Database db = await getDatabase();
    await db.insert(
      "USERS",
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // * READ
  static Future<UserModel> getData(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM USERS WHERE ID = $id");

    return UserModel.fromJson(maps.first);
  }

  // ? UPDATE
  static Future<void> updateData(UserModel user) async {
    final db = await getDatabase();
    await db.update(
      "USERS",
      user.toJson(),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }

  // ! DELETE
  static Future<void> deleteData(int id) async {
    final db = await getDatabase();
    await db.delete(
      "USERS",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
