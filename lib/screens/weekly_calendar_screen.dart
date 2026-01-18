import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../core/theme/app_theme.dart';
import '../data/local/storage_manager.dart';
import '../core/services/custom_cursor_service.dart';

class WeeklyCalendarScreen extends StatefulWidget {
  final int servings;
  
  const WeeklyCalendarScreen({
    super.key,
    required this.servings,
  });

  @override
  State<WeeklyCalendarScreen> createState() => _WeeklyCalendarScreenState();
}

class _WeeklyCalendarScreenState extends State<WeeklyCalendarScreen> {
  final List<String> days = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  Map<int, Map<String, List<Map<String, dynamic>>>> weekMeals = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeekMeals();
    
    // Imposta il cursore carota per questa schermata
    if (kIsWeb) {
      CustomCursorService.instance.setCursor(CursorType.carrot);
    }
  }

  Future<void> _loadWeekMeals() async {
    setState(() => _isLoading = true);
    
    Map<int, Map<String, List<Map<String, dynamic>>>> loaded = {};
    
    for (int day = 0; day < 7; day++) {
      loaded[day] = await StorageManager.instance.getMealsForDay(day);
    }
    
    setState(() {
      weekMeals = loaded;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Calendario Settimanale'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadWeekMeals,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: List.generate(7, (dayIndex) {
                  return _buildDayCard(dayIndex);
                }),
              ),
            ),
    );

    // Avvolgi con cursore personalizzato solo su web
    if (kIsWeb) {
      return CustomCursorOverlay(
        cursorType: CursorType.carrot,
        child: content,
      );
    }
    
    return content;
  }

  Widget _buildDayCard(int dayIndex) {
    final dayMeals = weekMeals[dayIndex] ?? {
      'colazione': [],
      'pranzo': [],
      'cena': [],
    };
    
    final totalMeals = 
        dayMeals['colazione']!.length +
        dayMeals['pranzo']!.length +
        dayMeals['cena']!.length;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppTheme.lightGreen.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header giorno
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[dayIndex],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${dayIndex + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDayName(dayIndex),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          '$totalMeals ${totalMeals == 1 ? "pasto" : "pasti"} pianificati',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (totalMeals > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$totalMeals',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              
              if (totalMeals > 0) ...[
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 12),
                
                // Pasti del giorno
                _buildMealTypeSection('🌅 Colazione', dayMeals['colazione']!, dayIndex, 'colazione'),
                if (dayMeals['colazione']!.isNotEmpty) SizedBox(height: 12),
                
                _buildMealTypeSection('🍽️ Pranzo', dayMeals['pranzo']!, dayIndex, 'pranzo'),
                if (dayMeals['pranzo']!.isNotEmpty) SizedBox(height: 12),
                
                _buildMealTypeSection('🌙 Cena', dayMeals['cena']!, dayIndex, 'cena'),
              ],
              
              if (totalMeals == 0) ...[
                SizedBox(height: 12),
                Center(
                  child: Text(
                    'Nessun pasto pianificato',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeSection(String title, List<Map<String, dynamic>> meals, int dayIndex, String mealType) {
    if (meals.isEmpty) return SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        SizedBox(height: 8),
        ...meals.asMap().entries.map((entry) => _buildMealTile(entry.value, dayIndex, mealType, entry.key)),
      ],
    );
  }

  Widget _buildMealTile(Map<String, dynamic> meal, int dayIndex, String mealType, int mealIndex) {
    final tile = Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Immagine
          if (meal['image'] != null && meal['image'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                meal['image'],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[200],
                    child: Icon(Icons.restaurant, size: 20, color: Colors.grey),
                  );
                },
              ),
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.restaurant, size: 20, color: Colors.grey),
            ),
          
          SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'] ?? 'Ricetta',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  meal['isVegan'] == true ? '🌱 Vegano' : '🥬 Vegetariano',
                  style: TextStyle(fontSize: 11, color: AppTheme.textLight),
                ),
              ],
            ),
          ),
          
          // Icona per indicare che è cliccabile
          Icon(
            Icons.chevron_right,
            color: AppTheme.primaryGreen,
            size: 20,
          ),
        ],
      ),
    );

    // Su web usa CustomCursorArea, su mobile GestureDetector normale
    if (kIsWeb) {
      return CustomCursorArea(
        cursorType: CursorType.carrot,
        onTap: () => _showRecipeDetails(meal, dayIndex, mealType, mealIndex),
        child: tile,
      );
    }

    return GestureDetector(
      onTap: () => _showRecipeDetails(meal, dayIndex, mealType, mealIndex),
      child: tile,
    );
  }

  // Mostra i dettagli della ricetta con selettore porzioni
  void _showRecipeDetails(Map<String, dynamic> meal, int dayIndex, String mealType, int mealIndex) {
    final isVegan = meal['isVegan'] == true;
    final ingredients = meal['ingredients'] as List<dynamic>? ?? [];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _RecipeDetailsSheet(
        meal: meal,
        isVegan: isVegan,
        ingredients: ingredients,
        initialServings: widget.servings,
        dayIndex: dayIndex,
        mealType: mealType,
        mealIndex: mealIndex,
        onRemove: () => _confirmRemoveMeal(dayIndex, mealType, mealIndex, meal['name']),
        getDayName: _getDayName,
        getMealTypeName: _getMealTypeName,
      ),
    );
  }

  // Conferma rimozione pasto
  void _confirmRemoveMeal(int dayIndex, String mealType, int mealIndex, String? mealName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rimuovere ricetta?'),
        content: Text('Vuoi rimuovere "${mealName ?? 'questa ricetta'}" dal menu di ${_getDayName(dayIndex)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annulla'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Chiudi dialog
              Navigator.pop(context); // Chiudi bottom sheet
              
              // Rimuovi il pasto
              await StorageManager.instance.deleteMeal(dayIndex, mealType, mealIndex);
              
              // Ricarica i dati
              await _loadWeekMeals();
              
              // Mostra conferma
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ricetta rimossa dal menu'),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
              }
            },
            child: Text('Rimuovi', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getDayName(int index) {
    const dayNames = [
      'Lunedì',
      'Martedì',
      'Mercoledì',
      'Giovedì',
      'Venerdì',
      'Sabato',
      'Domenica',
    ];
    return dayNames[index];
  }

  String _getMealTypeName(String mealType) {
    switch (mealType) {
      case 'colazione':
        return 'Colazione';
      case 'pranzo':
        return 'Pranzo';
      case 'cena':
        return 'Cena';
      default:
        return mealType;
    }
  }
}

