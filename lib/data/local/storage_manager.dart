import 'package:flutter/foundation.dart' show kIsWeb;
import 'shared_prefs_helper.dart';
import 'database_helper.dart';
import 'dart:convert';

class StorageManager {
  static final StorageManager instance = StorageManager._init();
  StorageManager._init();

  // Saves a meal
  Future<void> saveMeal(int day, String mealType, Map<String, dynamic> meal) async {
    if (kIsWeb) {
      // WEB: uses SharedPreferences
      final allMeals = await SharedPrefsHelper.loadMeals();
      allMeals[day]![mealType]!.add(meal);
      await SharedPrefsHelper.saveMeals(allMeals);
    } else {
      // mobile: uses SQLite

      await DatabaseHelper.instance.insertMeal({
        'day': day,
        'mealType': mealType,
        'mealId': meal['id'],
        'mealName': meal['name'],
        'mealImage': meal['image'] ?? '',
        'ingredients': jsonEncode(meal['ingredients'] ?? []),
        'isVegan': meal['isVegan'] ? 1 : 0,
      });
    }
  }

  // load meals for a specific day
  Future<Map<String, List<Map<String, dynamic>>>> getMealsForDay(int day) async {
    if (kIsWeb) {
      // WEB: usa SharedPreferences
      final allMeals = await SharedPrefsHelper.loadMeals();
      return allMeals[day] ?? {
        'colazione': [],
        'pranzo': [],
        'cena': [],
      };
    } else {
      // for mobile uses 
      final dbMeals = await DatabaseHelper.instance.getMealsForDay(day);
      
      Map<String, List<Map<String, dynamic>>> meals = {
        'colazione': [],
        'pranzo': [],
        'cena': [],
      };
      
      for (var meal in dbMeals) {
        String mealType = meal['mealType'];
        if (meals.containsKey(mealType)) {
          meals[mealType]!.add(meal);
        }
      }
      
      return meals;
    }
  }

  // delete meal
  Future<void> deleteMeal(int day, String mealType, dynamic mealId) async {
    if (kIsWeb) {
      // for web uses SharedPreferences
      final allMeals = await SharedPrefsHelper.loadMeals();
      
      if (mealId is int) {
        // Removes by index
        if (mealId < allMeals[day]![mealType]!.length) {
          allMeals[day]![mealType]!.removeAt(mealId);
        }
      } else {
        // Rimoves by id
        allMeals[day]![mealType]!.removeWhere((m) => m['id'] == mealId);
      }
      
      await SharedPrefsHelper.saveMeals(allMeals);
    } else {
      // MOBILE: usa SQLite
      await DatabaseHelper.instance.deleteMeal(mealId as int);
    }
  }

  // clear everything
  Future<void> clearAll() async {
    if (kIsWeb) {
      await SharedPrefsHelper.clearAll();
    } else {
      await DatabaseHelper.instance.clearAllMeals();
    }
  }
}