# Story 1.4: App Shell & Navigation

Status: review

## Story

As a player,
I want to navigate between recording and sessions seamlessly,
so that I can quickly access the features I need.

## Acceptance Criteria

1. **Given** go_router is configured
   **When** routes are defined
   **Then** /record and /sessions routes exist and navigation works between them

2. **Given** the recording screen
   **When** the player taps the sessions icon button
   **Then** the session history screen is displayed

3. **Given** the session history screen
   **When** the player taps the record icon button
   **Then** the recording screen is displayed

4. **Given** a fresh install with no sessions
   **When** the app launches
   **Then** it opens to the recording screen

5. **Given** the device orientation
   **When** the device is rotated
   **Then** the app remains locked to portrait mode

6. **Given** the app is launched (after first-use onboarding)
   **When** time to recording-ready is measured
   **Then** it is within 3 seconds

## Tasks / Subtasks

- [x] Task 1: Create route name constants (AC: #1)
  - [x] Create `lib/core/constants/route_names.dart`
  - [x] Define `record` and `sessions` route name constants

- [x] Task 2: Create placeholder page widgets for recording and session history (AC: #1, #2, #3)
  - [x] Create `lib/features/recording/presentation/pages/recording_page.dart` — placeholder Scaffold with AppBar containing history IconButton
  - [x] Create `lib/features/session_history/presentation/pages/session_history_page.dart` — placeholder Scaffold with AppBar and Record FAB
  - [x] Both pages use theme from Story 1.2 (Surface background, AppBar transparent/no elevation)

- [x] Task 3: Configure go_router with /record and /sessions routes (AC: #1, #4)
  - [x] Create `lib/core/router/app_router.dart`
  - [x] Define `GoRouter` with `/record` as initial location
  - [x] Register `/record` → `RecordingPage` and `/sessions` → `SessionHistoryPage`
  - [x] Use route name constants from Task 1

- [x] Task 4: Wire router into App widget (AC: #1, #4)
  - [x] Update `lib/app/view/app.dart` to use `MaterialApp.router` with go_router
  - [x] Pass `appTheme()` as theme
  - [x] Remove old `home:` parameter

- [x] Task 5: Implement navigation between screens (AC: #2, #3)
  - [x] Recording page: history icon button in AppBar navigates to `/sessions` via `context.goNamed`
  - [x] Session history page: FAB with record icon navigates to `/record` via `context.goNamed`
  - [x] Verify bidirectional navigation works

- [x] Task 6: Lock orientation to portrait (AC: #5)
  - [x] Add `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])` in `bootstrap.dart` before `runApp`
  - [x] Ensure `WidgetsFlutterBinding.ensureInitialized()` is called first

- [x] Task 7: Write tests (AC: #1–5)
  - [x] Widget test: App renders with router (initial route is recording page)
  - [x] Widget test: Recording page has history icon button
  - [x] Widget test: Session history page has record FAB
  - [x] Widget test: Tapping history icon on recording page navigates to sessions
  - [x] Widget test: Tapping record FAB on session history navigates to recording
  - [x] Unit test: Route names constants are correct
  - [x] Update existing app_test.dart to work with router-based App
  - [x] Run `dart analyze` — zero warnings
  - [x] Run `flutter test` — all tests pass

## Dev Notes

### Navigation Architecture (from UX spec)

**No bottom navigation bar for MVP.** Only 2 screens — a NavigationBar wastes 56dp. Instead:
- Record → Sessions: IconButton (history/list icon) in top AppBar
- Sessions → Record: FAB with record icon, or back navigation
- Fresh install opens to recording screen (`/record` is initial route)

### Route Tree

| Route | Screen | Notes |
|-------|--------|-------|
| `/record` | RecordingPage | Initial route on fresh install |
| `/sessions` | SessionHistoryPage | Session list (placeholder for now) |

Future routes (NOT this story): `/sessions/:id/summary`, `/sessions/:id/analysis`, `/settings`, `/upgrade`

### File Structure

```
lib/core/constants/
└── route_names.dart           # Route name constants

lib/core/router/
└── app_router.dart            # GoRouter configuration

lib/features/recording/presentation/pages/
└── recording_page.dart        # Placeholder with navigation

lib/features/session_history/presentation/pages/
└── session_history_page.dart  # Placeholder with navigation
```

Test mirror:

```
test/core/router/
└── app_router_test.dart

test/features/recording/presentation/pages/
└── recording_page_test.dart

test/features/session_history/presentation/pages/
└── session_history_page_test.dart
```

### Screen Layouts (Placeholder)

**Recording Page (placeholder):**
- Black `Scaffold` background (full camera preview area in future)
- Transparent `AppBar` with history `IconButton` (top-right) — `Icons.list` or `Icons.history`
- Center text placeholder: "Recording" (replaced by camera preview in Story 1.6)

**Session History Page (placeholder):**
- Surface background `Scaffold`
- `AppBar` with title "Sessions" (transparent, no elevation)
- Center text placeholder: "No sessions yet" (replaced by ListView in Epic 2)
- `FloatingActionButton` with record icon navigating to `/record`

### Portrait Lock

```dart
await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
]);
```

Called in `bootstrap()` after `WidgetsFlutterBinding.ensureInitialized()`.

### App Widget Change

Switch from `MaterialApp` to `MaterialApp.router`:

```dart
MaterialApp.router(
  theme: appTheme(),
  routerConfig: appRouter,
)
```

### go_router Pattern

```dart
final GoRouter appRouter = GoRouter(
  initialLocation: '/record',
  routes: [
    GoRoute(
      path: '/record',
      name: RouteNames.record,
      builder: (context, state) => const RecordingPage(),
    ),
    GoRoute(
      path: '/sessions',
      name: RouteNames.sessions,
      builder: (context, state) => const SessionHistoryPage(),
    ),
  ],
);
```

Navigation uses `context.goNamed(RouteNames.sessions)` — navigate by name, not path, per architecture ("one feature navigates to another via route name, never by importing the target feature's page directly").

### Testing Pattern

Widget tests use `MaterialApp.router` with the real `appRouter` to verify navigation. For isolated page tests, use `pumpApp` helper or wrap in `MaterialApp(home: ...)`.

For navigation tests, pump the full `App()` widget (which includes the router) and use `tester.tap` + `tester.pumpAndSettle` to verify page transitions.

### Architecture Compliance

- **UX-DR14:** Icon-button navigation between Record and Sessions — no bottom nav
- **UX-DR15:** Route tree via go_router: `/record`, `/sessions` (other routes added in future stories)
- **UX-DR22:** Portrait-only orientation lock
- **NFR7:** App launches to recording-ready within 3s — measured/tested in future with real camera, but navigation overhead is negligible
- **Feature boundary:** Pages import from their own feature package only. Navigation via route names, not page imports.
- **Import rule:** All imports use `package:pingpongbuddy/...`
- **File naming:** `snake_case`

### What NOT to Do

- Do NOT implement camera preview, record button, or any recording functionality — those are Stories 1.5/1.6
- Do NOT implement session list, trajectory header, or session items — those are Epic 2
- Do NOT implement last-viewed-screen restoration — that requires shared preferences (deferred)
- Do NOT implement >14-day break override — requires session history data
- Do NOT add settings, upgrade, or analysis routes yet — added in their respective stories
- Do NOT create BLoCs for these screens yet — BLoCs come with their feature stories
- Do NOT use ShellRoute yet — only needed for AnalysisBloc scope in Epic 4
- Do NOT register the router in GetIt — it's a top-level config, not a service

### Previous Story (1.3) Intelligence

- Database foundation complete. `AppDatabase` + `SessionsDao` registered in GetIt.
- `lib/core/router/` directory exists but is empty
- `lib/core/constants/` directory exists but is empty
- `lib/features/recording/` and `lib/features/session_history/` directories exist but are empty
- `lib/app/view/app.dart` uses `MaterialApp` with `home:` — needs to switch to `MaterialApp.router`
- `test/app/view/app_test.dart` tests for "PingPongBuddy" text — will need updating
- `bootstrap.dart` already calls `configureDependencies()` — add orientation lock before `runApp`
- `go_router: ^17.2.0` already in `pubspec.yaml`

### References

- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Navigation Architecture] — No bottom nav, icon-button navigation, route tree
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Navigation Patterns] — Push/pop transitions, back behavior
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Responsive Strategy] — Portrait only, SystemChrome
- [Source: _bmad-output/planning-artifacts/architecture.md#Frontend Architecture] — go_router routes, declarative routing
- [Source: _bmad-output/planning-artifacts/architecture.md#Target Project Structure] — router/, constants/, feature presentation/pages/
- [Source: _bmad-output/planning-artifacts/architecture.md#Feature Boundaries] — Navigate via route name, not page import
- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.4] — Acceptance criteria, UX-DR14/15/22, NFR7

## Dev Agent Record

### Agent Model Used

Claude claude-4.6-opus (via Cursor)

### Debug Log References

- `dart analyze` — zero issues
- `flutter test --no-test-assets` — 51/51 tests pass (39 existing from Stories 1.1–1.3 + 12 new navigation tests)
- GoRouter refactored from global `final` to `createAppRouter()` factory — avoids shared state across widget tests
- `App` converted from `StatelessWidget` to `StatefulWidget` to own the router instance (`late final GoRouter`)
- `very_good_analysis` lint fix: `specify_nonobvious_property_types` — added explicit `GoRouter` type annotation on late final
- Portrait lock via `SystemChrome.setPreferredOrientations` added to `bootstrap.dart` with `WidgetsFlutterBinding.ensureInitialized()` guard
- Navigation uses `context.goNamed(RouteNames.xxx)` — navigates by name, not path string, per architecture feature boundary rules
- Removed VGV `prefer_const_constructors` ignore from page tests (not needed — `const App()` used directly)

### Completion Notes List

- Created `RouteNames` abstract final class with `record` and `sessions` constants
- Created `RecordingPage` — black Scaffold, transparent AppBar with history IconButton
- Created `SessionHistoryPage` — Surface Scaffold, AppBar with "Sessions" title, FAB with videocam icon
- Created `createAppRouter()` factory — GoRouter with `/record` initial route, two routes using named constants
- Converted `App` to `StatefulWidget` with `MaterialApp.router` + `routerConfig`
- Added portrait lock to `bootstrap.dart` — `SystemChrome.setPreferredOrientations([portraitUp])`
- Updated `app_test.dart` for router-based App
- 12 new tests: 2 route name unit tests, 3 router navigation widget tests, 3 recording page widget tests, 3 session history page widget tests, 1 app integration test

### File List

New: `lib/core/constants/route_names.dart`, `lib/core/router/app_router.dart`, `lib/features/recording/presentation/pages/recording_page.dart`, `lib/features/session_history/presentation/pages/session_history_page.dart`, `test/core/constants/route_names_test.dart`, `test/core/router/app_router_test.dart`, `test/features/recording/presentation/pages/recording_page_test.dart`, `test/features/session_history/presentation/pages/session_history_page_test.dart`
Modified: `lib/app/view/app.dart`, `lib/bootstrap.dart`, `test/app/view/app_test.dart`
