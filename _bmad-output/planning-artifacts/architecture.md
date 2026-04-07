---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
lastStep: 8
status: 'complete'
completedAt: '2026-04-05'
inputDocuments:
  - '_bmad-output/planning-artifacts/prd.md'
  - '_bmad-output/planning-artifacts/product-brief-pingpongbuddy-distillate.md'
  - '_bmad-output/planning-artifacts/research/technical-mediapipe-tt-swing-analysis-research-2026-04-05.md'
  - '_bmad-output/research/market-ping-pong-swing-analysis-research-2026-04-05.md'
  - 'project-context.md'
workflowType: 'architecture'
project_name: 'pingpongbuddy'
user_name: 'Fam'
date: '2026-04-05'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:** 78 FRs across 10 capability areas. Core architectural drivers: sequential ML pipeline (FR13-26, FR77), background processing with progress reporting (FR22-25), graceful degradation across all pipeline stages (FR27-33), personal-baseline persistence with cross-session trend computation (FR44-45, FR51-53), and offline-first subscription management (FR59-68).

**Non-Functional Requirements:** 33 NFRs across 7 categories. Architecture-shaping NFRs: 15-minute processing ceiling on mid-range devices (NFR1), <100ms UI responsiveness during analysis (NFR5), zero data loss across updates (NFR15), functionally deterministic analysis (NFR16), atomic writes (NFR19), ≤15% battery for 30-min analysis (NFR20), ≤100MB binary (NFR25), extensibility via StrokeProfile configuration (NFR32).

**Scale & Complexity:**

- Primary domain: Cross-platform mobile (Flutter)
- Complexity level: Medium-High (ML pipeline + background processing + strict data integrity, constrained by no-backend architecture)
- Estimated architectural components: ~12-15 across 4 layers
- Zero backend infrastructure — all complexity is client-side

### Architectural Layer Model

| Layer | Responsibility | Key Technologies |
|-------|---------------|-----------------|
| **Presentation** | UI widgets, screen navigation, user interaction | Flutter widgets, BLoC (reactive state) |
| **Domain** | Use cases, entities, business rules, coaching logic | Pure Dart, StrokeProfile definitions |
| **Data** | Persistence, file management, IAP adapters, config | Drift (SQLite), file system, StoreKit/Play Billing |
| **ML Pipeline** | Processor chain, isolate management, ML inference | MediaPipe, IsolateKit, frame processing |

