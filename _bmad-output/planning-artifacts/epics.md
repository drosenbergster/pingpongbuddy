---
stepsCompleted: [1, 2, 3, 4]
status: 'complete'
completedAt: '2026-04-06'
inputDocuments:
  - '_bmad-output/planning-artifacts/prd.md'
  - '_bmad-output/planning-artifacts/architecture.md'
  - '_bmad-output/planning-artifacts/ux-design-specification.md'
---

# PingPongBuddy - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for PingPongBuddy, decomposing the requirements from the PRD, UX Design Specification, and Architecture into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: Player can start a video recording session with a single tap
FR2: Player can stop a recording session and retain the video file on device
FR3: Player can record a session without creating an account or signing in
FR4: Player can record a session while offline (no internet required)
FR5: Player can record a session even when their free tier analysis limit is reached
FR6: System records video as standard H.264 MP4 to local device storage
FR7: System continues recording uninterrupted regardless of on-screen activity or app backgrounding
FR8: Player sees a static camera setup guide on first use explaining optimal phone positioning (height, distance, angle)
FR9: System requests device permissions (camera, storage, notifications) just-in-time with plain-language explanation, never at app launch
FR10: Player can begin recording within 60 seconds of opening the app for the first time
FR11: System provides contextual setup tips on subsequent sessions based on conditions detected in prior sessions
FR12: Player can skip or dismiss onboarding and proceed directly to recording
FR13: Player can select a recorded video and trigger post-session analysis
FR14: System extracts body pose landmarks (33 keypoints) from recorded video frames
FR15: System detects ball on/off table events across the full session
FR16: System classifies detected strokes into three buckets: forehand topspin, backhand topspin, and other
FR17: System computes biomechanical metrics per stroke (full metric catalog defined in architecture — includes joint angles, rotational velocity, swing timing at minimum)
FR18: System computes session on-table rate across all detected strokes
FR19: System computes on-table rate per recognized stroke type (forehand topspin, backhand topspin)
FR20: System runs all analysis on-device with no cloud dependency
FR21: System selects optimal hardware acceleration (GPU/NPU/CPU) automatically based on device capabilities
FR22: System performs analysis in background isolates, keeping the UI responsive
FR23: Player can background the app during analysis and processing continues
FR24: Player receives a local notification when analysis completes while the app is backgrounded
FR25: Player sees a progress indicator during analysis showing percentage complete
FR26: If the app is killed mid-analysis, the recorded video is preserved and analysis can be restarted from scratch
FR27: System assigns confidence scores to pose landmark detections per frame (confidence thresholds are configurable parameters)
FR28: System drops frames where landmark confidence falls below the configured threshold
FR29: System performs best-effort single-player isolation from other people in the frame using position consistency
FR30: System discards ball detection events outside the defined table region
FR31: System handles sessions with zero valid frames by displaying an explanatory message with setup tips
FR32: System reports reduced data quality to the player when a session is analyzed with limited visibility
FR33: System withholds coaching tips when observation confidence does not meet the threshold for generating reliable advice
FR34: Player can view a session summary after analysis completes
FR35: Session summary displays total stroke count and stroke count per recognized type
FR36: Session summary displays session on-table rate and on-table rate per recognized stroke type
FR37: Session summary displays a text observation describing what the system detected in the session
FR38: Session summary displays baseline progress toward the coaching threshold during pre-threshold sessions
FR39: Session summary is designed for screenshot sharing — clean layout, all key data visible without scrolling or cropping
FR40: Player can share the session summary via the device's native share functionality
FR41: Player can play back a recorded session video with standard controls (play, pause, scrub)
FR42: Player can view a chronological list of all recorded sessions showing duration, thumbnail, and analysis status
FR43: Player can select an unanalyzed session from the list and trigger analysis
FR44: System persists session-level aggregated metrics across sessions
FR45: System computes cross-session trends for biomechanical metrics and on-table rates
FR46: System detects gaps in session history (breaks longer than a configurable threshold)
FR47: System contextualizes post-break sessions with appropriate messaging
FR48: System maintains baseline continuity across breaks — baselines are not reset
FR49: System retains all session history and progress data across app updates without data loss
FR50: System retains all session history and progress data across free-to-pro tier transitions
FR51: System withholds coaching tips until the player has accumulated 100+ strokes of a recognized type (trust ladder threshold)
FR52: System generates one coaching insight per session — either an observation or a tip, never more
FR53: System correlates changes in biomechanical metrics with changes in on-table rate to identify causal relationships
FR54: Coaching tips use forward-looking language patterns
FR55: System detects regression in previously improving metrics and surfaces re-entry coaching for returning users
FR56: System connects coaching for one stroke type to patterns observed in another when relevant correlations exist
FR57: Player can provide optional accuracy feedback (thumbs-up/thumbs-down) on observations and tips
FR58: System stores accuracy feedback signals for future coaching improvement (collect-only in MVP)
FR59: Player can use the app on a free tier with a configurable number of session analyses per month
FR60: System tracks free tier session usage and enforces the analysis limit
FR61: System checks tier status before starting analysis, never interrupts mid-analysis with a paywall
FR62: Player sees an upgrade screen displaying their personal progress data when the free tier limit is reached
FR63: Player can subscribe to the Pro tier ($7.99/mo or $49.99/yr) via in-app purchase
FR64: On upgrade, previously recorded unanalyzed sessions become available for player-initiated analysis
FR65: System caches subscription status locally for up to 7 days for offline use
FR66: System downgrades to free tier behavior after 7 days without subscription validation
FR67: System retains unanalyzed video files until the player explicitly deletes them
FR68: System requires network connectivity only for subscription purchase and validation
FR69: Player can access an app settings screen
FR70: Player can view storage space used and manage local video/session data
FR71: Player can delete all personal data from the device
FR72: System produces zero sounds, notifications, or visual interruptions while a recording session is active
FR73: System never sends push notifications for inactivity, marketing, or engagement purposes — only "analysis complete"
FR74: System never uploads video or analysis data to any external server without explicit player permission
FR75: System processes all ML inference and coaching logic on-device
FR76: System never displays gamification elements
FR77: Analysis pipeline stages execute sequentially — each stage depends on the prior stage's output
FR78: System provides App Store and Google Play compliant privacy disclosures and data safety declarations
FR79: Player sees estimated storage requirement before starting a recording session

### NonFunctional Requirements

