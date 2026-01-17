import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'search_recipes_screen.dart';

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
  int selectedDay = 0; // 0=Lun, 1=Mar, ...
  final List<String> days = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  
  // TODO: Sostituire con dati veri dal database
  Map<String, List<String>> meals = {
    'colazione': [],
    'pranzo': [],
    'cena': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Menu Settimanale'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // TODO: Aprire impostazioni
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealSection('Colazione', '🌅', 'colazione'),
                  SizedBox(height: 20),
                  _buildMealSection('Pranzo', '🍽️', 'pranzo'),
                  SizedBox(height: 20),
                  _buildMealSection('Cena', '🌙', 'cena'),
                  SizedBox(height: 80), // Spazio per FAB
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottone Lista Spesa
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Aprire lista spesa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lista spesa in arrivo!')),
          );
        },
        backgroundColor: AppTheme.accentOrange,
        icon: Icon(Icons.shopping_cart),
        label: Text('Lista Spesa'),
      ),
    );
  }
  
  Widget _buildMealSection(String title, String emoji, String mealType) {
    List<String> mealList = meals[mealType] ?? [];
    
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
          
          // Lista ricette aggiunte
          if (mealList.isEmpty)
            _buildAddMealButton(mealType)
          else
            ...mealList.map((meal) => _buildMealItem(meal, mealType)),
          
          // Bottone aggiungi altro
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
        // Naviga alla ricerca e aspetta il risultato
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchRecipesScreen(
              dietType: widget.dietType,
              mealType: mealType,
            ),
          ),
        );
        
        // Se l'utente ha selezionato una ricetta
        if (result != null) {
          setState(() {
            if (meals[mealType] == null) {
              meals[mealType] = [];
            }
            meals[mealType]!.add(result['name']);
          });
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
  
  Widget _buildMealItem(String mealName, String mealType) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${widget.servings} porzioni',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red[400]),
            onPressed: () {
              setState(() {
                meals[mealType]?.remove(mealName);
              });
            },
          ),
        ],
      ),
    );
  }
}