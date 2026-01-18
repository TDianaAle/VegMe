class IngredientTranslator {
  static const Map<String, String> _translations = {
    
    // Vegetables 
    'aubergine': 'melanzana',
    'eggplant': 'melanzana',
    'courgette': 'zucchina',
    'zucchini': 'zucchina',
    'tomato': 'pomodoro',
    'tomatoes': 'pomodori',
    'cherry tomatoes': 'pomodorini',
    'plum tomatoes': 'pomodori perini',
    'onion': 'cipolla',
    'onions': 'cipolle',
    'red onion': 'cipolla rossa',
    'spring onion': 'cipollotto',
    'garlic': 'aglio',
    'garlic clove': 'spicchio d\'aglio',
    'garlic cloves': 'spicchi d\'aglio',
    'potato': 'patata',
    'potatoes': 'patate',
    'carrot': 'carota',
    'carrots': 'carote',
    'bell pepper': 'peperone',
    'bell peppers': 'peperoni',
    'red pepper': 'peperone rosso',
    'green pepper': 'peperone verde',
    'pepper': 'pepe',
    'peppers': 'peperoni',
    'cucumber': 'cetriolo',
    'lettuce': 'lattuga',
    'spinach': 'spinaci',
    'mushroom': 'fungo',
    'mushrooms': 'funghi',
    'broccoli': 'broccoli',
    'cauliflower': 'cavolfiore',
    'cabbage': 'cavolo',
    'celery': 'sedano',
    'leek': 'porro',
    'pumpkin': 'zucca',
    'beetroot': 'barbabietola',
    'radish': 'ravanello',
    'asparagus': 'asparagi',
    'artichoke': 'carciofo',
    'fennel': 'finocchio',
    'rocket': 'rucola',
    'arugula': 'rucola',
    'basil': 'basilico',
    'parsley': 'prezzemolo',
    'rosemary': 'rosmarino',
    'thyme': 'timo',
    'oregano': 'origano',
    'mint': 'menta',
    'sage': 'salvia',
    'bay leaf': 'alloro',
    'bay leaves': 'foglie di alloro',
    'coriander': 'coriandolo',
    'cilantro': 'coriandolo',
    'dill': 'aneto',
    'chives': 'erba cipollina',
    
    // Legumes
    'chickpeas': 'ceci',
    'chickpea': 'ceci',
    'lentils': 'lenticchie',
    'lentil': 'lenticchie',
    'red lentils': 'lenticchie rosse',
    'beans': 'fagioli',
    'bean': 'fagioli',
    'kidney beans': 'fagioli rossi',
    'black beans': 'fagioli neri',
    'white beans': 'fagioli bianchi',
    'cannellini beans': 'fagioli cannellini',
    'peas': 'piselli',
    'pea': 'piselli',
    'green beans': 'fagiolini',
    'broad beans': 'fave',
    'soy beans': 'soia',
    'tofu': 'tofu',
    
    // Cereals and pasta
    'rice': 'riso',
    'basmati rice': 'riso basmati',
    'brown rice': 'riso integrale',
    'pasta': 'pasta',
    'spaghetti': 'spaghetti',
    'penne': 'penne',
    'fusilli': 'fusilli',
    'linguine': 'linguine',
    'tagliatelle': 'tagliatelle',
    'noodle': 'noodles',
    'noodles': 'noodles',
    'flour': 'farina',
    'plain flour': 'farina 00',
    'bread': 'pane',
    'breadcrumbs': 'pangrattato',
    'oats': 'avena',
    'quinoa': 'quinoa',
    'couscous': 'couscous',
    'bulgur': 'bulgur',
    
    // Fruits
    'apple': 'mela',
    'apples': 'mele',
    'banana': 'banana',
    'bananas': 'banane',
    'orange': 'arancia',
    'oranges': 'arance',
    'lemon': 'limone',
    'lemons': 'limoni',
    'lemon juice': 'succo di limone',
    'lime': 'lime',
    'lime juice': 'succo di lime',
    'strawberry': 'fragola',
    'strawberries': 'fragole',
    'blueberry': 'mirtillo',
    'blueberries': 'mirtilli',
    'raspberry': 'lampone',
    'raspberries': 'lamponi',
    'cherry': 'ciliegia',
    'cherries': 'ciliegie',
    'peach': 'pesca',
    'peaches': 'pesche',
    'pear': 'pera',
    'pears': 'pere',
    'plum': 'prugna',
    'plums': 'prugne',
    'grape': 'uva',
    'grapes': 'uva',
    'melon': 'melone',
    'watermelon': 'anguria',
    'pineapple': 'ananas',
    'mango': 'mango',
    'avocado': 'avocado',
    'kiwi': 'kiwi',
    'fig': 'fico',
    'figs': 'fichi',
    'date': 'dattero',
    'dates': 'datteri',
    
    // Condiments and spices
    'olive oil': 'olio d\'oliva',
    'vegetable oil': 'olio vegetale',
    'oil': 'olio',
    'vinegar': 'aceto',
    'balsamic vinegar': 'aceto balsamico',
    'wine vinegar': 'aceto di vino',
    'salt': 'sale',
    'sea salt': 'sale marino',
    'black pepper': 'pepe nero',
    'white pepper': 'pepe bianco',
    'chili': 'peperoncino',
    'chilli': 'peperoncino',
    'red chili': 'peperoncino rosso',
    'paprika': 'paprika',
    'cumin': 'cumino',
    'turmeric': 'curcuma',
    'ginger': 'zenzero',
    'fresh ginger': 'zenzero fresco',
    'ground ginger': 'zenzero in polvere',
    'cinnamon': 'cannella',
    'nutmeg': 'noce moscata',
    'vanilla': 'vaniglia',
    'vanilla extract': 'estratto di vaniglia',
    'sugar': 'zucchero',
    'brown sugar': 'zucchero di canna',
    'honey': 'miele',
    'mustard': 'senape',
    'dijon mustard': 'senape di Digione',
    'soy sauce': 'salsa di soia',
    'tomato sauce': 'salsa di pomodoro',
    'tomato paste': 'concentrato di pomodoro',
    'tomato puree': 'passata di pomodoro',
    'chopped tomatoes': 'pomodori pelati',
    'curry powder': 'curry in polvere',
    'chili powder': 'peperoncino in polvere',
    'clove': 'chiodo di garofano',
    'cloves': 'chiodi di garofano',
    
    // Dried fruits and nuts
    'almonds': 'mandorle',
    'walnuts': 'noci',
    'hazelnuts': 'nocciole',
    'pistachios': 'pistacchi',
    'cashews': 'anacardi',
    'peanuts': 'arachidi',
    'pine nuts': 'pinoli',
    'sunflower seeds': 'semi di girasole',
    'pumpkin seeds': 'semi di zucca',
    'sesame seeds': 'semi di sesamo',
    'chia seeds': 'semi di chia',
    'flax seeds': 'semi di lino',
    
    // Dairy products and eggs
    'milk': 'latte',
    'cheese': 'formaggio',
    'cheddar cheese': 'formaggio cheddar',
    'mozzarella': 'mozzarella',
    'parmesan': 'parmigiano',
    'ricotta': 'ricotta',
    'feta': 'feta',
    'goats cheese': 'formaggio di capra',
    'goat cheese': 'formaggio di capra',
    'goat\'s cheese': 'formaggio di capra',
    'yogurt': 'yogurt',
    'yoghurt': 'yogurt',
    'greek yogurt': 'yogurt greco',
    'butter': 'burro',
    'cream': 'panna',
    'double cream': 'panna da montare',
    'single cream': 'panna fresca',
    'egg': 'uovo',
    'eggs': 'uova',
    
    // Others
    'water': 'acqua',
    'vegetable stock': 'brodo vegetale',
    'stock': 'brodo',
    'vegetable broth': 'brodo vegetale',
    'coconut milk': 'latte di cocco',
    'almond milk': 'latte di mandorla',
    'soy milk': 'latte di soia',
    'cornflour': 'amido di mais',
    'cornstarch': 'amido di mais',
    'baking powder': 'lievito in polvere',
    'yeast': 'lievito',
    'zest': 'scorza',
    'peeled': 'sbucciato',
    
    // Measurements
    'tablespoon': 'cucchiaio',
    'tablespoons': 'cucchiai',
    'tbsp': 'cucchiaio',
    'teaspoon': 'cucchiaino',
    'teaspoons': 'cucchiaini',
    'tsp': 'cucchiaino',
    'cup': 'tazza',
    'cups': 'tazze',
    'handful': 'manciata',
    'handfuls': 'manciate',
    'pinch': 'pizzico',
    'splash': 'goccio',
    'dash': 'pizzico',
    'drizzle': 'filo',
    'to taste': 'q.b.',
    
    // Sizes
    'large': 'grande',
    'small': 'piccolo',
    'medium': 'medio',
    'big': 'grande',
    
    // Preparation methods and adjectives
    'sliced': 'affettato',
    'diced': 'a dadini',
    'chopped': 'tritato',
    'minced': 'tritato finemente',
    'crushed': 'schiacciato',
    'grated': 'grattugiato',
    'fresh': 'fresco',
    'dried': 'secco',
    'frozen': 'congelato',
    'canned': 'in scatola',
    'thinly': 'finemente',
    'finely': 'finemente',
    'roughly': 'grossolanamente',
    'coarsely': 'grossolanamente',
    'juice of': 'succo di',
    'zest of': 'scorza di',
    'ground': 'macinato',
    'whole': 'intero',
    'halved': 'dimezzato',
    'quartered': 'tagliato in quarti',
    
    // Common descriptors
    'hot': 'piccante',
    'mild': 'dolce',
    'sweet': 'dolce',
    'spicy': 'piccante',
    'powder': 'in polvere',
    'powdered': 'in polvere',
    'seeds': 'semi',
    'seed': 'seme',
    'leaves': 'foglie',
    'leaf': 'foglia',
    'root': 'radice',
    'stem': 'gambo',
  };

  // Translates a single ingredient from English to Italian
  static String translate(String ingredient) {
    if (ingredient.isEmpty) return ingredient;
    
    // Clean ingredient string
    String cleaned = ingredient.trim().toLowerCase();
    
    // Remove multiple spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    
    // Search for exact match
    if (_translations.containsKey(cleaned)) {
      return _translations[cleaned]!;
    }
    
    // Search for partial matches (sorted by length descending for longest matches first)
    List<MapEntry<String, String>> sortedEntries = _translations.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    
    for (var entry in sortedEntries) {
      if (cleaned.contains(entry.key)) {
        // Replace preserving the rest of the string
        String result = cleaned.replaceAll(entry.key, entry.value);
        // Capitalize first letter
        result = result[0].toUpperCase() + result.substring(1);
        return result;
      }
    }
    
    // If no translation found, return original with capitalized first letter
    return ingredient[0].toUpperCase() + ingredient.substring(1).toLowerCase();
  }

  // Translates a list of ingredients
  static List<Map<String, String>> translateIngredients(List<Map<String, String>> ingredients) {
    return ingredients.map((ing) {
      String originalName = ing['name'] ?? '';
      String translatedName = translate(originalName);
      
      return {
        'name': translatedName,
        'measure': ing['measure'] ?? '',
      };
    }).toList();
  }

  // Translates recipe titles (only common words, keeps proper names)
  static String translateTitle(String title) {
    if (title.isEmpty) return title;
    
    // Additional title-specific translations (cooking methods, dish types, etc.)
    final Map<String, String> titleSpecific = {
      // Cooking methods
      'baked': 'al forno',
      'grilled': 'alla griglia',
      'fried': 'fritto',
      'roasted': 'arrosto',
      'steamed': 'al vapore',
      'boiled': 'bollito',
      'sauteed': 'saltato',
      'sautéed': 'saltato',
      'stewed': 'in umido',
      'braised': 'brasato',
      'stuffed': 'ripieno',
      
      // Dish types
      'salad': 'insalata',
      'soup': 'zuppa',
      'stew': 'stufato',
      'curry': 'curry',
      'risotto': 'risotto',
      'pie': 'torta',
      'tart': 'crostata',
      'cake': 'torta',
      'sandwich': 'panino',
      'burger': 'hamburger',
      'wrap': 'wrap',
      'bowl': 'bowl',
      
      // Common words
      'with': 'con',
      'and': 'e',
      'in': 'in',
      'of': 'di',
      'the': '',
      'a': '',
      
      // Colors
      'red': 'rosso',
      'green': 'verde',
      'yellow': 'giallo',
      'white': 'bianco',
      'black': 'nero',
      'golden': 'dorato',
      'brown': 'marrone',
      
      // Sizes
      'big': 'grande',
    };
    
    // Combine both dictionaries (title-specific takes priority)
    final Map<String, String> combined = {..._translations, ...titleSpecific};
    
    // Split title into words
    List<String> words = title.split(' ');
    List<String> translatedWords = [];
    
    for (String word in words) {
      String lowerWord = word.toLowerCase();
      
      // Remove punctuation for lookup
      String cleanWord = lowerWord.replaceAll(RegExp(r'[,\.\!\?\:\;]'), '');
      
      if (combined.containsKey(cleanWord)) {
        // Translate
        String translated = combined[cleanWord]!;
        
        // Skip empty translations (like "the", "a")
        if (translated.isEmpty) continue;
        
        // Preserve capitalization of first letter
        if (word.isNotEmpty && word[0] == word[0].toUpperCase()) {
          translated = translated[0].toUpperCase() + translated.substring(1);
        }
        translatedWords.add(translated);
      } else {
        // Keep original word (proper names, unknown words)
        translatedWords.add(word);
      }
    }
    
    return translatedWords.join(' ');
  }
}