NFR1: Post-session analysis of a 30-minute session completes within 15 minutes on mid-range devices
NFR2: Post-session analysis of a 30-minute session completes within 5 minutes on flagship devices
NFR3: Video recording maintains stable 30 FPS capture with no dropped frames
NFR4: MediaPipe pose estimation maintains 30+ FPS processing throughput in GPU mode
NFR5: UI remains responsive (< 100ms touch response) during background analysis
NFR6: Session summary screen loads within 2 seconds after analysis completes
NFR7: App launches to recording-ready state within 3 seconds
NFR8: Session history list loads within 1 second for up to 100 sessions
NFR9: Progress indicator updates at least every 5 seconds during analysis
NFR10: All session data stored in app-sandboxed storage, inaccessible to other apps
NFR11: No personally identifiable information transmitted off-device except subscription purchase receipt
NFR12: Video files excluded from device cloud backups by default
NFR13: "Delete all data" performs complete removal — no residual data
NFR14: App does not use device advertising identifiers for tracking
NFR15: Zero data loss during app updates — database migrations preserve 100% of historical data
NFR16: Analysis pipeline produces functionally equivalent results when same video analyzed twice
NFR17: Subscription cache operates correctly during network outages up to 7 days
NFR18: App recovers gracefully from unexpected termination — no corrupted database state
NFR19: Session data write operations are atomic
NFR20: Analysis of a 30-minute session targets ≤15% battery consumption on mid-range devices
NFR21: Recording a 60-minute session consumes no more than 20% battery
NFR22: App idle state consumes negligible battery
NFR23: Background analysis does not trigger system thermal warnings on mid-range devices
NFR24: Analysis metadata for 100 sessions consumes less than 50MB of storage
NFR25: App binary size does not exceed 100MB including bundled ML models
NFR26: Temporary processing artifacts cleaned up within 60 seconds of analysis completion
NFR27: Video storage estimation accuracy within ±10% of actual file size
NFR28: All text meets WCAG 2.1 AA contrast ratios (4.5:1 body, 3:1 large text)
NFR29: All interactive elements have minimum 44x44pt touch targets
NFR30: Screen reader compatibility (VoiceOver/TalkBack) for session summary, history, and navigation
NFR31: No information conveyed through color alone
NFR32: Adding a new stroke type requires only a new StrokeProfile configuration — no pipeline/coaching engine changes
NFR33: Minimum supported device floor: 4GB RAM, GPU-capable SoC, Android API 31+, iPhone 12+

### Additional Requirements

**From Architecture:**

- AR1: Project initialization using Very Good CLI v1.1.1 with specified customizations (collapse to 2 flavors, remove i18n, add GetIt/Drift/go_router/feature-based structure)
- AR2: Drift schema versioning with step-by-step migrations established before first table creation
- AR3: Two-isolate model: main isolate for MediaPipe inference + vision tasks, computation isolate for pure-Dart pipeline stages
- AR4: PipelineStage interface with StageResult (success/partial/failure) for all pipeline stages
- AR5: PipelineConfig (ML tuning) and AppConfig (business rules) as separate injectable classes
- AR6: freezed + json_serializable for all immutable data classes and sealed unions (BLoC events/states, entities, DTOs, Failures)
- AR7: StrokeProfile schema defining per-stroke-type metrics, ranges, and coaching rules
- AR8: 9-metric biomechanical catalog: Shoulder Rotation, Hip Rotation, Upper Arm Rotation Velocity, Elbow Angle at Contact, Wrist Velocity Peak, Swing Arc Angle, Contact Height, Follow-Through Height, Weight Transfer
- AR9: PoC Gate 1: MediaPipe landmark extraction validated on 2+ physical devices before pipeline development
- AR10: PoC Gate 2: Stroke segmentation accuracy >85% on test footage
- AR11: PoC Gate 3: Ball detection on-table rate accuracy ±15% vs. manual count
- AR12: TransferableTypedData for zero-copy inter-isolate data transfer
- AR13: DTO-to-domain entity mapping layer at isolate boundary (data/mappers/)
- AR14: Repository stream error handling: repositories catch and map errors to Either<Failure, T>
- AR15: Golden file testing for pipeline stages; integration tests for PipelineRunner
- AR16: Binary fixtures (.bin) for landmark test data, JSON for other fixtures
- AR17: AnalysisBloc scoped to GoRouter shell route as sole exception to one-BLoC-per-screen rule
- AR18: Beta hardcodes Pro tier to focus on pipeline validation
- AR19: ThemeExtension<AppSpacing> for spacing tokens registered on ThemeData

### UX Design Requirements

- UX-DR1: Implement The Analyst color system — seed #455A64 (slate blue), Material 3 dynamic scheme with 16 color roles + 7 semantic roles (delta positive/declining/neutral, confidence high/low, coach voice)
- UX-DR2: Implement dual-family typography — Source Serif 4 (subsetted to digits/symbols, <20KB) for metrics, DM Sans (400/500/600 weights, ~80KB) for UI text. google_fonts package with fallback to Roboto.
- UX-DR3: Implement AppSpacing ThemeExtension with 6 spacing tokens (xs:4dp, sm:8dp, md:16dp, lg:24dp, xl:32dp, xxl:48dp)
- UX-DR4: Build HeroMetric custom widget — single widget with MetricSize enum (large 56sp, medium 28sp, mini 18sp), Source Serif 4, all states (default, baseline building, unavailable)
- UX-DR5: Build DeltaBadge custom widget — 5 states (positive green, declining slate, neutral, baseline building, hidden), arrow glyphs as primary indicator
- UX-DR6: Build CoachingTipCard custom widget — 6 states (default with left border, hidden, building baseline with progress, return after break, partial data, degradation only)
- UX-DR7: Build MiniMetricCard custom widget — tonal elevation card, 3 states (default, low confidence, unavailable)
- UX-DR8: Build AnalysisProgressNarrator custom widget — consumes Stream<AnalysisStage> from BLoC, 6 stage text mappings + thermal throttled state, cancel option
- UX-DR9: Build SessionHistoryItem custom widget — 4 states (analyzed, analyzing, ready, saved), thumbnail via FadeInImage with generated JPEG
- UX-DR10: Build TrajectoryHeader custom widget — 3 states (default, insufficient data, return after break)
- UX-DR11: Build RecordButton custom widget — 3 states (initializing with pulse animation, ready, recording with stop icon)
- UX-DR12: Build QualityBadge custom widget — 4 variants (high/medium/low confidence, N/A)
- UX-DR13: Build NothingToReport screen — coach voice, actionable setup tips, video still accessible
- UX-DR14: Implement navigation architecture — no bottom nav, icon-button navigation between Record and Sessions, last-viewed screen restoration, >14-day break override to history
- UX-DR15: Implement route tree via go_router: /record, /sessions, /sessions/:id/summary, /sessions/:id/analysis (real route with auto-replace on completion)
- UX-DR16: Implement analysis cancellation flow — cancel returns session to unanalyzed state, video preserved
- UX-DR17: Implement notification permission request on first app-backgrounding during analysis (not during onboarding)
- UX-DR18: Implement "See all metrics" DraggableScrollableSheet (bottom sheet) — only visible when ≥6 of 9 metrics have data
- UX-DR19: Implement session thumbnail generation — generate once post-recording, store as JPEG, FadeInImage loading with placeholder
- UX-DR20: Implement crossfade transition (400ms) from analysis progress to session summary, with reduceMotion instant swap
- UX-DR21: Implement messaging voice patterns — no exclamation marks, no gamification language, technical terms translated, numbers always contextualized
- UX-DR22: Portrait-only orientation lock for MVP
- UX-DR23: Implement Semantics wrappers on all custom widgets with proper labels, MergeSemantics grouping on session summary
- UX-DR24: Test with textScaleFactor 2.0 — no overflow or truncation on critical elements