The ML Pipeline is a dedicated layer — not data (it transforms data) and not domain (it's infrastructure). It deserves distinct architectural treatment because it runs in isolates, manages hardware acceleration, and has its own lifecycle independent of the UI.

**GetIt + BLoC pattern:** Services and repositories register in GetIt. BLoCs receive dependencies via constructor injection from GetIt. BLoCs themselves register in GetIt for widget tree access via `context.read<T>()`. This separation ensures testability — BLoCs can be instantiated with mock services in tests.

### Technical Constraints & Dependencies

| Category | Constraint | Rationale |
|----------|-----------|-----------|
| Framework | Flutter 3.20+ | Cross-platform from day one, single codebase |
| ML | MediaPipe Pose Landmarker v0.10.33 | 33 landmarks, GPU/NPU/CPU, peer-reviewed TT validation |
| Database | Drift (SQLite) | Type-safe, reactive, isolate-friendly, migration support |
| State | BLoC + GetIt | Reactive state management + dependency injection |
| Processing | Dart Isolates / IsolateKit | Background ML computation without UI blocking |
| Platform | Android API 31+ / iOS 14+ | Minimum for MediaPipe integration |
| Hardware | 4GB RAM, GPU-capable SoC | Minimum device floor for ML inference |
| Processing Model | Post-session batch only | Design commandment — no real-time analysis |
| Binary | ≤100MB including ML models | App store best practices + NFR25 |
| Network | Purchase/validation only | All other functionality offline (FR68) |
| Background Execution | BGTaskScheduler (iOS) / WorkManager (Android) | Platform-specific background task APIs required for analysis surviving app suspension. iOS may suspend isolates after ~30s in background; Android has similar constraints. Architecture must handle interrupted analysis via restart-from-scratch (FR26). |

### Cross-Cutting Concerns

| Concern | Scope | Architectural Impact |
|---------|-------|---------------------|
| **Graceful Degradation** | Every pipeline stage | Each stage produces confidence scores, handles insufficient data, propagates quality metadata downstream |
| **Data Integrity** | Database, migration, writes | Atomic transactions, bulletproof schema migration, zero data loss on update |
| **Video ↔ Analysis Synchronization** | File system + Drift | Videos (file system) and analysis artifacts (Drift) must stay synchronized — deleting a video must clean up analysis records and vice versa. Two storage systems with referential integrity requirements. |
| **Pipeline Stage Interface Contract** | Entire ML pipeline | Each stage implements a common interface and produces typed output consumed by the next stage. This is the most important interface in the system — if the inter-stage data shape is wrong, NFR32 (extensibility) becomes impossible. |
| **Offline-First** | Entire app | Subscription caching, no network assumptions, local-only processing |
| **Extensibility** | Pipeline, coaching, baseline | StrokeProfile parameterization — no hardcoded stroke logic in framework |
| **Pipeline Determinism** | StrokeSegmenter onward | NFR16 requires functionally equivalent results from the same video. Pose estimation may vary by hardware (GPU vs CPU floating-point), but everything downstream of raw landmarks must be pure functions of their input — no random seeds, no hardware-dependent computation, no time-dependent logic. |
| **Error Handling** | Pipeline, recording, UI | Fail gracefully, preserve video, restart analysis, honest messaging |
| **Testing Infrastructure** | All pipeline stages | Each stage must accept input from either the previous stage or a test fixture. Test fixtures include pre-recorded video snippets, mock landmark data, and synthetic stroke sequences. Designing for testability from day one shapes pipeline interfaces. |
| **Centralized Configuration** | Thresholds, limits, parameters | Confidence thresholds (FR27-28), trust ladder threshold (100 strokes, FR51), subscription grace period (7 days, FR65), free tier session limit (FR59) — all injectable configuration, not hardcoded constants. Enables testing and future tuning. |
| **Performance Monitoring** | Analysis pipeline, battery | Frame sampling rate as primary lever, hardware acceleration selection |

### Day-One Architectural Decisions

**Drift schema versioning:** NFR15 (zero data loss) means the migration strategy must be established before the first table is created. Commit to step-by-step schema migrations with explicit version numbers and migration hooks. Every schema change ships with a tested migration path from every previous version. No "drop and recreate" shortcuts.

**Component dependency graph:** Pipeline stages are sequential by design (FR77), but architectural components have broader dependencies. The architecture document must include a dependency graph showing which components can be built and tested independently. Goal: each pipeline stage is independently buildable and testable with mock inputs from the prior stage.

## Starter Template Evaluation

### Primary Technology Domain

Flutter (cross-platform mobile) — confirmed from PRD, technical research, and project context. BLoC + GetIt + Drift + MediaPipe stack is pre-validated.

### Starter Options Considered

| Option | What It Provides | Fit |
|--------|-----------------|-----|
| **Very Good CLI v1.1.1** (2026-03-26) | BLoC, build flavors, 100% test coverage setup, very_good_analysis lints, CI via GitHub Actions | **Selected.** Best testing infrastructure, production-grade linting, clean base. |
| **ARCLE CLI v1.0.3** | Clean Architecture + BLoC, Dio networking, env config | Moderate. Includes API/networking we don't need. |
| **Community templates** (charanprasanth, AndreyDAraya) | BLoC + GetIt + Drift + feature-based structure | Close to our stack but community-maintained, needs auditing. |
| **`flutter create` + manual** | Bare Flutter app | Viable but recreates what VGV provides for free. |

### Selected Starter: Very Good CLI v1.1.1

**Rationale:** VGV provides the highest-quality production foundation — testing, linting, CI, build flavors — without imposing architecture we'd undo. We layer our specific needs on top.

**Initialization Command:**

```bash
dart pub global activate very_good_cli
very_good create flutter_app pingpongbuddy --desc "AI-powered table tennis swing analyzer"
```

**Customizations Applied Post-Init:**

| Customization | Rationale |
|--------------|-----------|
| Collapse to 2 build flavors (dev + prod) | No backend = no staging environment. Dev for debugging, prod for release. |
| Remove internationalization setup | English only for MVP. ARB/localization infrastructure is overhead with no benefit. Easy to re-add later. |
| Add GetIt for dependency injection | Constructor injection into BLoCs, service registration |
| Add Drift for local persistence | Type-safe SQLite with migration support |
| Add go_router for navigation | Declarative routing |
| Add feature-based clean architecture structure | Aligns with 4-layer model |
| Add centralized configuration class | Injectable thresholds and tunable parameters |

### Architectural Decisions Provided by Starter

**Testing:** 100% line coverage setup with `flutter_test`, coverage reporting via `very_good test --coverage`.

**Code Quality:** `very_good_analysis` lint rules (strict, production-grade), Dart format enforcement.

**Build Configuration:** Two build flavors — development (debug mode, verbose logging, relaxed thresholds) and production (release mode, store submission). Separate entry points per flavor.

**CI/CD:** GitHub Actions workflow pre-configured with automated testing, formatting, and analysis checks.

### Target Project Structure

```
lib/
├── core/
│   ├── config/              # Tunable parameters (thresholds, limits)
│   ├── constants/           # App-wide constants (durations, asset paths, route names)
│   ├── database/            # Drift tables, DAOs, schema migrations
│   │   ├── tables/
│   │   ├── daos/
│   │   └── migrations/
│   ├── di/                  # GetIt service locator registration
│   ├── error/               # Failure types, error handling
│   ├── extensions/          # Dart/Flutter extension methods
│   ├── router/              # go_router configuration
│   └── theme/               # App theme
├── features/
│   ├── recording/           # Video capture (FR1-7)
│   ├── onboarding/          # Setup guides (FR8-12)
│   ├── analysis/            # Analysis triggering & progress UI (FR13, FR22-26)
│   ├── session_summary/     # Summary display & sharing (FR34-40)
│   ├── video_review/        # Video playback (FR41)
│   ├── session_history/     # Session list & management (FR42-50)
│   ├── coaching/            # Coaching UI, tip display, feedback (FR51-58 presentation)
│   ├── subscription/        # Monetization & IAP (FR59-68)
│   └── settings/            # App settings (FR69-71)
├── ml_pipeline/
│   ├── inference/           # MediaPipe integration, platform channels, frame extraction
│   │                        # (runs in main isolate — platform channels require it)
│   ├── vision/              # Main-isolate vision tasks requiring pixel data
│   │   ├── ball_detector.dart         # Frame differencing on pixel data
│   │   └── on_table_classifier.dart   # Ball event → on/off table
│   ├── pipeline/            # Pure-Dart processor chain (runs in computation isolate)
│   │   ├── stroke_segmenter.dart
│   │   ├── metrics_computer.dart
│   │   ├── session_aggregator.dart
│   │   └── coaching_engine.dart    # Rules engine (pure computation)
│   ├── models/              # Shared data types — pure Dart, used by both isolates
│   │   ├── stroke_profile.dart
│   │   ├── landmark_frame.dart
│   │   ├── stroke_event.dart
│   │   └── pipeline_result.dart
│   └── orchestrator/        # Multi-isolate workflow, progress reporting, cancellation
```

**Critical structural constraints:**

- `ml_pipeline/pipeline/` contains **pure Dart only** — no Flutter imports allowed. Runs in a computation isolate that cannot access platform channels.
- `ml_pipeline/inference/` handles MediaPipe via platform channels — must run in the main isolate (or a dedicated inference isolate with platform channel access).
- **Two-isolate model:** Main isolate runs MediaPipe inference (extracting landmarks per frame) → sends landmark data to computation isolate → computation isolate runs pure-Dart pipeline stages (segmentation, classification, metrics, coaching).
- `ml_pipeline/models/` is pure Dart shared between both isolates.
- Coaching rules engine (`ml_pipeline/pipeline/coaching_engine.dart`) is distinct from coaching UI (`features/coaching/`). Rules engine computes tips from metrics and baseline. Feature presents tips and handles feedback.

Each feature follows internal clean architecture (data/domain/presentation) where applicable. Test structure mirrors the `lib/` structure.

### Testing Strategy

| Code Category | Coverage Target | Test Type |
|--------------|----------------|-----------|
| `ml_pipeline/pipeline/` | 100% line coverage | Unit tests with mock landmark data and synthetic strokes |
| `core/` (config, database, error) | 100% line coverage | Unit tests |
| Feature domain + data layers | 100% line coverage | Unit tests with mock repositories |
| `ml_pipeline/inference/` | Functional coverage | Integration tests (platform channel mocking is brittle) |
| Feature presentation (widgets) | Functional coverage | Widget tests + integration tests |
| Platform-dependent code (camera, IAP) | Functional coverage | Integration tests on real devices |

**Note:** Project initialization using VGV CLI plus all customizations should be the first implementation story.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical (block implementation):**
- Pipeline stage interface contract and composition mechanism
- Inter-stage data types (StrokeProfile, LandmarkFrame, StageResult)
- Drift schema design with migration strategy
- Inter-isolate communication protocol with revised isolate boundary
- Video ↔ database synchronization pattern
- Biomechanical metric catalog

**Important (shape architecture):**
- BLoC naming and structure conventions
- Error propagation and failure handling across layers
- Subscription validation architecture
- Frame sampling strategy
- Logging and diagnostics approach

**Deferred (post-MVP):**
- Analytics/telemetry infrastructure
- Remote configuration (feature flags)
- Cloud backup opt-in
- Multi-language support

### Data Architecture

**Database: Drift ^2.32.1**

Core tables:

| Table | Purpose | Key Fields |
|-------|---------|------------|
| `sessions` | Session metadata | id, videoPath, recordedAt, duration, analysisStatus, tier |
| `strokes` | Per-stroke data | id, sessionId, strokeType, startFrame, contactFrame, endFrame, onTable, confidence |
| `landmarks` | Per-frame pose data | sessionId, frameIndex, landmarkData (dev: JSON, prod: compressed binary) |
| `stroke_metrics` | Biomechanical metrics per stroke | strokeId, metrics (typed JSON map — `Map<String, double>`) |
| `session_metrics` | Aggregated session-level metrics | sessionId, strokeType, metricAggregates (mean, stddev, trend per metric), strokeCount, onTableRate, consistencyScores |
| `baselines` | Personal-baseline aggregates | strokeType, metricName, mean, stddev, trendDirection, sampleCount |
| `coaching_tips` | Tip history + feedback | sessionId, tipText, tipType, feedbackSignal, generatedAt |
| `pipeline_runs` | Analysis attempt tracking | id, sessionId, startedAt, completedAt, status, failureReason, stagesCompleted |
| `subscription` | Cached subscription state | status, expiresAt, lastValidated, gracePeriodEnd |
| `app_config` | Runtime configuration overrides | key, value |

**`stroke_metrics` uses typed JSON map (`Map<String, double>`) instead of fixed columns.** Metric keys come from `StrokeProfile.coachingMetrics`. This means adding a new stroke type with different metrics (e.g., serve with toss height) requires zero schema migrations — only a new `StrokeProfile` definition. Trades type-safe column queries for extensibility (NFR32).

**Landmark storage:** Dev flavor stores landmarks as human-readable JSON for debugging and test fixture creation. Prod flavor uses compressed binary blobs (batched per 100 frames). Pipeline stages receive typed `LandmarkFrame` objects regardless of storage format — the DAO handles deserialization.

**Schema migration strategy:** Step-by-step versioned migrations. Each schema change is a numbered migration file with explicit `ALTER TABLE` / `CREATE TABLE` operations. Drift's `MigrationStrategy` with `onUpgrade` callback. Every migration tested with before/after snapshot assertions. No "drop and recreate" — ever.

**Video ↔ DB synchronization:**
- Session record holds `videoPath` as foreign reference to file system
- Deleting a session from Drift triggers video file deletion
- Deleting a video file (via settings) triggers session record cleanup
- On app launch, reconciliation pass: orphaned videos get session stubs; session records with missing videos get `videoPath` nulled and `analysisStatus` set to `video_deleted`
- All sync operations wrapped in Drift transactions

### Security & Privacy

**No authentication for MVP.** No accounts, no login, no user identity.

**Local data protection:**
- App sandbox (iOS Keychain for subscription, Android EncryptedSharedPreferences for subscription status)
- Video files marked with `NSURLIsExcludedFromBackupKey` (iOS) and excluded from Android auto-backup
- No IDFA/GAID usage
- "Delete all data" wipes Drift DB + all video files + subscription cache + shared preferences

**Subscription validation:**
- StoreKit 2 (iOS) / Google Play Billing Library v7+ (Android)
- Unified subscription repository behind platform abstraction
- Local cache: subscription status + expiry + last validation timestamp
- Grace period: 7 days offline before downgrade
- Validation on app launch (if network available) and after any purchase
- **Beta strategy:** Hardcode all users as "Pro" tier during beta. Build subscription infrastructure as last feature before store submission. Architecture supports this via a single tier-check guard in the analysis flow.

### Communication Patterns

**Revised Two-Isolate Model:**

Ball detection requires pixel data (frame differencing), not just pose landmarks. Therefore vision tasks (MediaPipe + ball detection) run on the main isolate side, and pure-Dart computation runs in the computation isolate.

```
Main Isolate (Vision)              Computation Isolate (Pure Dart)
─────────────────────              ────────────────────────────────
1. Extract frames from video
2. Run MediaPipe per frame
   (platform channel)
3. Run BallDetector per frame
   (frame differencing on pixels)
4. Run OnTableClassifier
   (ball event → on/off table)
5. Batch results:
   - LandmarkFrame[]
   - BallEvent[]
6. Transfer via SendPort ────────► 7. Receive landmark + ball data
   (TransferableTypedData            8. Run pure-Dart pipeline:
    for zero-copy transfer)              StrokeSegmenter
                                         MetricsComputer
                                         SessionAggregator
                                         CoachingEngine
9. Receive progress updates ◄──── 9. Send ProgressUpdate(stage, %)
10. Receive final result ◄─────── 10. Send PipelineResult
```

- Communication via `SendPort`/`ReceivePort`
- Landmark + ball data transferred via `TransferableTypedData` (zero-copy ownership transfer for large arrays)
- Progress messages: lightweight `ProgressUpdate(stage, percentComplete)` objects
- Error propagation: pipeline errors wrapped in `PipelineFailure` sealed class
- Cancellation: main isolate sends `CancelSignal`; computation isolate checks between stages

**Platform channel contract for MediaPipe:**
- Method channel: `com.pingpongbuddy/mediapipe`
- Methods: `initialize(modelVariant)`, `processFrame(bytes, width, height)` → `List<Landmark>`, `dispose()`
- Hardware acceleration selection in platform-native code

### Frontend Architecture

**BLoC conventions:**
- One BLoC per feature screen (`RecordingBloc`, `SessionSummaryBloc`, `SessionHistoryBloc`)
- Events: sealed classes (`sealed class RecordingEvent`)
- States: sealed classes (`sealed class RecordingState`)
- BLoCs receive use cases/repositories via constructor injection from GetIt
- No BLoC-to-BLoC direct communication — shared repositories or event streams

**Navigation:** go_router ^17.2.0 with declarative routes. Routes: `/record`, `/analyzing/:sessionId`, `/session/:sessionId`, `/sessions`, `/settings`, `/upgrade`. Deep links deferred.

**Theme:** Single Material 3 light theme with `ColorScheme.fromSeed()`. Dark mode deferred. WCAG 2.1 AA contrast compliance (NFR28). Design tokens in `core/theme/`.

### Infrastructure & Deployment

**Beta distribution:** TestFlight (iOS) + Firebase App Distribution (Android).

**Environment configuration:** Flavor-based via `core/config/app_config.dart`. Dev: verbose logging, relaxed thresholds, JSON landmark storage, debug tools. Prod: production thresholds, compressed landmarks, minimal logging.

**Logging:** `logger` package. Levels: debug (dev only), info, warning, error. Pipeline stages log entry/exit + timing. No PII. Local only.

### ML Pipeline Architecture

**Pipeline stage interface contract:**

```dart
abstract class PipelineStage<TInput, TOutput> {
  String get stageName;
  Future<StageResult<TOutput>> process(TInput input, PipelineConfig config);
}

class StageResult<T> {
  final T data;
  final StageMetadata metadata;  // timing, frames processed, confidence
  final StageQuality quality;    // full, partial, degraded
  final int skippedFrames;       // 0 for full quality
}
```

Stages return `StageResult.partial(data, skippedFrames: N)` for recoverable failures — downstream stages continue with available data. Each stage defines its contract for handling partial input from the prior stage: compute what's available, adjust confidence accordingly, propagate quality metadata. Only catastrophic failures (can't load video, MediaPipe crashes) trigger full restart.

