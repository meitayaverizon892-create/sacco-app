import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/member.dart';

class DBHelper {
  static Database? _database;

  // Get database (create if doesn't exist)
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'sacco_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE members(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            memberNumber TEXT NOT NULL,
            savings REAL NOT NULL,
            phone TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE - Add a new member
  static Future<int> insertMember(Member member) async {
    final db = await database;
    return await db.insert('members', member.toMap());
  }

  // READ - Get all members
  static Future<List<Member>> getMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('members');
    return List.generate(maps.length, (i) => Member.fromMap(maps[i]));
  }

  // UPDATE - Edit an existing member
  static Future<int> updateMember(Member member) async {
    final db = await database;
    return await db.update(
      'members',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  // DELETE - Remove a member
  static Future<int> deleteMember(int id) async {
    final db = await database;
    return await db.delete(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SEARCH - Find members by name
  static Future<List<Member>> searchMembers(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'members',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) => Member.fromMap(maps[i]));
  }
}
