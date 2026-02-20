import 'package:http/http.dart' as http;
import 'dart:convert';
import '../local/database_helper.dart';

class MealApiService {
  static const String baseUrl = 'https://italianrecipeapi.onrender.com/api';
  
  // Cerca ricette vegetariane
  Future<List<Map<String, dynamic>>> getVegetarianMeals() async {
    print(' Chiamando API: $baseUrl/recipes/preview?type=vegetarian');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipes/preview?type=vegetarian'),
      );
      
      print(' Status code: ${response.statusCode}');
      print(' Body (primi 200 char): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(' JSON decodificato: success=${data['success']}, recipes count=${data['recipes']?.length}');
        if (data['success'] == true && data['recipes'] != null) {
          return List<Map<String, dynamic>>.from(data['recipes']);
        }
      }
      print(' Errore API: ${response.statusCode}');
      return [];
    } catch (e) {
      print(' Errore: $e');
      return [];
    }
  }
  
  // Cerca ricette vegane
  Future<List<Map<String, dynamic>>> getVeganMeals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipes/preview?type=vegan'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['recipes'] != null) {
          return List<Map<String, dynamic>>.from(data['recipes']);
        }
      }
      print('Errore API: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Errore: $e');
      return [];
    }
  }
  
  // Cerca entrambe (vegetariane + vegane)
  Future<List<Map<String, dynamic>>> getBothMeals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipes/preview?type=both'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['recipes'] != null) {
          return List<Map<String, dynamic>>.from(data['recipes']);
        }
      }
      print('Errore API: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Errore: $e');
      return [];
    }
  }
  
  // Cerca ricette per nome
  Future<List<Map<String, dynamic>>> searchMeals(String query, {String dietType = 'both'}) async {
  List<Map<String, dynamic>> allRecipes;

  // Carica tutte le ricette disponibili in base al dietType
  switch (dietType) {
    case 'vegan':
      allRecipes = await getVeganMeals();
      break;
    case 'vegetarian':
      allRecipes = await getVegetarianMeals();
      break;
    default:
      allRecipes = await getBothMeals();
  }

  if (query.trim().isEmpty) {
    return allRecipes; // se l'utente non digita nulla, mostra tutte
  }

  // Filtra le ricette lato client
  final filtered = allRecipes.where((recipe) {
    final name = recipe['name']?.toString().toLowerCase() ?? '';
    return name.contains(query.toLowerCase());
  }).toList();

  print('Ricerca query="$query", dietType="$dietType", trovate ${filtered.length} ricette');

  return filtered;
  }
  
  // Dettagli ricetta
  Future<Map<String, dynamic>?> getMealDetails(String mealId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipes/$mealId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['recipe'] != null) {
          return data['recipe'];
        }
      }
      print('Errore dettagli: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Errore dettagli: $e');
      return null;
    }
  }
  
  // Verifica se ricetta è vegana
  bool isVegan(Map<String, dynamic> meal) {
    return meal['isVegan'] == true;
  }
  
  // Verifica se ricetta è vegetariana
  bool isVegetarian(Map<String, dynamic> meal) {
    return meal['isVegetarian'] == true;
  }
  
  // Estrae ingredienti
  List<Map<String, String>> getIngredients(Map<String, dynamic> meal) {
    if (meal['ingredients'] != null) {
      return List<Map<String, String>>.from(
        meal['ingredients'].map((ing) => {
          'name': ing['name'].toString(),
          'measure': ing['measure'].toString(),
        })
      );
    }
    return [];
  }
}