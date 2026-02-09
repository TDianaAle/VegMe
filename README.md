# Relazione VegMe

Programmazione di Sistemi Mobile  

---

## 1. Scopo del Progetto

VegMe nasce dall'esigenza pratica di semplificare la pianificazione dei pasti per chi segue diete vegetariane o vegane. Durante la fase di analisi preliminare, ho identificato due problematiche ricorrenti: la difficoltà nel variare i menu settimanali e la gestione inefficiente della lista della spesa.

L'obiettivo principale è stato sviluppare un'applicazione mobile che permettesse di:

1. Pianificare i pasti settimanali in modo visuale e intuitivo
2. Accedere a un catalogo di ricette tradotte in italiano
3. Generare automaticamente liste della spesa organizzate
4. Adattare le quantità degli ingredienti in base al numero di commensali

La scelta di supportare sia il regime vegetariano che vegano deriva dall'osservazione che molte famiglie includono membri con preferenze alimentari diverse. Ho quindi implementato una modalità "both" che permette di visualizzare ricette di entrambe le categorie.

Un vincolo importante è stato garantire il funzionamento cross-platform (Android, iOS, web) mantenendo una singola codebase. Questo ha influenzato significativamente le scelte architetturali, come vedremo nelle sezioni successive.

---

## 2. Architettura del Sistema

### 2.1 Scelta dell'Architettura Client-Server

L'architettura adottata prevede tre componenti principali:

```
┌──────────────────┐
│   Flutter App    │  ← Client (Dart)
│   (Mobile/Web)   │
└────────┬─────────┘
         │ REST API
┌────────▼─────────┐
│  Backend Python  │  ← Middleware (FastAPI)
│  (Render.com)    │
└────────┬─────────┘
         │ REST API
┌────────▼─────────┐
│   Forkify API    │  ← Sorgente dati
└──────────────────┘
```

La decisione di interporre un backend custom tra l'app e Forkify non è stata immediata. Inizialmente avevo considerato l'integrazione diretta, ma tre fattori hanno guidato la scelta attuale:

**Problema 1: Traduzione**  
Forkify restituisce ricette in inglese. Integrare un servizio di traduzione direttamente nell'app avrebbe significato:
- Aumentare le dimensioni del bundle (librerie di traduzione)
- Esporre API key nel codice client
- Gestire la cache delle traduzioni su ogni dispositivo

Centralizzando la traduzione nel backend, ottengo traduzioni consistenti e cachabili lato server.

**Problema 2: Filtraggio e Qualità Dati**  
L'API Forkify non distingue esplicitamente tra vegetariano e vegano. Perciò è stata implementata una logica euristica basata sui titoli e sugli ingredienti. Spostare questa complessità nel backend mi ha permesso di iterare rapidamente sulla logica di filtro senza ridistribuire l'app e aggiungere raffinamenti progressivi (es. esclusione latte, uova per i vegani).

**Problema 3: Rate Limiting e Costi**  
Forkify è gratuita ma potrebbe introdurre limiti futuri. Avere un backend mi consente di migrare eventualmente a provider alternativi senza modificare l'account, nonché aggiungere più sorgeti dati in futuro per aumentare la disponibilità di ricette in VegMe.

### 2.2 Backend: Scelte Tecnologiche

**Framework: FastAPI**


**Traduzione: deep-translator vs googletrans**

La libreria `googletrans` presentava problemi di dipendenze (richiedeva `httpx==0.13.3`, incompatibile con la versione necessaria per altri componenti). Ho migrato a `deep-translator` che:
- Supporta httpx moderno
- Offre la stessa API di Google Translate
- Ha manutenzione attiva

**Hosting: Render Free Tier**

La scelta di Render rispetto a Heroku o Railway è stata dettata dalla necessità di utilizzare una soluzione gratuita con auto deploy da GitHub.

Il principale svantaggio è il cold start (~30 secondi) quando il servizio va in sleep. Ho mitigato questo problema con il pattern Preview/Details:

### 2.3 Pattern Preview/Details: Soluzione al Timeout

Il problema più critico affrontato è stato il timeout di 30 secondi imposto da Render. L'approccio iniziale era:

```python
for recipe_id in search_results:
    details = fetch_details(recipe_id)  # 1-2s per chiamata
    translated = translate_all(details)  # 2-3s per ricetta
```

Con 20 ricette, il tempo totale arriva quasi al minuto d'attesa.

La soluzione implementata separa il caricamento in due fasi:

**Fase 1 - Preview (2-3s totali):**
```python
GET /api/recipes/preview?type=vegetarian

# Restituisce solo metadati essenziali
{
  "recipes": [
    {
      "id": "abc123",
      "name": "Pasta al Pomodoro",  # Tradotto
      "image": "https://...",
      "isVegan": false
    },
    ...
  ]
}
```

