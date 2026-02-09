import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/local/storage_manager.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  // Struttura: {dayIndex: {mealType: [meals]}}
  Map<int, Map<String, List<Map<String, dynamic>>>> _weekMeals = {};
  
  // Checkbox state: {ingredientKey: checked}
  Map<String, bool> _checkedItems = {};
  
  bool _isLoading = true;
  
  final List<String> _dayNames = [
    'Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'
  ];
  
  final Map<String, String> _mealTypeNames = {
    'colazione': '🌅 Colazione',
    'pranzo': '🍽️ Pranzo',
    'cena': '🌙 Cena',
  };

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  Future<void> _loadShoppingList() async {
    setState(() => _isLoading = true);
    
    Map<int, Map<String, List<Map<String, dynamic>>>> weekData = {};
    
    // Carica pasti di tutta la settimana
    for (int day = 0; day < 7; day++) {
      final dayMeals = await StorageManager.instance.getMealsForDay(day);
      
      // Filtra solo giorni con pasti
      bool hasAnyMeal = false;
      for (var meals in dayMeals.values) {
        if (meals.isNotEmpty) {
          hasAnyMeal = true;
          break;
        }
      }
      
      if (hasAnyMeal) {
        weekData[day] = dayMeals;
      }
    }
    
    setState(() {
      _weekMeals = weekData;
      _isLoading = false;
    });
  }

  String _getIngredientKey(int day, String mealType, int mealIndex, int ingIndex) {
    return '$day-$mealType-$mealIndex-$ingIndex';
  }

  String _extractIngredientName(String fullText) {
  // Rimuove numeri, unità di misura comuni, articoli
    final cleaned = fullText
        .replaceAll(RegExp(r'^\d+([.,]\d+)?\s*'), '') // Rimuove numeri iniziali
        .replaceAll(RegExp(r'\b(cucchiaio|cucchiai|cucchiaino|cucchiaini|tazza|tazze|grammi?|kg|litri?|ml|g|l|di|la|il|un|una|delle?|degli?)\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ') // Normalizza spazi
        .trim();
    
    return cleaned.isNotEmpty ? cleaned : fullText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Lista della Spesa'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadShoppingList,
          ),
          if (_checkedItems.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () {
                setState(() => _checkedItems.clear());
              },
              tooltip: 'Deseleziona tutto',
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
          : _weekMeals.isEmpty
              ? _buildEmptyState()
              : _buildShoppingList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
          SizedBox(height: 24),
          Text(
            'Nessun pasto pianificato',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Aggiungi ricette al tuo menu\nper generare la lista spesa',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingList() {
    // Conta totale ingredienti
    int totalIngredients = 0;
    _weekMeals.forEach((day, dayMeals) {
      dayMeals.forEach((mealType, meals) {
        for (var meal in meals) {
          final ingredients = meal['ingredients'];
          if (ingredients is List) {
            totalIngredients += ingredients.length;
          }
        }
      });
    });

    return Column(
      children: [
        // Header statistiche
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryGreen, AppTheme.primaryGreen.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '${_weekMeals.length}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _weekMeals.length == 1 ? 'giorno' : 'giorni',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              Container(
                width: 2,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Column(
                children: [
                  Text(
                    '$totalIngredients',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    totalIngredients == 1 ? 'ingrediente' : 'ingredienti',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Lista per giorni
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _weekMeals.length,
            itemBuilder: (context, index) {
              final day = _weekMeals.keys.elementAt(index);
              return _buildDayCard(day, _weekMeals[day]!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(int day, Map<String, List<Map<String, dynamic>>> dayMeals) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(16),
        childrenPadding: EdgeInsets.only(bottom: 12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${day + 1}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          _dayNames[day],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        children: [
          ...dayMeals.entries.expand((entry) {
            final mealType = entry.key;
            final meals = entry.value;
            
            return meals.isEmpty
                ? []
                : meals.asMap().entries.map((mealEntry) {
                    return _buildMealSection(
                      day,
                      mealType,
                      mealEntry.key,
                      mealEntry.value,
                    );
                  });
          }),
        ],
      ),
    );
  }

  Widget _buildMealSection(int day, String mealType, int mealIndex, Map<String, dynamic> meal) {
    final ingredients = meal['ingredients'];
    final ingredientsList = ingredients is List ? ingredients : [];
    
    if (ingredientsList.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header ricetta
          Row(
            children: [
              Text(
                _mealTypeNames[mealType] ?? mealType,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLight,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  meal['name'] ?? meal['mealName'] ?? 'Ricetta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          // Ingredienti con checkbox
          ...ingredientsList.asMap().entries.map((ingEntry) {
            final ingIndex = ingEntry.key;
            final ingredient = ingEntry.value;
            final name = ingredient['name']?.toString() ?? '';
            
            if (name.isEmpty) return SizedBox.shrink();
            
            final key = _getIngredientKey(day, mealType, mealIndex, ingIndex);
            final isChecked = _checkedItems[key] ?? false;
            
            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppTheme.primaryGreen,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _checkedItems[key] = value ?? false;
                });
              },
              title: Text(
                _extractIngredientName(name),
                style: TextStyle(
                  fontSize: 14,
                  color: isChecked ? Colors.grey : AppTheme.textDark,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}