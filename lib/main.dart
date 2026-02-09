import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/diet_setup_screen.dart';

void main() {
  runApp(const VegMeApp());
}

class VegMeApp extends StatelessWidget {
  const VegMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VegMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const OnboardingScreen(),
    );
  }
}

// Schermata Onboarding 
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Title
                const Text(
                  'Personalizza i tuoi\npasti veg',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Placeholder illustration
                const Text(
                  '🥗🥕🍅',
                  style: TextStyle(fontSize: 80),
                ),
                
                const SizedBox(height: 30),
                
                // Descrizione
                const Text(
                  'Pianifica i tuoi pasti vegani e vegetariani\nin pochi minuti. Scegli tra centinaia\ndi ricette personalizzate.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textLight,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Indicatori pagina (dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Bottone Continua
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DietSetupScreen(),
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
                      'Continua',
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
}