**Pipeline composition:**

```dart
class PipelineRunner {
  Future<PipelineResult> run(
    List<PipelineStageEntry> stages,
    PipelineInput input,
    PipelineConfig config,
    void Function(ProgressUpdate) onProgress,
  );
}
```

Orchestrator chains stages sequentially, handles type bridging, tracks progress, and manages cancellation.

**Biomechanical Metric Catalog (9 base metrics + 1 derived):**

| # | Internal ID | Display Phrase | Source | Computation |
|---|------------|---------------|--------|-------------|
| 1 | `shoulder_rotation` | "shoulder rotation" | Nanjing r=0.54-0.57 | Angle of shoulder line vs. reference axis at contact |
| 2 | `hip_rotation` | "hip rotation" | Nanjing r=0.51-0.59 | Angle of hip line vs. reference axis at contact |
| 3 | `upper_arm_rotation_velocity` | "arm swing speed" | Nanjing r=0.65-0.71 | Angular velocity of upper arm through stroke |
| 4 | `elbow_angle_at_contact` | "elbow angle" | Nanjing r=0.63-0.70 | Angle at elbow joint at peak wrist velocity moment |
| 5 | `wrist_velocity_peak` | "wrist speed" | Nanjing r=0.50-0.60 | Maximum wrist landmark velocity during stroke |
| 6 | `swing_arc_angle` | "swing arc" | Founder input | Total angular displacement of wrist path in sagittal plane, start to end |
| 7 | `contact_height` | "contact height" | Founder input | Wrist height at peak wrist velocity (proxy for ball contact) |
| 8 | `follow_through_height` | "follow-through height" | Founder input | Wrist height at stroke end minus height at start (topspin indicator) |
| 9 | `weight_transfer` | "weight shift" | Founder input | Center-of-mass shift from back foot to front foot during stroke (hip/ankle derived) |
| — | `stroke_consistency` | "consistency" | Derived | Coefficient of variation (stddev/mean) per metric within session (lower = more consistent) |

**StrokeProfile schema:**

```dart
class StrokeProfile {
  final String id;                    // 'forehand_topspin', 'backhand_topspin'
  final String displayName;           // 'Forehand Topspin'
  final ArmSide dominantArm;
  final AngleRanges classificationPosture;  // body posture for stroke type detection
  final List<MetricDefinition> metrics;     // ordered list of metrics to compute
  final Map<String, CoachingRule> rules;    // tip templates keyed by metric
}

class MetricDefinition {
  final String metricId;        // 'shoulder_rotation'
  final String displayPhrase;   // 'shoulder rotation'
  final MetricUnit unit;        // degrees, degreesPerSecond, meters, etc.
}
```

Both forehand and backhand topspin use the same 9 metrics with different `classificationPosture` ranges and `CoachingRule` templates. Adding a new stroke type = new `StrokeProfile` instance with its own metric list and rules. No pipeline code changes.

**Metrics are computed only for recognized strokes (forehand/backhand topspin).** The "other" bucket contributes to session on-table rate but does not receive biomechanical analysis.

**Baseline operates on session aggregates:** For each metric per stroke type per session, compute mean, standard deviation, and sample count. Cross-session trending compares session aggregates, not individual strokes (too noisy). `stroke_consistency` is the coefficient of variation within a session — highly coachable: "your shoulder rotation is improving, but it varies a lot stroke-to-stroke."

**Frame sampling strategy:** Configurable rate. Default: every 3rd frame (10 FPS from 30 FPS source). Primary lever for NFR1 (processing time) and NFR20 (battery). Adjustable per device capability.

### PoC Validation Gates

**Gate 1 (after ML inference integration — step 4 of implementation):**
- MediaPipe landmark extraction validated on 2+ physical devices (1 Android, 1 iOS)
- Landmarks visually track the player's body during forehand/backhand strokes
- No landmark flipping or wild jitter during swing phase
- **Must pass before proceeding to pipeline stage development**

**Gate 2 (after stroke segmentation — step 5):**
- Stroke segmentation accuracy >85% on test footage (correctly identifies stroke start, contact, end)
- False positive rate <15% (non-strokes classified as strokes)
- **Stroke segmentation is the primary PoC target** — all downstream metrics depend on correct boundaries

**Gate 3 (after ball detection — step 5):**
- On-table rate accuracy ±15% vs. manual count (from PRD success criteria)
- If frame differencing doesn't meet threshold: trigger YOLO upgrade path

### Decision Impact Analysis

**Implementation Sequence:**
1. Project init (VGV + dependencies + structure)
2. Drift schema + migration infrastructure
3. Recording pipeline (camera + video storage)
4. ML inference integration (MediaPipe platform channels) → **PoC Gate 1**
5. Pipeline stages: StrokeSegmenter + BallDetector → **PoC Gates 2 & 3**
6. Remaining pipeline stages: MetricsComputer, SessionAggregator
7. Session summary UI
8. Personal baseline + coaching engine
9. Subscription management (last before store submission)
10. Onboarding + settings + polish

**Cross-Component Dependencies:**

| Component | Depends On |
|-----------|-----------|
| Any pipeline stage | PipelineStage interface, PipelineConfig, StrokeProfile |
| MetricsComputer | StrokeSegmenter output (stroke boundaries), MetricDefinition catalog |
| CoachingEngine | All prior stages, baseline data, StrokeProfile coaching rules |
| Session summary UI | session_metrics, coaching_tips (from pipeline) |
| Subscription | Drift (cache), platform IAP adapters |
| Video review | Recording pipeline (video file), sessions table |
| Baseline computation | Multiple completed sessions in Drift |

## Implementation Patterns & Consistency Rules

### Naming Patterns

**Dart/Flutter Code (enforced by `very_good_analysis`):**

| Element | Convention | Example |
|---------|-----------|---------|
| Files | snake_case | `session_summary_bloc.dart` |
| Classes | PascalCase | `SessionSummaryBloc` |
| Variables/params | camelCase | `onTableRate` |
| Constants | camelCase | `defaultFrameSampleRate` |
| Private members | underscore prefix | `_computeMetrics()` |
| Enums | PascalCase type, camelCase values | `AnalysisStatus.inProgress` |
| Extensions | PascalCase + "Extension" | `DateTimeExtension` |

**Drift Database:**

| Element | Convention | Example |
|---------|-----------|---------|
| Table classes | PascalCase plural | `Sessions`, `Strokes`, `StrokeMetrics` |
| Columns | camelCase | `videoPath`, `onTableRate`, `analysisStatus` |
| DAOs | PascalCase + "Dao" | `SessionsDao`, `BaselinesDao` |
| Migrations | `v{N}.dart` | `v2.dart`, `v3.dart` |

**DateTime convention:** Store as UTC milliseconds since epoch (`int` column in Drift). Convert to local time only in presentation layer for display. Never store local time in the database.