### FR Coverage Map

| FR | Epic | Description |
|----|------|-------------|
| FR1–7 | Epic 1 | Session recording |
| FR8–10, FR12 | Epic 1 | Onboarding & camera setup |
| FR11 | Epic 6 | Contextual setup tips (requires session history) |
| FR13 | Epic 4 | Trigger post-session analysis |
| FR14 | Epic 3 | Pose landmark extraction |
| FR15 | Epic 3 | Ball on/off table detection |
| FR16 | Epic 3 | Stroke classification (FH topspin, BH topspin, other) |
| FR17–19 | Epic 4 | Biomechanical metrics & on-table rate computation |
| FR20–22 | Epic 3 | On-device ML, hardware acceleration, background isolates |
| FR23–26 | Epic 4 | Background analysis, notification, progress, restart |
| FR27–33 | Epic 4 | Graceful degradation |
| FR34–40 | Epic 5 | Session summary & sharing (FR38 stubbed — raw count from analysis data, baseline computation deferred to Epic 6) |
| FR41–42 | Epic 2 | Video review & session history list |
| FR43 | Epic 4 | Trigger analysis from history |
| FR44–49 | Epic 6 | Cross-session data, trends, breaks, data integrity |
| FR49 | Epic 1 | Database migration mechanism (AR2); verified in Epic 8 |
| FR51–58 | Epic 6 | Coaching engine & feedback |
| FR59–66, FR68 | Epic 7 | Subscription & monetization |
| FR67 | Epic 2 | Retain unanalyzed videos |
| FR69–71 | Epic 2 | Settings & data management |
| FR72 | Epic 1 | No interruptions during recording |
| FR73–76, FR78 | Epic 8 | System constraints & privacy compliance |
| FR77 | Epic 3 | Sequential pipeline execution |
| FR79 | Epic 1 | Storage estimation before recording |

**Note:** FR5 ("player can record even when free tier limit is reached") is a constraint/acceptance criterion on Epic 7, not a standalone deliverable — recording has no tier awareness until subscription logic exists.

### NFR Coverage Map

| NFR | Epic | Rationale |
|-----|------|-----------|
| NFR1–2 | Epic 4 | Analysis time targets validated during full pipeline runs |
| NFR3 | Epic 1 | 30 FPS recording capture stability |
| NFR4 | Epic 3 | MediaPipe throughput in GPU mode |
| NFR5 | Epic 4 | UI responsiveness during background analysis |
| NFR6 | Epic 5 | Session summary load time |
| NFR7 | Epic 1 | App launch to recording-ready <3s |
| NFR8 | Epic 2 | Session history list load <1s |
| NFR9 | Epic 4 | Progress indicator update frequency |
| NFR10–12 | Epic 1 | App-sandboxed storage, no PII off-device, cloud backup opt-out (foundational) |
| NFR13 | Epic 2 | Complete data removal (FR71) |
| NFR14 | Epic 8 | No advertising identifiers |
| NFR15 | Epic 1 | Zero data loss migrations (AR2 mechanism) |
| NFR16 | Epic 3 | Reproducible analysis results |
| NFR17 | Epic 7 | Subscription cache during network outages |
| NFR18–19 | Epic 1 | Graceful termination recovery, atomic writes |
| NFR20 | Epic 4 | Analysis battery consumption target |
| NFR21 | Epic 1 | Recording battery consumption target |
| NFR22 | Epic 1 | Idle battery consumption |
| NFR23 | Epic 4 | No thermal warnings during analysis |
| NFR24 | Epic 4 | Metadata storage budget |
| NFR25 | Epic 3 | Binary size including ML models |
| NFR26 | Epic 4 | Temp artifact cleanup |
| NFR27 | Epic 1 | Storage estimation accuracy |
| NFR28–29 | Epic 1 | Contrast ratios & touch targets (foundational, enforced by design system) |
| NFR30 | Epic 5 | Screen reader compatibility for summary & history |
| NFR31 | Epic 1 | No color-only information (foundational) |
| NFR32 | Epic 3 | StrokeProfile extensibility |
| NFR33 | Epic 1 | Minimum device floor |

## Epic List

### Epic 1: Project Foundation & First Recording
Player can install the app, see camera setup guidance, and record a table tennis session.
**FRs covered:** FR1–10, FR12, FR49, FR72, FR79
**ARs covered:** AR1, AR2, AR6, AR19
**UX-DRs covered:** UX-DR1, UX-DR2, UX-DR3, UX-DR11, UX-DR14, UX-DR15, UX-DR22, UX-DR23
**NFRs as ACs:** NFR3, NFR7, NFR10–12, NFR15, NFR18–19, NFR21–22, NFR27–29, NFR31, NFR33

### Epic 2: Session Management & Video Review
Player can browse recorded sessions, watch video playback, and manage local storage.
**FRs covered:** FR41, FR42, FR67, FR69, FR70, FR71
**UX-DRs covered:** UX-DR9 (saved/ready states), UX-DR19
**NFRs as ACs:** NFR8, NFR13

### Epic 3: Pipeline Infrastructure & PoC Validation
System processes video through MediaPipe pose estimation, stroke segmentation, and ball detection. Three PoC gates validate technical feasibility before investing in downstream features.
**FRs covered:** FR14–16, FR20–22, FR77
**ARs covered:** AR3–5, AR7–12
**NFRs as ACs:** NFR4, NFR16, NFR25, NFR32
**PoC Gates:** Gate 1 (landmark extraction on 2+ devices), Gate 2 (stroke segmentation >85%), Gate 3 (on-table rate ±15%)
**Exit criteria:** All three PoC gates pass, or scope pivot documented.

