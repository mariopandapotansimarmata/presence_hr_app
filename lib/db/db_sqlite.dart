import 'package:sqflite/sqflite.dart';

class PresenceDb {
  static final PresenceDb instance = PresenceDb._();

  static Database? _database;

  PresenceDb._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/presence.db';
    print(databasePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      user_name VARCHAR PRIMARY KEY,
      name VARCHAR NOT NULL,
      password VARCHAR NOT NULL
    )
  ''');

    await db.execute('''
  CREATE TABLE presence (
    presence_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_name TEXT NOT NULL,
    presence_time TEXT NOT NULL,
    go_home_time TEXT ,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL
  )
''');

    // Using a batch to execute multiple inserts
    Batch batch = db.batch();

    // Add SQL commands to the batch
    batch.insert('users', {
      'user_name': 'john_doe',
      'name': 'John Doe',
      'password': 'password123'
    });
    batch.insert('users', {
      'user_name': 'jane_smith',
      'name': 'Jane Smith',
      'password': 'password456'
    });

    final now = DateTime.now();
    batch.insert('presence', {
      'user_name': 'john_doe',
      'presence_time': now.subtract(Duration(hours: 1)).toIso8601String(),
      'go_home_time': now.toIso8601String(),
      'latitude': -7.756449440996939,
      'longitude': 110.40840409528828
    });
    batch.insert('presence', {
      'user_name': 'john_doe',
      'presence_time': now.subtract(Duration(hours: 2)).toIso8601String(),
      'go_home_time': now.subtract(Duration(hours: 1)).toIso8601String(),
      'latitude': -7.756549440996939,
      'longitude': 110.40850409528828
    });
    batch.insert('presence', {
      'user_name': 'jane_smith',
      'presence_time': now.subtract(Duration(hours: 3)).toIso8601String(),
      'go_home_time': now.subtract(Duration(hours: 2)).toIso8601String(),
      'latitude': -7.757449440996939,
      'longitude': 110.40940409528828
    });
    batch.insert('presence', {
      'user_name': 'jane_smith',
      'presence_time': now.subtract(Duration(hours: 4)).toIso8601String(),
      'go_home_time': now.subtract(Duration(hours: 3)).toIso8601String(),
      'latitude': -7.758449440996939,
      'longitude': 110.41040409528828
    });
    print("berhasil");
    await batch.commit(noResult: true);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