**BLoC Naming:**

| Element | Convention | Example |
|---------|-----------|---------|
| Bloc class | `{Feature}Bloc` | `RecordingBloc`, `SessionHistoryBloc` |
| Event base | `sealed class {Feature}Event` | `sealed class RecordingEvent` |
| Event variants | **Always past tense** (never imperative) | `RecordingStarted`, `AnalysisRequested`, `SessionDeleted` |
| State base | `sealed class {Feature}State` | `sealed class RecordingState` |
| State variants | Adjective or status | `RecordingInitial`, `RecordingInProgress`, `RecordingComplete` |

Events represent things that *happened*. `RecordingStarted` (correct) not `StartRecording` (wrong).

**Pipeline Naming:**

| Element | Convention | Example |
|---------|-----------|---------|
| Stage class | PascalCase computation | `StrokeSegmenter`, `MetricsComputer` |
| Input/output types | PascalCase + data suffix | `LandmarkBatch`, `SegmentedStrokes` |
| Metric IDs | snake_case strings | `'shoulder_rotation'`, `'wrist_velocity_peak'` |
| StrokeProfile IDs | snake_case | `'forehand_topspin'`, `'backhand_topspin'` |

### Structure Patterns

**Feature internal structure — create directories as-needed, not preemptively:**

```
features/{feature_name}/
├── data/                # Only if feature has data access
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/              # Only if feature has business logic
│   ├── entities/
│   ├── repositories/    # Abstract interfaces
│   └── usecases/
└── presentation/        # Always present
    ├── bloc/
    ├── pages/
    └── widgets/
```

Simple features (e.g., `onboarding/`) may only have `presentation/`. Add layers only when the feature actually needs them.

**Imports:** Always package imports (`import 'package:pingpongbuddy/...'`). Never relative imports.

**Dependency direction (strict — never violated):**

```
Presentation → Domain → Data
                ↑
          ML Pipeline (outputs domain entities)
```

**Isolate boundary mapping layer:** The computation isolate outputs plain Dart DTOs (no Flutter imports). These get mapped to domain entities on the main isolate after `SendPort` transfer. Each feature that consumes pipeline output has a `mappers/` directory inside its `data/` layer:

```
features/analysis/data/
├── mappers/
│   ├── pipeline_result_mapper.dart    # PipelineResultDto → SessionSummary
│   └── stroke_metrics_mapper.dart     # StrokeMetricsDto → StrokeMetrics
├── repositories/
└── datasources/
```

Pipeline DTOs live in `ml_pipeline/models/` (pure Dart). Domain entities live in each feature's `domain/entities/`. The mapper is the single translation point — no domain entity crosses the isolate boundary.

### Code Generation: `freezed` + `json_serializable`

**Position: Use `freezed` for all immutable data classes and sealed unions.**

Rationale: The project has dozens of data classes (landmark frames, stroke metrics, session summaries, pipeline DTOs, BLoC states, Failure types). Hand-writing `==`, `hashCode`, `copyWith`, `toString`, and JSON serialization for every class is error-prone and creates maintenance drag. `freezed` generates all of these plus enforces immutability and exhaustive pattern matching on sealed unions.

**Scope:**

| Layer | Use `freezed`? | Rationale |
|-------|---------------|-----------|
| BLoC events & states | Yes | Sealed unions with exhaustive matching |
| Domain entities | Yes | Immutable, `copyWith` for updates |
| Pipeline DTOs | Yes | Immutable, JSON serialization for debug logging |
| Failure hierarchy | Yes | Sealed union, exhaustive handling |
| Drift companion classes | No | Drift generates its own data classes |
| GetIt registrations | No | Service classes, not data |

**Build runner command:** `dart run build_runner build --delete-conflicting-outputs`

**File convention:** Source in `*.dart`, generated output in `*.freezed.dart` and `*.g.dart`. Generated files committed to version control (avoids CI build_runner dependency and ensures reproducibility).

### Data Flow Patterns

**Repository pattern:**

```dart
// Domain layer — abstract interface
abstract class SessionRepository {
  Future<Session> getSession(String id);
  Stream<List<Session>> watchSessions();
}

// Data layer — concrete implementation
class DriftSessionRepository implements SessionRepository {
  final SessionsDao _dao;
  // ...
}
```

Registered in GetIt. BLoCs receive the abstract interface. Tests substitute mocks.

**Result type: `fpdart` package for `Either<Failure, T>`.**

```dart
// Use case returns Either
Future<Either<Failure, SessionSummary>> call(String sessionId);

// BLoC maps to state
result.fold(
  (failure) => emit(SessionSummaryError(failure.message)),
  (summary) => emit(SessionSummaryLoaded(summary)),
);
```

**Stream error handling convention: repository catches and maps.**

```dart
// Repository wraps Drift stream errors into domain failures
Stream<Either<Failure, List<Session>>> watchSessions() {
  return _dao.watchAllSessions()
      .map((rows) => Right<Failure, List<Session>>(rows.map(_toEntity).toList()))
      .handleError((e, st) => Left<Failure, List<Session>>(
        DatabaseFailure('Failed to load sessions: ${e.runtimeType}'),
      ));
}

// BLoC subscribes to the Either stream — no onError needed
_subscription = _repository.watchSessions().listen((result) {
  result.fold(
    (failure) => emit(SessionListError(failure.message)),
    (sessions) => emit(SessionListLoaded(sessions)),
  );
});
```

The repository is the error boundary for streams — it never lets raw exceptions propagate. BLoCs always receive `Either` values, keeping error handling consistent between single calls and streams.

### Error Handling Patterns

**Failure type hierarchy:**

```dart
sealed class Failure {
  String get message;
}
class DatabaseFailure extends Failure { ... }
class PipelineFailure extends Failure { ... }
class VideoFileFailure extends Failure { ... }
class SubscriptionFailure extends Failure { ... }
```

**Pipeline errors:** Wrapped in `PipelineFailure` with stage name, error type, and recovery hint. Sent to main isolate via `SendPort`. User sees friendly message; detail logged in dev only.

**User-facing errors:** Never technical. Always actionable.
- Bad: `PipelineStage StrokeSegmenter threw FormatException`
- Good: `We couldn't analyze this session. Try recording with better lighting.`

### State Management Patterns

**Standard BLoC state categories (every BLoC follows this):**

```dart
sealed class FeatureState {}
class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState { final Data data; }
class FeatureError extends FeatureState { final String message; }
```

All states immutable. Loading is always local to the screen that triggered it — no global loading state.

**Cross-screen BLoC policy — the `AnalysisBloc` exception:**

The "one BLoC per screen" rule has one documented exception: `AnalysisBloc`. Analysis spans two screens (progress indicator → session summary) because the pipeline is a long-running operation that must survive navigation.

Pattern: `AnalysisBloc` is scoped to the `GoRouter` shell route that wraps both the progress and summary screens. It is **not** a global singleton — it is created when the user taps "Analyze" and disposed when they navigate back to the session list.

```
/session/:id/analyze        → AnalysisProgressPage (reads AnalysisBloc)
/session/:id/analyze/result → SessionSummaryPage   (reads AnalysisBloc)
```

The summary screen reads the completed `AnalysisLoaded` state from the same BLoC instance. If the user navigates away before completion, the BLoC cancels the isolate and cleans up.

**No other BLoC may span screens.** If a similar need arises in future, the pattern must be: BLoC scoped to a shell route, not promoted to a global singleton.

**Async disposal pattern:** Every BLoC that subscribes to a stream stores the `StreamSubscription` and cancels it in `close()`. Every repository that opens a Drift watch query provides `dispose()`. Failure to cancel subscriptions causes memory leaks and "setState after dispose" errors.

### Configuration Patterns

**Two config classes — separated by concern:**

```dart
/// ML pipeline tuning — changes when algorithm improves
class PipelineConfig {
  final double landmarkConfidenceThreshold;  // 0.5
  final int frameSampleRate;                 // 3
  final double strokeSegmentationGap;        // 0.8s
  final double partialResultThreshold;       // 0.3
  final int minFramesPerStroke;              // 5
  // ...
}

/// Business rules — changes when product strategy evolves
class AppConfig {
  final int trustLadderStrokeThreshold;      // 100
  final int subscriptionGracePeriodDays;     // 7
  final int freeSessionsPerMonth;            // 3
  final int maxVideoLengthMinutes;           // 15
  final int baselineMinSessions;             // 3
  // ...
}
```

Both registered in GetIt. Dev flavor overrides for testing. Never hardcoded in business logic. Pipeline stages receive `PipelineConfig`; BLoCs and use cases receive `AppConfig`.

### Testing Patterns

**Test naming:** `test('should [expected behavior] when [condition]')`.
- Good: `test('should return partial result when 30% of frames have low confidence')`
- Bad: `test('test stroke segmenter')`

**Test fixture convention:** Files in `test/fixtures/` with format-appropriate extensions. Loaded via shared `TestFixtures` helper class.

- **JSON fixtures** for structured data (coaching rules, session metadata, config overrides):
  - `coaching_regression_detected.json`
  - `session_summary_five_sessions.json`
