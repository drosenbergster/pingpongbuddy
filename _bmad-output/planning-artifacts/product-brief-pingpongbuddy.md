---
title: "Product Brief: PingPongBuddy"
status: "complete"
created: "2026-04-05"
updated: "2026-04-05"
inputs:
  - "_bmad-output/research/market-ping-pong-swing-analysis-research-2026-04-05.md"
  - "_bmad-output/brainstorming/brainstorming-session-2026-04-05-01.md"
  - "_bmad-output/planning-artifacts/research/technical-mediapipe-tt-swing-analysis-research-2026-04-05.md"
  - "project-context.md"
---

# Product Brief: PingPongBuddy

## Executive Summary

Every table tennis player hits a wall. They've watched the YouTube tutorials, drilled forehands for months, and they *know* something is off — but they can't see it. Coaching costs $30-60/session and barely exists outside major metros. Video alone doesn't help because most players lack the expertise to diagnose what they're watching. The result: millions of players stagnate, lose matches they feel they should win, and eventually lose motivation.

PingPongBuddy is a phone-based AI coach that does what no product on the market does today: it watches your body — not just the ball — and tells you in plain English what to work on next. You set your phone on a tripod, press record, and play. When you're done, the app analyzes your body mechanics *and* whether the ball landed on the table, connects the two, and gives you one coaching tip. That's it. No special equipment. No cloud uploads. No interruptions. Android and iOS from day one. Works in airplane mode.

The technology is validated. A peer-reviewed 2025 study confirmed that the same pose estimation framework PingPongBuddy uses (MediaPipe) extracts meaningful biomechanical data from table tennis forehand strokes with a single camera. The AI sports coaching market is projected to reach $25 billion by 2033. SwingVision proved the model for tennis (200K+ users, $10M+ funded). Golf has SwingAi. **Table tennis has nothing.** PingPongBuddy fills that gap — at a tenth of SwingVision's price, with a philosophy of restraint that respects the player's time, phone, data, and wallet.

## The Problem

Table tennis is the world's most accessible racket sport — 3M+ annual participants in the US alone, a global equipment market of $2.9-4.6 billion — yet the path from casual to competitive is uniquely blind.

- **The feedback gap.** How you think you play differs from how you actually play. Without a trained eye watching your body, you can't diagnose your own form. "I don't know what I'm doing wrong" is the most common frustration across table tennis communities.
- **Coaching scarcity.** $30-60/session where available, often not available at all. Most club players have never had a private lesson.
- **Tool mismatch.** Existing tech analyzes the *wrong object.* Spinsight tracks ball spin (requires special dotted balls, iPhone-only). Racketry tracks paddle stroke (requires proprietary hardware). Neither explains *why* your forehand lands in the net — which is a body mechanics problem.
- **Data without direction.** When products do offer analytics, it's dashboards and numbers. Players don't want a spreadsheet — they want to be told what to do next, in words they understand.

The cost of the status quo: players plateau at the 6-12 month mark. Month 2-3 is the critical retention cliff — the window where a tool like PingPongBuddy can break the stagnation cycle.

## The Solution

PingPongBuddy is a quiet, forward-looking AI coach. It works like a GoPro: set up your phone on a tripod, press record, play your entire session, and review later.

**Two-layer intelligence — the core differentiator:**
1. **Body layer.** Pose estimation extracts 33 body landmarks and computes joint angles, rotational velocity, and swing timing for every stroke.
2. **Outcome layer.** Ball detection classifies each shot as on-table or off-table — a concrete success rate that confirms what your body feels.

The magic is the connection between the two. When your on-table rate improves after adjusting your shoulder rotation, you don't just *believe* the tip worked — you *see* it in the numbers. The ball doesn't lie.

**Your form is the baseline, not a textbook.** PingPongBuddy doesn't compare you to an abstract ideal — it tracks *your* mechanics over time and connects changes in your movement to changes in your results. Using coaching principles (which movements correlate with spin, power, consistency), the app detects when a change in your form is producing better outcomes and reinforces it — or notices a regression and flags it. A 5'4" player and a 6'2" player have different ideal mechanics. The app doesn't pretend otherwise.

