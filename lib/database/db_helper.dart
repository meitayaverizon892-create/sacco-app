import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/member.dart';
import '../models/loan.dart';
import '../models/sacco_transaction.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'sacco_app.db');
    return await openDatabase(
      path,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE members(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            memberNumber TEXT NOT NULL UNIQUE,
            savings REAL NOT NULL,
            phone TEXT NOT NULL,
            passwordHash TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE loans(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            memberId INTEGER NOT NULL,
            amount REAL NOT NULL,
            purpose TEXT NOT NULL,
            durationMonths INTEGER NOT NULL,
            guarantorName TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'Pending',
            dateApplied TEXT NOT NULL,
            FOREIGN KEY (memberId) REFERENCES members (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            memberId INTEGER NOT NULL,
            type TEXT NOT NULL,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY (memberId) REFERENCES members (id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE members ADD COLUMN passwordHash TEXT');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS loans(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              memberId INTEGER NOT NULL,
              amount REAL NOT NULL,
              purpose TEXT NOT NULL,
              durationMonths INTEGER NOT NULL,
              guarantorName TEXT NOT NULL,
              status TEXT NOT NULL DEFAULT 'Pending',
              dateApplied TEXT NOT NULL,
              FOREIGN KEY (memberId) REFERENCES members (id) ON DELETE CASCADE
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS transactions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              memberId INTEGER NOT NULL,
              type TEXT NOT NULL,
              amount REAL NOT NULL,
              date TEXT NOT NULL,
              FOREIGN KEY (memberId) REFERENCES members (id) ON DELETE CASCADE
            )
          ''');
        }
      },
    );
  }

  // ================= MEMBERS =================

  static Future<int> insertMember(Member member) async {
    final db = await database;
    return await db.insert('members', member.toMap());
  }

  static Future<List<Member>> getMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('members');
    return List.generate(maps.length, (i) => Member.fromMap(maps[i]));
  }

  static Future<Member?> getMemberByNumber(String memberNumber) async {
    final db = await database;
    final maps = await db.query(
      'members',
      where: 'memberNumber = ?',
      whereArgs: [memberNumber],
    );
    if (maps.isEmpty) return null;
    return Member.fromMap(maps.first);
  }

  static Future<int> updateMember(Member member) async {
    final db = await database;
    return await db.update(
      'members',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  static Future<int> deleteMember(int id) async {
    final db = await database;
    return await db.delete(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Member>> searchMembers(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'members',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) => Member.fromMap(maps[i]));
  }

  // ================= LOANS =================

  static Future<int> insertLoan(Loan loan) async {
    final db = await database;
    return await db.insert('loans', loan.toMap());
  }

  static Future<List<Loan>> getLoansForMember(int memberId) async {
    final db = await database;
    final maps = await db.query(
      'loans',
      where: 'memberId = ?',
      whereArgs: [memberId],
    );
    return List.generate(maps.length, (i) => Loan.fromMap(maps[i]));
  }

  static Future<int> updateLoanStatus(int loanId, String status) async {
    final db = await database;
    return await db.update(
      'loans',
      {'status': status},
      where: 'id = ?',
      whereArgs: [loanId],
    );
  }

  // ================= TRANSACTIONS =================

  static Future<int> insertTransaction(SaccoTransaction tx) async {
    final db = await database;
    return await db.insert('transactions', tx.toMap());
  }

  static Future<List<SaccoTransaction>> getTransactionsForMember(
      int memberId) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'memberId = ?',
      whereArgs: [memberId],
    );
    return List.generate(maps.length, (i) => SaccoTransaction.fromMap(maps[i]));
  }
}