- **Binary fixtures (`.bin`)** for landmark data (a 5-minute session at 10fps = 3,000 frames × 33 landmarks × 4 floats = ~1.5MB as binary vs. ~12MB as JSON):
  - `landmarks_good_forehand.bin`
  - `landmarks_low_confidence.bin`
  - `TestFixtures.loadLandmarkBatch('good_forehand')` deserializes `Float32List` from binary

**Pipeline stage testing pattern (mandatory for every pure-Dart stage):**

```dart
group('StrokeSegmenter', () {
  test('should segment forehand topspin when wrist velocity peaks detected');
  test('should return partial result when 20% of frames are dropped');
  test('should classify as other when posture matches no StrokeProfile');
  test('should produce deterministic output for identical input');  // NFR16
});
```

The determinism test (same input → same output) is **mandatory** for every pure-Dart pipeline stage. This enforces NFR16.

**Golden file testing (mandatory for every pipeline stage):**

Determinism tests prove *consistency* but not *correctness*. Golden file tests prove both: known input → known expected output, verified by hand once, then regression-tested forever.

```
test/fixtures/golden/
├── stroke_segmenter_forehand_input.bin      # Known landmark data
├── stroke_segmenter_forehand_expected.json  # Hand-verified expected output
├── metrics_computer_topspin_input.json
├── metrics_computer_topspin_expected.json
└── ...
```

```dart
test('should match golden output for forehand topspin segmentation', () {
  final input = TestFixtures.loadLandmarkBatch('golden/stroke_segmenter_forehand_input');
  final expected = TestFixtures.loadJson('golden/stroke_segmenter_forehand_expected');
  final result = segmenter.process(input);
  expect(result.toJson(), equals(expected));
});
```

Golden files are **never auto-updated**. If a golden test fails, it means either the stage has a regression (fix the code) or the expected output has legitimately changed (update the golden file with explicit review).

**Integration test pattern for composed pipeline:**

Unit tests cover individual stages; integration tests catch stage interface mismatches. Located in `test/integration/pipeline/`.

```dart
// test/integration/pipeline/full_pipeline_test.dart
group('PipelineRunner integration', () {
  test('should produce valid SessionSummary from raw landmark data', () async {
    final landmarks = TestFixtures.loadLandmarkBatch('golden/full_session_input');
    final ballEvents = TestFixtures.loadJson('golden/full_session_ball_events');
    final runner = PipelineRunner(stages: productionStages, config: testConfig);
    final result = await runner.run(landmarks, ballEvents);
    expect(result.isRight(), isTrue);
    final summary = result.getRight();
    expect(summary.strokes, isNotEmpty);
    expect(summary.metrics.keys, containsAll(['shoulder_rotation', 'wrist_velocity_peak']));
    expect(summary.onTableRate, inInclusiveRange(0.0, 1.0));
  });

  test('should degrade gracefully with 50% low-confidence frames', () async {
    final landmarks = TestFixtures.loadLandmarkBatch('golden/degraded_session_input');
    final result = await runner.run(landmarks, []);
    expect(result.isRight(), isTrue);
    expect(result.getRight().qualityScore, lessThan(0.8));
  });
});
```

### Enforcement Guidelines

**CRITICAL (violation causes bugs or architectural breakdown):**
1. `ml_pipeline/pipeline/` contains pure Dart only — no Flutter imports, no platform channels
2. Use cases return `Either<Failure, T>` — never throw exceptions across layer boundaries
3. No direct Drift access from BLoCs — always BLoC → UseCase → Repository → DAO

**IMPORTANT (violation causes inconsistency or maintenance burden):**
4. Package imports only — no relative imports
5. All ML thresholds from `PipelineConfig`, all business rules from `AppConfig` — no hardcoded magic numbers
6. One BLoC per feature screen — `AnalysisBloc` is the sole documented exception (shell-route scoped, not global)
7. Cancel stream subscriptions in `close()` — no leak potential
8. Events in past tense — `RecordingStarted` not `StartRecording`
9. Use `freezed` for all data classes and sealed unions (except Drift companions)
10. Repositories wrap stream errors into `Either` — BLoCs never handle raw stream `onError`
11. Golden file + determinism tests mandatory for every pipeline stage
12. Pipeline DTOs mapped to domain entities in `data/mappers/` — no domain objects cross the isolate boundary

**Anti-Patterns with Correct Alternatives:**

| Anti-Pattern | Correct Approach |
|-------------|-----------------|
| Direct Drift access from BLoC | BLoC → UseCase → Repository → DAO |
| Throwing exceptions from pipeline stages | Return `StageResult` with quality/error metadata |
| Importing another feature's internal classes | Expose domain entities; consume via repository interface |
| Storing UI state in database | BLoC state is ephemeral; persist only domain data in Drift |
| Platform code outside `inference/` | All platform channels isolated in `ml_pipeline/inference/` |
| Hardcoded thresholds in business logic | Read from `PipelineConfig` injected via GetIt |
| Mutable BLoC state objects | All states immutable; use `freezed` sealed class variants |
| Hand-written data class boilerplate | Use `freezed` — generates `==`, `hashCode`, `copyWith`, JSON |
| Raw stream exceptions reaching BLoC | Repository wraps in `Either`; BLoC only processes `Either` values |
| Domain entities crossing isolate boundary | Pipeline outputs DTOs; `data/mappers/` translates to domain entities |
| Global singleton BLoC for cross-screen state | Shell-route scoped BLoC (only `AnalysisBloc` permitted) |

## Project Structure & Boundaries

### Complete Project Directory Structure