**One tip, not ten.** After analysis, PingPongBuddy identifies the single most impactful observation and delivers one forward-looking coaching tip in plain English: *"Your shoulder rotation increased this session — and your on-table rate went up with it. Keep pushing that rotation."*

**What it doesn't do:** interrupt you during play, require special equipment, upload your video to the cloud, gamify your experience with streaks and confetti, or overwhelm you with data. The app is invisible at the table and minimal when you return to the screen.

## What Makes This Different

| | PingPongBuddy | Spinsight | Racketry | SwingVision | SportsReflector |
|---|---|---|---|---|---|
| **What it analyzes** | Your body | Ball spin/speed | Paddle stroke | Body (tennis) | Body (20+ sports) |
| **Equipment needed** | Phone + tripod | Special balls + iPhone | Smart paddle | Phone + tripod | Phone + tripod |
| **TT-specific coaching** | Deep (forehand → all strokes) | Ball metrics only | Stroke classification | None (tennis only) | Generic across sports |
| **Platform** | Android + iOS | iPhone only | Proprietary hardware | iOS primarily | Android + iOS |
| **Price** | $7.99/mo | ~$60+ balls | ~$200+ paddle | $14.99/mo ($180/yr) | $9.99/mo |
| **Privacy** | On-device, no upload | Cloud processing | Bluetooth sync | Cloud processing | Cloud processing |

**The white space is clear:** no commercial product combines phone-camera body-form analysis with table tennis domain intelligence. PingPongBuddy is a new category, not a marginal improvement.

**Personal progress, not imposed standards.** Most sports analysis tools compare you to a model. PingPongBuddy compares you to *yourself* — tracking how your mechanics evolve session over session, and correlating those changes to your results. Coaching principles from the sport (rotation generates spin, weight transfer generates power) inform what to look for, but every player's form is their own baseline. This makes the coaching relevant to every body type and skill level.

**On-device by design, not by compromise.** All processing happens on the phone. No cloud accounts, no video uploads, no subscription to external AI services. This works in airplane mode, respects club connectivity issues, and makes a genuine privacy promise — your video never leaves your phone. Camera setup guidance recommends positioning the phone to face the table (not the room), and a clear privacy statement addresses filming in social settings.

**Technically validated.** A 2025 peer-reviewed study (Nanjing Sport Institute, *Frontiers in Sports and Active Living*) confirmed that MediaPipe extracts biomechanically meaningful data from single-camera table tennis forehand strokes, with strong correlation coefficients (0.50-0.71) for the exact body landmarks this app uses.

## Who This Serves

**Primary: The Aspiring Competitor.** Age 20-40. Plays 2-4 times per week at a club. 1-3 years of experience. Watches YouTube tutorials but has hit a plateau. No regular coaching access. Willing to pay $5-15/month for a tool that demonstrably helps. They want to beat their club rival, win their league division, and *feel* themselves getting better. The aha moment happens at the table — when they try the thing the app suggested and the ball goes where they wanted.

**Secondary: The Informal Coach.** Club veterans (35-60) who want to show students what they're doing differently. Even without the full Coach tier, sharing a session summary screen is enough to start a conversation.

## Success Criteria

| Signal | Metric | Target |
|--------|--------|--------|
| **Product works** | Coaching tips rated "helpful" by expert coach | 60%+ |
| **Users see value** | Free→Pro conversion within 30 days | 8-12% |
| **Users stay** | 30-day retention | >30% |
| **Technology delivers** | On-table rate accuracy vs. manual count | ±15% |
| **Growth engine works** | Downloads within 90 days of launch | 1,000+ |
| **Revenue validates** | Monthly recurring revenue within 6 months | $500+ MRR |

These targets are aspirational anchors based on category benchmarks (fitness/coaching apps) and will be refined with real usage data.

## Scope

