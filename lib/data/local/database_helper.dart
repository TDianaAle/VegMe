import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vegme.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planned_meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day INTEGER NOT NULL,
        mealType TEXT NOT NULL,
        mealId TEXT NOT NULL,
        mealName TEXT NOT NULL,
        mealImage TEXT,
        ingredients TEXT,
        isVegan INTEGER NOT NULL
      )
    ''');
  }

  // salves meal
  Future<int> insertMeal(Map<String, dynamic> meal) async {
    final db = await database;
    return await db.insert('planned_meals', meal);
  }

  // get all meals of the day
  Future<List<Map<String, dynamic>>> getMealsForDay(int day) async {
    final db = await database;
    return await db.query(
      'planned_meals',
      where: 'day = ?',
      whereArgs: [day],
      orderBy: 'mealType ASC',
    );
  }

  // gets all meals of the week
  Future<List<Map<String, dynamic>>> getAllMeals() async {
    final db = await database;
    return await db.query('planned_meals', orderBy: 'day ASC, mealType ASC');
  }

  // delete meal
  Future<int> deleteMeal(int id) async {
    final db = await database;
    return await db.delete('planned_meals', where: 'id = ?', whereArgs: [id]);
  }

  // cleaning
  Future<void> clearAllMeals() async {
    final db = await database;
    await db.delete('planned_meals');
  }
}