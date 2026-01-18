import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefsHelper {
  // Salva pasti per un giorno specifico
  static Future<void> saveDayMeals(int day, Map<String, List<Map<String, dynamic>>> meals) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'meals_day_$day';
    final jsonString = jsonEncode(meals);
    await prefs.setString(key, jsonString);
    print('✅ Salvato giorno $day: $jsonString'); // Debug
  }

  // Carica pasti per un giorno
  static Future<Map<String, List<Map<String, dynamic>>>> loadDayMeals(int day) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'meals_day_$day';
    final jsonString = prefs.getString(key);
    
    print('📖 Caricato giorno $day: $jsonString'); // Debug
    
    if (jsonString == null) {
      return _createEmptyDay();
    }
    
    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      
      Map<String, List<Map<String, dynamic>>> result = {};
      decoded.forEach((mealType, meals) {
        result[mealType] = List<Map<String, dynamic>>.from(
          (meals as List).map((m) => Map<String, dynamic>.from(m))
        );
      });
      
      return result;
    } catch (e) {
      print('❌ Errore caricamento: $e');
      return _createEmptyDay();
    }
  }

  // Carica tutti i pasti della settimana
  static Future<Map<int, Map<String, List<Map<String, dynamic>>>>> loadMeals() async {
    Map<int, Map<String, List<Map<String, dynamic>>>> week = {};
    for (int i = 0; i < 7; i++) {
      week[i] = await loadDayMeals(i);
    }
    return week;
  }

  // Salva tutti i pasti
  static Future<void> saveMeals(Map<int, Map<String, List<Map<String, dynamic>>>> allMeals) async {
    for (var entry in allMeals.entries) {
      await saveDayMeals(entry.key, entry.value);
    }
  }

  // Crea giorno vuoto
  static Map<String, List<Map<String, dynamic>>> _createEmptyDay() {
    return {
      'colazione': [],
      'pranzo': [],
      'cena': [],
    };
  }

  // Pulisci tutto
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 7; i++) {
      await prefs.remove('meals_day_$i');
    }
  }
}