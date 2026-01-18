class TranslationService {
  // Dizionario italiano -> inglese per ricerche
  static const Map<String, String> _italianToEnglish = {
    // Verdure
    'pomodoro': 'tomato',
    'pomodori': 'tomato',
    'cipolla': 'onion',
    'cipolle': 'onion',
    'aglio': 'garlic',
    'patata': 'potato',
    'patate': 'potato',
    'carota': 'carrot',
    'carote': 'carrot',
    'sedano': 'celery',
    'spinaci': 'spinach',
    'lattuga': 'lettuce',
    'cetriolo': 'cucumber',
    'peperone': 'pepper',
    'peperoni': 'peppers',
    'peperoncino': 'chilli',
    'fungo': 'mushroom',
    'funghi': 'mushroom',
    'zucchina': 'zucchini',
    'zucchine': 'zucchini',
    'melanzana': 'eggplant',
    'melanzane': 'eggplant',
    'broccoli': 'broccoli',
    'cavolfiore': 'cauliflower',
    'cavolo': 'cabbage',
    'piselli': 'peas',
    'fagiolini': 'green beans',
    'fagioli': 'beans',
    'lenticchie': 'lentils',
    'ceci': 'chickpeas',
    'mais': 'corn',
    'asparagi': 'asparagus',
    'carciofo': 'artichoke',
    'carciofi': 'artichoke',
    'porro': 'leek',
    'porri': 'leek',
    'zucca': 'pumpkin',
    'rucola': 'rocket',
    'basilico': 'basil',
    'prezzemolo': 'parsley',
    'coriandolo': 'coriander',
    'menta': 'mint',
    'origano': 'oregano',
    'timo': 'thyme',
    'rosmarino': 'rosemary',
    'salvia': 'sage',
    'alloro': 'bay leaf',
    
    // Frutta
    'mela': 'apple',
    'mele': 'apple',
    'banana': 'banana',
    'banane': 'banana',
    'arancia': 'orange',
    'arance': 'orange',
    'limone': 'lemon',
    'limoni': 'lemon',
    'fragola': 'strawberry',
    'fragole': 'strawberry',
    'lampone': 'raspberry',
    'lamponi': 'raspberry',
    'mirtillo': 'blueberry',
    'mirtilli': 'blueberry',
    'uva': 'grape',
    'pesca': 'peach',
    'pera': 'pear',
    'ciliegia': 'cherry',
    'ciliegie': 'cherry',
    'mango': 'mango',
    'ananas': 'pineapple',
    'cocco': 'coconut',
    'avocado': 'avocado',
    'melone': 'melon',
    'anguria': 'watermelon',
    'fico': 'fig',
    'fichi': 'fig',
    'datteri': 'dates',
    'uvetta': 'raisins',
    
    // Latticini e uova
    'latte': 'milk',
    'panna': 'cream',
    'burro': 'butter',
    'formaggio': 'cheese',
    'parmigiano': 'parmesan',
    'mozzarella': 'mozzarella',
    'ricotta': 'ricotta',
    'mascarpone': 'mascarpone',
    'gorgonzola': 'gorgonzola',
    'feta': 'feta',
    'yogurt': 'yogurt',
    'uovo': 'egg',
    'uova': 'egg',
    
    // Cereali e pasta
    'farina': 'flour',
    'riso': 'rice',
    'pasta': 'pasta',
    'spaghetti': 'spaghetti',
    'penne': 'penne',
    'lasagna': 'lasagne',
    'lasagne': 'lasagne',
    'pane': 'bread',
    'pangrattato': 'breadcrumbs',
    'avena': 'oats',
    'quinoa': 'quinoa',
    'polenta': 'polenta',
    
    // Piatti e tipi
    'zuppa': 'soup',
    'insalata': 'salad',
    'risotto': 'risotto',
    'pizza': 'pizza',
    'torta': 'cake',
    'dolce': 'dessert',
    'dessert': 'dessert',
    'colazione': 'breakfast',
    'antipasto': 'starter',
    'contorno': 'side',
    'frittata': 'omelette',
    'pancake': 'pancakes',
    
    // Termini culinari
    'vegetariano': 'vegetarian',
    'vegano': 'vegan',
    'arrosto': 'roasted',
    'grigliato': 'grilled',
    'fritto': 'fried',
    'forno': 'baked',
    'ripieno': 'stuffed',
    'cremoso': 'creamy',
    'piccante': 'spicy',
    
    // Spezie e condimenti
    'cannella': 'cinnamon',
    'cumino': 'cumin',
    'paprika': 'paprika',
    'curcuma': 'turmeric',
    'zenzero': 'ginger',
    'curry': 'curry',
    'vaniglia': 'vanilla',
    'cioccolato': 'chocolate',
    'cacao': 'cocoa',
    'miele': 'honey',
    'zucchero': 'sugar',
    'sale': 'salt',
    'pepe': 'pepper',
    'olio': 'oil',
    'aceto': 'vinegar',
    
    // Frutta secca
    'mandorle': 'almonds',
    'noci': 'walnuts',
    'nocciole': 'hazelnuts',
    'anacardi': 'cashews',
    'arachidi': 'peanuts',
    'pinoli': 'pine nuts',
    'pistacchi': 'pistachios',
    
    // Altro
    'tofu': 'tofu',
    'tempeh': 'tempeh',
    'seitan': 'seitan',
  };

  /// Traduce una query di ricerca da italiano a inglese per l'API
  static String translateSearchQuery(String query) {
    String translated = query.toLowerCase().trim();
    
    // Prima cerca corrispondenza esatta della query completa
    if (_italianToEnglish.containsKey(translated)) {
      return _italianToEnglish[translated]!;
    }
    
    // Poi prova a tradurre parola per parola
    final words = translated.split(' ');
    final translatedWords = words.map((word) {
      return _italianToEnglish[word] ?? word;
    }).toList();
    
    return translatedWords.join(' ');
  }

  // Dizionario ingredienti inglese -> italiano
  static const Map<String, String> _ingredients = {
    // Verdure
    'tomato': 'pomodoro',
    'tomatoes': 'pomodori',
    'onion': 'cipolla',
    'onions': 'cipolle',
    'garlic': 'aglio',
    'garlic clove': 'spicchio d\'aglio',
    'garlic cloves': 'spicchi d\'aglio',
    'potato': 'patata',
    'potatoes': 'patate',
    'carrot': 'carota',
    'carrots': 'carote',
    'celery': 'sedano',
    'spinach': 'spinaci',
    'lettuce': 'lattuga',
    'cucumber': 'cetriolo',
    'peppers': 'peperoni',
    'bell pepper': 'peperone',
    'red pepper': 'peperone rosso',
    'green pepper': 'peperone verde',
    'yellow pepper': 'peperone giallo',
    'chilli': 'peperoncino',
    'chili': 'peperoncino',
    'mushroom': 'fungo',
    'mushrooms': 'funghi',
    'zucchini': 'zucchina',
    'courgette': 'zucchina',
    'eggplant': 'melanzana',
    'aubergine': 'melanzana',
    'broccoli': 'broccoli',
    'cauliflower': 'cavolfiore',
    'cabbage': 'cavolo',
    'peas': 'piselli',
    'green beans': 'fagiolini',
    'beans': 'fagioli',
    'lentils': 'lenticchie',
    'chickpeas': 'ceci',
    'corn': 'mais',
    'sweetcorn': 'mais dolce',
    'asparagus': 'asparagi',
    'artichoke': 'carciofo',
    'leek': 'porro',
    'leeks': 'porri',
    'spring onion': 'cipollotto',
    'spring onions': 'cipollotti',
    'shallot': 'scalogno',
    'shallots': 'scalogni',
    'radish': 'ravanello',
    'beetroot': 'barbabietola',
    'pumpkin': 'zucca',
    'squash': 'zucca',
    'butternut squash': 'zucca butternut',
    'kale': 'cavolo riccio',
    'rocket': 'rucola',
    'arugula': 'rucola',
    'basil': 'basilico',
    'parsley': 'prezzemolo',
    'coriander': 'coriandolo',
    'cilantro': 'coriandolo',
    'mint': 'menta',
    'oregano': 'origano',
    'thyme': 'timo',
    'rosemary': 'rosmarino',
    'sage': 'salvia',
    'bay leaf': 'alloro',
    'bay leaves': 'foglie di alloro',
    'dill': 'aneto',
    'chives': 'erba cipollina',
    
    // Frutta
    'apple': 'mela',
    'apples': 'mele',
    'banana': 'banana',
    'bananas': 'banane',
    'orange': 'arancia',
    'oranges': 'arance',
    'lemon': 'limone',
    'lemons': 'limoni',
    'lemon juice': 'succo di limone',
    'lemon zest': 'scorza di limone',
    'lime': 'lime',
    'lime juice': 'succo di lime',
    'strawberry': 'fragola',
    'strawberries': 'fragole',
    'raspberry': 'lampone',
    'raspberries': 'lamponi',
    'blueberry': 'mirtillo',
    'blueberries': 'mirtilli',
    'grape': 'uva',
    'grapes': 'uva',
    'peach': 'pesca',
    'pear': 'pera',
    'cherry': 'ciliegia',
    'cherries': 'ciliegie',
    'mango': 'mango',
    'pineapple': 'ananas',
    'coconut': 'cocco',
    'coconut milk': 'latte di cocco',
    'coconut cream': 'crema di cocco',
    'avocado': 'avocado',
    'melon': 'melone',
    'watermelon': 'anguria',
    'fig': 'fico',
    'figs': 'fichi',
    'dates': 'datteri',
    'raisins': 'uvetta',
    'sultanas': 'uvetta sultanina',
    'dried apricots': 'albicocche secche',
    'prunes': 'prugne secche',
    
    // Latticini e uova
    'milk': 'latte',
    'cream': 'panna',
    'heavy cream': 'panna da montare',
    'sour cream': 'panna acida',
    'butter': 'burro',
    'cheese': 'formaggio',
    'parmesan': 'parmigiano',
    'parmesan cheese': 'parmigiano',
    'mozzarella': 'mozzarella',
    'ricotta': 'ricotta',
    'mascarpone': 'mascarpone',
    'gorgonzola': 'gorgonzola',
    'feta': 'feta',
    'cheddar': 'cheddar',
    'goat cheese': 'formaggio di capra',
    'cream cheese': 'formaggio spalmabile',
    'yogurt': 'yogurt',
    'greek yogurt': 'yogurt greco',
    'egg': 'uovo',
    'eggs': 'uova',
    'egg yolk': 'tuorlo',
    'egg yolks': 'tuorli',
    'egg white': 'albume',
    'egg whites': 'albumi',
    
    // Cereali e pasta
    'flour': 'farina',
    'plain flour': 'farina 00',
    'all-purpose flour': 'farina 00',
    'bread flour': 'farina manitoba',
    'whole wheat flour': 'farina integrale',
    'rice': 'riso',
    'basmati rice': 'riso basmati',
    'arborio rice': 'riso arborio',
    'brown rice': 'riso integrale',
    'pasta': 'pasta',
    'spaghetti': 'spaghetti',
    'penne': 'penne',
    'fusilli': 'fusilli',
    'tagliatelle': 'tagliatelle',
    'lasagne sheets': 'sfoglie di lasagna',
    'noodles': 'noodles',
    'bread': 'pane',
    'breadcrumbs': 'pangrattato',
    'oats': 'avena',
    'rolled oats': 'fiocchi d\'avena',
    'couscous': 'cous cous',
    'quinoa': 'quinoa',
    'polenta': 'polenta',
    'cornmeal': 'farina di mais',
    
    // Olio e condimenti
    'oil': 'olio',
    'olive oil': 'olio d\'oliva',
    'extra virgin olive oil': 'olio extravergine d\'oliva',
    'vegetable oil': 'olio di semi',
    'sunflower oil': 'olio di girasole',
    'sesame oil': 'olio di sesamo',
    'vinegar': 'aceto',
    'balsamic vinegar': 'aceto balsamico',
    'wine vinegar': 'aceto di vino',
    'apple cider vinegar': 'aceto di mele',
    'salt': 'sale',
    'sea salt': 'sale marino',
    'pepper': 'pepe',
    'black pepper': 'pepe nero',
    'white pepper': 'pepe bianco',
    'sugar': 'zucchero',
    'brown sugar': 'zucchero di canna',
    'icing sugar': 'zucchero a velo',
    'powdered sugar': 'zucchero a velo',
    'honey': 'miele',
    'maple syrup': 'sciroppo d\'acero',
    'soy sauce': 'salsa di soia',
    'tomato paste': 'concentrato di pomodoro',
    'tomato sauce': 'salsa di pomodoro',
    'passata': 'passata di pomodoro',
    'pesto': 'pesto',
    'mustard': 'senape',
    'dijon mustard': 'senape di Digione',
    'mayonnaise': 'maionese',
    'ketchup': 'ketchup',
    'hot sauce': 'salsa piccante',
    'worcestershire sauce': 'salsa Worcester',
    'tahini': 'tahina',
    
    // Spezie
    'cinnamon': 'cannella',
    'cumin': 'cumino',
    'paprika': 'paprika',
    'smoked paprika': 'paprika affumicata',
    'turmeric': 'curcuma',
    'ginger': 'zenzero',
    'fresh ginger': 'zenzero fresco',
    'nutmeg': 'noce moscata',
    'cardamom': 'cardamomo',
    'curry powder': 'curry in polvere',
    'garam masala': 'garam masala',
    'chili powder': 'peperoncino in polvere',
    'cayenne pepper': 'pepe di Cayenna',
    'saffron': 'zafferano',
    'vanilla': 'vaniglia',
    'vanilla extract': 'estratto di vaniglia',
    'mixed herbs': 'erbe miste',
    'italian seasoning': 'erbe italiane',
    
    // Frutta secca e semi
    'almonds': 'mandorle',
    'walnuts': 'noci',
    'hazelnuts': 'nocciole',
    'cashews': 'anacardi',
    'peanuts': 'arachidi',
    'pine nuts': 'pinoli',
    'pistachios': 'pistacchi',
    'pecans': 'noci pecan',
    'sunflower seeds': 'semi di girasole',
    'pumpkin seeds': 'semi di zucca',
    'sesame seeds': 'semi di sesamo',
    'chia seeds': 'semi di chia',
    'flax seeds': 'semi di lino',
    'poppy seeds': 'semi di papavero',
    
    // Altro
    'water': 'acqua',
    'stock': 'brodo',
    'vegetable stock': 'brodo vegetale',
    'chicken stock': 'brodo di pollo',
    'beef stock': 'brodo di manzo',
    'wine': 'vino',
    'white wine': 'vino bianco',
    'red wine': 'vino rosso',
    'beer': 'birra',
    'tofu': 'tofu',
    'tempeh': 'tempeh',
    'seitan': 'seitan',
    'yeast': 'lievito',
    'baking powder': 'lievito in polvere',
    'baking soda': 'bicarbonato',
    'bicarbonate of soda': 'bicarbonato',
    'cocoa powder': 'cacao in polvere',
    'chocolate': 'cioccolato',
    'dark chocolate': 'cioccolato fondente',
    'milk chocolate': 'cioccolato al latte',
    'white chocolate': 'cioccolato bianco',
    'chocolate chips': 'gocce di cioccolato',
    'capers': 'capperi',
    'olives': 'olive',
    'black olives': 'olive nere',
    'green olives': 'olive verdi',
    'anchovy': 'acciuga',
    'anchovies': 'acciughe',
    'tuna': 'tonno',
    'salmon': 'salmone',
    
    // Unità di misura comuni
    'cup': 'tazza',
    'cups': 'tazze',
    'tablespoon': 'cucchiaio',
    'tablespoons': 'cucchiai',
    'tbsp': 'cucchiai',
    'tbs': 'cucchiai',
    'teaspoon': 'cucchiaino',
    'teaspoons': 'cucchiaini',
    'tsp': 'cucchiaini',
    'pinch': 'pizzico',
    'handful': 'manciata',
    'slice': 'fetta',
    'slices': 'fette',
    'piece': 'pezzo',
    'pieces': 'pezzi',
    'clove': 'spicchio',
    'cloves': 'spicchi',
    'bunch': 'mazzo',
    'sprig': 'rametto',
    'sprigs': 'rametti',
    'chopped': 'tritato',
    'diced': 'a dadini',
    'sliced': 'affettato',
    'minced': 'macinato',
    'grated': 'grattugiato',
    'crushed': 'schiacciato',
    'fresh': 'fresco',
    'dried': 'secco',
    'ground': 'macinato',
    'whole': 'intero',
    'large': 'grande',
    'medium': 'medio',
    'small': 'piccolo',
    'to taste': 'q.b.',
    'as needed': 'q.b.',
    'optional': 'facoltativo',
  };

  // Dizionario nomi piatti comuni
  static const Map<String, String> _dishes = {
    'soup': 'zuppa',
    'salad': 'insalata',
    'pasta': 'pasta',
    'rice': 'riso',
    'risotto': 'risotto',
    'pizza': 'pizza',
    'sandwich': 'panino',
    'burger': 'hamburger',
    'stew': 'stufato',
    'curry': 'curry',
    'pie': 'torta',
    'cake': 'torta',
    'bread': 'pane',
    'pancakes': 'pancake',
    'omelette': 'frittata',
    'omelet': 'frittata',
    'roasted': 'arrosto',
    'grilled': 'grigliato',
    'fried': 'fritto',
    'baked': 'al forno',
    'stuffed': 'ripieno',
    'creamy': 'cremoso',
    'spicy': 'piccante',
    'sweet': 'dolce',
    'vegetarian': 'vegetariano',
    'vegan': 'vegano',
    'with': 'con',
    'and': 'e',
    'in': 'in',
    'sauce': 'salsa',
    'cream sauce': 'salsa alla panna',
    'tomato sauce': 'salsa di pomodoro',
  };

  /// Traduce un singolo ingrediente
  static String translateIngredient(String ingredient) {
    final lower = ingredient.toLowerCase().trim();
    
    // Prima cerca corrispondenza esatta
    if (_ingredients.containsKey(lower)) {
      return _capitalizeFirst(_ingredients[lower]!);
    }
    
    // Poi cerca corrispondenze parziali
    String translated = ingredient;
    _ingredients.forEach((eng, ita) {
      final regex = RegExp(r'\b' + RegExp.escape(eng) + r'\b', caseSensitive: false);
      translated = translated.replaceAllMapped(regex, (match) => ita);
    });
    
    return _capitalizeFirst(translated);
  }

  /// Traduce un nome di piatto
  static String translateDishName(String dishName) {
    String translated = dishName;
    
    // Sostituisci parole chiave
    _dishes.forEach((eng, ita) {
      final regex = RegExp(r'\b' + RegExp.escape(eng) + r'\b', caseSensitive: false);
      translated = translated.replaceAllMapped(regex, (match) => ita);
    });
    
    // Traduci anche ingredienti nel nome
    _ingredients.forEach((eng, ita) {
      final regex = RegExp(r'\b' + RegExp.escape(eng) + r'\b', caseSensitive: false);
      translated = translated.replaceAllMapped(regex, (match) => ita);
    });
    
    return _capitalizeWords(translated);
  }

  /// Traduce una misura (es. "2 tablespoons" -> "2 cucchiai")
  static String translateMeasure(String measure) {
    String translated = measure.toLowerCase();
    
    _ingredients.forEach((eng, ita) {
      final regex = RegExp(r'\b' + RegExp.escape(eng) + r'\b', caseSensitive: false);
      translated = translated.replaceAllMapped(regex, (match) => ita);
    });
    
    return translated;
  }

  /// Traduce ingrediente completo con misura
  static Map<String, String> translateFullIngredient(String name, String measure) {
    return {
      'name': translateIngredient(name),
      'measure': translateMeasure(measure),
    };
  }

  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String _capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      // Non capitalizzare articoli e preposizioni brevi
      if (['e', 'con', 'in', 'di', 'a', 'da', 'per', 'al', 'alla', 'alle', 'ai'].contains(word.toLowerCase())) {
        return word.toLowerCase();
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}