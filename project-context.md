# PingPongBuddy — Project Context

## Project Overview

**Project Name:** PingPongBuddy (working title)
**Type:** Mobile app — AI-powered table tennis swing/form analyzer
**Stage:** Pre-development — Market research, brainstorming, technical research, and product brief complete
**Date Started:** 2026-04-05

## Product Vision

A quiet, forward-looking AI coach that you set on a tripod and forget about while you play. It watches your body mechanics and whether the ball lands on the table, and when you're ready, gives you one thing to work on next. It's invisible during play and respects your focus, your phone, your data, and your wallet.

## Founder Context

The founder is a **former nationally ranked competitive table tennis player** with deep domain knowledge of stroke mechanics, coaching methodology, and the competitive-to-club player experience. This expertise directly informs stroke pattern definitions, coaching tip validation, and product credibility within the TT community. The founder can record reference footage for PoC validation and serve as expert evaluator for coaching tip quality.

## Target User

**Primary:** Casual table tennis players (1–3 years experience) wanting to become competitive. Age 20–40, play 2–4x/week at a club, no regular coaching access. Willing to pay $5–15/month for tools that demonstrably help.

**Secondary:** Informal coaches, club-level players seeking detailed analytics.

## Core Product Principles

### The Product Soul (from First Principles)
1. **The Feedback Gap** — The only thing the player is missing. The app is a mirror that talks back.
2. **The App Is Not the Destination** — Gives one tip, gets out of the way. Succeeds when you put the phone down.
3. **Positive Framing** — "You're doing well. Here's what's next." Never judgment, always opportunity.
4. **One Thing, Not Ten** — Drip-feed coaching. One actionable tip per session.
5. **Validates What the Body Feels** — On-table rate confirms the "aha moment" the player feels physically.
6. **Two-Layer Intelligence** — Body mechanics (pose estimation) + ball outcomes (on/off table), connected.

### The Eleven Commandments (Non-Negotiable Rules)
1. Playing in 60 seconds (no complex setup)
2. Your phone + a tripod, nothing else (no special equipment)
3. Invisible during play (no interruptions)
4. One tip in plain English (no data walls)
5. Forward-looking opportunity framing (no negativity)
6. Honest or silent (no fabrication when uncertain)
7. Adaptive and evolving (grows with the player)
8. Light phone footprint (on-device, battery-conscious)
9. Gracefully imperfect (handles bad conditions without crashing)
10. Privacy by default (video stays on phone)
11. Worth it from the free tier (real value before payment)

### UX Philosophy
- **GoPro Model** — Set up, press record, play entire session, review later
- **"The App Is Furniture"** — Zero screen time during play
- **Pull Data, Not Push** — Progress available when sought, never pushed
- **Anti-Gamification** — No confetti, streaks, or nagging. Quiet confidence.
- **Forward-Looking Coach** — Every insight is "here's what's next," never "here's what happened"

## MVP Feature Set

1. **GoPro recording** — set up on tripod, press record, play, review later
2. **Two-layer tracking** — body pose (MediaPipe) + ball on/off table detection
3. **One coaching tip per session** — plain English, forward-looking, positive
4. **On-table rate** — the success metric the player cares about
5. **On-device processing** — privacy, speed, no cloud dependency
6. **Cross-platform** — Android + iOS from day 1 via MediaPipe
7. **Session summary** — on-table rate + one tip. Minimal post-session UI.
8. **Smart segmentation** — auto-detect drills vs. matches vs. breaks

## Technical Direction (Validated via Technical Research — 2026-04-05)

- **Pose Estimation:** MediaPipe Pose Landmarker v0.10.33 (33 body landmarks, 30+ FPS on modern phones, ~3ms/frame GPU, ~13-16ms NPU, cross-platform iOS/Android). Peer-reviewed 2025 Nanjing study confirms extraction of TT-relevant biomechanical features from single camera with correlation coefficients of 0.50–0.71.
- **Ball Tracking:** Frame differencing + table region masking for MVP on/off table classification. Upgrade path to YOLOv7tiny (0.843 precision, 136 FPS on TT datasets) if accuracy insufficient.
- **Processing:** On-device post-session batch processing via background isolates. ~5-6 minutes to analyze a 30-minute session on mid-range phone (NPU path).
- **App Framework:** Flutter 3.20+ with BLoC state management, `flutter_pose_detection` package, Drift (SQLite), IsolateKit for background processing.
- **Coaching Intelligence:** Personal-baseline tracking (compare player to THEMSELVES over time, not a universal ideal) informed by coaching principles (which movements correlate with spin, power, consistency). Rule-based for MVP; on-device LLM or Claude API for v2.
- **Architecture:** Modular processor chain (FrameExtractor → PoseProcessor → StrokeSegmenter → BallDetector → MetricsComputer → CoachingEngine). Each stage independently replaceable and testable.
- **App Size:** ~30-45MB estimated. MVP cost: ~$325-625. Zero ongoing cloud infrastructure costs.