### Epic 4: Analysis Experience & Graceful Degradation
Player triggers analysis on a recorded session, sees real-time progress, gets results even when conditions are imperfect. System computes biomechanical metrics and on-table rates with honest quality reporting.
**FRs covered:** FR13, FR17–19, FR23–33, FR43
**ARs covered:** AR13–16
**UX-DRs covered:** UX-DR8, UX-DR12, UX-DR13, UX-DR16, UX-DR17, UX-DR20
**NFRs as ACs:** NFR1–2, NFR5, NFR9, NFR20, NFR23–24, NFR26

### Epic 5: Session Summary & Sharing
Player views a session summary with stroke counts, on-table rates, biomechanical metrics, and an observation. Summary is screenshot-friendly and shareable.
**FRs covered:** FR34–40
**UX-DRs covered:** UX-DR4, UX-DR5 (partial — no cross-session trends), UX-DR6 (partial — default + building baseline states), UX-DR7, UX-DR18
**NFRs as ACs:** NFR6, NFR30
**Note:** FR38 (baseline progress) is stubbed — displays raw stroke count from analysis data (e.g., "37 forehand topspins tracked"). Full baseline computation and threshold logic deferred to Epic 6.

### Epic 6: Personal Baseline, Trends & Coaching
Player's practice is tracked over time with cross-session trends. After 100+ strokes of a type, the coaching engine provides one personalized insight per session.
**FRs covered:** FR11, FR44–49, FR51–58
**UX-DRs covered:** UX-DR5 (full — with trend arrows), UX-DR6 (full — all 6 states), UX-DR10, UX-DR21

### Epic 7: Subscription & Monetization
Free tier with configurable analysis limits. Pro tier via in-app purchase. Fair upgrade path showing personal progress data. Recording never gated by tier status.
**FRs covered:** FR50, FR59–66, FR68
**ARs covered:** AR17, AR18
**NFRs as ACs:** NFR17
**Constraint:** FR5 — subscription logic must never prevent recording.

### Epic 8: Store Readiness & Polish
App is polished, accessible, privacy-compliant, and ready for App Store / Google Play submission.
**FRs covered:** FR73–76, FR78
**UX-DRs covered:** UX-DR24
**NFRs as ACs:** NFR14
**Activities:** Privacy disclosures, IDFA/GAID compliance, FR49 migration path verification, accessibility audit (text scaling, screen reader), no-gamification audit, full NFR validation pass.

**Dependency flow:** Epic 1 → Epic 2 → Epic 3 → Epic 4 → Epic 5 → Epic 6 → Epic 7 → Epic 8
Each epic is standalone — delivers complete value for its domain without requiring future epics to function.

---

## Epic 1: Project Foundation & First Recording

Player can install the app, see camera setup guidance, and record a table tennis session. Includes VGV scaffolding, Drift schema initialization, design system foundation, camera integration, and the recording screen.

### Story 1.1: Project Scaffolding with Very Good CLI

As a developer,
I want a properly initialized Flutter project with production-grade tooling,
So that all subsequent development builds on a solid foundation.

**Acceptance Criteria:**

**Given** Very Good CLI v1.1.1 is installed
**When** `very_good create flutter_app pingpongbuddy` is run and customizations are applied
**Then** the project compiles and runs on both iOS and Android simulators
**And** only dev and prod build flavors exist (staging removed)
**And** internationalization setup is removed
**And** GetIt, Drift, go_router, freezed, and json_serializable dependencies are added and resolve
**And** the feature-based directory structure matches the architecture document's target project structure
**And** `very_good_analysis` lints pass with zero warnings
**And** GitHub Actions CI workflow runs tests, formatting checks, and analysis successfully

### Story 1.2: Design System Foundation

As a player,
I want a visually consistent and accessible app,
So that the experience feels polished and trustworthy from first launch.

**Acceptance Criteria:**

**Given** The Analyst color system is implemented
**When** the M3 dynamic scheme is generated from seed #455A64
**Then** all 16 standard color roles and 7 semantic roles (delta positive, delta declining, delta neutral, confidence high, confidence low, coach voice, surface elevated) are defined

**Given** typography is configured
**When** fonts are loaded
**Then** Source Serif 4 is subsetted to digits and symbols (<20KB) for metric display and DM Sans (400/500/600 weights, ~80KB) is used for UI text with Roboto fallback via google_fonts

**Given** the AppSpacing ThemeExtension is registered on ThemeData
**When** spacing is consumed via `Theme.of(context).extension<AppSpacing>()`
**Then** 6 tokens are available: xs (4dp), sm (8dp), md (16dp), lg (24dp), xl (32dp), xxl (48dp)

**Given** any text element on screen
**When** contrast ratio is measured
**Then** it meets WCAG 2.1 AA (4.5:1 body text, 3:1 large text)

**Given** any interactive element
**When** its touch target is measured
**Then** it is at least 44x44pt

**Given** any status indicator using color
**When** it is evaluated
**Then** a supplementary glyph or text label is also present

### Story 1.3: Database Foundation & Migration Infrastructure

As a developer,
I want Drift database tables with versioned schema migrations,
So that the app can evolve its data model without ever losing player data.

**Acceptance Criteria:**

**Given** Drift is configured
**When** the sessions table is created
**Then** it stores session metadata (id, timestamp, duration, video path, analysis status, thumbnail path)

**Given** any schema change
**When** a migration is applied
**Then** it follows step-by-step versioned migration with explicit version numbers and migration hooks

**Given** a previous database version
**When** the app updates
**Then** 100% of historical session data is preserved

**Given** unexpected app termination
**When** the app restarts
**Then** no corrupted database state or orphaned temp files exist

**Given** a session data write operation
**When** it executes
**Then** it is atomic — partial writes do not corrupt existing data

**Given** the target device
**When** minimum device floor is checked
**Then** it supports 4GB RAM, GPU-capable SoC, Android API 31+, iPhone 12+

### Story 1.4: App Shell & Navigation

As a player,
I want to navigate between recording and sessions seamlessly,
So that I can quickly access the features I need.

**Acceptance Criteria:**

**Given** go_router is configured
**When** routes are defined
**Then** /record and /sessions routes exist and navigation works between them

**Given** the recording screen
**When** the player taps the sessions icon button
**Then** the session history screen is displayed

**Given** the session history screen
**When** the player taps the record icon button
**Then** the recording screen is displayed

**Given** a fresh install with no sessions
**When** the app launches
**Then** it opens to the recording screen

**Given** the device orientation
**When** the device is rotated
**Then** the app remains locked to portrait mode

