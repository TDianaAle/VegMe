import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/services/meal_api_service.dart';

class SearchRecipesScreen extends StatefulWidget {
  final String dietType; // vegan, vegetarian, both
  final String mealType; // colazione, pranzo, cena
  
  const SearchRecipesScreen({
    super.key,
    required this.dietType,
    required this.mealType,
  });

  @override
  State<SearchRecipesScreen> createState() => _SearchRecipesScreenState();
}

class _SearchRecipesScreenState extends State<SearchRecipesScreen> {
  final MealApiService _apiService = MealApiService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _recipes = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadVegetarianRecipes();
  }

  Future<void> _loadVegetarianRecipes() async {
    setState(() => _isLoading = true);
    
    final recipes = await _apiService.getVegetarianMeals();
    
    setState(() {
      _recipes = _filterByDietType(recipes);
      _isLoading = false;
      _hasSearched = true;
    });
  }

  Future<void> _searchRecipes(String query) async {
    if (query.isEmpty) {
      _loadVegetarianRecipes();
      return;
    }
    
    setState(() => _isLoading = true);
    
    final recipes = await _apiService.searchMeals(query);
    
    setState(() {
      _recipes = _filterByDietType(recipes);
      _isLoading = false;
      _hasSearched = true;
    });
  }

  List<Map<String, dynamic>> _filterByDietType(List<Map<String, dynamic>> recipes) {
    if (widget.dietType == 'vegan') {
      return recipes.where((meal) => _apiService.isVegan(meal)).toList();
    } else if (widget.dietType == 'vegetarian') {
      return recipes.where((meal) => _apiService.isVegetarian(meal)).toList();
    } else {
      // both
      return recipes.where((meal) => _apiService.isVegetarian(meal)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Cerca Ricette'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca ricette...',
                prefixIcon: Icon(Icons.search, color: AppTheme.primaryGreen),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadVegetarianRecipes();
                        },
                      )
                    : null,
              ),
              onSubmitted: _searchRecipes,
              onChanged: (value) {
                setState(() {}); // Per aggiornare suffixIcon
              },
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
          : _recipes.isEmpty && _hasSearched
              ? _buildEmptyState()
              : _buildRecipesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Nessuna ricetta trovata',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textLight,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Prova con un altro termine',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        final isVegan = _apiService.isVegan(recipe);
        
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () async {
              // Carica dettagli completi
              final details = await _apiService.getMealDetails(recipe['idMeal']);
              if (details != null) {
                _showRecipeDetails(details);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Immagine
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    recipe['strMealThumb'] ?? '',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: Icon(Icons.restaurant, size: 60, color: Colors.grey),
                      );
                    },
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              recipe['strMeal'] ?? 'Ricetta',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isVegan ? AppTheme.primaryGreen : AppTheme.accentOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isVegan ? '🌱 Vegano' : '🥬 Vegetariano',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      if (recipe['strCategory'] != null) ...[
                        SizedBox(height: 8),
                        Text(
                          recipe['strCategory'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRecipeDetails(Map<String, dynamic> recipe) {
    final ingredients = _apiService.getIngredients(recipe);
    final isVegan = _apiService.isVegan(recipe);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Titolo
                Text(
                  recipe['strMeal'] ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                
                SizedBox(height: 8),
                
                // Badge dieta
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isVegan ? AppTheme.primaryGreen : AppTheme.accentOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isVegan ? '🌱 Vegano' : '🥬 Vegetariano',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Ingredienti
                Text(
                  'Ingredienti',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                
                SizedBox(height: 12),
                
                ...ingredients.map((ing) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${ing['measure']} ${ing['name']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )),
                
                SizedBox(height: 24),
                
                // Bottone Aggiungi
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Chiudi bottom sheet
                      Navigator.pop(context, {
                        'name': recipe['strMeal'],
                        'id': recipe['idMeal'],
                        'ingredients': ingredients,
                      }); // Ritorna alla home con i dati
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Aggiungi al Menu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}