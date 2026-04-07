# Story 1.1: Project Scaffolding with Very Good CLI

Status: ready-for-dev

## Story

As a developer,
I want a properly initialized Flutter project with production-grade tooling,
so that all subsequent development builds on a solid foundation.

## Acceptance Criteria

1. **Given** Very Good CLI v1.1.1 is installed
   **When** `very_good create flutter_app pingpongbuddy` is run and customizations are applied
   **Then** the project compiles and runs on both iOS and Android simulators

2. **And** only dev and prod build flavors exist (staging removed)

3. **And** internationalization setup is removed

4. **And** GetIt, Drift, go_router, freezed, and json_serializable dependencies are added and resolve

5. **And** the feature-based directory structure matches the architecture document's target project structure

6. **And** `very_good_analysis` lints pass with zero warnings

7. **And** GitHub Actions CI workflow runs tests, formatting checks, and analysis successfully

## Tasks / Subtasks

- [ ] Task 1: Initialize project with VGV CLI (AC: #1)
  - [ ] Install VGV CLI: `dart pub global activate very_good_cli`
  - [ ] Create project: `very_good create flutter_app pingpongbuddy --desc "AI-powered table tennis swing analyzer"`
  - [ ] Verify project compiles: `flutter run` on iOS simulator and Android emulator

- [ ] Task 2: Collapse build flavors to dev + prod (AC: #2)
  - [ ] Remove `main_staging.dart` entry point
  - [ ] Remove staging flavor configuration from `android/app/build.gradle`
  - [ ] Remove staging scheme from iOS Xcode project
  - [ ] Update `.vscode/launch.json` to reference only dev and prod flavors
  - [ ] Verify both `flutter run --flavor development --target lib/main_development.dart` and `flutter run --flavor production --target lib/main_production.dart` compile

- [ ] Task 3: Remove internationalization setup (AC: #3)
  - [ ] Delete `l10n/` directory and ARB files
  - [ ] Remove `flutter_localizations` and `intl` dependencies from `pubspec.yaml`
  - [ ] Remove `l10n.yaml` if present
  - [ ] Remove localization delegates from `MaterialApp` in `app.dart`
  - [ ] Remove any generated `l10n/` output files

- [ ] Task 4: Add dependencies to pubspec.yaml (AC: #4)
  - [ ] Add runtime dependencies (see Dev Notes for exact versions)
  - [ ] Add dev dependencies (see Dev Notes for exact versions)
  - [ ] Run `dart pub get` — all dependencies must resolve without conflict
  - [ ] Run `dart run build_runner build --delete-conflicting-outputs` to verify code generation pipeline works

- [ ] Task 5: Create feature-based directory structure (AC: #5)
  - [ ] Create `lib/core/` subdirectories: `config/`, `constants/`, `database/` (with `tables/`, `daos/`, `migrations/`), `di/`, `error/`, `extensions/`, `router/`, `theme/`
  - [ ] Create `lib/features/` subdirectories: `recording/`, `onboarding/`, `analysis/`, `session_summary/`, `video_review/`, `session_history/`, `coaching/`, `subscription/`, `settings/`
  - [ ] Create `lib/ml_pipeline/` subdirectories: `inference/`, `vision/`, `pipeline/`, `models/`, `profiles/`, `orchestrator/`
  - [ ] Create `test/` mirror structure: `test/core/`, `test/features/`, `test/ml_pipeline/`, `test/integration/pipeline/`, `test/fixtures/golden/`, `test/helpers/`
  - [ ] Add `.gitkeep` files to empty directories so they are tracked in version control
  - [ ] Verify structure matches architecture document's "Target Project Structure" section exactly

- [ ] Task 6: Create placeholder files for bootstrap and DI (AC: #5)
  - [ ] Create `lib/bootstrap.dart` with GetIt initialization stub and Drift init stub
  - [ ] Create `lib/core/di/injection_container.dart` with empty `configureDependencies()` function
  - [ ] Create `lib/core/error/failures.dart` with base `Failure` sealed class
  - [ ] Create `lib/core/config/app_config.dart` with empty `AppConfig` class
  - [ ] Create `lib/core/config/pipeline_config.dart` with empty `PipelineConfig` class
  - [ ] Wire `bootstrap.dart` into both `main_development.dart` and `main_production.dart`
  - [ ] Verify app still compiles and runs after wiring

- [ ] Task 7: Verify lints pass with zero warnings (AC: #6)
  - [ ] Run `very_good analyze` (or `dart analyze`) — zero warnings, zero errors
  - [ ] Run `dart format --set-exit-if-changed .` — all files formatted

- [ ] Task 8: Verify GitHub Actions CI workflow (AC: #7)
  - [ ] Review `.github/workflows/` CI configuration from VGV
  - [ ] Update CI to run only dev and prod flavors (remove staging references)
  - [ ] Ensure CI runs: `dart format --set-exit-if-changed .`, `very_good analyze`, `very_good test --coverage`
  - [ ] Commit and verify CI passes (or verify locally with `act` if available)

## Dev Notes

### Initialization Commands

```bash
dart pub global activate very_good_cli
very_good create flutter_app pingpongbuddy --desc "AI-powered table tennis swing analyzer"
cd pingpongbuddy
```

VGV CLI v1.1.1 generates a Flutter app with:
- BLoC boilerplate
- 3 build flavors (development, staging, production) — we collapse to 2
- 100% test coverage setup
- `very_good_analysis` lint rules
- GitHub Actions CI workflow
- `.vscode/launch.json` preconfigured

### Dependency Versions (pubspec.yaml)

**Runtime dependencies:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.1
  bloc: ^9.0.0
  get_it: ^9.2.1
  drift: ^2.32.1
  sqlite3_flutter_libs: any
  go_router: ^17.2.0
  freezed_annotation: any
  json_annotation: any
  fpdart: ^1.2.0
```

**Dev dependencies:**

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  very_good_analysis: ^10.2.0
  build_runner: ^2.13.1
  freezed: ^3.2.5
  json_serializable: ^6.13.1
  drift_dev: any
```

**Critical version notes:**
- `fpdart` must be `^1.2.0` (stable). Version 2.x is pre-release with breaking API changes — do NOT use.
- `freezed` 3.x is a major rewrite from 2.x. If encountering migration issues, consult the [freezed v3 migration guide](https://github.com/rrousselGit/freezed/blob/master/packages/freezed/migration_guide.md).
- `go_router` 17.x has breaking changes from prior majors. Use the official migration guide if referencing older examples.
- `very_good_analysis` ^10.2.0 may include stricter lint rules than older versions — resolve all warnings before committing.
- Flutter SDK stable is currently 3.41.x (April 2026). The `pubspec.yaml` environment should use: `sdk: '>=3.6.0 <4.0.0'` (or whatever VGV generates — don't widen unnecessarily).

### Build Flavor Configuration

**Keep:** `development` (dev) and `production` (prod)
**Remove:** `staging`

VGV generates three entry points:
- `lib/main_development.dart` — KEEP
- `lib/main_staging.dart` — DELETE
- `lib/main_production.dart` — KEEP

For Android (`android/app/build.gradle`): Remove the `staging` productFlavor block and any staging-specific `signingConfig`.

For iOS: Remove the `staging` scheme from the Xcode project. This may require editing `.xcscheme` files or using Xcode. The VGV template uses flavor-specific `xcconfig` files — remove the staging config.

### Target Directory Structure

Create ALL of these directories. Use `.gitkeep` in empty directories.

```
lib/
├── app.dart
├── bootstrap.dart
├── main_development.dart
├── main_production.dart
├── core/
│   ├── config/
│   ├── constants/
│   ├── database/
│   │   ├── tables/
│   │   ├── daos/
│   │   └── migrations/
│   ├── di/
│   ├── error/
│   ├── extensions/
│   ├── router/
│   └── theme/
├── features/
│   ├── recording/
│   ├── onboarding/
│   ├── analysis/
│   ├── session_summary/
│   ├── video_review/
│   ├── session_history/
│   ├── coaching/
│   ├── subscription/
│   └── settings/
└── ml_pipeline/
    ├── inference/
    ├── vision/
    ├── pipeline/
    ├── models/
    ├── profiles/
    └── orchestrator/
```

Test structure mirrors `lib/`:

```
test/
├── core/
│   ├── config/
│   ├── database/
│   │   ├── daos/
│   │   └── migrations/
│   ├── di/
│   └── error/
├── features/
│   ├── recording/
│   ├── onboarding/
│   ├── analysis/
│   ├── session_summary/
│   ├── video_review/
│   ├── session_history/
│   ├── coaching/
│   ├── subscription/
│   └── settings/
├── ml_pipeline/
│   ├── inference/
│   ├── vision/
│   ├── pipeline/
│   ├── models/
│   ├── profiles/
│   └── orchestrator/
├── integration/
│   └── pipeline/
├── fixtures/
│   └── golden/
└── helpers/
```

### Placeholder File Requirements

**`lib/bootstrap.dart`** — The bootstrap function that both entry points call. Stub it with:
- GetIt initialization call (`configureDependencies()`)
- App runner (`runApp()`)
- No Drift init yet (that's Story 1.3)

**`lib/core/di/injection_container.dart`** — Empty `configureDependencies()` that registers nothing yet. Future stories add registrations here.

**`lib/core/error/failures.dart`** — Base failure type:

```dart
sealed class Failure {
  const Failure(this.message);
  final String message;
}
```

**`lib/core/config/app_config.dart`** and **`lib/core/config/pipeline_config.dart`** — Empty config classes with no fields yet. Future stories populate them.

### Architecture Compliance

**Enforcement rules that apply to this story:**
- Package imports only — `import 'package:pingpongbuddy/...'`. Never relative imports.
- `very_good_analysis` lints with zero warnings.
- `ml_pipeline/pipeline/` must contain ONLY pure Dart files — no Flutter imports, no platform channel imports. (Empty for now, but the directory establishes this boundary.)
- Generated files (`*.freezed.dart`, `*.g.dart`) are committed to version control.

**Patterns established by this story that ALL future stories must follow:**
- Two build flavors: dev (debug mode, verbose logging) and prod (release mode)
- Feature-based directory structure under `lib/features/`
- Clean architecture layers within features: `data/`, `domain/`, `presentation/` (created as-needed, not preemptively)
- Core infrastructure in `lib/core/`
- ML pipeline as separate top-level directory `lib/ml_pipeline/`
- Test structure mirrors `lib/` structure exactly

### build.yaml Configuration

Create `build.yaml` at project root for `build_runner` / `freezed` / `json_serializable`:

```yaml
targets:
  $default:
    builders:
      freezed:
        options:
          format: true
```

This ensures generated code is formatted. The default `build_runner` configuration works for `json_serializable` and `drift_dev` — no custom options needed for those initially.

### What NOT to Do

- Do NOT add any Drift table definitions — that's Story 1.3
- Do NOT create any widgets or screens — that's Story 1.2+
- Do NOT add `camera` or `share_plus` packages — those are for later stories
- Do NOT create `l10n/` or ARB files — English only, no i18n infrastructure
- Do NOT add a third build flavor — only dev and prod
- Do NOT use relative imports anywhere — always `package:pingpongbuddy/`
- Do NOT add custom lint rule overrides to `analysis_options.yaml` — use `very_good_analysis` as-is
- Do NOT create feature-internal subdirectories (data/domain/presentation) preemptively — only the top-level feature directory is created now; internal structure is added when a story needs it

### Project Structure Notes

- This is a greenfield project — there is no existing code to work with
- VGV CLI generates the initial structure; we modify it (remove staging, remove i18n, add dependencies, add directories)
- The architecture document defines the complete target structure; this story creates the skeleton
- Story 1.2 (Design System) and Story 1.3 (Database) build on top of this scaffolding

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Starter Template Evaluation] — VGV CLI selection rationale
- [Source: _bmad-output/planning-artifacts/architecture.md#Target Project Structure] — Canonical directory structure
- [Source: _bmad-output/planning-artifacts/architecture.md#Implementation Patterns & Consistency Rules] — Naming, imports, enforcement rules
- [Source: _bmad-output/planning-artifacts/architecture.md#Core Architectural Decisions] — Dependency versions, build configuration
- [Source: _bmad-output/planning-artifacts/architecture.md#Complete Project Directory Structure] — Full tree from root to leaf
- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.1] — Acceptance criteria
- [Source: _bmad-output/planning-artifacts/architecture.md#Code Generation] — freezed + json_serializable setup, build_runner command

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