**Fase 2 - Details on-demand (1-2s):**
```python
GET /api/recipes/{id}

# Chiamato solo al tap dell'utente
{
  "name": "Pasta al Pomodoro",
  "ingredients": [
    {"name": "400 grammi di pasta", "measure": ""},
    ...
  ]
}
```

Questo approccio ha ridotto il tempo di caricamento iniziale da oltre 60s a circa 3s, rendendo l'app utilizzabile.

### 2.4 Traduzione Contestuale vs Parola-per-Parola

Un aspetto critico è stato il metodo di traduzione degli ingredienti. L'approccio iniziale era:

```python
# Approccio ingenuo
name = translate("vegetable oil")      # → "olio vegetale"
measure = translate("1.5 tablespoons") # → "1.5 cucchiai"
```

Questo produceva risultati grammaticalmente corretti ma privi di articoli e preposizioni:
- Output: "1.5 cucchiai olio vegetale"
- Atteso: "1,5 cucchiai di olio vegetale"

La soluzione finale traduce l'intera stringa:

```python
full_text = f"{quantity} {unit} {description}"  # "1.5 tbsp vegetable oil"
translated = translate(full_text)                # "1,5 cucchiai di olio vegetale"
```

Google Translate, ricevendo il contesto completo, genera output più naturali con:
- Conversione punto-virgola per decimali
- Articoli appropriati
- Preposizioni contestuali

---

## 3. Applicazione Flutter: Struttura e Design Pattern

### 3.1 Organizzazione dei Sorgenti

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart              # Design system
│   └── services/
│       └── custom_cursor_service.dart  # Cursori personalizzati (solo web)
│
├── data/
│   ├── local/
│   │   ├── database_helper.dart        # Wrapper SQLite
│   │   ├── shared_prefs_helper.dart    # Storage web (JSON)
│   │   └── storage_manager.dart        # Facade pattern
│   └── services/
│       └── meal_api_service.dart       # HTTP client
│
└── screens/
    ├── welcome_screen.dart             # Onboarding
    ├── home_screen.dart                # Pianificazione giornaliera
    ├── search_recipes_screen.dart      # Ricerca ricette
    ├── weekly_calendar_screen.dart     # Vista settimanale
    └── shopping_list_screen.dart       # Lista spesa
```

E' stata addottata una struttura a tre livelli:

1. **core/**: Configurazioni globali e utility condivise
2. **data/**: Layer di persistenza e comunicazione esterna
3. **screens/**: UI e logica di presentazione

### 3.2 Storage Multi-Platform: Il Pattern Facade

La sfida principale nello sviluppo cross-platform è stata gestire storage eterogenei:
- **Mobile (Android/iOS):** SQLite
- **Web:** SharedPreferences (chiave-valore serializzato)

Ho implementato il pattern Facade con `StorageManager`:

```dart
class StorageManager {
  static final instance = StorageManager._init();
  
  Future<void> saveMeal(int day, String mealType, Map meal) async {
    if (kIsWeb) {
      await SharedPrefsHelper.saveMeals(...);
    } else {
      await DatabaseHelper.instance.insertMeal(...);
    }
  }
}
```

Tutti gli screen interagiscono esclusivamente con `StorageManager`, che delega all'implementazione corretta in base alla piattaforma. Questo permette di:

- Scrivere la logica business una sola volta
- Testare le implementazioni separatamente
- Aggiungere nuovi backend (es. Firebase) senza modificare gli screen

Un'alternativa considerata era usare package come `hive` (funziona ovunque), ma ho preferito soluzioni native per:
- Migliori performance su mobile (SQLite è ottimizzato)
- Maggiore controllo su schema e query
- Familiarità con strumenti standard della piattaforma

### 3.3 Sistema di Caching Multi-Livello

Per minimizzare le chiamate di rete ho implementato caching su due livelli:

**L1 - In-Memory (Session Cache)**

```dart
class _SearchRecipesScreenState {
  final Map<String, Map<String, dynamic>> _detailsCache = {};
  
