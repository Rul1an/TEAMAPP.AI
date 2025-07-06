# JO17 Tactical Manager - Architecture Document

## 📋 Inhoudsopgave

1. [Project Overzicht](#project-overzicht)
2. [Technische Stack](#technische-stack)
3. [Architectuur Overzicht](#architectuur-overzicht)
4. [Project Structuur](#project-structuur)
5. [Data Models](#data-models)
6. [State Management](#state-management)
7. [UI/UX Design](#uiux-design)
8. [Platform Support](#platform-support)
9. [Huidige Status](#huidige-status)
10. [Bekende Issues](#bekende-issues)
11. [Toekomstige Ontwikkeling](#toekomstige-ontwikkeling)
12. [Development Guidelines](#development-guidelines)

## 🎯 Project Overzicht

JO17 Tactical Manager is een hybride Flutter applicatie voor het beheren van jeugdvoetbalteams (JO17). De app biedt functionaliteit voor:

- **Spelersbeheer**: Registratie, tracking en performance monitoring
- **Trainingsbeheer**: Planning, aanwezigheid en voortgang
- **Wedstrijdbeheer**: Planning, opstellingen en resultaten
- **Statistieken**: Team en individuele prestatie-indicatoren
- **Performance Rating**: 5-sterren beoordelingssysteem
- **Import/Export**: Excel/CSV import en export functionaliteit

### Doelgroep
- Voetbaltrainers en coaches van JO17 teams
- Team managers en assistenten
- Technische staf

### Core Features
- Offline-first architectuur
- Cross-platform (iOS, Android, Web, macOS)
- Nederlandse interface
- Real-time synchronisatie (toekomstig)
- Import/Export functionaliteit

## 🛠 Technische Stack

### Frontend Framework
- **Flutter 3.32.2**: Cross-platform UI framework
- **Dart**: Programmeertaal

### State Management
- **Riverpod 2.5.1**: Reactive state management
- **flutter_riverpod**: Flutter integratie

### Database
- **Isar 3.1.0**: NoSQL database voor mobile/desktop
- **Mock implementation**: Tijdelijke oplossing voor web
- **Supabase** (dependencies aanwezig): Toekomstige cloud database

### Navigation
- **go_router 14.2.0**: Declarative routing

### UI/Design
- **Material 3**: Design system
- **google_fonts 6.2.1**: Typography (Inter font)
- **fl_chart 0.68.0**: Grafieken en visualisaties
- **table_calendar 3.1.3**: Kalender functionaliteit

### Import/Export
- **excel 4.0.2**: Excel bestanden lezen/schrijven
- **csv 6.0.0**: CSV bestanden verwerken
- **file_picker 10.1.9**: Bestandsselectie
- **file_saver 0.2.14**: Bestanden downloaden
- **pdf 3.10.8**: PDF generatie

### Development Tools
- **build_runner**: Code generation
- **flutter_lints**: Code quality
- **riverpod_generator**: Provider generation (voorbereid)

### Toekomstige Integraties (Gepland)
- **Video Storage & Streaming**
  - Firebase Storage of Supabase Storage voor video opslag
  - Video compressie libraries (video_compress)
  - Video player packages (video_player, chewie)
  - HLS streaming voor grote video bestanden

- **AI/LLM Services**
  - OpenAI API (GPT-4) voor geavanceerde analyse
  - Anthropic Claude API als alternatief
  - LangChain voor complexe AI workflows
  - Vector database (Pinecone/Weaviate) voor kennisopslag
  - Edge AI modellen voor offline functionaliteit

- **Analytics & Monitoring**
  - Firebase Analytics voor gebruikersgedrag
  - Sentry voor error tracking
  - Performance monitoring

## 🏗 Architectuur Overzicht

```
┌─────────────────────────────────────────────────────────────┐
│                        Presentation Layer                    │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │   Screens   │  │   Widgets    │  │   Navigation     │  │
│  │             │  │              │  │   (go_router)    │  │
│  └─────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      State Management Layer                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Riverpod Providers                      │   │
│  │  - playersProvider    - matchesProvider             │   │
│  │  - trainingsProvider  - statisticsProvider          │   │
│  │  - performanceRatingProvider                        │   │
│  │  - videoProvider (toekomstig)                       │   │
│  │  - aiCoachProvider (toekomstig)                     │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Repository Layer                       │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Repositories                           │   │
│  │  - ProfileRepository    - PlayerRepository          │   │
│  │  - MatchRepository      - TrainingRepository        │   │
│  │  - PdfGenerator facade (export)                     │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────┐   │
│  │ Isar (Mobile)│  │ Mock (Web)   │  │ Supabase       │   │
│  │              │  │              │  │ (Toekomstig)   │   │
│  └──────────────┘  └──────────────┘  └────────────────┘   │
│  ┌──────────────┐  ┌──────────────┐                       │
│  │Video Storage │  │ AI/LLM APIs │                       │
│  │(Toekomstig)  │  │ (Toekomstig) │                       │
│  └──────────────┘  └──────────────┘                       │
└─────────────────────────────────────────────────────────────┘
```

### Design Patterns

1. **Repository Pattern**: Repositories (`PlayerRepository`, `MatchRepository`, etc.) isoleren data-access en verbergen opslagdetails (Isar, Supabase, Mock).
2. **Result Wrapper**: Alle repository-calls retourneren een `Result<T>` (Ok / Error) voor type-veilige foutafhandeling.
3. **Provider Pattern**: Riverpod voor dependency-injectie en reactieve state.
4. **MVVM**: ViewModels coördineren repositories; Views tonen uitsluitend UI-state.

## 📁 Project Structuur

```
jo17_tactical_manager/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── config/
│   │   ├── router.dart          # GoRouter configuratie
│   │   └── theme.dart           # App theming
│   ├── models/
│   │   ├── player.dart          # Speler model
│   │   ├── team.dart            # Team model
│   │   ├── training.dart        # Training model
│   │   ├── match.dart           # Wedstrijd model
│   │   └── performance_rating.dart # Performance rating model
│   ├── providers/
│   │   ├── player_repository_provider.dart  # Speler repository
│   │   ├── match_repository_provider.dart   # Wedstrijd repository
│   │   └── training_repository_provider.dart# Training repository
│   ├── screens/
│   │   ├── dashboard/           # Dashboard schermen
│   │   ├── players/             # Speler schermen
│   │   ├── training/            # Training schermen
│   │   └── matches/             # Wedstrijd schermen
│   ├── repositories/
│   │   ├── player_repository.dart       # Speler data access
│   │   ├── match_repository.dart        # Wedstrijd data access
│   │   └── training_repository.dart     # Training data access
│   └── widgets/
│       ├── common/              # Gedeelde widgets
│       ├── player/              # Speler-specifieke widgets
│       ├── match/               # Wedstrijd widgets
│       └── training/            # Training widgets
├── assets/                      # Assets (leeg, Google Fonts gebruikt)
├── android/                     # Android platform files
├── ios/                         # iOS platform files
├── macos/                       # macOS platform files
├── web/                         # Web platform files
└── pubspec.yaml                # Dependencies
```

## 📊 Data Models

### Player Model
```dart
class Player {
  Id id;
  String firstName;
  String lastName;
  int jerseyNumber;
  DateTime birthDate;
  Position position;
  PreferredFoot preferredFoot;
  double height;
  double weight;

  // Performance metrics
  int matchesPlayed;
  int goals;
  int assists;
  int yellowCards;
  int redCards;

  // Computed properties
  String get name;
  int get age;
  double get attendancePercentage;
}
```

### Performance Rating Model
```dart
class PerformanceRating {
  Id id;
  String playerId;
  String eventId;
  RatingType type; // match, training
  DateTime date;

  // Ratings (1-5 stars)
  double overallRating;
  double? attackingRating;
  double? defendingRating;
  double? tacticalRating;
  double? workRateRating;

  String? notes;
  String? coachId;
}
```

### Team Model
```dart
class Team {
  Id id;
  String name;
  String ageGroup;
  String season;
  Formation preferredFormation;

  // Statistics
  int matchesPlayed;
  int wins;
  int draws;
  int losses;
  int goalsFor;
  int goalsAgainst;

  // Computed properties
  int get points;
  int get goalDifference;
  double get winPercentage;
}
```

### Training Model
```dart
class Training {
  Id id;
  DateTime date;
  int duration;
  TrainingFocus focus;
  TrainingIntensity intensity;
  TrainingStatus status;

  // Attendance
  List<String> presentPlayerIds;
  List<String> absentPlayerIds;
}
```

### Match Model
```dart
class Match {
  Id id;
  DateTime date;
  String opponent;
  Location location;
  Competition competition;
  MatchStatus status;

  // Score
  int? teamScore;
  int? opponentScore;

  // Lineup
  List<String> startingLineupIds;
  List<String> substituteIds;

  // Computed properties
  MatchResult? get result;
}
```

## 🔄 State Management

### Provider Architecture

```dart
// Repository providers (dependency injection)
final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  // Switch implementation op basis van platform/build-flavour
  return LocalPlayerRepository(); // of SupabasePlayerRepository()
});

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return LocalMatchRepository();
});

// Voorbeeld ViewModel dat repositories gebruikt
class PlayersViewModel extends ChangeNotifier {
  PlayersViewModel(this._read);
  final Reader _read;

  Future<List<Player>> loadPlayers() async {
    final result = await _read(playerRepositoryProvider).getAll();
    return switch (result) {
      Ok(value: final players) => players,
      Error() => [],
    };
  }
}
```

### State Flow
1. UI ↔︎ ViewModel observe Riverpod-providers (`ref.watch()`).
2. ViewModel roept repositories aan om data te laden of bij te werken.
3. Repositories verzorgen caching & I/O (Isar offline, Supabase cloud) en geven een `Result<T>` terug.
4. ViewModel vertaalt `Result<T>` naar UI-state; widgets rebuilden automatisch.

## 🎨 UI/UX Design

### Design System
- **Material 3**: Modern Material Design
- **Color Scheme**:
  - Primary: Blue (#1976D2)
  - Secondary: Green (#388E3C)
  - Error: Red (#D32F2F)
  - Position-based colors for players

### Responsive Design
- **Desktop (>900px)**: NavigationRail, Grid layouts
- **Tablet (>600px)**: Adapted spacing, mixed layouts
- **Mobile (<600px)**: Bottom navigation, List views

### Typography
- **Font**: Inter (via Google Fonts)
- **Hierarchy**: Consistent text styles via theme

## 💻 Platform Support

### ✅ Web
- Runs in modern browsers
- URL-based routing
- Responsive design
- **Limitation**: Isar database niet ondersteund

### ✅ macOS
- Native desktop app
- Window sizing (1200x800 default)
- NavigationRail interface
- **Requirement**: Xcode + CocoaPods

### ✅ iOS
- Native mobile app
- Touch-optimized
- Bottom navigation
- **Requirement**: Xcode + CocoaPods

### ✅ Android
- Native mobile app
- Material Design
- Touch-optimized
- **Requirement**: Android SDK

## 📈 Huidige Status

### ✅ Geïmplementeerd
1. **Core Architecture**
   - Project setup met Flutter 3.32.2
   - Riverpod state management
   - GoRouter navigation
   - Responsive UI framework

2. **Models**
   - Player, Team, Training, Match models
   - Performance Rating model
   - Enums voor types en statussen
   - Computed properties

3. **UI Screens**
   - Dashboard met statistieken
   - Players lijst met search/filter
   - Player detail met performance badges
   - Match detail met lineup builder
   - Training attendance registratie
   - Edit screens voor players en matches

4. **Platform Support**
   - Web build configuratie
   - macOS build configuratie
   - Responsive design implementatie

5. **Performance Rating System**
   - 5-sterren rating voor wedstrijden en trainingen
   - Trend berekening (stijgend/dalend/stabiel)
   - Visuele badges voor speler performance
   - Rating geschiedenis in speler detail

6. **Import/Export Functionaliteit**
   - Excel import voor spelers
   - CSV import ondersteuning
   - Template generator voor gebruikers
   - Excel export voor spelers, wedstrijden en trainingen
   - PDF export voor rapporten
   - Web-compatibele file handling

### 🚧 In Progress & Roadmap

#### Phase 2: Enhanced Features ✅ (Mostly Complete)
- [x] **Edit Functionaliteit**
  - [x] Edit player screen met form validatie
  - [x] Delete player functionaliteit
  - [x] Edit match screen met score en status updates
  - [x] Delete match functionaliteit
  - [ ] Edit training screen

- [x] **Performance Rating**
  - [x] Rating model en database integratie
  - [x] Rating widgets (StarRating, InteractiveStarRating)
  - [x] Performance badges
  - [x] Rating dialog voor input
  - [x] Integratie in match en training screens
  - [ ] Periodieke assessments UI
  - [ ] Ontwikkelingsdoelen tracking

- [x] **Import/Export**
  - [x] Excel/CSV import voor spelers
  - [x] Template download functionaliteit
  - [x] Excel export voor alle data types
  - [x] Web-compatibele implementatie
  - [ ] Match schedule import
  - [ ] Training planning import
  - [ ] Bulk operations

#### Phase 3: Advanced Features 🚧
- [ ] **Team Lineup Builder**
  - [x] Basic lineup selection
  - [ ] Drag & drop interface
  - [ ] Formation templates (4-3-3, 4-4-2, etc.)
  - [ ] Save/load lineups
  - [ ] Tactical board

- [ ] **Video Integration** (See VIDEO_FEATURE_ROADMAP.md)
  - [ ] Video upload & storage
  - [ ] Video player
  - [ ] Match analysis tools
  - [ ] Training video library
  - [ ] Player highlights

- [ ] **Data Persistence**
  - [ ] Supabase integration
  - [ ] User authentication
  - [ ] Multi-team support
  - [ ] Data synchronization
  - [ ] Offline support

#### Phase 4: AI & Analytics 🔮
- [ ] **AI Coach Assistant**
  - [ ] Automated performance insights
  - [ ] Training recommendations
  - [ ] Lineup suggestions
  - [ ] Injury risk predictions

- [ ] **Advanced Analytics**
  - [ ] Team performance trends
  - [ ] Player development curves
  - [ ] Predictive modeling
  - [ ] Comparison tools

### 📋 Nieuwe Features Documentatie

#### Performance Rating System
Uitgebreid beoordelingssysteem voor speler prestaties:
- **5-Sterren Ratings**: Intuïtieve schaal van 1-5
- **Match Ratings**:
  - Aanvallend vermogen
  - Verdedigend vermogen
  - Tactisch inzicht
  - Werkinzet
- **Training Ratings**:
  - Technische vaardigheden
  - Coachbaarheid
  - Teamwork
- **Trend Analyse**: Automatische berekening van prestatie trends
- **Visuele Feedback**: Badges met kleuren en pijlen

#### Import/Export System
Flexibele data import en export mogelijkheden:
- **Import Features**:
  - Excel (.xlsx, .xls) en CSV ondersteuning
  - Slimme kolom herkenning
  - Validatie met foutrapportage
  - Template generator
- **Export Features**:
  - Excel export met meerdere sheets
  - PDF rapporten
  - Web-compatibel (geen path_provider)
- **Ondersteunde Data**:
  - Spelers (volledig profiel)
  - Wedstrijden (met resultaten)
  - Trainingen (met aanwezigheid)

### 🔧 Bug Fixes & Improvements
- [x] Fixed overflow issues in player cards
- [x] Improved responsive layouts voor alle screens
- [x] Nederlandse locale voor alle datums
- [x] Consistent error handling
- [x] Loading states voor async operations
- [x] Web-compatibele file operations
- [x] Performance optimalisaties

### 📝 Development Notes

#### Belangrijke Directories
- **ALTIJD** werk vanuit `/jo17_tactical_manager` directory
- Root directory bevat oude versie zonder web support
- Alle Flutter commands uitvoeren vanuit jo17_tactical_manager/

#### Backups
- `jo17_tactical_manager_with_performance_roadmap_20250607_005235.tar.gz` - Performance rating implementatie
- `jo17_tactical_manager_with_import_export_20250607_[timestamp].tar.gz` - Import/Export implementatie

---

*Document laatst bijgewerkt: **11 July 2025***
*Versie: 1.1.0*

### New Data Access Layer (2025 Roadmap)

To align with Clean Architecture 2025 guidelines we are introducing an explicit **Repository Layer**:

```
Widget → Provider (StateNotifier) → Repository → Data Source (Supabase API, Hive cache)
```

* Repositories expose pure Dart interfaces (no Flutter dependencies).
* Each feature gets its own repository (e.g. `ProfileRepository`, `PlayerRepository`).
* Data-sources are injected (Supabase, Hive, Fake).
* Providers depend only on repository abstractions – improves testability.

Implementation completed for Profiles, Players, Matches and Trainings (Jul 2025). All providers now depend solely on repositories.

For detailed coding patterns, see `docs/guides/REPOSITORY_USAGE_GUIDE_2025.md`.

## 🆕 Repository Layer Roadmap (Q3 2025)

To conform with 2025 Clean-Architecture recommendations we will introduce an **explicit Repository layer** between providers and data-sources.

```
UI ➜ Riverpod Provider ➜ Repository ➜ Data-Source (Supabase / Hive / Mock)
```

Benefits:
1. Decoupled business logic from back-end implementation.
2. Easy unit-testing with in-memory / fake repositories.
3. Seamless switch between online (Supabase) and offline (Hive) persistence.

The migration will proceed incrementally:
1. `ProfileRepository` as reference implementation.
2. Players, Matches, Trainings repositories.
3. Generic `RepositoryProvider<T>` + caching adapters.

See `docs/plans/architecture/REPOSITORY_LAYER_REFRACTOR_Q3_2025.md` for the detailed execution plan.

## 🖥️ Web Renderer Strategy (2025 Update)

With Flutter 3.29+ the legacy `--web-renderer` flag was removed. We now follow a **dual-renderer approach**:

* **Primary**: Skwasm (WebAssembly) build using `flutter build web --wasm`. This reduces JavaScript payload ~40-50 % and unlocks hardware-accelerated Impeller rendering on compatible browsers.
* **Fallback**: Traditional CanvasKit (JS) build produced in CI as `build-web-canvaskit`. Netlify automatically serves it when an outdated browser (no WasmGC) is detected.

Deployment matrix:

| Artifact | Path | Served to |
|----------|------|-----------|
| `build-web` | `build/web` | Modern browsers (WasmGC) |
| `build-web-canvaskit` | `build/web-canvaskit` | Legacy / iOS 15 Safari, older Edge |

The selection happens through a 3-line JavaScript snippet in `404.html`. See `netlify.toml` for redirect logic.

### CI Flow
1. Compile CanvasKit build and move to `build/web-canvaskit` (fallback).
2. Compile Wasm build (becomes `build/web`).
3. Inject real-user-metrics (RUM) snippet **before** closing `</head>`.
4. Upload both artifacts. Subsequent stages use the Wasm variant.

Diagram:
```mermaid
graph LR
    A[Flutter build --release] --> B{{CanvasKit}}
    B -->|mv| C[build/web-canvaskit]
    A2[Flutter build --wasm] --> D{{Skwasm}}
    D --> E[build/web]
    E --> F[Inject RUM JS]
    F --> G[Upload artifact]
```

## 📈 Real-User Metrics (RUM) Flow

We leverage [web-vitals v3](https://github.com/GoogleChrome/web-vitals) to capture **LCP, CLS, FID & INP**:

1. `web-vitals-inline.js` is generated in CI.
2. Metrics are sent via `navigator.sendBeacon('/api/web-vitals', …)` on `visibilitychange` and `pagehide`.
3. Netlify proxy rule forwards `/api/web-vitals` to Supabase Edge Function `web_vitals`.
4. Edge Function inserts rows into `web_vitals` table (`metric`, `value`, `url`, `captured_at`).
5. Grafana dashboard visualises p75 targets with alerts (Slack webhook) when thresholds are breached.

```mermaid
graph TD
  UI[Flutter Web App] -- sendBeacon --> FN[Edge Function web_vitals]
  FN --> DB[(Supabase\nweb_vitals)]
  DB --> GRAF[Grafana Panel]
  GRAF --> Slack[Slack Alert]
```

Thresholds (p75):
* LCP < 2.5 s
* CLS < 0.1
* INP < 200 ms

> Note: Lighthouse performance category remains **disabled** in CI until an SSR landing page is introduced (Phase 2 of the performance roadmap).

## Q3 2025 – Local Data Layer Refactor

The legacy `DatabaseService` singleton has been **removed**. Local persistence is now handled via a versioned Hive cache layer that sits behind `LocalStore<T>` and the `BaseHiveCache` wrapper.

Key points:

- Every repository now delegates **read / write / clear** concerns to its dedicated `Hive*Cache` implementation.
- Caches share cross-cutting concerns (TTL, schema versioning, JSON (de)serialisation) via `BaseHiveCache`.
- Offline-first behaviour is preserved; remote failures transparently fall back to cache.
- Tests cover all caches (write / read / TTL expiry) and repository fall-back strategies.

Impact on architecture diagram:

```
[ UI ] → [ Provider ] → [ Repository ] ⇄ [ Hive Cache ] ⇄ [ Hive Box ]
                             ⇡                     ⇣
                        (remote data source)   (TTL / Version)
```

All diagrams will be regenerated in Q4 after the code-style cleanup initiative.

## Q3 2025 – Session Builder Modularisation

The former 1 700-line `session_builder_screen.dart` is being decomposed into a layered structure that follows 2025 Flutter best-practice guidance (feature-first, MVU):

```
UI                ┌──────────────────────────────┐
                 │ SessionBuilderView (Widget) │
                 └──────────▲─────────▲─────────┘
State/Logic       ┌─────────┴─────────┴─────────┐
                 │ SessionBuilderController     │  (StateNotifier)
                 └─────────▲─────────▲─────────┘
Domain helpers    ┌────────┴─────────┘
                 │ TrainingSessionBuilderService │  (pure helpers)
                 └───────────────────────────────┘
```

Key advantages:

* UI is now a lightweight ConsumerWidget (< 70 LOC).
* Business rules live in a testable StateNotifier.
* Reusable helper logic centralised in `services/`.
* Navigation updated – route `/training-sessions/builder` resolves to `SessionBuilderView`.

This lays the groundwork for further extraction of sub-widgets (toolbar, phase list) which will live under `widgets/session_builder/`.
