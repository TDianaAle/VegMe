import 'package:http/http.dart' as http;
import 'dart:convert';

class MealApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  
  // not vegan ingredients to filter 
  static const List<String> nonVeganIngredients = [
    'chicken', 'beef', 'pork', 'fish', 'meat', 
    'salmon', 'tuna', 'turkey', 'lamb', 'bacon',
    'prawn', 'shrimp', 'egg', 'milk', 'cheese', 
    'butter', 'cream', 'yogurt', 'honey',
  ];
  
  // search recipes by name
  Future<List<Map<String, dynamic>>> searchMeals(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<Map<String, dynamic>> meals = 
              List<Map<String, dynamic>>.from(data['meals']);
          return meals;
        }
      }
      return [];
    } catch (e) {
      print('Errore ricerca: $e');
      return [];
    }
  }
  
  //  vegetarian recepies fron category
  Future<List<Map<String, dynamic>>> getVegetarianMeals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=Vegetarian'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return List<Map<String, dynamic>>.from(data['meals']);
        }
      }
      return [];
    } catch (e) {
      print('Errore: $e');
      return [];
    }
  }
  
  // details of full recipe
  Future<Map<String, dynamic>?> getMealDetails(String mealId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lookup.php?i=$mealId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return data['meals'][0];
        }
      }
      return null;
    } catch (e) {
      print('Errore dettagli: $e');
      return null;
    }
  }
  
  // verifies if recipe is vegan (no eggs, milk, cheese etc)
  bool isVegan(Map<String, dynamic> meal) {
    List<String> veganOnly = ['egg', 'milk', 'cheese', 'butter', 'cream', 'yogurt', 'honey'];
    
    for (int i = 1; i <= 20; i++) {
      String? ingredient = meal['strIngredient$i']?.toString().toLowerCase();
      if (ingredient != null && ingredient.isNotEmpty) {
        for (var nonVegan in veganOnly) {
          if (ingredient.contains(nonVegan)) {
            return false;
          }
        }
      }
    }
    return true;
  }
  
  // verifies if recipe is vegetarian (no meat, no fish)
  bool isVegetarian(Map<String, dynamic> meal) {
    List<String> meatFish = [
      'chicken', 'beef', 'pork', 'fish', 'meat', 
      'salmon', 'tuna', 'turkey', 'lamb', 'bacon',
      'prawn', 'shrimp',
    ];
    
    for (int i = 1; i <= 20; i++) {
      String? ingredient = meal['strIngredient$i']?.toString().toLowerCase();
      if (ingredient != null && ingredient.isNotEmpty) {
        for (var meat in meatFish) {
          if (ingredient.contains(meat)) {
            return false;
          }
        }
      }
    }
    return true;
  }
  
  // Estract ingredients fron recipe
  List<Map<String, String>> getIngredients(Map<String, dynamic> meal) {
    List<Map<String, String>> ingredients = [];
    
    for (int i = 1; i <= 20; i++) {
      String? ingredient = meal['strIngredient$i'];
      String? measure = meal['strMeasure$i'];
      
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add({
          'name': ingredient,
          'measure': measure ?? '',
        });
      }
    }
    
    return ingredients;
  }
}