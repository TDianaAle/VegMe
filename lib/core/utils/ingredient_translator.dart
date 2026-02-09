class IngredientTranslator {
  // Dizionario completo ingredienti
  static const Map<String, String> _ingredients = {
    // Verdure
    'tomato': 'pomodoro',
    'tomatoes': 'pomodori',
    'cherry tomato': 'pomodorino',
    'cherry tomatoes': 'pomodorini',
    'sun-dried tomato': 'pomodoro secco',
    'sun-dried tomatoes': 'pomodori secchi',
    'canned tomato': 'pomodoro in scatola',
    'canned tomatoes': 'pomodori in scatola',
    'tomato paste': 'concentrato di pomodoro',
    'tomato sauce': 'salsa di pomodoro',
    'onion': 'cipolla',
    'onions': 'cipolle',
    'red onion': 'cipolla rossa',
    'white onion': 'cipolla bianca',
    'spring onion': 'cipollotto',
    'scallion': 'cipollotto',
    'scallions': 'cipollotti',
    'spring onion tops': 'punta di cipollotto',
    'scallion tops': 'punte di cipollotto',    
    'scallions tops': 'punte di cipollotti',
    'shallot': 'scalogno',
    'shallots': 'scalogni',
    'garlic': 'aglio',
    'garlic clove': 'spicchio d\'aglio',
    'garlic powder': 'aglio in polvere',
    'carrot': 'carota',
    'carrots': 'carote',
    'baby carrot': 'carota baby',
    'baby carrots': 'carote baby',
    'potato': 'patata',
    'potatoes': 'patate',
    'sweet potato': 'patata dolce',
    'sweet potatoes': 'patate dolci',
    'zucchini': 'zucchina',
    'courgette': 'zucchina',
    'eggplant': 'melanzana',
    'aubergine': 'melanzana',
    'bell pepper': 'peperone',
    'red bell pepper': 'peperone rosso',
    'green bell pepper': 'peperone verde',
    'yellow bell pepper': 'peperone giallo',
    'chili pepper': 'peperoncino',
    'jalapeño': 'jalapeño',
    'mushroom': 'fungo',
    'mushrooms': 'funghi',
    'button mushroom': 'fungo champignon',
    'portobello mushroom': 'fungo portobello',
    'spinach': 'spinaci',
    'baby spinach': 'spinaci baby',
    'lettuce': 'lattuga',
    'romaine lettuce': 'lattuga romana',
    'iceberg lettuce': 'lattuga iceberg',
    'kale': 'cavolo riccio',
    'curly kale': 'cavolo riccio',
    'rocket': 'rucola',
    'arugula': 'rucola',
    'cucumber': 'cetriolo',
    'broccoli': 'broccoli',
    'broccolini': 'broccolini',
    'cauliflower': 'cavolfiore',
    'cabbage': 'cavolo',
    'red cabbage': 'cavolo rosso',
    'chinese cabbage': 'cavolo cinese',
    'brussels sprout': 'cavoletto di bruxelles',
    'brussels sprouts': 'cavoletti di bruxelles',
    'celery': 'sedano',
    'celery stalk': 'gambo di sedano',
    'celery seed': 'semi di sedano',
    'leek': 'porro',
    'leeks': 'porri',
    'asparagus': 'asparagi',
    'artichoke': 'carciofo',
    'artichokes': 'carciofi',
    'fennel': 'finocchio',
    'beetroot': 'barbabietola',
    'beet': 'barbabietola',
    'radish': 'ravanello',
    'radishes': 'ravanelli',
    'turnip': 'rapa',
    'pumpkin': 'zucca',
    'squash': 'zucca',
    'butternut squash': 'zucca butternut',
    'corn': 'mais',
    'sweetcorn': 'mais dolce',
    
    // Erbe aromatiche
    'basil': 'basilico',
    'fresh basil': 'basilico fresco',
    'parsley': 'prezzemolo',
    'flat-leaf parsley': 'prezzemolo a foglia piatta',
    'coriander': 'coriandolo',
    'oregano': 'origano',
    'thyme': 'timo',
    'rosemary': 'rosmarino',
    'sage': 'salvia',
    'mint': 'menta',
    'dill': 'aneto',
    'chives': 'erba cipollina',
    'bay leaf': 'foglia di alloro',
    'bay leaves': 'foglie di alloro',
    'marjoram': 'maggiorana',
    'tarragon': 'dragoncello',
    
    // Legumi e cereali
    'rice': 'riso',
    'white rice': 'riso bianco',
    'brown rice': 'riso integrale',
    'basmati rice': 'riso basmati',
    'jasmine rice': 'riso jasmine',
    'arborio rice': 'riso arborio',
    'quinoa': 'quinoa',
    'couscous': 'couscous',
    'bulgur': 'bulgur',
    'pasta': 'pasta',
    'spaghetti': 'spaghetti',
    'penne': 'penne',
    'fusilli': 'fusilli',
    'farfalle': 'farfalle',
    'rigatoni': 'rigatoni',
    'oats': 'avena',
    'rolled oats': 'fiocchi d\'avena',
    'flour': 'farina',
    'all-purpose flour': 'farina 00',
    'whole wheat flour': 'farina integrale',
    'bread': 'pane',
    'breadcrumbs': 'pangrattato',
    
    // Legumi
    'beans': 'fagioli',
    'black beans': 'fagioli neri',
    'kidney beans': 'fagioli rossi',
    'white beans': 'fagioli bianchi',
    'cannellini beans': 'fagioli cannellini',
    'pinto beans': 'fagioli pinto',
    'green beans': 'fagiolini',
    'broad beans': 'fave',
    'chickpeas': 'ceci',
    'lentils': 'lenticchie',
    'red lentils': 'lenticchie rosse',
    'green lentils': 'lenticchie verdi',
    'peas': 'piselli',
    'split peas': 'piselli spezzati',
    'edamame': 'edamame',
    'tofu': 'tofu',
    'firm tofu': 'tofu compatto',
    'silken tofu': 'tofu morbido',
    'tempeh': 'tempeh',
    
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
    'blueberry': 'mirtillo',
    'blueberries': 'mirtilli',
    'raspberry': 'lampone',
    'raspberries': 'lamponi',
    'blackberry': 'mora',
    'blackberries': 'more',
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
    'raisin': 'uvetta',
    'raisins': 'uvetta',
    
    // Condimenti e oli
    'olive oil': 'olio d\'oliva',
    'extra virgin olive oil': 'olio extravergine d\'oliva',
    'vegetable oil': 'olio vegetale',
    'sunflower oil': 'olio di girasole',
    'coconut oil': 'olio di cocco',
    'sesame oil': 'olio di sesamo',
    'vinegar': 'aceto',
    'balsamic vinegar': 'aceto balsamico',
    'white wine vinegar': 'aceto di vino bianco',
    'red wine vinegar': 'aceto di vino rosso',
    'apple cider vinegar': 'aceto di mele',
    'soy sauce': 'salsa di soia',
    'tamari': 'tamari',
    'hot sauce': 'salsa piccante',
    'sriracha': 'salsa sriracha',
    'mustard': 'senape',
    'dijon mustard': 'senape di digione',
    'ketchup': 'ketchup',
    'mayonnaise': 'maionese',
    'tahini': 'tahini',
    'peanut butter': 'burro di arachidi',
    'almond butter': 'burro di mandorle',
    
    // Spezie
    'salt': 'sale',
    'sea salt': 'sale marino',
    'kosher salt': 'sale kosher',
    'pepper': 'pepe',
    'black pepper': 'pepe nero',
    'white pepper': 'pepe bianco',
    'ground pepper': 'pepe macinato',
    'peppercorn': 'grano di pepe',
    'chili': 'peperoncino',
    'chili powder': 'peperoncino in polvere',
    'chili flakes': 'peperoncino in scaglie',
    'red pepper flakes': 'fiocchi di peperoncino',
    'cayenne pepper': 'pepe di cayenna',
    'paprika': 'paprika',
    'smoked paprika': 'paprika affumicata',
    'cumin': 'cumino',
    'ground cumin': 'cumino macinato',
    'ground coriander': 'coriandolo macinato',
    'turmeric': 'curcuma',
    'ground turmeric': 'curcuma macinata',
    'ginger': 'zenzero',
    'fresh ginger': 'zenzero fresco',
    'ground ginger': 'zenzero in polvere',
    'cinnamon': 'cannella',
    'ground cinnamon': 'cannella in polvere',
    'cinnamon stick': 'stecca di cannella',
    'nutmeg': 'noce moscata',
    'ground nutmeg': 'noce moscata macinata',
    'clove': 'chiodo di garofano',
    'cloves': 'chiodi di garofano',
    'cardamom': 'cardamomo',
    'star anise': 'anice stellato',
    'fennel seed': 'semi di finocchio',
    'caraway seed': 'semi di cumino',
    'mustard seed': 'semi di senape',
    'sesame seed': 'semi di sesamo',
    'Sesame seeds': 'semi di sesamo',
    'poppy seed': 'semi di papavero',
    'vanilla': 'vaniglia',
    'vanilla extract': 'estratto di vaniglia',
    'vanilla bean': 'bacca di vaniglia',
    'curry powder': 'curry in polvere',
    'garam masala': 'garam masala',
    
    // Latticini (per vegetariani)
    'milk': 'latte',
    'whole milk': 'latte intero',
    'skim milk': 'latte scremato',
    'almond milk': 'latte di mandorla',
    'soy milk': 'latte di soia',
    'oat milk': 'latte d\'avena',
    'coconut milk': 'latte di cocco',
    'cream': 'panna',
    'heavy cream': 'panna da cucina',
    'sour cream': 'panna acida',
    'whipped cream': 'panna montata',
    'butter': 'burro',
    'unsalted butter': 'burro non salato',
    'vegan butter': 'burro vegano',
    'cheese': 'formaggio',
    'parmesan': 'parmigiano',
    'mozzarella': 'mozzarella',
    'ricotta': 'ricotta',
    'feta': 'feta',
    'cheddar': 'cheddar',
    'goat cheese': 'formaggio di capra',
    'cream cheese': 'formaggio spalmabile',
    'yogurt': 'yogurt',
    'greek yogurt': 'yogurt greco',
    'egg': 'uovo',
    'eggs': 'uova',
    'egg white': 'albume',
    'egg yolk': 'tuorlo',
    
    // Frutta secca e semi
    'almonds': 'mandorle',
    'sliced almonds': 'mandorle a fette',
    'almond flour': 'farina di mandorle',
    'walnuts': 'noci',
    'hazelnuts': 'nocciole',
    'pistachios': 'pistacchi',
    'cashews': 'anacardi',
    'peanuts': 'arachidi',
    'pecans': 'noci pecan',
    'pine nuts': 'pinoli',
    'macadamia nuts': 'noci di macadamia',
    'sunflower seeds': 'semi di girasole',
    'pumpkin seeds': 'semi di zucca',
    'chia seeds': 'semi di chia',
    'flax seeds': 'semi di lino',
    'hemp seeds': 'semi di canapa',
    
    // Altro
    'water': 'acqua',
    'vegetable broth': 'brodo vegetale',
    'vegetable stock': 'brodo vegetale',
    'chicken broth': 'brodo di pollo',
    'beef broth': 'brodo di manzo',
    'wine': 'vino',
    'white wine': 'vino bianco',
    'red wine': 'vino rosso',
    'sugar': 'zucchero',
    'brown sugar': 'zucchero di canna',
    'powdered sugar': 'zucchero a velo',
    'honey': 'miele',
    'maple syrup': 'sciroppo d\'acero',
    'agave': 'agave',
    'molasses': 'melassa',
    'cornstarch': 'amido di mais',
    'baking powder': 'lievito in polvere',
    'baking soda': 'bicarbonato di sodio',
    'yeast': 'lievito',
    'cocoa powder': 'cacao in polvere',
    'chocolate': 'cioccolato',
    'dark chocolate': 'cioccolato fondente',
    'chocolate chips': 'gocce di cioccolato',
    'noodles': 'noodles',
    'rice noodles': 'noodles di riso',
    'seaweed': 'alga',
    'nori': 'alga nori',
    'liquid smoke': 'fumo liquido',
    'nutritional yeast': 'lievito alimentare',
  };

  // Unità di misura
  static const Map<String, String> _units = {
    // Volume
    'ml': 'ml',
    'l': 'l',
    'liter': 'litro',
    'liters': 'litri',
    'tsp': 'cucchiaino',
    'tsps': 'cucchiaini',
    'teaspoon': 'cucchiaino',
    'teaspoons': 'cucchiaini',
    'tbsp': 'cucchiaio',
    'tbsps': 'cucchiai',
    'tablespoon': 'cucchiaio',
    'tablespoons': 'cucchiai',
    'cup': 'tazza',
    'cups': 'tazze',
    'fl oz': 'fl oz',
    'fluid ounce': 'oncia fluida',
    
    // Peso
    'g': 'g',
    'kg': 'kg',
    'gram': 'grammo',
    'grams': 'grammi',
    'kilogram': 'chilogrammo',
    'oz': 'oz',
    'ounce': 'oncia',
    'ounces': 'once',
    'lb': 'lb',
    'pound': 'libbra',
    'pounds': 'libbre',
    
    // Quantità
    'clove': 'spicchio',
    'cloves': 'spicchi',
    'bunch': 'mazzo',
    'bunches': 'mazzi',
    'stalk': 'gambo',
    'stalks': 'gambi',
    'stick': 'stecca',
    'sticks': 'stecche',
    'sprig': 'rametto',
    'sprigs': 'rametti',
    'leaf': 'foglia',
    'leaves': 'foglie',
    'head': 'testa',
    'heads': 'teste',
    'bulb': 'bulbo',
    'bulbs': 'bulbi',
    'can': 'barattolo',
    'cans': 'barattoli',
    'jar': 'vasetto',
    'jars': 'vasetti',
    'package': 'confezione',
    'packages': 'confezioni',
    'slice': 'fetta',
    'slices': 'fette',
    'piece': 'pezzo',
    'pieces': 'pezzi',
    'serving': 'porzione',
    'servings': 'porzioni',
    'handful': 'manciata',
    'handfuls': 'manciate',
    'dash': 'pizzico',
    'dashes': 'pizzichi',
    'pinch': 'pizzico',
    'pinches': 'pizzichi',
    
    // Dimensioni
    'small': 'piccolo',
    'medium': 'medio',
    'large': 'grande',
    'extra large': 'extra grande',
  };

  // Aggettivi/modificatori
  static const Map<String, String> _modifiers = {
    'fresh': 'fresco',
    'dried': 'secco',
    'frozen': 'congelato',
    'canned': 'in scatola',
    'chopped': 'tritato',
    'minced': 'tritato finemente',
    'diced': 'a cubetti',
    'sliced': 'affettato',
    'ground': 'macinato',
    'grated': 'grattugiato',
    'shredded': 'sminuzzato',
    'crushed': 'schiacciato',
    'whole': 'intero',
    'halved': 'tagliato a metà',
    'quartered': 'tagliato in quarti',
    'peeled': 'sbucciato',
    'seeded': 'senza semi',
    'roasted': 'arrostito',
    'toasted': 'tostato',
    'raw': 'crudo',
    'cooked': 'cotto',
    'steamed': 'al vapore',
    'optional': 'facoltativo',
  };

  /// Traduce ingrediente completo gestendo l'ordine delle parole
  static Map<String, String> translateFullIngredient(String name, String measure) {
    String translatedName = _translateIngredientName(name);
    String translatedMeasure = _translateMeasure(measure);
    
    return {
      'name': translatedName,
      'measure': translatedMeasure,
    };
  }

  /// Traduce il nome dell'ingrediente con ordine corretto
  static String _translateIngredientName(String name) {
    if (name.isEmpty) return '';
    
    String cleaned = name.toLowerCase().trim();
    
    // Rimuovi "optional:" all'inizio
    if (cleaned.startsWith('optional:')) {
      cleaned = cleaned.replaceFirst('optional:', '').trim();
    }
    
    // Cerca traduzione diretta
    if (_ingredients.containsKey(cleaned)) {
      return _ingredients[cleaned]!;
    }
    
    // Gestisci pattern "X of Y" → "Y di X"
    final ofPattern = RegExp(r'(\w+)\s+of\s+(.+)');
    final ofMatch = ofPattern.firstMatch(cleaned);
    if (ofMatch != null) {
      String quantity = ofMatch.group(1)!;
      String ingredient = ofMatch.group(2)!;
      String transQuantity = _units[quantity] ?? _modifiers[quantity] ?? quantity;
      String transIngredient = _ingredients[ingredient] ?? ingredient;
      return '$transIngredient di $transQuantity';
    }
    
    // Separa modificatori da ingrediente principale
    List<String> words = cleaned.split(' ');
    List<String> modifiersList = [];
    String mainIngredient = '';
    
    // Identifica modificatori e ingrediente principale
    for (int i = 0; i < words.length; i++) {
      if (_modifiers.containsKey(words[i])) {
        modifiersList.add(_modifiers[words[i]]!);
      } else {
        // Il resto è l'ingrediente principale
        mainIngredient = words.sublist(i).join(' ');
        break;
      }
    }
    
    // Traduci ingrediente principale
    String translatedMain = _ingredients[mainIngredient] ?? 
                           _findPartialTranslation(mainIngredient);
    
    // Ricomponi: ingrediente + modificatori in italiano
    if (modifiersList.isEmpty) {
      return translatedMain;
    } else {
      return '$translatedMain ${modifiersList.join(' ')}';
    }
  }

  /// Cerca traduzione parziale
  static String _findPartialTranslation(String text) {
    // Prova a trovare la parola più lunga che ha traduzione
    List<String> words = text.split(' ');
    
    for (int len = words.length; len > 0; len--) {
      for (int start = 0; start <= words.length - len; start++) {
        String phrase = words.sublist(start, start + len).join(' ');
        if (_ingredients.containsKey(phrase)) {
          // Sostituisci e mantieni il resto
          return text.replaceAll(phrase, _ingredients[phrase]!);
        }
      }
    }
    
    // Capitalizza se non trovato
    return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
  }

  /// Traduce misura con numero + unità
  static String _translateMeasure(String measure) {
    if (measure.isEmpty) return '';
    
    String cleaned = measure.toLowerCase().trim();
    
    // Estrai numero e unità
    final pattern = RegExp(r'([\d.]+)\s*(.*)');
    final match = pattern.firstMatch(cleaned);
    
    if (match == null) return measure;
    
    String numStr = match.group(1)!;
    String unit = match.group(2)!.trim();
    
    // Converti numero
    double num = double.tryParse(numStr) ?? 0;
    
    // Traduci unità
    String translatedUnit = _translateUnit(unit, num);
    
    // Formatta
    return _formatMeasure(num, translatedUnit);
  }

  /// Traduce unità con singolare/plurale
  static String _translateUnit(String unit, double quantity) {
    if (unit.isEmpty) return '';
    
    // Cerca traduzione diretta
    if (_units.containsKey(unit)) {
      String translated = _units[unit]!;
      return _adjustPlural(translated, quantity);
    }
    
    // Cerca parziale
    for (var entry in _units.entries) {
      if (unit.contains(entry.key)) {
        String translated = entry.value;
        return _adjustPlural(translated, quantity);
      }
    }
    
    return unit;
  }

  /// Aggiusta singolare/plurale
static String _adjustPlural(String unit, double quantity) {
  if (quantity == 1.0) {
    // Singolare
    return unit
        .replaceAll('cucchiai', 'cucchiaio')
        .replaceAll('cucchiaini', 'cucchiaino')
        .replaceAll('tazze', 'tazza')
        .replaceAll('spicchi', 'spicchio')
        .replaceAll('gambi', 'gambo')
        .replaceAll('mazzi', 'mazzo')
        .replaceAll('stecche', 'stecca')
        .replaceAll('rametti', 'rametto')
        .replaceAll('foglie', 'foglia')
        .replaceAll('teste', 'testa')
        .replaceAll('porzioni', 'porzione')
        .replaceAll('manciate', 'manciata')
        .replaceAll('pizzichi', 'pizzico')
        .replaceAll('grammi', 'grammo')
        .replaceAll('litri', 'litro');
  }
  return unit;
}

  /// Formatta numero + unità
  static String _formatMeasure(double amount, String unit) {
    if (amount == 0) return '';
    
    String numStr;
    if (amount == amount.toInt()) {
      numStr = amount.toInt().toString();
    } else {
      numStr = amount.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    }
    
    return unit.isEmpty ? numStr : '$numStr $unit';
  }
}