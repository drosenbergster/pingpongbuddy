---
title: "Product Brief Distillate: PingPongBuddy"
type: llm-distillate
source: "product-brief-pingpongbuddy.md"
created: "2026-04-05"
purpose: "Token-efficient context for downstream PRD creation"
---

# PingPongBuddy — Product Brief Detail Pack

## Founder Domain Expertise

- Founder is a **former nationally ranked competitive table tennis player** — deep domain knowledge of stroke mechanics, coaching methodology, and what the aspiring competitor segment actually needs
- Founder can record reference footage for PoC validation and serve as expert evaluator for coaching tip quality
- This is a genuine founder-market fit advantage that general-purpose sports AI companies cannot replicate

## The Eleven Commandments (Non-Negotiable Design Rules)

Every product decision must pass this filter: "Does this violate any of the Eleven Commandments?"

1. **Playing in 60 seconds** — open → record → tripod; no account on first use; no calibration marathon
2. **Your phone + a tripod, nothing else** — any ball/paddle/table; Android + iOS
3. **Invisible during play** — zero sounds/notifications while recording; app is furniture
4. **One tip, plain English** — no jargon wall; data available if sought, never the default
5. **Forward-looking opportunity framing** — "you're doing well, here's what's next"; never judgment
6. **Honest or silent** — if uncertain, say so; never fabricate insights
7. **Adaptive and evolving** — tips change as the player improves; no eternal generic advice
8. **Light phone footprint** — on-device, battery-conscious; target ~80%+ battery after session
9. **Gracefully imperfect** — bad lighting, people in frame = OK; drop bad segments; never crash
10. **Your video stays on your phone** — on-device processing; nothing uploaded without explicit permission
11. **Worth it from the free tier** — free = real value; paid $7-10/mo; never feels like a ripoff

## Coaching Philosophy: Personal Baseline (Key Product Decision)

- **DO NOT compare against a universal "ideal form"** — every player's body is different (height, arm length, flexibility)
- **Track the player's OWN form as baseline** and detect CHANGE over time
- Use coaching principles (which movements correlate with spin, power, consistency) to understand WHAT changed
- Connect mechanical changes to outcome changes (on-table rate) to determine if the change was positive
- Reinforcement model: "Your shoulder rotation increased this session, and your on-table rate went up with it"
- Regression detection: "Your elbow angle dropped compared to last session — your on-table rate dipped too"
- This solves anthropometric diversity without requiring player-specific calibration
- Coaching literature and founder expertise inform WHAT to measure; the player's own history determines WHAT'S CHANGED

## Rejected Ideas (Do Not Re-Propose)

- **Gamification** (streaks, confetti, performative praise) — constitutionally rejected; "table is the celebration"
- **Real-time analysis during play** — violates "invisible during play" commandment; app is furniture
- **Complex onboarding / calibration** — violates 60-second rule
- **Data dashboards as primary UI** — players want one tip, not a spreadsheet; data available if sought
- **Push notifications / nagging** ("you haven't practiced") — violates pull-not-push philosophy
- **Social/community features in MVP** — deferred; not core to the coaching value prop
- **Cloud processing** — violates privacy commandment and adds infrastructure cost
- **Universal ideal form comparison** — replaced by personal-baseline tracking (see above)
- **Negative framing** ("your form is bad") — constitutionally rejected; always forward-looking opportunity

## Technical Architecture Summary

- **App Framework:** Flutter 3.20+ (cross-platform Android + iOS from single codebase)
- **State Management:** BLoC pattern + GetIt dependency injection
- **Pose Estimation:** MediaPipe Pose Landmarker v0.10.33 via `flutter_pose_detection` (v0.4.1) — 33 landmarks, GPU/NPU/CPU fallback, iOS 14+ and Android API 31+
- **Ball Detection MVP:** Frame differencing + static table region masking for on/off table classification
- **Ball Detection Upgrade:** YOLOv7tiny (0.843 precision, 136 FPS on TT datasets) if frame differencing insufficient
- **Database:** Drift (reactive SQLite, v2.32.1) — type-safe, reactive streams, isolate-friendly
- **Background Processing:** Dart Isolates via IsolateKit — progress tracking, cancellation, pooling
- **Processing Model:** Post-session batch (GoPro model) — NOT real-time during recording
- **Processing Time:** ~5-6 minutes for 30-minute session on mid-range phone (NPU path)
- **App Size:** ~30-45MB estimated
- **CI/CD:** GitHub Actions or Codemagic