  Future<void> _loadRecipe(String id) async {
    if (_detailsCache.containsKey(id)) {
      return _detailsCache[id];  // Hit: <100ms
    }
    
    final details = await _apiService.getMealDetails(id);
    _detailsCache[id] = details;
    return details;
  }
}
```

Vantaggi:
- Latenza quasi nulla per ricette già viste nella sessione
- Zero overhead di serializzazione
- Automatic garbage collection alla chiusura screen

Svantaggi:
- Perso al riavvio app
- Memoria limitata (max ~50 ricette realisticamente)

**L2 - SQLite (Persistent Cache)**

```sql
CREATE TABLE recipe_cache (
  id TEXT PRIMARY KEY,
  name TEXT,
  ingredients TEXT,  -- JSON serializzato
  cached_at INTEGER  -- Unix timestamp
);
```

Questa tabella, introdotta successivamente nel database, permette di:
- Caricare ricette istantaneamente anche dopo giorni
- Funzionare offline per ricette già visualizzate
- Ridurre consumo dati

Il flusso completo è:

1. Utente tappa ricetta
2. Check L1 cache → se hit, render immediato
3. Check L2 (SQLite) → se hit, render + populate L1
4. API call → salva in L2 e L1, render

Questo approccio ha ridotto le chiamate API durante l'uso normale dell'applicazione.

### 3.4 Gestione dello Stato: Perché Non BLoC

Flutter offre molteplici soluzioni per lo state management (Provider, BLoC, Riverpod, GetX). Ho deliberatamente scelto `StatefulWidget` con `setState()` per:

**Semplicità:**
- Curva di apprendimento minima
- Debugging più immediato (meno layer di astrazione)
- Codice più leggibile per revisori non esperti Flutter

**Scope Limitato:**
- Nessuno stato veramente globale complesso
- Dati condivisi gestiti tramite database, non in memoria
- Navigazione lineare (nessun deeplink o routing complesso)

**Performance Adeguate:**
- Rebuild localizzati (nessuna rebuild dell'intero albero)
- Liste virtualizzate (ListView.builder)
- Operazioni asincrone non bloccanti

BLoC sarebbe stata una scelta prematura per questo progetto. Tuttavia, se dovessi aggiungere funzionalità come sincronizzazione real-time o collaborazione multi-utente, migrerei a un pattern più robusto di questo tipo.

---

## 4. Implementazione Funzionalità Chiave

### 4.1 Scaling Ingredienti

Una funzionalità apparentemente semplice ma tecnicamente interessante è lo scaling degli ingredienti in base alle porzioni.

**Problema:**
Gli ingredienti arrivano come stringhe eterogenee:
- "1.5 cucchiai di olio"
- "1/2 cipolla"
- "200 grammi di pasta"
- "un pizzico di sale"

**Soluzione:**
Implementazione di un parser basato su regex:

```dart
String _scaleQuantity(String measure) {
  final regex = RegExp(r'^([\d.,/]+)\s*(.*)$');
  final match = regex.firstMatch(measure.trim());
  
  if (match != null) {
    final numberStr = match.group(1)!;
    final unit = match.group(2) ?? '';
    
    double number;
    
    // Gestione frazioni
    if (numberStr.contains('/')) {
      final parts = numberStr.split('/');
      number = double.parse(parts[0]) / double.parse(parts[1]);
    } else {
      number = double.parse(numberStr.replaceAll(',', '.'));
    }
    
    final scaledNumber = number * (_currentServings / _initialServings);
    return '${_formatNumber(scaledNumber)} $unit';
  }
  
  return measure;  // Fallback: non scalabile
}
```

Casistiche gestite:
- Decimali: `1.5` → `3.0` (per 2x porzioni)
- Frazioni: `1/2` → `1` (per 2x porzioni)
- Virgola italiana: `1,5` → `3`

Limitazioni note:
- Non scala ingredienti descrittivi ("un pizzico", "quanto basta")
- Non converte unità (2 cucchiai → 30ml)

Queste limitazioni rappresentano un punto da migliorare in futuro.

### 4.2 Generazione Lista Spesa

La lista della spesa è stata l'ultima funzionalità implementata e ha richiesto diverse iterazioni per trovare l'organizzazione ottimale.

**Approccio finale:**
Gerarchia Giorno → Pasto → Ricetta → Ingredienti:

```
📅 Lunedì
  🌅 Colazione
    ☑ Pancake vegani
      ☐ 200g farina
      ☐ 300ml latte vegetale
  🍽️ Pranzo
    ☑ Pasta al pomodoro
      ☐ 400g pasta
      ☐ 500g pomodori