**MVP (v1.0) — In:**
- Forehand topspin analysis (single stroke type)
- GoPro recording model (record → analyze post-session)
- Body pose estimation (33 landmarks) + ball on/off table classification
- One coaching tip per session (rule-based, forward-looking, positive)
- On-table success rate
- On-device processing, no cloud dependency
- Cross-platform: Android + iOS via Flutter
- Session summary screen (on-table rate + one tip)
- No account required for first use
- Free tier: 3 analyses/month

**Rapid stroke expansion (v1.1–1.3):** The analysis pipeline is stroke-agnostic — the same landmark math and personal-baseline tracking applies to any stroke. Once forehand topspin is validated, backhand topspin, forehand chop/loop, and serve follow with new stroke pattern definitions, not new architecture. This is the path to Pro tier value.

**MVP — Explicitly Out:**
- Real-time analysis during play
- LLM-powered coaching (v2.0)
- Scout mode, YouTube/pro comparison, training modes
- Progress journal / longitudinal narrative
- Coach tier / multi-player management
- Community features, social sharing, cloud sync

## Pricing

| Tier | Price | Ships In | Value |
|------|-------|----------|-------|
| **Free** | $0 | MVP | 3 analyses/month, form overlay, forehand topspin |
| **Pro** | $7.99/mo or $49.99/yr | MVP | Unlimited analyses, progress tracking, all stroke types (as added) |
| **Coach** | $19.99/mo | v2.0+ | Pro + share with students, multi-player comparison |

The free tier delivers real value — enough to experience the aha moment. Paid conversion happens after the player has proof the app works for them. "Worth it from the free tier" is a non-negotiable design rule.

## Go-to-Market

**Community-first, zero-budget launch:**
1. **Build in Public** on Reddit (r/tabletennis, r/tabletennis_tips) — share PoC videos, development progress, early results. The TT community is tight-knit and hungry for tools.
2. **YouTube creator partnerships** — early access for Tom Lodziak (274K subs), PingSkills (211K), EmRatThich. One "I tried this AI coaching app" video from a trusted creator is worth more than any ad spend.
3. **Club word-of-mouth** — one player improves at a club → others notice → organic spread. Referral program (invite a friend, both get a free Pro month).
4. **App Store Optimization** — target "table tennis training," "ping pong coach," "table tennis form analysis." Low competition keywords with high intent.

**The funnel:** Problem awareness (YouTube/Reddit) → free tier trial → 2-3 sessions to prove value → Pro conversion. First-session aha moment is make-or-break.

## Vision

If PingPongBuddy succeeds, it becomes **the SwingVision of table tennis** — the default tool competitive club players reach for when they want to improve. But unlike SwingVision, it stays accessible, stays quiet, and stays honest.

**Year 1:** Forehand topspin mastery. Prove the technology, build the community, earn trust one session at a time.

**Year 2:** All major strokes. LLM-powered coaching that knows your history. Coach tier drives B2B2C growth through clubs and academies. Progress journal shows players their own improvement arc.

**Year 3:** The platform every serious club player uses. Match analysis, training program generation, equipment brand partnerships. The "quiet coach" identity becomes the brand — trusted precisely because it never oversold.

**The moat is not the technology — it's the trust.** Pose estimation will become commodity. What won't be easy to replicate is deep table tennis domain knowledge, a community that believes in the product, club-level distribution, and a brand identity built on restraint. PingPongBuddy's defense against fast followers is the same thing that makes it a good product: it refuses to be anything other than genuinely helpful.

**Founder-market expertise.** PingPongBuddy is built by a former nationally ranked competitive player who understands table tennis mechanics from the inside — what good form feels like, how coaching tips land, and what the aspiring competitor actually needs to hear. This domain expertise directly informs stroke pattern definitions, coaching tip validation, and the product's credibility within the TT community. It's the kind of advantage a general-purpose sports AI company can't replicate by hiring a consultant.

The first-mover window is approximately 6-12 months. The next step is clear: record 20 forehand topspins and prove the technology works.
