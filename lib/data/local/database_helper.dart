import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

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
      version: 2, //  Incrementato per aggiungere nuova tabella
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabella pasti pianificati
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

    // Tabella cache ricette
    await db.execute('''
      CREATE TABLE recipe_cache (
        id TEXT PRIMARY KEY,
        name TEXT,
        image TEXT,
        ingredients TEXT,
        isVegan INTEGER,
        publisher TEXT,
        servings INTEGER,
        cookingTime INTEGER,
        cached_at INTEGER
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Aggiunge tabella cache se aggiorna da versione 1
      await db.execute('''
        CREATE TABLE recipe_cache (
          id TEXT PRIMARY KEY,
          name TEXT,
          image TEXT,
          ingredients TEXT,
          isVegan INTEGER,
          publisher TEXT,
          servings INTEGER,
          cookingTime INTEGER,
          cached_at INTEGER
        )
      ''');
    }
  }

  // ==================== PASTI PIANIFICATI ====================

  Future<int> insertMeal(Map<String, dynamic> meal) async {
    final db = await database;
    return await db.insert('planned_meals', meal);
  }

  Future<List<Map<String, dynamic>>> getMealsForDay(int day) async {
    final db = await database;
    final results = await db.query(
      'planned_meals',
      where: 'day = ?',
      whereArgs: [day],
      orderBy: 'mealType ASC',
    );
    
    // Parse ingredienti da JSON string a List
    return results.map((meal) {
      return {
        'id': meal['id'],
        'day': meal['day'],
        'mealType': meal['mealType'],
        'name': meal['mealName'], 
        'image': meal['mealImage'], 
        'ingredients': meal['ingredients'] != null
            ? jsonDecode(meal['ingredients'] as String)
            : [],
        'isVegan': meal['isVegan'] == 1,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllMeals() async {
    final db = await database;
    return await db.query('planned_meals', orderBy: 'day ASC, mealType ASC');
  }

  Future<int> deleteMeal(int id) async {
    final db = await database;
    return await db.delete('planned_meals', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllMeals() async {
    final db = await database;
    await db.delete('planned_meals');
  }

  // ==================== CACHE RICETTE ====================

  Future<Map<String, dynamic>?> getCachedRecipe(String recipeId) async {
    final db = await database;
    
    final result = await db.query(
      'recipe_cache',
      where: 'id = ?',
      whereArgs: [recipeId],
    );
    
    if (result.isEmpty) return null;
    
    final cached = result.first;
    
    return {
      'id': cached['id'],
      'name': cached['name'],
      'image': cached['image'],
      'ingredients': cached['ingredients'] != null 
          ? jsonDecode(cached['ingredients'] as String)
          : [],
      'isVegan': cached['isVegan'] == 1,
      'isVegetarian': true,
      'publisher': cached['publisher'],
      'servings': cached['servings'],
      'cookingTime': cached['cookingTime'],
    };
  }

  Future<void> cacheRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    
    await db.insert(
      'recipe_cache',
      {
        'id': recipe['id'],
        'name': recipe['name'],
        'image': recipe['image'],
        'ingredients': jsonEncode(recipe['ingredients'] ?? []),
        'isVegan': recipe['isVegan'] == true ? 1 : 0,
        'publisher': recipe['publisher'],
        'servings': recipe['servings'],
        'cookingTime': recipe['cookingTime'],
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clearRecipeCache() async {
    final db = await database;
    await db.delete('recipe_cache');
  }

  Future<int> getCachedRecipesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM recipe_cache');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}