## Pricing Strategy

| Tier | Price | Features |
|------|-------|----------|
| Free | $0 | 3 analyses/month, basic form overlay, single stroke type |
| Pro | $7.99/mo or $49.99/yr | Unlimited analyses, all strokes, progress tracking, coaching tips |
| Coach | $19.99/mo | Pro + share with students, team management, multi-player comparison |

## Competitive Landscape

- **No direct competitor exists** for phone-camera body-form analysis in table tennis
- **Spinsight** — ball metrics (spin/speed) but not body, requires special balls, iPhone-only
- **SportsReflector** — body analysis across 20+ sports but no TT-specific intelligence (launched March 2026)
- **SwingVision** — gold standard for tennis ($10M+ funded, 200K+ MAU) but no ping pong support
- **Racketry** — smart paddle with stroke recognition but requires proprietary hardware
- **sportFX** — $8M funded, monocular 3D biomechanics, baseball-first but plans expansion

## Go-to-Market Strategy

1. **Community-first:** Build in Public on Reddit r/tabletennis, early access for YouTube creators (Tom Lodziak 274K subs, PingSkills 211K subs, EmRatThich)
2. **Club word-of-mouth:** One player improves → others follow. Referral program.
3. **App Store Optimization:** Target "table tennis training," "ping pong coach," "table tennis form analysis"

## Project Artifacts

| Artifact | Path | Description |
|----------|------|-------------|
| Market Research | `_bmad-output/research/market-ping-pong-swing-analysis-research-2026-04-05.md` | Comprehensive market analysis including customer segments, pain points, decision journey, competitive landscape, and strategic recommendations |
| Brainstorming Session | `_bmad-output/brainstorming/brainstorming-session-2026-04-05-01.md` | Product vision brainstorm using First Principles, Cross-Pollination, and Reverse Brainstorming — produced 17 named ideas, the Eleven Commandments, and the MVP feature set |
| Technical Research | `_bmad-output/planning-artifacts/research/technical-mediapipe-tt-swing-analysis-research-2026-04-05.md` | Comprehensive technical feasibility study covering MediaPipe pose estimation, ball tracking, Flutter architecture, integration patterns, implementation roadmap, risk assessment, and cost analysis. Verdict: GREEN LIGHT. |
| Product Brief | `_bmad-output/planning-artifacts/product-brief-pingpongbuddy.md` | Executive product brief — problem, solution, differentiation, users, scope, pricing, GTM, and vision. Includes personal-baseline coaching philosophy and founder domain expertise. |
| Product Brief Distillate | `_bmad-output/planning-artifacts/product-brief-pingpongbuddy-distillate.md` | Token-efficient detail pack for PRD creation — Eleven Commandments, rejected ideas, technical architecture, competitive intelligence, market data, UX philosophy, open questions, and implementation roadmap. |

## Next Steps (Priority Order)

1. ~~**Technical Research (TR)** — Can MediaPipe reliably detect TT-relevant body landmarks during forehand topspin from a phone on a tripod? Can ball on/off table tracking work from the same camera?~~ **COMPLETED 2026-04-05 — VERDICT: GREEN LIGHT**
2. ~~**Product Brief (CB)** — Formalize vision, MVP scope, target user, and success criteria into one document~~ **COMPLETED 2026-04-05**
3. **PRD Creation** — Use product brief + distillate to create detailed Product Requirements Document
4. **UX Design** — Plan UX patterns and design specifications
5. **Architecture Design** — Formalize technical architecture decisions
6. **Proof of Concept** — Record 20 forehands, run MediaPipe, evaluate raw data quality
7. **Epic/Story Creation** — Break requirements into implementable stories
8. **MVP Build** — Forehand topspin only, cross-platform, GoPro recording model

## BMAD Workflow Status

- [x] Market Research (completed 2026-04-05)
- [x] Brainstorming Session (completed 2026-04-05)
- [x] Technical Research (completed 2026-04-05)
- [x] Product Brief (completed 2026-04-05)
- [ ] PRD (Product Requirements Document)
- [ ] UX Design
- [ ] Architecture Design
- [ ] Epic/Story Creation
- [ ] Implementation