```
pingpongbuddy/
├── .github/
│   └── workflows/
│       └── ci.yml                          # VGV-generated: format, analyze, test
├── .vscode/
│   ├── launch.json                         # Dev/prod flavor launch configs
│   └── settings.json                       # Dart/Flutter workspace settings
├── android/
│   ├── app/
│   │   └── src/
│   │       └── main/
│   │           └── kotlin/.../             # MediaPipe platform channel (Android side)
│   └── build.gradle
├── ios/
│   ├── Runner/
│   │   └── MediaPipeChannel.swift          # MediaPipe platform channel (iOS side)
│   └── Podfile
├── lib/
│   ├── app.dart                            # MaterialApp + GoRouter + BlocProvider tree
│   ├── main_development.dart               # Dev flavor entry point
│   ├── main_production.dart                # Prod flavor entry point
│   ├── bootstrap.dart                      # GetIt registration + Drift init
│   ├── core/
│   │   ├── config/
│   │   │   ├── pipeline_config.dart        # ML tuning parameters
│   │   │   └── app_config.dart             # Business rules (trust ladder, free tier, etc.)
│   │   ├── constants/
│   │   │   ├── route_names.dart
│   │   │   ├── asset_paths.dart
│   │   │   └── durations.dart
│   │   ├── database/
│   │   │   ├── app_database.dart           # Drift database class
│   │   │   ├── app_database.g.dart         # Generated
│   │   │   ├── tables/
│   │   │   │   ├── sessions.dart
│   │   │   │   ├── strokes.dart
│   │   │   │   ├── landmarks.dart
│   │   │   │   ├── stroke_metrics.dart
│   │   │   │   ├── session_metrics.dart
│   │   │   │   ├── baselines.dart
│   │   │   │   ├── coaching_tips.dart
│   │   │   │   ├── pipeline_runs.dart
│   │   │   │   ├── subscription.dart
│   │   │   │   └── app_config_table.dart
│   │   │   ├── daos/
│   │   │   │   ├── sessions_dao.dart
│   │   │   │   ├── strokes_dao.dart
│   │   │   │   ├── landmarks_dao.dart
│   │   │   │   ├── baselines_dao.dart
│   │   │   │   ├── coaching_tips_dao.dart
│   │   │   │   ├── pipeline_runs_dao.dart
│   │   │   │   └── subscription_dao.dart
│   │   │   └── migrations/
│   │   │       ├── v2.dart
│   │   │       └── ...                     # One file per schema version
│   │   ├── di/
│   │   │   └── injection_container.dart    # GetIt registration (DAOs, repos, configs)
│   │   ├── error/
│   │   │   └── failures.dart               # Sealed Failure hierarchy
│   │   ├── extensions/
│   │   │   ├── datetime_extension.dart
│   │   │   └── either_extension.dart
│   │   ├── router/
│   │   │   └── app_router.dart             # GoRouter config + shell routes
│   │   └── theme/
│   │       ├── app_theme.dart              # Material 3 theme from seed
│   │       └── design_tokens.dart          # Spacing, radii, typography scale
│   ├── features/
│   │   ├── onboarding/
│   │   │   └── presentation/              # FR8-12: Setup guides, permission requests
│   │   │       ├── bloc/
│   │   │       ├── pages/
│   │   │       └── widgets/
│   │   ├── recording/
│   │   │   ├── data/                      # FR1-7: Camera access, video storage
│   │   │   │   ├── datasources/
│   │   │   │   │   └── camera_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── recording_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── recording_session.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── recording_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── start_recording.dart
│   │   │   │       └── stop_recording.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── recording_bloc.dart
│   │   │       │   ├── recording_event.dart
│   │   │       │   └── recording_state.dart
│   │   │       ├── pages/
│   │   │       │   └── recording_page.dart
│   │   │       └── widgets/
│   │   │           └── recording_controls.dart
│   │   ├── analysis/
│   │   │   ├── data/                      # FR13, FR22-26: Pipeline orchestration
│   │   │   │   ├── mappers/
│   │   │   │   │   ├── pipeline_result_mapper.dart
│   │   │   │   │   └── stroke_metrics_mapper.dart
│   │   │   │   └── repositories/
│   │   │   │       └── analysis_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── analysis_result.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── analysis_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── run_analysis.dart
│   │   │   │       └── cancel_analysis.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── analysis_bloc.dart  # Shell-route scoped (spans progress + summary)
│   │   │       │   ├── analysis_event.dart
│   │   │       │   └── analysis_state.dart
│   │   │       ├── pages/
│   │   │       │   └── analysis_progress_page.dart
│   │   │       └── widgets/
│   │   │           └── progress_indicator_widget.dart
│   │   ├── session_summary/
│   │   │   ├── data/                      # FR34-40: Summary display, sharing
│   │   │   │   └── repositories/
│   │   │   │       └── session_summary_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── session_summary.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── session_summary_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_session_summary.dart
│   │   │   │       └── share_session_summary.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       ├── pages/
│   │   │       │   └── session_summary_page.dart
│   │   │       └── widgets/
│   │   │           ├── metrics_card.dart
│   │   │           ├── on_table_rate_badge.dart
│   │   │           └── coaching_tip_card.dart
│   │   ├── video_review/
│   │   │   ├── domain/                    # FR41: Video playback
│   │   │   │   └── usecases/
│   │   │   │       └── load_video.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       ├── pages/
│   │   │       │   └── video_review_page.dart
│   │   │       └── widgets/
│   │   │           └── video_player_controls.dart
│   │   ├── session_history/
│   │   │   ├── data/                      # FR42-50: Session list, management, baselines
│   │   │   │   └── repositories/
│   │   │   │       ├── session_history_repository_impl.dart
│   │   │   │       └── baseline_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── session_list_item.dart
│   │   │   │   │   └── baseline.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   ├── session_history_repository.dart
│   │   │   │   │   └── baseline_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_sessions.dart
│   │   │   │       ├── delete_session.dart
│   │   │   │       └── compute_baseline.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       ├── pages/
│   │   │       │   └── session_history_page.dart
│   │   │       └── widgets/
│   │   │           └── session_list_tile.dart
│   │   ├── coaching/
│   │   │   ├── data/                      # FR51-58: Coaching tip display, feedback
│   │   │   │   └── repositories/
│   │   │   │       └── coaching_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── coaching_tip.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── coaching_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_coaching_tips.dart
│   │   │   │       └── submit_tip_feedback.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       ├── pages/
│   │   │       └── widgets/
│   │   ├── subscription/
│   │   │   ├── data/                      # FR59-68: IAP, tier management
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── ios_iap_datasource.dart
│   │   │   │   │   └── android_iap_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── subscription_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── subscription_status.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── subscription_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── check_subscription.dart
│   │   │   │       └── purchase_subscription.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       ├── pages/
│   │   │       │   └── upgrade_page.dart
│   │   │       └── widgets/
│   │   └── settings/
│   │       └── presentation/              # FR69-71: App settings
│   │           ├── bloc/
│   │           ├── pages/
│   │           │   └── settings_page.dart
│   │           └── widgets/
│   └── ml_pipeline/
│       ├── inference/                     # Main isolate — platform channels
│       │   ├── mediapipe_service.dart     # Platform channel wrapper
│       │   └── frame_extractor.dart       # Video → frame bytes
│       ├── vision/                        # Main isolate — pixel-level processing
│       │   ├── ball_detector.dart         # Frame differencing on pixel data
│       │   └── on_table_classifier.dart   # Ball events → on/off table
│       ├── pipeline/                      # Computation isolate — pure Dart only
│       │   ├── stroke_segmenter.dart
│       │   ├── metrics_computer.dart
│       │   ├── session_aggregator.dart
│       │   └── coaching_engine.dart
│       ├── models/                        # Pure Dart — shared between isolates
│       │   ├── landmark_frame.dart
│       │   ├── stroke_event.dart
│       │   ├── ball_event.dart
│       │   ├── stage_result.dart
│       │   ├── pipeline_result.dart
│       │   ├── pipeline_config.dart
│       │   ├── stroke_profile.dart
│       │   ├── metric_definition.dart
│       │   ├── coaching_rule.dart
│       │   └── progress_update.dart
│       ├── profiles/                      # StrokeProfile definitions
│       │   ├── forehand_topspin.dart
│       │   └── backhand_topspin.dart
│       └── orchestrator/                  # Isolate lifecycle + composition
│           ├── pipeline_runner.dart
│           └── isolate_manager.dart
├── test/
│   ├── core/
│   │   ├── database/
│   │   │   ├── daos/                      # DAO unit tests
│   │   │   └── migrations/               # Migration snapshot tests
│   │   ├── config/
│   │   ├── di/
│   │   └── error/
│   ├── features/
│   │   ├── recording/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── analysis/
│   │   │   ├── data/
│   │   │   │   └── mappers/              # DTO → entity mapping tests
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── session_summary/
│   │   ├── video_review/
│   │   ├── session_history/
│   │   ├── coaching/
│   │   ├── subscription/
│   │   └── settings/
│   ├── ml_pipeline/
│   │   ├── inference/                     # Integration tests (platform mocking)
│   │   ├── vision/                        # Unit tests (ball detection, classifier)
│   │   ├── pipeline/                      # Unit tests per stage + determinism + golden
│   │   ├── models/
│   │   ├── profiles/                      # StrokeProfile validation tests
│   │   └── orchestrator/
│   ├── integration/
│   │   └── pipeline/                      # End-to-end pipeline composition tests
│   │       └── full_pipeline_test.dart
│   ├── fixtures/
│   │   ├── golden/                        # Hand-verified input→output pairs
│   │   │   ├── stroke_segmenter_forehand_input.bin
│   │   │   ├── stroke_segmenter_forehand_expected.json
│   │   │   ├── metrics_computer_topspin_input.json
│   │   │   ├── metrics_computer_topspin_expected.json
│   │   │   ├── full_session_input.bin
│   │   │   └── full_session_ball_events.json
│   │   ├── landmarks_good_forehand.bin
│   │   ├── landmarks_low_confidence.bin
│   │   ├── coaching_regression_detected.json
│   │   └── session_summary_five_sessions.json
│   └── helpers/
│       ├── test_fixtures.dart             # Fixture loading (binary + JSON)
│       ├── pump_app.dart                  # VGV widget test helper
│       └── mock_repositories.dart
├── assets/
│   ├── onboarding/                        # Setup guide images
│   └── icons/                             # App icons
├── l10n/                                  # Localization (English only for MVP)
│   └── arb/
│       └── app_en.arb
├── analysis_options.yaml                  # very_good_analysis rules
├── pubspec.yaml
├── pubspec.lock
├── build.yaml                             # build_runner config for freezed
├── README.md
├── LICENSE
└── .gitignore
```

### Architectural Boundaries

**Isolate Boundary (most critical boundary in the project):**

```
┌──────────────────────────────────────┐   ┌──────────────────────────────────┐
│          MAIN ISOLATE                │   │     COMPUTATION ISOLATE          │
│                                      │   │                                  │
│  lib/ml_pipeline/inference/          │   │  lib/ml_pipeline/pipeline/       │
│    MediaPipe platform channels       │   │    StrokeSegmenter               │
│    Frame extraction                  │   │    MetricsComputer               │
│                                      │   │    SessionAggregator             │
│  lib/ml_pipeline/vision/             │   │    CoachingEngine                │
│    BallDetector (pixel data)         │   │                                  │
│    OnTableClassifier                 │   │  ── Pure Dart only ──            │
│                                      │   │  No Flutter, no platform imports │
│  lib/features/*/presentation/        │   │                                  │
│    All UI (BLoCs, pages, widgets)    │   │                                  │
│                                      │   │                                  │
│  lib/features/*/data/                │   │                                  │
│    Repositories, DAOs, mappers       │   │                                  │
│                                      │   │                                  │
│  lib/core/                           │   │                                  │
│    Database, DI, routing, theme      │   │                                  │
├──────────────────────────────────────┤   ├──────────────────────────────────┤
│  SENDS: LandmarkFrame[], BallEvent[] │──►│  RECEIVES via SendPort           │
│  RECEIVES: ProgressUpdate, Result    │◄──│  SENDS: ProgressUpdate, Result   │
└──────────────────────────────────────┘   └──────────────────────────────────┘
                    │
         lib/ml_pipeline/models/  (pure Dart — shared by both sides)
```

**Feature Boundaries (no cross-feature imports):**

Features communicate only through:
1. **Shared domain entities** via abstract repository interfaces in each feature's `domain/repositories/`
2. **GoRouter navigation** — one feature navigates to another via route name, never by importing the target feature's page directly
3. **Shared DAOs** in `core/database/daos/` — multiple features can read/write the same tables through their own repositories

| Feature | Reads From (DAOs) | Writes To (DAOs) |
|---------|-------------------|-------------------|
| recording | — | SessionsDao (create) |
| analysis | SessionsDao, LandmarksDao | StrokesDao, StrokeMetricsDao (via mapper), SessionMetricsDao, CoachingTipsDao, PipelineRunsDao |
| session_summary | SessionsDao, SessionMetricsDao, CoachingTipsDao | — |
| video_review | SessionsDao | — |
| session_history | SessionsDao, BaselinesDao | SessionsDao (delete), BaselinesDao |
| coaching | CoachingTipsDao | CoachingTipsDao (feedback signal) |
| subscription | SubscriptionDao | SubscriptionDao |
| settings | AppConfigDao | AppConfigDao, SessionsDao (delete all) |
| onboarding | — | — |