### ML Pipeline Architecture (Modular Processor Chain)

```
VideoFile → FrameExtractor → PoseProcessor → StrokeSegmenter → BallDetector → 
OnTableClassifier → MetricsComputer → SessionAggregator → CoachingEngine → SessionSummary
```

Each processor is independently replaceable, testable, and upgradeable. Adding a new stroke type = adding a new StrokeProfile data class, not changing architecture.

### Performance Benchmarks (from technical research)

| Component | Performance |
|-----------|------------|
| Pose estimation (GPU) | ~3ms/frame (Galaxy S25 Ultra) |
| Pose estimation (NPU) | ~13-16ms/frame (Snapdragon QNN) |
| Pose estimation (CPU) | ~17ms/frame |
| YOLOv7tiny on TT datasets | 136 FPS, 0.843 precision |
| YOLOv8s on TT datasets | 128 FPS, 0.856 precision |

## Competitive Intelligence Deep-Dive

### Direct/Adjacent Competitors

| Product | What It Does | Limitation for Our User | Price |
|---------|-------------|------------------------|-------|
| **Spinsight** | Ball spin/speed tracking | Requires special dotted balls, iPhone-only, no body analysis | ~$60+ balls |
| **Racketry** | Smart paddle stroke recognition | Requires proprietary paddle, alpha stage, no body analysis | ~$200+ |
| **SwingVision** | Phone-based tennis body analysis | No table tennis support, $180/yr, iOS-primary | $14.99/mo |
| **SportsReflector** | Multi-sport body analysis (20+ sports) | Launched March 2026, no TT-specific intelligence, spread thin | $9.99/mo |
| **sportFX** | Monocular 3D biomechanics | Baseball-first, $8M funded, plans expansion but not TT yet | Enterprise |
| **PongFox/Pongbot** | TT robots + tracking | Position/accuracy focus, not technique/body form, hardware | $500+ |

### Key Competitive Insight

- Market share for phone-camera body-form analysis in table tennis: **0%** — the category doesn't exist yet
- Tennis model (SwingVision) validated at 200K+ MAU, $10M+ funded — proves the pattern works for racket sports
- First-mover window: ~6-12 months before SportsReflector, sportFX, or SwingVision could meaningfully enter TT
- Spinsight has ~3,000 users; SportsReflector ~24K across all sports

## Market Data Points

- US TT participation: 3M+ annually (Statista 2024)
- Global TT equipment market: $2.9-4.6B (2024-2025), growing to $4.1-7.8B by 2033
- AI sports coaching market: $4.2B (2025) → $25B by 2033, 28% CAGR
- Mobile sports coaching apps segment: $622.7M (2024)
- 70%+ of athletes under 25 prefer mobile-based feedback
- Coaching cost: $30-60/session vs. app at $7.99/mo

## User Insights (from market research)

- **#1 frustration:** "I don't know what I'm doing wrong" — the feedback gap
- **Aha moment:** When the player tries the suggested adjustment and the ball goes where they wanted — happens at the table, not in the app
- **Retention cliff:** Month 2-3 is critical; 3+ sessions in week 1 → 4-5x lower churn (fitness benchmark)
- **Decision journey:** Problem awareness → YouTube/forums → free tier trial → 2-3 sessions to prove value → paid conversion
- **First-session experience is make-or-break** for conversion
- **Visual > verbal feedback** — players value seeing what they're doing wrong more than being told
- **Community matters:** Club word-of-mouth is highest conversion channel; one player improves → others follow

## UX Philosophy (from brainstorming)

