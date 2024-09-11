import 'package:presence_hr_app/db/db_sqlite.dart';
import 'package:presence_hr_app/model/presence_model.dart';

class PresenceRepo {
  PresenceDb presenceDb = PresenceDb.instance;
  static final PresenceRepo instance = PresenceRepo._();

  static const String tableName = "presence";

  PresenceRepo._();

  Future<void> create(Presence presence) async {
    final db = await presenceDb.database;
    await db.insert(tableName, presence.toJson());
  }

  Future<Presence> read(String userName) async {
    final db = await presenceDb.database;
    final maps = await db.query(
      tableName,
      columns: [
        "presence_id",
        "presence_time",
        "user_name",
        "go_home_time",
        "latitude",
        "longitude"
      ],
      where: 'user_name = ? AND go_home_time IS NULL',
      whereArgs: [userName],
    );

    if (maps.isNotEmpty) {
      return Presence.fromJson(maps.first);
    } else {
      throw Exception('user name $userName not found');
    }
  }

  Future<List<Presence>> readAll(String userName) async {
    final db = await presenceDb.database;
    const orderBy = 'presence_time';
    final result = await db.query(tableName,
        columns: [
          "presence_id",
          "presence_time",
          "user_name",
          "go_home_time",
          "latitude",
          "longitude"
        ],
        where: 'user_name = ?',
        whereArgs: [userName],
        orderBy: orderBy);
    print(result);
    return result.map((json) => Presence.fromJson(json)).toList();
  }

  Future<int> update(Presence presence) async {
    final db = await presenceDb.database;
    return db.update(
      tableName,
      presence.toJson(),
      where: 'presence_id = ?',
      whereArgs: [presence.presenceId],
    );
  }
}