**Given** the app is launched (after first-use onboarding)
**When** time to recording-ready is measured
**Then** it is within 3 seconds

### Story 1.5: Camera Setup & Onboarding

As a player,
I want to understand how to position my phone for optimal recording,
So that my sessions produce the best possible analysis data.

**Acceptance Criteria:**

**Given** a first-time user opens the app
**When** the onboarding screen is displayed
**Then** a static camera setup guide explains optimal phone positioning (height, distance, angle)

**Given** the setup guide is shown
**When** the player taps skip or dismiss
**Then** they proceed directly to the recording screen

**Given** camera permission is needed
**When** the permission is requested
**Then** a plain-language explanation is shown and the request is just-in-time (not at app launch)

**Given** storage permission is needed
**When** the permission is requested
**Then** a plain-language explanation is shown and the request is just-in-time

**Given** the full onboarding flow
**When** time from first app launch to recording-ready is measured
**Then** it is within 60 seconds

### Story 1.6: Video Recording Session

As a player,
I want to record my table tennis practice session with a single tap,
So that I have video footage available for later analysis.

**Acceptance Criteria:**

**Given** the recording screen is ready
**When** the player taps the RecordButton
**Then** video recording starts immediately (single tap)
**And** the RecordButton transitions to the recording state showing a stop icon

**Given** recording is active
**When** the player taps the stop button
**Then** recording stops and the video file is retained on device as standard H.264 MP4

**Given** recording is active
**When** the player backgrounds the app or interacts with on-screen elements
**Then** recording continues uninterrupted

**Given** recording is active
**When** system audio and notification state is checked
**Then** zero sounds, notifications, or visual interruptions are produced

**Given** no account exists
**When** the player records
**Then** recording works without sign-in or account creation

**Given** no internet connection
**When** the player records
**Then** recording works fully offline

**Given** the RecordButton widget
**When** the camera is initializing
**Then** it shows the initializing state with a pulsing animation

**Given** the video file after recording
**When** storage location is checked
**Then** it is in app-sandboxed storage inaccessible to other apps
**And** it is excluded from device cloud backups by default

**Given** a 60-minute recording session
**When** battery consumption is measured
**Then** it does not exceed 20%

**Given** the camera capture
**When** FPS is measured
**Then** it maintains stable 30 FPS with no dropped frames

### Story 1.7: Storage Estimation & Idle Efficiency

As a player,
I want to see how much storage a recording will use before I start,
So that I can manage my device space proactively.

**Acceptance Criteria:**

**Given** the recording screen
**When** displayed before recording starts
**Then** an estimated storage requirement is shown (based on expected duration)

**Given** the storage estimation
**When** compared to actual recorded file size
**Then** accuracy is within ±10%

**Given** the app is idle (not recording, not analyzing)
**When** battery consumption is measured
**Then** it is negligible (no background processing)

---

## Epic 2: Session Management & Video Review

Player can browse recorded sessions, watch video playback, and manage local storage. Sessions display as "saved" or "ready" — analysis states are added in Epic 4.

### Story 2.1: Session History Screen

As a player,
I want to view a chronological list of all my recorded sessions,
So that I can find and select any past session.

**Acceptance Criteria:**

**Given** one or more sessions exist
**When** the player navigates to /sessions
**Then** a chronological list is displayed with duration and analysis status for each session

**Given** the session list contains up to 100 sessions
**When** load time is measured
**Then** it loads within 1 second

**Given** no sessions exist
**When** the player views the session history screen
**Then** an appropriate empty state is displayed with guidance

**Given** an unanalyzed session
**When** it is displayed in the list
**Then** the video file is retained until the player explicitly deletes it

### Story 2.2: Session Thumbnails

As a player,
I want to see a visual thumbnail for each session,
So that I can quickly identify sessions in the list.

**Acceptance Criteria:**

**Given** a recording has completed
**When** the session is saved
**Then** a JPEG thumbnail is generated from the video and stored

**Given** the session list
**When** thumbnails are loading
**Then** FadeInImage displays a placeholder while the thumbnail loads asynchronously

**Given** a session in the list
**When** it is displayed
**Then** the SessionHistoryItem widget renders in the correct state (saved or ready)

### Story 2.3: Video Playback

As a player,
I want to play back a recorded session video,
So that I can visually review my practice.

**Acceptance Criteria:**

**Given** a session in the list
**When** the player selects it for playback
**Then** the video plays with standard controls (play, pause, scrub)

**Given** the video player
**When** the video finishes
**Then** playback controls remain accessible for replay or scrubbing

### Story 2.4: App Settings & Data Management

As a player,
I want to manage my app settings and storage usage,
So that I can control disk space and delete data when needed.

**Acceptance Criteria:**

**Given** the app
**When** the player navigates to settings
**Then** the settings screen is accessible

**Given** the settings screen
**When** storage usage is displayed
**Then** the player sees space used by videos and session data and can manage individual items

**Given** a specific session
**When** the player deletes it
**Then** the video file and associated metadata are removed

**Given** the settings screen
**When** the player selects "delete all data"
**Then** complete removal is performed — no residual data in caches, temp files, or database WAL

---

## Epic 3: Pipeline Infrastructure & PoC Validation

System processes video through MediaPipe pose estimation, stroke segmentation, and ball detection. Three PoC gates validate technical feasibility before investing in downstream features. Exit criteria: all gates pass, or scope pivot is documented.

### Story 3.1: Pipeline Stage Interface & Data Models

As a developer,
I want a consistent pipeline stage interface and shared data models,
So that all pipeline stages can be composed reliably and tested independently.

**Acceptance Criteria:**

**Given** the pipeline framework
**When** the PipelineStage interface is defined
**Then** it specifies a process method with typed input that produces StageResult (success, partial, or failure)

**Given** the StrokeProfile model
**When** it is defined for forehand topspin and backhand topspin
**Then** each profile contains per-stroke-type metrics, expected ranges, and coaching rules

**Given** the 9-metric biomechanical catalog
**When** metric definitions are created
**Then** they include: Shoulder Rotation, Hip Rotation, Upper Arm Rotation Velocity, Elbow Angle at Contact, Wrist Velocity Peak, Swing Arc Angle, Contact Height, Follow-Through Height, Weight Transfer

**Given** data models (LandmarkFrame, StrokeEvent, PipelineResult)
**When** they are created
**Then** they use freezed for immutability and json_serializable for serialization

**Given** PipelineConfig and AppConfig
**When** they are defined
**Then** they are separate injectable classes — PipelineConfig for ML tuning parameters, AppConfig for business rules

**Given** the pipeline
**When** stages execute
**Then** they execute sequentially with each stage depending on the prior stage's output

