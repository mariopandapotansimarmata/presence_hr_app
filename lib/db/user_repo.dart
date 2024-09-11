import 'package:presence_hr_app/db/db_sqlite.dart';
import 'package:presence_hr_app/model/user_model.dart';

class UserRepo {
  PresenceDb presenceDb = PresenceDb.instance;
  static final UserRepo instance = UserRepo._();

  static const String tableName = "users";

  UserRepo._();

  Future<void> create(User user) async {
    final db = await presenceDb.database;
    await db.insert(tableName, user.toJson());
  }

  Future<User> read(String userName) async {
    final db = await presenceDb.database;
    final maps = await db.query(
      tableName,
      columns: ["user_name, name,"],
      where: 'user_name = ?',
      whereArgs: [userName],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('user name $userName not found');
    }
  }

  Future<List<User>> readAll() async {
    final db = await presenceDb.database;
    const orderBy = 'exp DESC';
    final result = await db.query(tableName,
        columns: ["user_name, name,"], orderBy: orderBy);
    print(result);
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> delete(String userName) async {
    final db = await presenceDb.database;
    return await db.delete(
      tableName,
      where: 'user_name = ?',
      whereArgs: [userName],
    );
  }
}
