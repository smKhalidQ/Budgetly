import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../error/exceptions.dart';

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
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
      return myDb;
    } on DatabaseException catch (e) {
      if (e.isOpenFailedError()) {
        throw DatabaseInitializationException("Failed to initialize or open database.");
      } else {
        throw QueryExecutionException("Query execution failed: ${e.toString()}");
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
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (categoryId) REFERENCES category (categoryId) ON DELETE CASCADE
      )''');

      print("Tables successfully created");
    } on DatabaseException catch (e) {
      throw SQLSyntaxException("SQL syntax error: ${e.toString()}");
    }
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE userInfo ADD COLUMN userImg TEXT NOT NULL DEFAULT ""');
        print("Table userInfo upgraded successfully");
      } catch (e) {
        print("Error upgrading table userInfo: $e");
        throw SQLSyntaxException("Failed to upgrade table userInfo: ${e.toString()}");
      }
    }
  }

  // حذف كامل للقاعدة
  static Future<void> removeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "budgettly.db");
    await deleteDatabase(path);
    print("Database deleted");
  }

  // حذف بيانات جدول category
  static Future<void> clearCategoryTable() async {
    final dbClient = await db;
    await dbClient?.delete('category');
    print("Category table cleared");
  }

  // حذف بيانات جدول subcategory
  static Future<void> clearSubcategoryTable() async {
    final dbClient = await db;
    await dbClient?.delete('subcategory');
    print("Subcategory table cleared");
  }
}