**Layer Boundaries (strict dependency direction):**

```
┌─────────────────────────────────────────────┐
│              Presentation Layer              │
│  BLoCs → Use Cases (never skip to Data)     │
├─────────────────────────────────────────────┤
│              Domain Layer                    │
│  Entities, Abstract Repos, Use Cases        │
│  No imports from Data or Presentation       │
├─────────────────────────────────────────────┤
│              Data Layer                      │
│  Repo Impls, DAOs, Datasources, Mappers     │
│  Implements Domain interfaces               │
├─────────────────────────────────────────────┤
│              ML Pipeline                     │
│  Outputs DTOs → mapped to Domain entities   │
│  inference/ + vision/ (main isolate)        │
│  pipeline/ (computation isolate)            │
└─────────────────────────────────────────────┘
```

### Requirements-to-Structure Mapping

**Feature Mapping (PRD FR → Directory):**

| FR Range | Capability | Feature Directory | Key Files |
|----------|-----------|-------------------|-----------|
| FR1-7 | Video recording & camera | `features/recording/` | `camera_datasource.dart`, `recording_bloc.dart` |
| FR8-12 | Onboarding & setup | `features/onboarding/` | `onboarding_page.dart` |
| FR13-21 | Analysis pipeline | `features/analysis/` + `ml_pipeline/` | `analysis_bloc.dart`, `pipeline_runner.dart` |
| FR22-26 | Degradation & quality | `ml_pipeline/models/stage_result.dart` | `StageResult.quality`, confidence scoring |
| FR27-33 | Graceful degradation | `ml_pipeline/pipeline/` (all stages) | Per-stage partial result handling |
| FR34-40 | Session summary & sharing | `features/session_summary/` | `session_summary_page.dart`, `metrics_card.dart` |
| FR41 | Video review | `features/video_review/` | `video_review_page.dart` |
| FR42-50 | Session history & baselines | `features/session_history/` | `session_history_page.dart`, `baseline_repository.dart` |
| FR51-58 | Coaching tips & feedback | `features/coaching/` + `ml_pipeline/pipeline/coaching_engine.dart` | `coaching_tip_card.dart`, `coaching_engine.dart` |
| FR59-68 | Subscription & monetization | `features/subscription/` | `upgrade_page.dart`, `subscription_repository.dart` |
| FR69-71 | Settings | `features/settings/` | `settings_page.dart` |
| FR72-78 | System constraints | `core/` (cross-cutting) | `app_config.dart`, `pipeline_config.dart` |

**Cross-Cutting Concern Mapping:**

| Concern | Primary Location | Touches |
|---------|-----------------|---------|
| Error handling | `core/error/failures.dart` | All features (via `Either<Failure, T>`) |
| Dependency injection | `core/di/injection_container.dart` | All features (GetIt registration) |
| Database | `core/database/` | All features with data layer |
| Routing | `core/router/app_router.dart` | All features with pages |
| Theme | `core/theme/` | All presentation layers |
| Logging | `core/` (logger setup) | All layers |
| Config | `core/config/` | `PipelineConfig` → ml_pipeline; `AppConfig` → features |

### Integration Points

**Internal Data Flow:**

```
Recording ──(video file + session record)──► Analysis
     │                                           │
     │                                    ┌──────┴──────┐
     │                                    │  ML Pipeline │
     │                                    │  (2 isolates)│
     │                                    └──────┬──────┘
     │                                           │
     │                              ┌────────────┼────────────┐
     │                              ▼            ▼            ▼
     │                        StrokesDao  SessionMetrics  CoachingTips
     │                              │            │            │
     ▼                              ▼            ▼            ▼
Session History ◄────── Session Summary ◄─── Coaching
     │
     ▼
Baselines (computed from SessionMetrics across sessions)
```

**External Integration Points:**

| Integration | Directory | Protocol |
|-------------|-----------|----------|
| MediaPipe SDK | `ml_pipeline/inference/` + `android/` + `ios/` | Platform channel (`com.pingpongbuddy/mediapipe`) |
| StoreKit 2 (iOS) | `features/subscription/data/datasources/ios_iap_datasource.dart` | Platform channel |
| Google Play Billing v7+ | `features/subscription/data/datasources/android_iap_datasource.dart` | Platform channel |
| Camera API | `features/recording/data/datasources/camera_datasource.dart` | `camera` package (wraps platform) |
| Share sheet | `features/session_summary/` | `share_plus` package |

### File Organization Patterns

**Configuration files at project root:**
- `pubspec.yaml` — all Dart/Flutter dependencies with pinned versions
- `analysis_options.yaml` — extends `very_good_analysis` with zero custom overrides initially
- `build.yaml` — `build_runner` / `freezed` / `json_serializable` config
- `.github/workflows/ci.yml` — format → analyze → test pipeline

**Source organization rules:**
- One public class per file (except tightly coupled types like event/state pairs)
- File named after its primary export: `session_summary_bloc.dart` exports `SessionSummaryBloc`
- Private helper classes may share a file with their public consumer
- Generated files (`*.freezed.dart`, `*.g.dart`) committed to VCS and co-located with source

**Test organization rules:**
- Test file mirrors source: `lib/features/recording/domain/usecases/start_recording.dart` → `test/features/recording/domain/usecases/start_recording_test.dart`
- Integration tests in `test/integration/` (not mirrored)
- Golden files in `test/fixtures/golden/`
- Shared test utilities in `test/helpers/`

**Asset organization:**
- `assets/onboarding/` — setup guide imagery
- `assets/icons/` — app icons, launcher icons
- No ML model assets checked in — MediaPipe models bundled via platform-native build (CocoaPods / Gradle)

## Architecture Validation Results

### Coherence Validation

**Decision Compatibility: PASS**

All technology choices are mutually compatible:
- Flutter 3.20+ ↔ Drift ^2.32.1 ↔ flutter_bloc ^9.1.1 ↔ GetIt ^9.2.1 ↔ go_router ^17.2.0 — all current stable, no known conflicts
- MediaPipe Pose Landmarker v0.10.33 integrates via platform channels — no Dart package dependency conflicts
- `freezed` + `json_serializable` + `build_runner` — standard code generation stack, compatible with BLoC and Drift
- `fpdart` for `Either<Failure, T>` — lightweight, no conflicts with BLoC event/state flow
- Two-isolate model: `SendPort`/`ReceivePort` + `TransferableTypedData` are core Dart — no package dependency

**One inconsistency fixed during step 6:** `ball_detector.dart` and `on_table_classifier.dart` were listed under `ml_pipeline/pipeline/` (pure-Dart computation isolate) in the step-03 tree, but step-04 revised the two-isolate model to run these on the main isolate (they require pixel data). Resolved by creating `ml_pipeline/vision/` directory. Both the step-03 tree and step-06 full tree are now consistent.

**Pattern Consistency: PASS**

- Naming conventions (snake_case files, PascalCase classes, past-tense BLoC events) are consistent across all sections
- `freezed` adoption aligns with immutable state requirement in BLoC patterns
- `Either<Failure, T>` return convention is consistently applied in repository, use case, and stream patterns
- `PipelineConfig` / `AppConfig` split aligns with isolate boundary — pipeline config crosses to computation isolate, app config stays on main
- Metric IDs use snake_case strings consistently in both the biomechanical catalog and `StrokeProfile` schema

**Structure Alignment: PASS**

- Project tree supports all architectural decisions: separate `inference/`, `vision/`, `pipeline/` directories enforce the isolate boundary
- Feature-based clean architecture (data/domain/presentation) aligns with BLoC + repository + use case patterns
- `data/mappers/` in analysis feature supports the isolate boundary DTO → entity translation
- `ml_pipeline/profiles/` directory supports StrokeProfile extensibility (NFR32)
- Test structure mirrors lib/ and includes dedicated integration + golden file directories

### Requirements Coverage Validation

**Functional Requirements Coverage: PASS (FR1-78)**

| FR Range | Capability | Architectural Support |
|----------|-----------|----------------------|
| FR1-7 | Recording | `features/recording/` + camera datasource + SessionsDao |
| FR8-12 | Onboarding | `features/onboarding/` presentation-only feature |
| FR13-21 | Analysis trigger/processing | `features/analysis/` + `ml_pipeline/orchestrator/` + `PipelineRunner` |
| FR22-26 | Analysis quality/degradation | `StageResult.quality` + `StageResult.partial` + confidence metadata |
| FR27-33 | Graceful degradation | Per-stage partial result handling + `PipelineConfig` thresholds |
| FR34-40 | Session summary/sharing | `features/session_summary/` + SessionMetricsDao + share_plus |
| FR41 | Video review | `features/video_review/` + video playback |
| FR42-50 | Session history/baselines | `features/session_history/` + BaselinesDao + baseline computation |
| FR51-58 | Coaching tips/feedback | `features/coaching/` + `ml_pipeline/pipeline/coaching_engine.dart` + `StrokeProfile.rules` |
| FR59-68 | Subscription/monetization | `features/subscription/` + platform IAP datasources + SubscriptionDao + beta hardcode strategy |
| FR69-71 | Settings | `features/settings/` + AppConfigDao |
| FR72-78 | System constraints | `core/config/`, `PipelineConfig`, `AppConfig`, offline-first design |

