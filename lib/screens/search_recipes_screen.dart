import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/services/meal_api_service.dart';

class SearchRecipesScreen extends StatefulWidget {
  final String dietType; // 'vegan' | 'vegetarian' | 'both'
  final String mealType;

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

   // CACHE DETTAGLI RICETTE
   //altrimenti ci impiega troppo a caricare le ricette e salvarle
  final Map<String, Map<String, dynamic>> _detailsCache = {};
  

  @override
  void initState() {
    super.initState();
    _loadInitialRecipes();
  }

  Future<void> _loadInitialRecipes() async {
    setState(() => _isLoading = true);

    List<Map<String, dynamic>> recipes;
    
    switch (widget.dietType) {
      case 'vegan':
        recipes = await _apiService.getVeganMeals();
        break;
      case 'both':
        recipes = await _apiService.getBothMeals();
        break;
      default:
        recipes = await _apiService.getVegetarianMeals();
    }

    setState(() {
      _recipes = recipes;
      _isLoading = false;
      _hasSearched = true;
    });
  }

  Future<void> _searchRecipes(String query) async {
    if (query.isEmpty) {
      _loadInitialRecipes();
      return;
    }

    setState(() => _isLoading = true);

    final recipes = await _apiService.searchMeals(query);

    setState(() {
      _recipes = recipes;
      _isLoading = false;
      _hasSearched = true;
    });

    
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Cerca Ricette'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadInitialRecipes();
                        },
                      )
                    : null,
              ),
              onSubmitted: _searchRecipes,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
            )
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
          const SizedBox(height: 16),
          Text(
            'Nessuna ricetta trovata',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 8),
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
      padding: const EdgeInsets.all(16),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        final isVegan = _apiService.isVegan(recipe);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              if (recipe['id'] != null) {
                final recipeId = recipe['id'].toString();
                
                // Controlla cache prima
                if (_detailsCache.containsKey(recipeId)) {
                  print(' Cache HIT per $recipeId');
                  _showRecipeDetails(_detailsCache[recipeId]!);
                } else {
                  print(' Caricamento dettagli per $recipeId...');
                  final details = await _apiService.getMealDetails(recipeId);
                  if (details != null) {
                    _detailsCache[recipeId] = details; //  Salva in cache
                    print('Salvato in cache $recipeId');
                    _showRecipeDetails(details);
                  }
                }
              } else {
                _showRecipeDetails(recipe);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    recipe['image'] ?? '',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe['name'] ?? 'Ricetta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      _buildBadge(isVegan),
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

  Widget _buildBadge(bool isVegan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isVegan ? AppTheme.primaryGreen : AppTheme.accentOrange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isVegan ? '🌱 Vegano' : '🥬 Vegetariano',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showRecipeDetails(Map<String, dynamic> recipe) {
    final ingredients = _apiService.getIngredients(recipe);
    final isVegan = _apiService.isVegan(recipe);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe['name'] ?? 'Ricetta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              _buildBadge(isVegan),
              const SizedBox(height: 24),
              const Text(
                'Ingredienti',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...ingredients.map(
                  (ing) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            //  FIX: se measure è vuoto, usa solo name
                            ing['measure']?.toString().isNotEmpty == true
                                ? '${ing['measure']} ${ing['name']}'
                                : ing['name']?.toString() ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final nav = Navigator.of(context);
                    //usa solo i dati gia caricati per evitare altri ritardi -.-
                    final recipeData = {
                      'name': recipe['name'] ?? 'Ricetta',
                      'id': recipe['id']?.toString() ?? '',
                      'image': recipe['image'] ?? '',
                      'ingredients': ingredients,
                      'isVegan': isVegan,
                    };
                    
                    print('Salvando: ${recipeData['name']}');
                    // Usa navigator salvato
                    nav.pop(); // Chiudi modale
                    nav.pop(recipeData); // Torna con ricetta
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Aggiungi al Menu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
