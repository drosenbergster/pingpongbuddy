# Story 1.2: Design System Foundation

Status: review

## Story

As a player,
I want a visually consistent and accessible app,
so that the experience feels polished and trustworthy from first launch.

## Acceptance Criteria

1. **Given** The Analyst color system is implemented
   **When** the M3 dynamic scheme is generated from seed `#455A64`
   **Then** all 16 standard color roles and 7 semantic roles (delta positive, delta declining, delta neutral, confidence high, confidence low, coach voice, surface elevated) are defined

2. **Given** typography is configured
   **When** fonts are loaded
   **Then** Source Serif 4 is subsetted to digits and symbols (<20KB) for metric display and DM Sans (400/500/600 weights, ~80KB) is used for UI text with Roboto fallback via `google_fonts`

3. **Given** the AppSpacing ThemeExtension is registered on ThemeData
   **When** spacing is consumed via `Theme.of(context).extension<AppSpacing>()`
   **Then** 6 tokens are available: xs (4dp), sm (8dp), md (16dp), lg (24dp), xl (32dp), xxl (48dp)

4. **Given** any text element on screen
   **When** contrast ratio is measured
   **Then** it meets WCAG 2.1 AA (4.5:1 body text, 3:1 large text)

5. **Given** any interactive element
   **When** its touch target is measured
   **Then** it is at least 44x44pt

6. **Given** any status indicator using color
   **When** it is evaluated
   **Then** a supplementary glyph or text label is also present

## Tasks / Subtasks

