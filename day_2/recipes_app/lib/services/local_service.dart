import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recipes_app/models/MealsResponse.dart';

class LocalService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'meals.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            ${MealFields.idMeal} TEXT PRIMARY KEY,
            ${MealFields.strMeal} TEXT,
            ${MealFields.strInstructions} TEXT,
            ${MealFields.strCategory} TEXT,
            ${MealFields.strMealThumb} TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertMeal(Meals meal) async {
    final db = await database;
    final Map<String, dynamic> row = {
      MealFields.idMeal: meal.idMeal,
      MealFields.strMeal: meal.strMeal,
      MealFields.strInstructions: meal.strInstructions,
      MealFields.strCategory: meal.strCategory,
      MealFields.strMealThumb: meal.strMealThumb,
    };
    await db.insert(
      tableName,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteMeal(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '${MealFields.idMeal} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Meals>> getListFavoriteMeal() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((e) => Meals.fromJson(e)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '${MealFields.idMeal} = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  Future<Meals?> getMealById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '${MealFields.idMeal} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Meals.fromJson(maps.first);
    }
    return null;
  }
}