**Given** a new stroke type needs to be added
**When** only a new StrokeProfile configuration is created
**Then** no changes to the pipeline framework, analysis infrastructure, or coaching engine core logic are required

### Story 3.2: MediaPipe Integration & Landmark Extraction (PoC Gate 1)

As a developer,
I want MediaPipe Pose Landmarker integrated via platform channels,
So that the system can extract body pose data from recorded video frames.

**Acceptance Criteria:**

**Given** a recorded video
**When** MediaPipe processes frames
**Then** 33 body keypoints are extracted per frame with confidence scores

**Given** MediaPipe integration
**When** it executes
**Then** it runs in the main isolate via platform channels (pixel-dependent task)

**Given** device capabilities
**When** hardware acceleration is selected
**Then** the system automatically chooses optimal GPU/NPU/CPU

**Given** MediaPipe processing
**When** throughput is measured in GPU mode
**Then** it maintains 30+ FPS

**Given** all processing
**When** network dependency is checked
**Then** analysis runs entirely on-device with no cloud calls

**Given** landmark extraction
**When** the same video is processed twice
**Then** functionally equivalent results are produced

**Given** the app binary including bundled ML models
**When** size is measured
**Then** it does not exceed 100MB

**Given** test footage on 2+ physical devices (1 Android, 1 iOS)
**When** landmarks are visualized
**Then** they track the player's body during forehand/backhand strokes with no flipping or wild jitter
**And** **PoC Gate 1 passes** — proceed to pipeline stage development

### Story 3.3: Stroke Segmentation (PoC Gate 2)

As a developer,
I want the system to segment continuous landmark data into individual strokes and classify them,
So that metrics can be computed per stroke.

**Acceptance Criteria:**

**Given** landmark frame data from MediaPipe
**When** StrokeSegmenter processes it in the computation isolate
**Then** individual stroke events are identified with start, contact, and end boundaries

**Given** detected strokes
**When** they are classified
**Then** each stroke is placed into one of three buckets: forehand topspin, backhand topspin, or other

**Given** the computation isolate
**When** StrokeSegmenter runs
**Then** it uses pure Dart with no Flutter imports

**Given** inter-isolate data transfer
**When** landmark data is sent from main to computation isolate
**Then** TransferableTypedData is used for zero-copy transfer

**Given** pipeline processing
**When** it runs in background isolates
**Then** the UI remains responsive

**Given** test footage
**When** segmentation accuracy is measured
**Then** it exceeds 85% correct stroke identification with false positive rate <15%
**And** **PoC Gate 2 passes** — stroke segmentation validated

### Story 3.4: Ball Detection & On-Table Classification (PoC Gate 3)

As a developer,
I want the system to detect ball events and classify on-table vs. off-table,
So that on-table rate can be computed per stroke and per session.

**Acceptance Criteria:**

**Given** video frames
**When** BallDetector processes them via frame differencing
**Then** ball events are detected across the full session

**Given** ball events
**When** OnTableClassifier processes them
**Then** each event is classified as on-table or off-table

**Given** ball detection events
**When** they fall outside the defined table region
**Then** they are discarded

**Given** BallDetector and OnTableClassifier
**When** they execute
**Then** they run in the main isolate (vision tasks requiring pixel data)

**Given** test footage
**When** on-table rate is compared to manual count
**Then** accuracy is within ±15%
**And** **PoC Gate 3 passes** — ball detection validated

**Given** PoC Gate 3 failure
**When** frame differencing doesn't meet the accuracy threshold
**Then** the YOLO upgrade path is triggered and documented

---

## Epic 4: Analysis Experience & Graceful Degradation

Player triggers analysis on a recorded session, sees real-time progress, and gets results even when recording conditions are imperfect. System computes biomechanical metrics and on-table rates with honest quality reporting.

### Story 4.1: Analysis Orchestration & Progress

As a player,
I want to trigger analysis on a recorded session and see real-time progress,
So that I know the system is working and approximately how long to wait.

**Acceptance Criteria:**

**Given** a recorded session
**When** the player triggers analysis
**Then** the full pipeline runs sequentially through all stages

**Given** analysis is running
**When** the AnalysisProgressNarrator widget is displayed
**Then** it consumes Stream<AnalysisStage> from the BLoC with 6 stage text mappings plus a thermal throttled state
**And** a percentage-complete indicator is shown based on pipeline stage progression

**Given** progress updates
**When** the indicator refreshes
**Then** it updates at least every 5 seconds

**Given** background analysis
**When** the UI is interacted with
**Then** it remains responsive with <100ms touch response

**Given** a session in history during analysis
**When** it is displayed
**Then** the SessionHistoryItem shows the "Analyzing..." state with a progress indicator

**Given** analysis completes
**When** the result is ready
**Then** a 400ms crossfade transitions to the session summary (instant swap when reduceMotion is enabled)

### Story 4.2: Metrics Computation & Session Aggregation

As a player,
I want the system to compute detailed metrics from my session,
So that I get meaningful biomechanical data about my practice.

**Acceptance Criteria:**

**Given** stroke events from segmentation
**When** MetricsComputer processes them
**Then** biomechanical metrics are computed per stroke using the 9-metric catalog

**Given** all detected strokes in a session
**When** SessionAggregator runs
**Then** session-level on-table rate is computed

**Given** classified strokes
**When** per-type aggregation runs
**Then** on-table rate is computed separately for forehand topspin and backhand topspin

**Given** data crossing the isolate boundary
**When** pipeline results are received
**Then** DTO-to-domain entity mapping is applied at the boundary

**Given** repository operations
**When** errors occur
**Then** they are caught and mapped to Either<Failure, T>

**Given** a 30-minute session on a mid-range device
**When** total analysis time is measured
**Then** it completes within 15 minutes

**Given** a 30-minute session on a flagship device
**When** total analysis time is measured
**Then** it completes within 5 minutes

**Given** a 30-minute session on a mid-range device
**When** battery consumption is measured
**Then** it is ≤15%

**Given** analysis on a mid-range device at room temperature
**When** thermal state is checked
**Then** no system thermal warnings are triggered

**Given** analysis metadata for 100 sessions
**When** storage is measured
**Then** it consumes less than 50MB

### Story 4.3: Graceful Degradation & Quality Reporting

As a player,
I want the system to handle imperfect conditions honestly,
So that I always understand what the data represents and never see misleading results.

**Acceptance Criteria:**

**Given** pose detection per frame
**When** confidence is evaluated
**Then** confidence scores are assigned with configurable thresholds

**Given** frames with confidence below the threshold
**When** the pipeline processes them
**Then** they are dropped from analysis