- **GoPro model:** One press, then zero interaction until review
- **"The app is furniture"** — optimize for zero screen time at the table
- **Anti-gamification:** No streaks, confetti, performative praise; table is the celebration
- **Pull, not push:** Progress available when curious; no nagging
- **Forward-looking coach:** Every insight is "what's next," never "here's what happened"
- **"The app succeeds when you put the phone down"**
- **"The aha moment doesn't happen in the app — it happens at the table, in the player's body"**

## Pricing Strategy Details

- Sweet spot validated at $5-15/mo across TT community research
- $180/yr (SwingVision price) alienates broad TT audience
- Annual discount: 40-50% off for committed users ($49.99/yr vs $95.88 monthly)
- Free tier MUST deliver real aha moment — 3 analyses/month is enough
- Paywall after first proven value, not before
- Coach tier ($19.99/mo) is v2.0 — NOT in MVP

## Go-to-Market Details

- **YouTube creators:** Tom Lodziak (274K subs), PingSkills (211K), EmRatThich — early access program
- **Reddit:** r/tabletennis — build in public, share PoC videos, engage form-check culture
- **Club word-of-mouth:** Referral program (invite friend, both get free Pro month)
- **ASO keywords:** "table tennis training," "ping pong coach," "table tennis form analysis" — low competition
- **No paid ads in launch plan** — community-first, earned media, organic growth
- **Target:** 1,000 downloads in 90 days via organic channels

## Open Questions (Unresolved)

- **Camera angle sensitivity:** How much does phone positioning angle affect landmark quality in real club conditions? PoC will determine acceptable angle range and inform setup guidance.
- **Ball detection accuracy floor:** Will frame differencing achieve 70%+ bounce detection in varied lighting? At what point do we upgrade to YOLO?
- **Stroke segmentation heuristic:** Will wrist velocity peaks reliably segment forehand topspins from other movements? May need combined heuristic (wrist speed + body posture classification).
- **Reference stroke patterns:** How to define "forehand topspin" StrokeProfile without imposing universal ideal? Personal-baseline approach helps, but initial detection still needs a pattern to recognize what IS a forehand topspin vs. other movements.
- **Club filming policies:** Do major club chains or leagues restrict phone recording? Need to survey actual policies.
- **Processing time tolerance:** How long will users actually wait for post-session analysis? Is 5-6 minutes acceptable? Need user testing.

## Proof of Concept Plan

- **Scope:** 20 forehand topspins recorded from phone on tripod at 3-4m (side angle)
- **Tools:** Python 3.10+ with MediaPipe, OpenCV, NumPy, matplotlib
- **Output:** Annotated video with skeleton overlay + CSV of landmarks + frame-differencing heatmap
- **Success criteria:** Shoulder/elbow/wrist landmarks visually track the stroke; joint angles show consistent patterns; frame differencing detects 70%+ of bounces
- **Timeline:** 1-2 weekends
- **Cost:** ~$0-30 (tripod if not owned)
- **Founder records their own strokes** as reference footage — leveraging competitive playing experience

## Implementation Roadmap

| Phase | Timeline | Deliverable |
|-------|----------|-------------|
| Phase 0: PoC | 1-2 weekends | Python script + annotated video + landmark CSV |
| Phase 1: Core Pipeline | Weeks 1-4 | Flutter app: record → extract → pose → overlay |
| Phase 2: Biomechanics | Weeks 5-7 | Joint angles, stroke segmentation, session metrics |
| Phase 3: Ball Detection | Weeks 6-8 | Frame differencing for on/off table |
| Phase 4: Coaching | Weeks 8-10 | Rule-based tips, personal baseline, session summary |
| Phase 5: Polish | Weeks 11-14 | Progress tracking, onboarding, beta testing |
| Phase 6: Launch | Weeks 15-16 | App store submission, community seeding |

## Cost Summary

- **PoC:** ~$0-30
- **MVP development (solo dev, 3-5 months):** ~$325-625 total
- **Monthly post-launch:** ~$8-57/mo (Apple dev program + optional CI/CD)
- **No cloud infrastructure costs** — on-device architecture
- **Revenue breakeven:** A handful of Pro subscribers covers all operating costs