- [x] Task 1: Add `google_fonts` dependency (AC: #2)
  - [x] Add `google_fonts: ^8.0.2` to `pubspec.yaml` dependencies
  - [x] Run `flutter pub get` — must resolve without conflict
  - [x] Add macOS entitlement for HTTP font fetching in debug (see Dev Notes)

- [x] Task 2: Implement color system in `lib/core/theme/app_theme.dart` (AC: #1, #4)
  - [x] Create `ColorScheme.fromSeed(seedColor: Color(0xFF455A64))` light scheme
  - [x] Define 7 semantic color extensions via a `SemanticColors` ThemeExtension
  - [x] Verify all text/background combinations meet WCAG 2.1 AA contrast ratios (table in Dev Notes)

- [x] Task 3: Implement typography in `lib/core/theme/app_theme.dart` (AC: #2)
  - [x] Define `TextTheme` using `GoogleFonts.dmSansTextTheme()` as base
  - [x] Create Source Serif 4 text styles for metric sizes (hero 56sp, section 28sp, mini 18sp)
  - [x] Create DM Sans text styles for all UI roles (display, title, body, coach voice, label, caption)
  - [x] Expose typography helpers via a `AppTypography` ThemeExtension

- [x] Task 4: Implement AppSpacing ThemeExtension in `lib/core/theme/design_tokens.dart` (AC: #3)
  - [x] Create `AppSpacing` class extending `ThemeExtension<AppSpacing>`
  - [x] Define 6 tokens: xs=4, sm=8, md=16, lg=24, xl=32, xxl=48
  - [x] Implement `copyWith` and `lerp` methods
  - [x] Register on `ThemeData.extensions` in `app_theme.dart`

- [x] Task 5: Wire theme into `App` widget (AC: #1, #2, #3)
  - [x] Replace existing `ThemeData` in `lib/app/view/app.dart` with the new `appTheme()`
  - [x] Verify app compiles and renders with new theme

- [x] Task 6: Write tests (AC: #1–6)
  - [x] Unit test: `AppSpacing` values, `copyWith`, and `lerp`
  - [x] Unit test: semantic color values match spec
  - [x] Unit test: typography styles use correct fonts, weights, and sizes
  - [x] Widget test: theme extensions are accessible from `BuildContext`
  - [x] Accessibility test: assert WCAG contrast ratios programmatically for all defined color pairs
  - [x] Run `dart analyze` — zero warnings

## Dev Notes

### Dependency Addition

Add to `pubspec.yaml` under `dependencies`:

```yaml
google_fonts: ^8.0.2
```

`google_fonts` 8.x requires Dart SDK >=3.9, which is satisfied by our Dart 3.11.4. It fetches fonts via HTTP in debug mode and from bundled assets in release. For macOS debug builds, ensure the following entitlement exists in `macos/Runner/DebugProfile.entitlements`:

```xml
<key>com.apple.security.network.client</key>
<true/>
```

For release builds, fonts should be bundled as assets (deferred — acceptable to use HTTP fetching for now during development).

### File Structure

```
lib/core/theme/
├── app_theme.dart          # ThemeData factory, registers all extensions
└── design_tokens.dart      # AppSpacing, SemanticColors, AppTypography extensions
```

Test mirror:

```
test/core/theme/
├── app_theme_test.dart
└── design_tokens_test.dart
```

### Color System — The Analyst

**Seed:** `Color(0xFF455A64)` (Blue Grey 700)

Generate via `ColorScheme.fromSeed(seedColor: Color(0xFF455A64))`. The 16 standard M3 roles are automatic. Override or verify these key values match the UX spec:

| Role | Expected Value | Usage |
|------|---------------|-------|
| Primary | `#455A64` | Hero metric, active states |
| On Primary | `#FFFFFF` | Text/icons on primary |
| Primary Container | `#C8DDE8` | Selected states |
| On Primary Container | `#0D1B24` | Text on primary container |
| Secondary | `#586268` | Stroke-type metric values |
| Secondary Container | `#DCE6ED` | Mini-metric backgrounds |
| Surface | `#F8FAFB` | Screen backgrounds |
| On Surface | `#191C1E` | Primary text |
| On Surface Variant | `#41484D` | Secondary labels, timestamps |
| Outline | `#71787E` | Borders |
| Error | `#BA1A1A` | App errors only — never player metrics |

**Semantic Colors** — Define as `ThemeExtension<SemanticColors>`:

| Field | Value | Usage |
|-------|-------|-------|
| `deltaPositive` | `Color(0xFF2E7D5B)` | Up arrows, improving trends |
| `deltaPositiveSurface` | `Color(0xFFD4EDDF)` | Positive badge background |
| `deltaDeclining` | `Color(0xFF71787E)` | Down arrows — neutral slate, NOT red |
| `deltaDecliningSurface` | `Color(0xFFE8EAEB)` | Declining badge background |
| `deltaNeutral` | `Color(0xFF71787E)` | No change |
| `confidenceHigh` | `Color(0xFF455A64)` | "Based on 94% of strokes" |
| `confidenceLow` | `Color(0xFF71787E)` | "Based on 47% of strokes" |
| `coachVoice` | `Color(0xFF455A64)` | "One thing to try" label |
| `surfaceElevated` | `Color(0xFFECF0F3)` | Tonal elevation cards |

**Critical design rule:** Declining metrics NEVER use red. Red is reserved for app errors only. Declining = neutral slate + down arrow glyph.

### Typography System

**Dual-family strategy:** Source Serif 4 for numbers (authority), DM Sans for UI text (clarity).

Define as `ThemeExtension<AppTypography>` with named getters:

| Getter | Font | Weight | Size | Letter Spacing | Usage |
|--------|------|--------|------|----------------|-------|
| `heroMetric` | Source Serif 4 | 700 | 56sp | -2% | On-table rate "58%" |
| `sectionMetric` | Source Serif 4 | 700 | 28sp | default | Per-type breakdown |
| `miniMetric` | Source Serif 4 | 700 | 18sp | default | Mini-metric cards |
| `display` | DM Sans | 600 | 22sp | default | Screen titles |
| `title` | DM Sans | 600 | 16sp | default | Section headers |
| `body` | DM Sans | 400 | 14sp | default | Descriptions, general UI |
| `coachVoice` | DM Sans | 500 | 14sp | default | Coaching insight text |
| `label` | DM Sans | 500 | 12sp | default | Metric labels, timestamps |
| `caption` | DM Sans | 500 | 10sp | default | Fine print, confidence |

Implementation pattern using `google_fonts`:

```dart
static TextStyle _sourceSerif({
  required double fontSize,
  double? letterSpacing,
}) =>
    GoogleFonts.sourceSerif4(
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
    );

static TextStyle _dmSans({
  required FontWeight fontWeight,
  required double fontSize,
}) =>
    GoogleFonts.dmSans(
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
```

Fallback to Roboto is automatic — `google_fonts` falls back to the system default if font loading fails.

### AppSpacing ThemeExtension

```dart
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    this.xs = 4.0,
    this.sm = 8.0,
    this.md = 16.0,
    this.lg = 24.0,
    this.xl = 32.0,
    this.xxl = 48.0,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  // implement copyWith and lerp
}
```

Consumed via: `Theme.of(context).extension<AppSpacing>()!.md`

### Contrast Ratio Verification (AC: #4)

These pairs must be verified programmatically in tests:

| Combination | Expected Ratio | Requirement |
|-------------|---------------|-------------|
| Primary (#455A64) on Surface (#F8FAFB) | ~7.2:1 | Pass (≥4.5:1) |
| On Surface (#191C1E) on Surface (#F8FAFB) | ~15.8:1 | Pass (≥4.5:1) |
| On Surface Variant (#41484D) on Surface (#F8FAFB) | ~7.1:1 | Pass (≥4.5:1) |
| Delta Positive (#2E7D5B) on Delta Surface (#D4EDDF) | ~5.2:1 | Pass (≥4.5:1) |
| On Primary (#FFFFFF) on Primary (#455A64) | ~8.1:1 | Pass (≥4.5:1) |

Use the WCAG relative luminance formula: `contrast = (L1 + 0.05) / (L2 + 0.05)` where L1 is lighter.

### Touch Target Minimum (AC: #5)

This is a design-system-level guideline, not a per-widget implementation in this story. Document the 48dp minimum (Material 3 standard, exceeds WCAG 44pt requirement) as a constant in `design_tokens.dart`:

```dart
static const double minTouchTarget = 48.0;
```

All subsequent widget stories enforce this via their own widget tests.

### No Color-Only Information (AC: #6)

This is an architectural constraint enforced by the semantic color definitions. Delta colors always pair with arrow glyphs (▲/▼/—). The colorblind safety strategy:
- Positive green (#2E7D5B) and declining slate (#71787E) differ in luminance, not just hue
- Red-green conflict avoided entirely in session summary (red never appears there)
- Enforced per-widget in subsequent stories; this story defines the colors and documents the constraint

### Architecture Compliance

- **AR19:** AppSpacing as ThemeExtension — implemented in Task 4
- **AR6:** freezed is NOT used in this story. The theme extensions are simple classes with `copyWith`/`lerp` — no sealed unions or JSON serialization needed. Using freezed here would add unnecessary code generation overhead for classes that don't benefit from it.
- **Import rule:** All imports use `package:pingpongbuddy/...` — never relative
- **File naming:** `snake_case` — `app_theme.dart`, `design_tokens.dart`
- **One public class per file exception:** `design_tokens.dart` exports `AppSpacing`, `SemanticColors`, and `AppTypography` since they are tightly coupled design token definitions. This follows the architecture's allowance for "tightly coupled types" sharing a file.

### What NOT to Do

- Do NOT implement any custom widgets (HeroMetric, DeltaBadge, etc.) — those are built in their respective feature stories
- Do NOT add dark mode — light theme only for MVP
- Do NOT use standalone `const` color values scattered across files — all colors live in the theme
- Do NOT use `freezed` for theme extension classes — they have no sealed variants and don't need JSON serialization
- Do NOT bundle font files as assets yet — HTTP fetching via `google_fonts` is fine for development; bundling is a release optimization
- Do NOT cap `textScaleFactor` — layout must accommodate 200% text scaling (tested in later stories per-widget)
- Do NOT create a `colors.dart` or `typography.dart` separate from the ThemeExtension pattern — everything is accessed through the theme

### Previous Story (1.1) Intelligence

- Project scaffold is verified and committed. Flutter 3.41.6, Dart 3.11.4.
- `lib/core/theme/` directory exists but is empty (has `.gitkeep`)
- `lib/app/view/app.dart` has a placeholder `ThemeData` with `useMaterial3: true` — replace this
- `pubspec.yaml` already has `freezed_annotation`, `flutter_bloc`, etc. — `google_fonts` is the only new dependency
- `analysis_options.yaml` extends `very_good_analysis` with no overrides — keep it that way
- All imports use `package:pingpongbuddy/` pattern
- `build_runner` pipeline is already verified working

### References

- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Color System] — The Analyst palette, all 23 color roles
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Typography System] — Dual-family spec, all type roles
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Spacing & Layout Foundation] — AppSpacing tokens and layout principles
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Accessibility Considerations] — Contrast ratios, touch targets, colorblind safety
- [Source: _bmad-output/planning-artifacts/architecture.md#Complete Project Directory Structure] — `core/theme/app_theme.dart`, `core/theme/design_tokens.dart`
- [Source: _bmad-output/planning-artifacts/architecture.md#Frontend Architecture] — Material 3 light theme, WCAG compliance
- [Source: _bmad-output/planning-artifacts/architecture.md#Implementation Patterns & Consistency Rules] — Naming, imports, file conventions
- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.2] — Acceptance criteria, referenced ARs and UX-DRs

## Dev Agent Record

### Agent Model Used

Claude claude-4.6-opus (via Cursor)

### Debug Log References

- `dart analyze` — zero issues
- `flutter test --no-test-assets` — 20/20 tests pass (9 design_tokens, 9 app_theme, 2 existing app_test)
- Delta Positive color adjusted from UX spec's #2E7D5B to #277150 — original failed WCAG 4.5:1 at 4.04:1; corrected to 4.80:1
- `google_fonts ^8.0.2` resolved cleanly, added 12 transitive dependencies
- macOS DebugProfile.entitlements updated for network client (font HTTP fetching in debug)
- `AppTypography.light` uses factory constructor (not static getter) per `very_good_analysis` lint `sort_constructors_first`
- Tests use `--no-test-assets` and `testWidgets` for typography tests to avoid google_fonts HTTP fetch failures in test environment

### Completion Notes List

- Added `google_fonts: ^8.0.2` dependency
- Created `lib/core/theme/design_tokens.dart` with `AppSpacing`, `SemanticColors`, and `AppTypography` ThemeExtensions
- Created `lib/core/theme/app_theme.dart` with `appTheme()` factory using seed #455A64
- Wired theme into `lib/app/view/app.dart` replacing placeholder ThemeData
- All 3 ThemeExtensions accessible via `Theme.of(context).extension<T>()`
- 5 WCAG contrast pairs verified programmatically in tests
- Delta Positive adjusted from #2E7D5B to #277150 for WCAG AA compliance (4.80:1 ratio)

### File List

New: `lib/core/theme/app_theme.dart`, `lib/core/theme/design_tokens.dart`, `test/core/theme/app_theme_test.dart`, `test/core/theme/design_tokens_test.dart`
Modified: `pubspec.yaml`, `lib/app/view/app.dart`, `macos/Runner/DebugProfile.entitlements`
Deleted: `test/core/theme/.gitkeep`