**Given** multiple people in the camera frame
**When** player isolation is attempted
**Then** best-effort single-player isolation uses position consistency; quality degrades proportionally with visible people

**Given** ball detection events outside the table region
**When** they are evaluated
**Then** they are discarded

**Given** a session with zero valid frames
**When** the result is displayed
**Then** an explanatory message with setup tips is shown — never empty or nonsensical data (NothingToReport screen)

**Given** a session analyzed with reduced visibility
**When** the result is displayed
**Then** quality is reported honestly (e.g., "observations based on 70% of detected strokes") via the QualityBadge

**Given** low observation confidence
**When** coaching tips would normally be generated
**Then** they are withheld entirely

**Given** pipeline test fixtures
**When** golden file tests run
**Then** output matches expected results for known inputs

**Given** landmark test data
**When** fixtures are loaded
**Then** binary fixtures (.bin) are used for landmarks; JSON for other fixtures

### Story 4.4: Background Analysis & Notifications

As a player,
I want analysis to keep running when I leave the app and get notified when it finishes,
So that I don't have to keep the app open during the wait.

**Acceptance Criteria:**

**Given** analysis is running
**When** the player backgrounds the app
**Then** processing continues

**Given** analysis completes while the app is backgrounded
**When** the result is ready
**Then** a local notification is sent to the player

**Given** notification permission has not been granted
**When** the player first backgrounds the app during analysis
**Then** notification permission is requested at that moment (not during onboarding or at app launch)

**Given** notification behavior
**When** notification types are audited
**Then** only "analysis complete" notifications exist — never inactivity, marketing, or engagement

**Given** analysis completion
**When** temporary processing artifacts are checked
**Then** they are cleaned up within 60 seconds

### Story 4.5: Analysis Cancellation & Recovery

As a player,
I want to cancel a running analysis or restart it after a crash,
So that I'm never stuck and my video is always safe.

**Acceptance Criteria:**

**Given** analysis is in progress
**When** the player taps cancel on the progress screen
**Then** analysis stops and the session returns to the unanalyzed state with the video preserved

**Given** the app is killed mid-analysis
**When** the app restarts
**Then** the recorded video is preserved and analysis can be restarted from scratch

**Given** an unanalyzed session in the history list
**When** the player selects it
**Then** they can trigger analysis on it

**Given** the analysis progress screen
**When** thermal throttling is detected
**Then** the AnalysisProgressNarrator shows the "thermal throttled" state with adjusted messaging

---

## Epic 5: Session Summary & Sharing

Player views a session summary with stroke counts, on-table rates, biomechanical metrics, and an observation. The summary is screenshot-friendly and shareable. Baseline progress is stubbed (raw count, not computed trend).

### Story 5.1: Session Summary Screen

As a player,
I want to see a summary of my analyzed session with key metrics and an observation,
So that I understand how my practice went at a glance.

**Acceptance Criteria:**

**Given** analysis has completed for a session
**When** the player navigates to /sessions/:id/summary
**Then** the session summary screen is displayed

**Given** the summary
**When** stroke data is shown
**Then** total stroke count and count per recognized type (forehand topspin, backhand topspin) are displayed

**Given** the summary
**When** on-table rates are shown
**Then** session on-table rate and per-type on-table rates are displayed

**Given** the summary
**When** the HeroMetric widget displays the primary metric
**Then** it uses Source Serif 4 at the correct MetricSize with appropriate state (default, baseline building, or unavailable)

**Given** the summary
**When** a text observation is shown
**Then** it describes what the system detected in the session

**Given** the summary
**When** the CoachingTipCard displays the observation
**Then** it uses the default state with left-border accent or the "building baseline" state showing progress count

**Given** a pre-threshold session (fewer than 100 strokes of a type)
**When** baseline progress is displayed
**Then** it shows the raw stroke count from analysis data (e.g., "37 forehand topspins tracked — building your baseline") — full baseline computation deferred to Epic 6

**Given** the summary screen
**When** load time is measured after analysis completes
**Then** it loads within 2 seconds

**Given** a screen reader (VoiceOver/TalkBack)
**When** the summary is read
**Then** all content is announced correctly with MergeSemantics grouping

### Story 5.2: Expanded Metrics View

As a player,
I want to see all available biomechanical metrics for my session,
So that I can dive deeper into my performance data.

**Acceptance Criteria:**

**Given** the session summary
**When** 6 or more of the 9 metrics have data
**Then** a "See all metrics" link appears below the 3-up MiniMetricCard row

**Given** the "See all metrics" link
**When** the player taps it
**Then** a DraggableScrollableSheet (bottom sheet) opens displaying all available metrics

**Given** fewer than 6 metrics have data
**When** the summary is displayed
**Then** the "See all metrics" link is hidden

**Given** the MiniMetricCard widget
**When** a metric is displayed
**Then** it renders in the correct state (default, low confidence, or unavailable)

### Story 5.3: Session Summary Sharing

As a player,
I want to share my session summary,
So that I can show friends and coaches my progress.

**Acceptance Criteria:**

**Given** the session summary layout
**When** it is evaluated for screenshot readiness
**Then** all key data is visible without scrolling or cropping

**Given** the session summary
**When** the player taps share
**Then** the device's native share functionality is triggered with the summary as an image

---

## Epic 6: Personal Baseline, Trends & Coaching

Player's practice is tracked over time with cross-session trends. After 100+ strokes of a recognized type, the coaching engine provides one personalized insight per session based on the player's own data.

### Story 6.1: Session Metric Persistence & Cross-Session Trends

As a player,
I want my metrics saved and trends computed across sessions,
So that I can see how I'm improving over time.

**Acceptance Criteria:**

**Given** an analyzed session
**When** metrics are persisted
**Then** session-level aggregated metrics (stroke counts, on-table rates, biomechanical averages) are stored in the database

**Given** multiple analyzed sessions
**When** trends are computed
**Then** cross-session trends for biomechanical metrics and on-table rates are available

### Story 6.2: Break Detection & Baseline Continuity

As a player,
I want the app to understand my practice gaps and not judge me for breaks,
So that returning to practice feels encouraging.

**Acceptance Criteria:**

**Given** session timestamps
**When** a gap exceeds the configurable threshold
**Then** the system detects the break

**Given** a post-break session
**When** the summary is displayed
**Then** appropriate messaging contextualizes it (e.g., "your last session was 21 days ago — this is normal after a break")

**Given** a break in session history
**When** baselines are computed
**Then** they are not reset — breaks are incorporated as data points

**Given** a break longer than 14 days
**When** the app opens
**Then** it overrides last-viewed restoration and opens to the session history screen