**Non-Functional Requirements Coverage: PASS (NFR1-33)**

| NFR | Requirement | Architectural Support |
|-----|-----------|----------------------|
| NFR1-2 | Processing time targets | Frame sampling rate in `PipelineConfig` (primary lever), two-isolate model for parallel processing |
| NFR3-4 | Recording/ML FPS | Native camera package, MediaPipe GPU acceleration via platform channel |
| NFR5 | UI responsiveness during analysis | Computation isolate — analysis never blocks main isolate UI thread |
| NFR6-8 | Load time targets | Drift reactive queries (`watchSessions`), pre-computed session_metrics table |
| NFR9 | Progress indicator updates | `ProgressUpdate(stage, percentComplete)` via `SendPort` |
| NFR10-14 | Security/privacy | App sandbox, no PII off-device, no IDFA, video backup exclusion, subscription-only network |
| NFR15 | Zero data loss on update | Step-by-step versioned migrations with snapshot assertions, explicit `ALTER TABLE` |
| NFR16 | Pipeline determinism | Pure-Dart pipeline stages, mandatory determinism tests, no random/time-dependent logic |
| NFR17 | Subscription offline cache | SubscriptionDao + 7-day grace period in `AppConfig` |
| NFR18-19 | Crash recovery, atomic writes | Drift transactions, video ↔ DB reconciliation on app launch |
| NFR20-23 | Battery/thermal | Frame sampling as primary lever, no background processing when idle, configurable via `PipelineConfig` |
| NFR24 | Metadata storage < 50MB/100 sessions | Typed JSON map for stroke_metrics (compact), compressed binary landmarks in prod |
| NFR25 | App binary ≤ 100MB | MediaPipe model variant selection (6-26MB), Flutter framework (~15-20MB) |
| NFR26 | Temp artifact cleanup | Pipeline orchestrator cleanup in `finally` block |
| NFR27 | Video storage estimation | Recording feature estimates based on resolution + duration |
| NFR28-31 | Accessibility | Material 3 theme with WCAG AA, 44pt touch targets, screen reader compatibility, no color-only indicators |
| NFR32 | Extensibility (new stroke types) | `StrokeProfile` parameterization — new profile instance, zero pipeline changes |
| NFR33 | Device floor | Technical constraint: 4GB RAM, GPU SoC, Android API 31+, iPhone 12+ |

### Implementation Readiness Validation

**Decision Completeness: PASS**

- All critical dependencies have pinned versions
- All 10 Drift tables defined with purpose and key fields
- Pipeline stage interface (`PipelineStage<TInput, TOutput>`) and composition (`PipelineRunner`) fully specified
- Biomechanical metric catalog (9 + 1 derived) with internal IDs, display phrases, sources, and computation methods
- Two-isolate communication protocol defined with data transfer, progress, error, and cancellation patterns
- PoC validation gates defined with pass/fail criteria at 3 stages
- Implementation sequence (10 steps) with PoC gates positioned at steps 4 and 5

**Structure Completeness: PASS**

- Full project tree from root to leaf files
- Every feature expanded to file level with FR traceability
- Platform-specific directories (android/, ios/) include MediaPipe channel locations
- Test structure mirrors lib/ with dedicated integration, golden, and fixture directories

**Pattern Completeness: PASS**

- 12 enforcement rules (3 CRITICAL, 9 IMPORTANT)
- 11 anti-patterns with correct alternatives
- Code examples for: repository pattern, Either usage, stream error handling, BLoC state, cross-screen BLoC, pipeline testing, golden file testing, integration testing
- `freezed` scope table (what uses it, what doesn't)
- Two config classes with clear ownership boundaries

### Gap Analysis Results

**Critical Gaps: None identified.**

**Important Gaps (2):**

1. **Background execution handling is noted but not fully patterned.** The technical constraint mentions `BGTaskScheduler` (iOS) / `WorkManager` (Android) and that analysis may be interrupted. FR26 says restart-from-scratch. The `pipeline_runs` table tracks analysis attempts. However, there is no explicit pattern for how the `IsolateManager` detects app suspension vs. completion, or how it triggers restart. **Recommendation:** Defer — this is implementation detail that depends on platform-specific behavior discovered during PoC Gate 1. The `pipeline_runs` table and FR26 restart strategy provide sufficient architectural direction.

2. **Logging pattern is mentioned (logger package, levels, no PII) but no structured format is defined.** Different agents could log differently. **Recommendation:** Acceptable for MVP — `very_good_analysis` lint rules enforce consistent code style, and logging format can be standardized during first story implementation without architectural impact.

**Nice-to-Have Gaps (2):**

1. `share_plus` package not listed in the Technical Constraints & Dependencies table (it's implied by session summary sharing). Minor — add during story implementation.
2. `camera` package not listed in the Technical Constraints & Dependencies table (it's implied by recording). Minor — add during story implementation.

### Architecture Completeness Checklist

**Requirements Analysis**
- [x] Project context thoroughly analyzed (PRD, tech research, product brief, distillate)
- [x] Scale and complexity assessed (4-layer model, ML pipeline, two-isolate architecture)
- [x] Technical constraints identified (10 constraints with rationale)
- [x] Cross-cutting concerns mapped (10 concerns with architectural impact)

**Architectural Decisions**
- [x] Critical decisions documented with versions (Flutter 3.20+, Drift ^2.32.1, MediaPipe v0.10.33, etc.)
- [x] Technology stack fully specified (framework, ML, database, state, DI, routing, code generation)
- [x] Integration patterns defined (isolate communication, platform channels, repository pattern)
- [x] Performance considerations addressed (frame sampling, isolate model, configurable thresholds)
- [x] Data architecture defined (10 Drift tables, migration strategy, video sync, landmark storage)
- [x] Security & privacy addressed (sandbox, no PII, backup exclusion, subscription validation)
- [x] ML pipeline architecture defined (stage interface, composition, biomechanical catalog, StrokeProfile)

**Implementation Patterns**
- [x] Naming conventions established (6 categories: Dart, Drift, DateTime, BLoC, Pipeline)
- [x] Structure patterns defined (feature internals, imports, dependency direction, isolate boundary mapping)
- [x] Data flow patterns specified (repository, Either, stream error handling)
- [x] Error handling patterns documented (Failure hierarchy, pipeline errors, user-facing messages)
- [x] State management patterns defined (standard BLoC states, cross-screen policy, disposal)
- [x] Configuration patterns specified (PipelineConfig + AppConfig split, GetIt injection)
- [x] Testing patterns documented (naming, fixtures, determinism, golden files, integration)
- [x] Code generation position stated (freezed scope, build_runner, file conventions)
- [x] Enforcement guidelines documented (12 rules, 11 anti-patterns)

**Project Structure**
- [x] Complete directory structure defined (root to leaf)
- [x] Component boundaries established (isolate, feature, layer)
- [x] Integration points mapped (internal data flow, external integrations)
- [x] Requirements to structure mapping complete (FR1-78, NFR1-33)

### Architecture Readiness Assessment

**Overall Status: READY FOR IMPLEMENTATION**

**Confidence Level: HIGH**

The architecture covers all 78 functional requirements and 33 non-functional requirements with traceable support. Three PoC gates provide explicit go/no-go checkpoints before full investment in downstream features.

**Key Strengths:**
- Two-isolate model cleanly separates platform-dependent vision tasks from pure-Dart computation, enabling comprehensive unit testing of the most critical code paths
- `StrokeProfile` parameterization (NFR32) future-proofs stroke type expansion with zero pipeline changes
- Explicit PoC gates at ML inference, stroke segmentation, and ball detection de-risk the highest-uncertainty technical assumptions before building dependent features
- `PipelineConfig` / `AppConfig` split + `freezed` + `Either<Failure, T>` provide a consistent, testable foundation that AI agents can follow without ambiguity
- Biomechanical metric catalog grounded in peer-reviewed research (Nanjing correlations) and founder coaching expertise

**Areas for Future Enhancement (post-MVP):**
- Analytics/telemetry infrastructure (deferred per decision priority)
- Remote configuration / feature flags
- Cloud backup opt-in
- Multi-language support
- Dark mode theme
- Deep linking
- YOLO upgrade path for ball detection (triggered by PoC Gate 3 failure)

### Implementation Handoff

**AI Agent Guidelines:**
- Follow all architectural decisions exactly as documented — versions, patterns, naming, boundaries
- Use implementation patterns consistently across all components
- Respect isolate boundary: never import Flutter in `ml_pipeline/pipeline/`
- Use `freezed` for data classes, `Either<Failure, T>` for error handling, past-tense BLoC events
- Run determinism + golden file tests for every pipeline stage
- Check PoC gates before proceeding past steps 4 and 5

**First Implementation Steps:**
```bash
dart pub global activate very_good_cli
very_good create flutter_app pingpongbuddy --desc "AI-powered table tennis swing analyzer"
```
Then: apply customizations (collapse to 2 flavors, add GetIt/Drift/go_router, create feature directory structure, set up Drift schema with migration infrastructure).
