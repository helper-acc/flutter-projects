import 'package:lab02/database/database_helper.dart';
import 'package:lab02/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper implements DatabaseHelper {
  static final SQLiteHelper instance = SQLiteHelper._init();
  static Database? _database;

  SQLiteHelper._init();

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''create table $usersTable (
    ${UserModel.columnId} integer primary key autoincrement,
    ${UserModel.columnEmail} text not null unique,
    ${UserModel.columnName} text not null,
    ${UserModel.columnPhone} text not null,
    ${UserModel.columnPassword} text not null,
    ${UserModel.columnGender} text not null
    )''');
  }

  Future<Database> _initDB(String filename) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, filename);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDB('pizza_order.db');
      return _database;
    }
  }

  @override
  Future<void> insertUser(User user) async {
    final db = await instance.database;
    await db!.insert(usersTable, user.toMap());
  }

  @override
  Future<User> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db!.query(
      usersTable,
      columns: UserModel.allColumns,
      where: '${UserModel.columnEmail} = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      throw Exception('$email not found.');
    }
  }

  @override
  Future<User> getUserLoggedIn(String email, String password) async {
    final db = await instance.database;
    final maps = await db!.query(
      usersTable,
      columns: UserModel.allColumns,
      where: '${UserModel.columnEmail} = ? and ${UserModel.columnPassword} = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      throw Exception('$email not found.');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    final db = await instance.database;
    db!.update(
      usersTable,
      user.toMap(),
      where: '${UserModel.columnId} = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    final db = await instance.database;
    db!.delete(
      usersTable,
      where: '${UserModel.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db!.close();
  }
}
