import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'home_screen.dart';

class DietSetupScreen extends StatefulWidget {
  const DietSetupScreen({super.key});

  @override
  State<DietSetupScreen> createState() => _DietSetupScreenState();
}

class _DietSetupScreenState extends State<DietSetupScreen> {
  String selectedDiet = 'vegan'; // vegan, vegetarian, both
  int servings = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Che tipo di dieta\nsegui?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // diet options
                _buildDietOption(
                  'vegan',
                  '🌱 Solo Vegana',
                  'Nessun prodotto animale',
                ),
                
                const SizedBox(height: 16),
                
                _buildDietOption(
                  'vegetarian',
                  '🥬 Solo Vegetariana',
                  'Include uova e latticini',
                ),
                
                const SizedBox(height: 16),
                
                _buildDietOption(
                  'both',
                  '🌿 Entrambe',
                  'Tutte le ricette disponibili',
                ),
                
                const SizedBox(height: 40),
                
                // persons number
                const Text(
                  'Per quante persone\ncucini?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Number selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 40),
                      color: AppTheme.primaryGreen,
                      onPressed: () {
                        if (servings > 1) {
                          setState(() => servings--);
                        }
                      },
                    ),
                    
                    const SizedBox(width: 32),
                    
                    Text(
                      '$servings',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    
                    const SizedBox(width: 32),
                    
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 40),
                      color: AppTheme.primaryGreen,
                      onPressed: () {
                        if (servings < 10) {
                          setState(() => servings++);
                        }
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 60),
                
                // Continue Button
                SizedBox(
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
                    child: const Text(
                      'Inizia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
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
        padding: const EdgeInsets.all(20),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
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