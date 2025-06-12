### Performance & Assessment (from `PERFORMANCE_RATING_ROADMAP.md`)

**Phase 2: Periodieke Assessments (Partially Completed)**
*   [X] **Rapporten:**
    *   [X] Implement individual development reports. *(Done via `pdf_service.dart` -> `generateAssessmentReport`)*
    *   [X] Create team overview reports. *(Done via `export_service.dart` for players and matches)*
    *   [X] Add functionality to export reports to PDF. *(Done via `pdf_service.dart` and `export_service.dart`)*

**Phase 3: Advanced Analytics (Sprint 5-6)**
*   [X] **Data Visualization:**
    *   [X] Create performance graphs. *(Done: Pie, Bar, and Horizontal Bar charts implemented in analytics dialogs)*
    *   [X] Implement spider/radar charts for skills. *(Done: Implemented in `assessment_detail_screen.dart`)*
    *   [ ] Develop heatmaps for team performance.
*   [/] **Predictive Analytics:** *(In Progress: Basic rule-based insights exist, but no real prediction)*
    *   [ ] Implement form predictions.
    *   [ ] Model development trajectories.
    *   [ ] Provide position recommendations.

**Phase 4: Import Functionality (Sprint 7-8)**
*   [X] **Excel/CSV Import:**
    *   [X] Build a template generator. *(Done for players in `import_service.dart`)*
    *   [X] Enable bulk import of players. *(Done in `import_service.dart`)*
    *   [ ] Allow import of match schedules.
    *   [ ] Allow import of training plans.
*   [/] **Validation & Error Handling:**
    *   [X] Implement data validation for imports. *(Done)*
    *   [/] Add duplicate detection. *(Partially Done: Needs explicit check before insert)*
    *   [X] Create error reporting for failed imports. *(Done)*

**Future Features (Backlog)**
*   [ ] **OCR & AI Integration**
*   [ ] **Video Analysis Integration**
*   [ ] **Parent/Player Portal**

---

### Video Features (from `VIDEO_FEATURE_ROADMAP.md`) - NOT STARTED

**Phase 1: Basic Video Upload & Playback (Sprint 1-2)**
*   [ ] **Video Upload**
*   [ ] **Video Storage**
*   [ ] **Video Player**
*   [ ] **UI Components**

**Phase 2: Video Processing & Optimization (Sprint 3-4)**
*   [ ] **Video Compression**
*   [ ] **Thumbnail Generation**
*   [ ] **Metadata Extraction**

**Phase 3: Tagging & Categorization (Sprint 5-6)**
*   [ ] **Video Tagging**
*   [ ] **Smart Playlists**
*   [ ] **Search & Filter**

**Phase 4: Advanced Features (Sprint 7-8)**
*   [ ] **Video Analysis Tools**
*   [ ] **Sharing & Export**
*   [ ] **Offline Support**

**Phase 5: AI & Automation (Future)**
*   [ ] **AI Video Analysis**
*   [ ] **Performance Analytics from Video**

---

### General/Architectural (from `ARCHITECTURE.md` and other files) - NOT STARTED

*   [ ] Set up Firebase Analytics for user behavior tracking.
*   [ ] Integrate Sentry for error reporting.
*   [ ] Explore and integrate with OpenAI, Anthropic Claude, and vector databases for future AI features.
