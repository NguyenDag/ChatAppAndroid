import 'package:myapp/models/friend.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/message.dart';

class MessageDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id TEXT PRIMARY KEY,
            friendId TEXT,
            content TEXT,
            images TEXT,
            files TEXT,
            isSend INTEGER,
            messageType INTEGER,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  // ================= Message methods =================
  static Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Message>> getMessages(String friendId) async {
    final db = await database;
    final maps = await db.query(
      'messages',
      where: 'friendId = ?',
      whereArgs: [friendId],
      orderBy: 'createdAt ASC',
    );

    return maps.map((map) => Message.fromMap(map)).toList();
  }

  static Future<void> clearMessages() async {
    final db = await database;
    await db.delete('messages');
  }
}
