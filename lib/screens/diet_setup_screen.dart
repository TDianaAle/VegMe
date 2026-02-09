import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'home_screen.dart';

class DietSetupScreen extends StatefulWidget {
  const DietSetupScreen({super.key});

  @override
  State<DietSetupScreen> createState() => _DietSetupScreenState();
}

class _DietSetupScreenState extends State<DietSetupScreen> {
  String selectedDiet = 'vegan';
  int servings = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titolo
                    Text(
                      'Che tipo di dieta\nsegui?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                        height: 1.2,
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Opzioni dieta
                    _buildDietOption(
                      'vegan',
                      '🌱 Solo Vegana',
                      'Nessun prodotto animale',
                    ),
                    
                    SizedBox(height: 16),
                    
                    _buildDietOption(
                      'vegetarian',
                      '🥬 Solo Vegetariana',
                      'Include uova e latticini',
                    ),
                    
                    SizedBox(height: 16),
                    
                    _buildDietOption(
                      'both',
                      '🌿 Entrambe',
                      'Tutte le ricette disponibili',
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Numero persone
                    Text(
                      'Per quante persone\ncucini?',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                        height: 1.0,
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Selettore numero
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline, size: 40),
                          color: AppTheme.primaryGreen,
                          onPressed: () {
                            if (servings > 1) {
                              setState(() => servings--);
                            }
                          },
                        ),
                        
                        SizedBox(width: 32),
                        
                        Text(
                          '$servings',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        
                        SizedBox(width: 32),
                        
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, size: 40),
                          color: AppTheme.primaryGreen,
                          onPressed: () {
                            if (servings < 10) {
                              setState(() => servings++);
                            }
                          },
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Bottone fisso in basso
            Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          dietType: selectedDiet,
                          servings: servings,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Inizia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDietOption(String value, String title, String subtitle) {
    bool isSelected = selectedDiet == value;
    
    return GestureDetector(
      onTap: () {
        setState(() => selectedDiet = value);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.lightGreen : Colors.grey[100],
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryGreen,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}