// Widget separato per il bottom sheet con stato per le porzioni
class _RecipeDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> meal;
  final bool isVegan;
  final List<dynamic> ingredients;
  final int initialServings;
  final int dayIndex;
  final String mealType;
  final int mealIndex;
  final VoidCallback onRemove;
  final String Function(int) getDayName;
  final String Function(String) getMealTypeName;

  const _RecipeDetailsSheet({
    required this.meal,
    required this.isVegan,
    required this.ingredients,
    required this.initialServings,
    required this.dayIndex,
    required this.mealType,
    required this.mealIndex,
    required this.onRemove,
    required this.getDayName,
    required this.getMealTypeName,
  });

  @override
  State<_RecipeDetailsSheet> createState() => _RecipeDetailsSheetState();
}

class _RecipeDetailsSheetState extends State<_RecipeDetailsSheet> {
  late int _currentServings;

  @override
  void initState() {
    super.initState();
    _currentServings = widget.initialServings;
  }

  // Calcola la quantità scalata in base alle porzioni
  String _scaleQuantity(String measure) {
    if (measure.isEmpty) return measure;
    
    // Prova a estrarre il numero dalla misura
    final regex = RegExp(r'^([\d.,/]+)\s*(.*)$');
    final match = regex.firstMatch(measure.trim());
    
    if (match != null) {
      final numberStr = match.group(1)!;
      final unit = match.group(2) ?? '';
      
      double? number;
      
      // Gestisci frazioni come "1/2"
      if (numberStr.contains('/')) {
        final parts = numberStr.split('/');
        if (parts.length == 2) {
          final num = double.tryParse(parts[0]);
          final den = double.tryParse(parts[1]);
          if (num != null && den != null && den != 0) {
            number = num / den;
          }
        }
      } else {
        // Gestisci numeri normali (anche con virgola)
        number = double.tryParse(numberStr.replaceAll(',', '.'));
      }
      
      if (number != null) {
        // Scala in base alle porzioni (assumendo che la ricetta base sia per 1 porzione o per initialServings)
        final scaleFactor = _currentServings / widget.initialServings;
        final scaledNumber = number * scaleFactor;
        
        // Formatta il numero
        String formattedNumber;
        if (scaledNumber == scaledNumber.roundToDouble()) {
          formattedNumber = scaledNumber.round().toString();
        } else {
          formattedNumber = scaledNumber.toStringAsFixed(1);
        }
        
        return '$formattedNumber $unit'.trim();
      }
    }
    
    return measure;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
              
              // Immagine
              if (widget.meal['image'] != null && widget.meal['image'].toString().isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.meal['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(Icons.restaurant, size: 60, color: Colors.grey),
                      );
                    },
                  ),
                ),
              
              SizedBox(height: 20),
              
              // Titolo
              Text(
                widget.meal['name'] ?? 'Ricetta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              
              SizedBox(height: 12),
              
              // Badge dieta + giorno
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.isVegan ? AppTheme.primaryGreen : AppTheme.accentOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.isVegan ? '🌱 Vegano' : '🥬 Vegetariano',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.getDayName(widget.dayIndex)} - ${widget.getMealTypeName(widget.mealType)}',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Ingredienti
              if (widget.ingredients.isNotEmpty) ...[
                Text(
                  'Ingredienti',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                
                SizedBox(height: 12),
                
                // ✅ SELETTORE PORZIONI CON + E -
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGreen.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people, color: AppTheme.primaryGreen, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Porzioni',
                            style: TextStyle(
                              color: AppTheme.textDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      
                      // Controlli + e -
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Bottone -
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: _currentServings > 1
                                    ? () => setState(() => _currentServings--)
                                    : null,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _currentServings > 1 
                                        ? AppTheme.primaryGreen 
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            
                            // portions number
                            
                            Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: Text(
                                '$_currentServings',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ),
                            
                            // + button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: _currentServings < 20
                                    ? () => setState(() => _currentServings++)
                                    : null,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _currentServings < 20 
                                        ? AppTheme.primaryGreen 
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // ingredients lists with scaled quantities
                ...widget.ingredients.map((ing) {
                  final name = ing['name']?.toString() ?? '';
                  final measure = ing['measure']?.toString() ?? '';
                  final scaledMeasure = _scaleQuantity(measure);
                  
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            scaledMeasure.isNotEmpty ? '$scaledMeasure $name' : name,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ] else ...[
                // if no saved ingredients
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey[600]),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ingredienti non disponibili per questa ricetta',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              SizedBox(height: 24),
              
              //remove menu
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: widget.onRemove,
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  label: Text(
                    'Rimuovi dal Menu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}