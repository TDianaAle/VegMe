import 'shopping_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:vegme/core/theme/app_theme.dart';
import 'package:vegme/data/local/storage_manager.dart';
import 'package:vegme/screens/search_recipes_screen.dart';
import 'package:vegme/screens/weekly_calendar_screen.dart';


class HomeScreen extends StatefulWidget {
  final String dietType;
  final int servings;
  
  const HomeScreen({
    super.key,
    required this.dietType,
    required this.servings,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDay = 0;
  final List<String> days = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  
  Map<String, List<Map<String, dynamic>>> meals = {
    'colazione': [],
    'pranzo': [],
    'cena': [],
  };
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => _isLoading = true);
    
    final loadedMeals = await StorageManager.instance.getMealsForDay(selectedDay);
    
    setState(() {
      meals = loadedMeals;
      _isLoading = false;
    });
  }

  Future<void> _saveMeal(String mealType, Map<String, dynamic> recipe) async {
    await StorageManager.instance.saveMeal(selectedDay, mealType, recipe);
    await _loadMeals();
  }

  Future<void> _deleteMeal(String mealType, int index) async {
    // Su web usiamo l'indice, su mobile l'ID
    final meal = meals[mealType]![index];
    await StorageManager.instance.deleteMeal(
      selectedDay, 
      mealType, 
      meal['id'] ?? index
    );
    await _loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Menu Settimanale'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeeklyCalendarScreen(
                    servings: widget.servings,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Cancella tutto'),
                  content: Text('Vuoi cancellare tutti i pasti pianificati?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Annulla'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Cancella', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              
              if (confirm == true) {
                await StorageManager.instance.clearAll();
                _loadMeals();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Selettore giorni
          Container(
            height: 80,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: days.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedDay == index;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedDay = index);
                    _loadMeals();
                  },
                  child: Container(
                    width: 60,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Lista pasti
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMealSection('Colazione', '🌅', 'colazione'),
                        SizedBox(height: 20),
                        _buildMealSection('Pranzo', '🍽️', 'pranzo'),
                        SizedBox(height: 20),
                        _buildMealSection('Cena', '🌙', 'cena'),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShoppingListScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.accentOrange,
        icon: Icon(Icons.shopping_cart),
        label: Text('Lista Spesa'),
      ),
    );
  }
  
  Widget _buildMealSection(String title, String emoji, String mealType) {
    List<Map<String, dynamic>> mealList = meals[mealType] ?? [];
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          if (mealList.isEmpty)
            _buildAddMealButton(mealType)
          else
            ...mealList.asMap().entries.map((entry) => 
              _buildMealItem(entry.value, mealType, entry.key)
            ),
          
          if (mealList.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: _buildAddMealButton(mealType),
            ),
        ],
      ),
    );
  }
  
  Widget _buildAddMealButton(String mealType) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchRecipesScreen(
              dietType: widget.dietType,
              mealType: mealType,
            ),
          ),
        );
        
        if (result != null) {
          await _saveMeal(mealType, result);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryGreen, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppTheme.primaryGreen),
            SizedBox(width: 8),
            Text(
              'Aggiungi ricetta',
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMealItem(Map<String, dynamic> meal, String mealType, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Immagine ricetta
          if (meal['image'] != null && meal['image'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                meal['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: Icon(Icons.restaurant, color: Colors.grey),
                  );
                },
              ),
            ),
          
          SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'] ?? 'Ricetta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${widget.servings} porzioni',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textLight,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      meal['isVegan'] == true ? '🌱 Vegano' : '🥬 Vegetariano',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          IconButton(
            icon: Icon(Icons.close, color: Colors.red[400]),
            onPressed: () async {
              await _deleteMeal(mealType, index);
            },
          ),
        ],
      ),
    );
  }

}