### Story 6.3: Coaching Engine & Trust Ladder

As a player,
I want personalized coaching insights after the system has enough data,
So that I get advice I can trust based on my own patterns.

**Acceptance Criteria:**

**Given** fewer than 100 strokes of a type across all sessions
**When** the session summary is generated
**Then** coaching tips are withheld for that type

**Given** 100+ strokes of a type
**When** the session summary is generated
**Then** exactly one coaching insight is produced — either an observation or a tip, never more

**Given** coaching analysis
**When** metric changes are evaluated
**Then** correlations between biomechanical metrics and on-table rate are identified

**Given** coaching output text
**When** language is evaluated
**Then** tips use forward-looking patterns (e.g., "try increasing rotation" not "your rotation was too low")

**Given** a previously improving metric
**When** regression is detected
**Then** re-entry coaching is surfaced for returning users

**Given** multiple stroke types
**When** cross-type correlations exist
**Then** coaching connects patterns across types when relevant

**Given** coaching text
**When** messaging voice is evaluated
**Then** it follows quiet coach patterns — no exclamation marks, no gamification language, technical terms translated, numbers always contextualized

### Story 6.4: Coaching Feedback Collection

As a player,
I want to rate coaching observations with thumbs-up or thumbs-down,
So that the system can improve over time.

**Acceptance Criteria:**

**Given** a coaching observation or tip in the session summary
**When** the player views it
**Then** thumbs-up and thumbs-down feedback buttons are available

**Given** feedback is provided
**When** it is stored
**Then** the signal is persisted locally for future improvement (collect-only in MVP, no adaptive behavior)

### Story 6.5: Trend-Enhanced Summary Components

As a player,
I want my session summary to show cross-session trends and context,
So that each session feels connected to my overall progress.

**Acceptance Criteria:**

**Given** cross-session trend data
**When** DeltaBadge is displayed
**Then** it renders the full state set: positive (green + up arrow), declining (slate + down arrow), neutral, baseline building, hidden

**Given** coaching and session context
**When** CoachingTipCard is displayed
**Then** all 6 states are supported: default, hidden, building baseline, return after break, partial data, degradation only

**Given** session trajectory context
**When** TrajectoryHeader is displayed
**Then** it renders in the correct state: default, insufficient data, or return after break

**Given** prior session conditions
**When** the player starts a new session
**Then** contextual setup tips based on conditions detected in prior sessions are shown

---

## Epic 7: Subscription & Monetization

Free tier with configurable analysis limits. Pro tier via in-app purchase with a fair upgrade path showing the player's personal progress data. Recording is never gated by tier status.

### Story 7.1: Free Tier Analysis Limits

As a player,
I want to use the app for free with a limited number of analyses per month,
So that I can experience the value before committing to a subscription.

**Acceptance Criteria:**

**Given** the free tier
**When** the player uses the app
**Then** a system-configurable number of session analyses per month is allowed (not user-facing)

**Given** free tier usage
**When** analyses are performed
**Then** the system accurately tracks monthly usage against the configured limit

**Given** the analysis limit is reached
**When** the player attempts to analyze
**Then** tier status is checked before analysis starts — never interrupts mid-analysis

**Given** the free tier limit is reached
**When** the player attempts to record
**Then** recording always works regardless of analysis limit (FR5 constraint)

### Story 7.2: Upgrade Screen & In-App Purchase

As a player,
I want to see my personal progress when prompted to upgrade,
So that the upgrade decision is informed by my own results.

**Acceptance Criteria:**

**Given** the free tier limit is reached
**When** the upgrade screen is displayed
**Then** it shows the player's personal progress data (session count, trends, metrics highlights)

**Given** the upgrade screen
**When** the player chooses to subscribe
**Then** Pro tier is available at $7.99/mo or $49.99/yr via in-app purchase

**Given** the player upgrades
**When** previously recorded unanalyzed sessions exist
**Then** they become available for player-initiated analysis (player selects which to analyze)

**Given** all session data
**When** the player upgrades
**Then** all history and progress data is retained across the tier transition

**Given** subscription purchase
**When** network requirements are checked
**Then** connectivity is required only for purchase and validation — all other functionality works offline

### Story 7.3: Subscription Status & Offline Handling

As a player,
I want my subscription to work offline for a reasonable period,
So that I can use the app during practice without needing internet.

**Acceptance Criteria:**

**Given** an active subscription
**When** status is cached locally
**Then** it remains valid for up to 7 days without network validation

**Given** no subscription validation for 7+ days
**When** the cache expires
**Then** the system downgrades to free tier behavior

**Given** network outages lasting up to 7 days
**When** the subscription cache is evaluated
**Then** it operates correctly

**Given** the AnalysisBloc
**When** it is instantiated
**Then** it is scoped to a GoRouter shell route as the sole exception to one-BLoC-per-screen

**Given** beta builds
**When** tier status is checked
**Then** Pro tier is hardcoded to focus on pipeline validation

---

## Epic 8: Store Readiness & Polish

App is polished, accessible, privacy-compliant, and ready for App Store and Google Play submission. Final NFR validation pass.

### Story 8.1: Privacy Compliance & Store Declarations

As a player,
I want confidence that my data is private and the app meets store requirements,
So that I can trust the app with my practice footage.

**Acceptance Criteria:**

**Given** app data handling
**When** transmission behavior is audited
**Then** video and analysis data are never uploaded to any external server without explicit permission

**Given** ML processing
**When** inference and coaching execution is audited
**Then** all processing runs on-device

**Given** app content
**When** gamification elements are audited
**Then** none exist — no streaks, confetti, leaderboards, or badges

**Given** notification behavior
**When** notification types are audited
**Then** only "analysis complete" exists — no inactivity, marketing, or engagement notifications

**Given** app store requirements
**When** privacy disclosures are prepared
**Then** App Store and Google Play compliant data safety declarations are complete

**Given** advertising identifiers
**When** usage is audited
**Then** IDFA/GAID are not used for any tracking purpose

### Story 8.2: Accessibility Audit & Final Polish

As a player,
I want the app to be accessible to everyone,
So that no one is excluded from using it.

**Acceptance Criteria:**

**Given** all screens
**When** tested with textScaleFactor 2.0
**Then** no overflow or truncation occurs on critical elements

**Given** all custom widgets
**When** Semantics wrappers are audited
**Then** all have proper labels and MergeSemantics grouping where appropriate

**Given** the database migration mechanism from Epic 1
**When** migration paths are tested across all released schema versions
**Then** 100% of historical data is preserved

**Given** all NFR targets
**When** a final validation pass is run
**Then** all targets are met or documented exceptions with justification exist
