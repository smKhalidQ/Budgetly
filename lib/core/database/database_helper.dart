import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database?> get db async {
    if (_db == null) {
      _db = await _initializeDb();
      return _db;
    }
    return _db;
  }

  static Future<Database> _initializeDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'budgettly.db');
    try {
      Database myDb = await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
      return myDb;
    } on DatabaseException catch (e) {
      if (e.isOpenFailedError()) {
        throw Exception("database initialization failed");
      } else {
        throw Exception("query execution failed");
      }
    } catch (e) {
      throw Exception("Unknown error opening database: ${e.toString()}");
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''CREATE TABLE category (
        categoryId INTEGER PRIMARY KEY,
        categoryName TEXT NOT NULL,
        categoryColor TEXT,
        categoryIcon TEXT,
        allocatedAmount REAL NOT NULL,
        storedSpentAmount REAL NOT NULL DEFAULT 0
      )''');

      await db.execute('''CREATE TABLE subcategory (
        subcategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
        subcategoryName TEXT NOT NULL,
        subcategoryColor TEXT,
        subcategoryIcon TEXT,
        subcategorySpentAmount TEXT,
        parentCategoryId INTEGER NOT NULL,
        FOREIGN KEY (parentCategoryId) REFERENCES category (categoryId) ON DELETE CASCADE
      )''');

      await db.execute('''CREATE TABLE userInfo (
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT NOT NULL,
        userImg TEXT NOT NULL,
        monthlySalary TEXT NOT NULL,
        currency TEXT NOT NULL,
        storedSpentAmount REAL NOT NULL DEFAULT 0
      )''');

      await db.execute('''CREATE TABLE `transaction` (
        transactionId INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryId INTEGER NOT NULL,
        subcategoryId INTEGER,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'expense',
        note TEXT,
        FOREIGN KEY (categoryId) REFERENCES category (categoryId) ON DELETE CASCADE,
        FOREIGN KEY (subcategoryId) REFERENCES subcategory (subcategoryId) ON DELETE SET NULL
      )''');
    } on DatabaseException catch (_) {
      throw Exception("sql syntax error");
    }
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _addColumnIfMissing(
        db, 'transaction', 'subcategoryId', 'INTEGER');
      await _addColumnIfMissing(
        db, 'transaction', 'type', "TEXT NOT NULL DEFAULT 'expense'");
    }
  }

  /// Adds [column] to [table] only when it isn't already present, so reruns of
  /// a migration on a partially-upgraded database don't crash on duplicates.
  static Future<void> _addColumnIfMissing(
    Database db,
    String table,
    String column,
    String definition,
  ) async {
    final info = await db.rawQuery('PRAGMA table_info(`$table`)');
    final exists = info.any((row) => row['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE `$table` ADD COLUMN $column $definition');
    }
  }

  static Future<void> removeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "budgettly.db");
    await deleteDatabase(path);
  }

  static Future<void> clearCategoryTable() async {
    final dbClient = await db;
    await dbClient?.delete('category');
  }

  static Future<void> clearSubcategoryTable() async {
    final dbClient = await db;
    await dbClient?.delete('subcategory');
  }
}