```

Vantaggi:
- Contesto completo preservato
- Checkbox indipendenti per ingrediente
- Possibilità di fare spesa per singoli giorni
- Utile per identificare duplicati

**Algoritmo di estrazione ingredienti puliti:**

Un dettaglio che ha migliorato l'usabilità è rimuovere quantità dalla lista spesa:

```dart
String _extractIngredientName(String fullText) {
  return fullText
    .replaceAll(RegExp(r'^\d+([.,]\d+)?\s*'), '')           // "1.5 olio" → "olio"
    .replaceAll(RegExp(r'\b(cucchiai?|grammi?|...)\b'), '') // "olio vegetale" → "olio vegetale"
    .replaceAll(RegExp(r'\s+'), ' ')                        // normalizza spazi
    .trim();
}
```

Razionale: al supermercato l'utente decide la quantità da comprare (confezione disponibile), non ha bisogno del dato esatto.

---

## 5. Punti di Forza Architetturali

### 5.1 Separazione Client-Server

La scelta di non integrare direttamente Forkify ha permesso:

**Flessibilità:**
- E' possibile cambiare più volte la strategia di traduzione senza ridistribuire l'app
- Si può aggiungere rate limiting lato server senza impatto client
- Facile A/B testing di algoritmi di filtro

**Permette miglioramenti o future implementazioni**:
- Aggiungere ricette proprietarie
- Integrare altre API (Spoonacular, Edamam)
- Implementare raccomandazioni ML

**Costi:**
- Latenza aggiuntiva (~100ms)
- Complessità deployment (due servizi invece di uno)


### 5.2 Cache 

Lo schema del database include una tabella dedicata (recipe_cache), progettata per la persistenza delle informazioni necessarie al recupero efficiente dei contenuti precedentemente consultati. Parallelamente, l’API è stata concepita secondo principi che ne favoriscono la cacheabilità, adottando endpoint idempotenti basati su richieste GET e mantenendo l’assenza di stato lato server, in linea con il paradigma RESTful.

---

### 5.3 Traduzione

È stata sviluppata un’API custom, deployata tramite la piattaforma Render, con il ruolo di livello di astrazione tra il client applicativo e l’API di terze parti Forkify.
Questa API intermedia è responsabile del recupero dei dati delle ricette dall’API Forkify e della loro successiva elaborazione, includendo la traduzione automatica dei contenuti testuali relativi alle ricette, agli ingredienti e alle quantità.

In particolare, l’API custom gestisce:

- l’invocazione delle richieste verso l’API Forkify;
- la normalizzazione e trasformazione dei dati ricevuti;
- la traduzione automatica dei campi testuali rilevanti;
- l’esposizione di un’interfaccia uniforme e controllata verso il client.

---

## 6. Possibili Migliorie

 6.1 Backend: Da Monolite a Microservizi

L’architettura attuale del backend è basata su un singolo processo FastAPI, che incapsula l’intera logica applicativa. Sebbene questa soluzione risulti adeguata nelle fasi iniziali di sviluppo, presenta limitazioni in termini di scalabilità, manutenibilità e flessibilità evolutiva. Al fine di supportare una crescita del sistema e una gestione più efficiente dei carichi, si propone un’evoluzione verso un’architettura a microservizi, in cui le responsabilità applicative vengano suddivise in servizi indipendenti, ciascuno focalizzato su un dominio funzionale specifico.

#### 6.2 Analisi Nutrizionale

Per supportare utenti vegetariani e vegani a rischio di carenze (B12, ferro, proteine), è possibile integrare l’API USDA FoodData Central per ottenere informazioni nutrizionali dettagliate su ricette e ingredienti. La UI evidenzia indicatori chiave come "High Protein" o "Rich in Iron", mostra grafici settimanali dei macronutrienti e segnala eventuali carenze potenziali, fornendo un feedback immediato e personalizzato.

#### 6.3  Generazione Menu Automatica

Per ridurre la complessità della pianificazione settimanale dei pasti, è possibile integrare un algoritmo automatico che genera menu basati su vincoli di varietà, bilanciamento tra gruppi alimentari, stagionalità degli ingredienti e limiti di budget. L’approccio garantisce rotazione delle ricette, ottimizzazione della varietà nutrizionale e controllo della qualità dei pasti, facilitando una pianificazione rapida e nutrizionalmente equilibrata.

### 6.4 Altre implementazioni future utili:

- Aggiungere più ricette
- Aggiungere autenticazione (Firebase Auth)
- UX ottimizzabile (onboarding, tutorial)
- Export PDF menu/lista spesa
- Modalità offline completa
- Partnership con grocery
- ML recommendations
- Social features
- Traduzione in più lingue (EN, ES, FR)

---

## 8. Considerazioni su Sicurezza e Privacy

### 8.1 Superficie di Attacco Attuale

**Backend:**
- ✅ HTTPS enforced (Render)
- ✅ Input validation (Pydantic type checking)


**Client:**
- ✅ mitigazione contro SQL injection con query parametrizzate SQLite
- ✅ Dati sensibili solo locali

---

### API Utilizzate
- Forkify API. (2024). *Recipe Search API*. https://forkify-api.herokuapp.com
- Google Translate (via deep-translator). *Translation Service*. Accessed via Python library.
- https://italianrecipeapi.onrender.com (custom per traduzione e backend).




