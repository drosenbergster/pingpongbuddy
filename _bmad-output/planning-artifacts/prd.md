---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-02b-vision', 'step-02c-executive-summary', 'step-03-success', 'step-04-journeys', 'step-05-domain-skipped', 'step-06-innovation', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish']
inputDocuments:
  - '_bmad-output/planning-artifacts/product-brief-pingpongbuddy.md'
  - '_bmad-output/planning-artifacts/product-brief-pingpongbuddy-distillate.md'
  - '_bmad-output/planning-artifacts/research/technical-mediapipe-tt-swing-analysis-research-2026-04-05.md'
  - '_bmad-output/research/market-ping-pong-swing-analysis-research-2026-04-05.md'
  - '_bmad-output/brainstorming/brainstorming-session-2026-04-05-01.md'
  - 'project-context.md'
documentCounts:
  briefs: 2
  research: 2
  brainstorming: 1
  projectDocs: 0
workflowType: 'prd'
classification:
  projectType: 'mobile_app'
  projectTypeNote: 'passive-capture interaction model'
  domain: 'Sports Coaching Technology (AI-powered)'
  complexity: 'medium'
  complexityNote: 'architecturally ambitious, well-constrained by deliberate design decisions'
  projectContext: 'greenfield'
---

# Product Requirements Document - pingpongbuddy

**Author:** Fam
**Date:** 2026-04-05

## Executive Summary

Every table tennis player hits the same wall: they know something is off, but they can't see their own body. Coaching costs $30-60/session and barely exists outside major metros. Existing tools analyze the wrong thing — Spinsight tracks the ball (requires special balls, iPhone-only), Racketry tracks the paddle (requires proprietary hardware). Nobody analyzes the player's body, which is where technique problems actually live. Players plateau, lose matches they feel they should win, and eventually lose motivation.

PingPongBuddy fills this gap. It's a cross-platform mobile app that uses on-device pose estimation and ball detection to analyze table tennis body mechanics, correlate them with shot outcomes, and deliver plain-English observations and coaching tips — all from a phone on a tripod, with no cloud dependency, no special equipment, and no interruption to play.

The app operates on a GoPro model: set up phone on tripod, press record, play entire session, review later. Post-session, the app extracts 33 body landmarks via MediaPipe, detects ball on/off table events across all strokes, segments individual strokes, computes biomechanical metrics, and compares them against the player's own historical baseline.

Output is a session summary with objective observations (stroke count, session on-table rate, consistency metrics) and — once sufficient baseline data exists — one forward-looking coaching insight connecting a mechanical change to an outcome change.

The opportunity is large and the timing is urgent. US table tennis participation exceeds 3 million annually, with a global equipment market of $2.9-4.6 billion. The AI sports coaching market is projected to grow from $4.2 billion (2025) to $25 billion by 2033 at 28% CAGR. Phone-camera body-form analysis for table tennis has zero market share — the category doesn't exist as a product. SwingVision proved the model for tennis (200K+ MAU, $10M+ funded). SportsReflector launched in March 2026 covering 20+ sports broadly but without table tennis depth. The first-mover window is approximately 6-12 months.

The target user is the aspiring competitor: age 20-40, plays 2-4x/week at a club, 1-3 years experience, no regular coaching access. They're willing to pay $5-15/month for a tool that demonstrably helps.

Technology is validated. A peer-reviewed 2025 study (Nanjing Sport Institute, *Frontiers in Sports and Active Living*) confirmed MediaPipe extracts biomechanically meaningful data from single-camera table tennis forehand strokes under controlled conditions, with correlation coefficients of 0.50-0.71 for shoulder, elbow, wrist, and hip landmarks. The technical stack — Flutter + MediaPipe Pose Landmarker + Drift + BLoC — is production-proven and cross-platform. Estimated development cost for a solo developer: ~$325-625 over 4-6 months, with zero ongoing cloud infrastructure costs.

The product is informed by the founder's experience as a former nationally ranked competitive table tennis player — deep domain knowledge of stroke mechanics and coaching methodology that shapes what the app measures, how insights are framed, and what "good" looks like for each stroke type.

### What Makes This Special

**The only coaching app that learns you before it coaches you.** The trust ladder: early sessions deliver accurate observations and session on-table rate. After sufficient baseline data, the app graduates to coaching tips grounded in the player's own trajectory. This patience is a deliberate positioning advantage in a market skeptical of AI coaching accuracy. The app earns trust through accurate observation before it earns the right to coach.

**Two-layer intelligence with app-detected outcomes.** PingPongBuddy connects body mechanics (pose estimation) to ball outcomes (on/off table detection). When a player's shoulder rotation increases and their on-table rate climbs with it, the app surfaces that correlation. The causal link between what the body does and where the ball goes is computed, not self-reported. No competitor connects these two layers.

**Personal-baseline tracking, not universal ideal comparison.** The app compares each player to themselves over time, informed by coaching principles (which movements correlate with spin, power, consistency). A 5'4" player and a 6'2" player have different mechanics — the app doesn't impose a textbook ideal. It detects change, correlates it with outcomes, and reinforces what works for that individual.

**Restraint as product identity.** One insight per session — an observation or a tip, never a data wall. Forward-looking framing, never judgment. Invisible during play. Honest when uncertain. No gamification. The Eleven Commandments define what the product will never be — and that restraint is what earns trust.

## Design Philosophy & Product Voice

**The Quiet Coach.** This product has the personality of a great human coach — watches quietly, notices one thing, tells you simply, lets you go try it, and never makes it about themselves. Every screen, every interaction, every word of copy should feel like a coach's notebook, not a data dashboard.

**The aha moment happens at the table, not in the app.** The app succeeds when the player puts the phone down and plays better. Session summaries are designed for quick consumption — see the number, read the observation, nod, close. If the player lingers in the app, the design is wrong.

**The app validates what the body feels.** Players feel improvement before they can name it. The app confirms the feeling with data — "your on-table rate climbed from 58% to 67%." Feel it → see it confirmed → trust the next tip → implement → feel more. This confirmation loop is the retention engine.

**The app is furniture.** Zero screen time during play. The app is invisible while the player is at the table — like a good referee, you don't notice it doing its job well. Every UX decision gets tested: "does this pull the player's attention away from the table?"

## Project Classification

| Attribute | Value |
|-----------|-------|
| **Project Type** | Mobile App (passive-capture interaction model) |
| **Domain** | Sports Coaching Technology (AI-powered) |
| **Complexity** | Medium — architecturally ambitious (modular analysis pipeline, on-device processing, cross-platform), well-constrained by deliberate design decisions (post-session batch, rule-based coaching, no cloud infra) |
| **Project Context** | Greenfield — net-new product, no existing codebase |
| **Platforms** | Android + iOS via Flutter (cross-platform from day one) |
| **Processing Model** | On-device, post-session batch analysis |
| **MVP Scope** | Forehand and backhand topspin analysis with session-wide observation and on-table rate across all detected strokes |

## Success Criteria

### User Success

| Signal | Metric | Target | When |
|--------|--------|--------|------|
| **The app sees accurately** | Session on-table rate vs. manual count | ±15% agreement | PoC / Beta |
| **Observations feel real** | Users confirm observation accuracy ("yes, that sounds like my session") | 70%+ confirmation rate | Beta testing |
| **The trust ladder works** | Users who complete 3+ sessions in first month | >50% of active users | Post-launch month 1 |
| **Coaching tips land** | Tips rated "helpful" or "accurate" by expert coach review | 60%+ | Beta |
| **The aha moment happens** | Users who report learning something new about their form in session 1 | Qualitative — tracked via optional post-session feedback | Beta / Post-launch |
| **Players come back** | Users who return for a second session within 7 days | >40% | Post-launch |

The first-session aha moment is observation-driven: the player sees their session on-table rate and stroke count for the first time. The coaching aha comes later, after baseline is established. Both are success signals, but they happen on different timelines.

### Business Success (Aspirational — Post-MVP)

These are directional targets to be validated with real usage data, not MVP pass/fail criteria:

| Signal | Metric | Aspirational Target |
|--------|--------|---------------------|
| **Growth** | Downloads within 90 days of launch | 1,000+ |
| **Engagement** | Weekly active users at 90 days | 100+ |
| **Conversion** | Free→Pro conversion within 30 days | 8-12% |
| **Retention** | 30-day retention | >30% |
| **Revenue** | Monthly recurring revenue within 6 months | $500+ MRR |
| **Satisfaction** | App Store rating | 4.3+ |

### Technical Success

| Signal | Metric | Target | Gate |
|--------|--------|--------|------|
| **Pose estimation quality** | Shoulder/elbow/wrist landmarks visually track the stroke | No landmark flipping or wild jitter during swing phase | PoC go/no-go |
| **Joint angle accuracy** | Computed angles vs. manually measured ground truth | ±10° | PoC / Phase 2 |
| **On-table rate accuracy** | Automated vs. human-counted bounces | ±15% agreement | Phase 3 go/no-go |
| **Processing time** | 30-minute session analysis on mid-range phone | <15 minutes | Phase 5 |
| **Stroke classification** | Forehand vs. backhand vs. other classification accuracy | >80% for recognized strokes | Phase 2 |
| **App stability** | Crash rate during recording + analysis | <1% of sessions | Launch gate |
| **Session completion** | Started sessions that produce a summary | >80% | Launch gate |
| **Battery impact** | Battery consumption during post-session analysis | Phone at 70%+ after 30-min session analysis | Phase 5 |

### Measurable Outcomes

**MVP success is defined by three questions:**

1. **Does the pipeline work?** Pose estimation produces stable landmarks, ball detection achieves ±15% on-table rate accuracy, stroke classification distinguishes forehand/backhand/other at >80%. Validated through PoC and beta.

2. **Do observations feel valuable?** Users confirm accuracy, return for a second session within 7 days at >40%, and complete 3+ sessions in their first month at >50%. Validated through beta testing and post-launch analytics.

3. **Do coaching tips help?** Expert review rates 60%+ of tips as "helpful" or "accurate." Users who receive tips (post-baseline) report the tip matched what they experienced at the table. Validated through expert review and qualitative user feedback.

If the answer to all three is yes, the product works. Business metrics follow.

## Product Scope

### MVP — Minimum Viable Product

**In:**
- GoPro recording model (record → analyze post-session)
- Forehand and backhand topspin coaching (two recognized stroke types)
- Session-wide observation and on-table rate across all detected strokes
- Three-bucket stroke classification: forehand topspin, backhand topspin, other
- Body pose estimation (33 landmarks via MediaPipe)
- Ball on/off table detection (frame differencing; YOLO upgrade path if accuracy insufficient)
- Personal-baseline tracking — compare player to themselves over time
- Trust ladder: observations in early sessions, coaching tips after sufficient baseline
- Session summary: stroke count, session on-table rate, consistency metrics, one insight (observation or tip)
- On-device processing, no cloud dependency
- Cross-platform: Android + iOS via Flutter
- No account required for first use
- Free tier with tunable session count (start generous for trust ladder, refine based on user testing)
- Pro tier: $7.99/mo or $49.99/yr for unlimited analyses and progress tracking
- Camera setup guidance for optimal phone positioning

**Explicitly Out:**
- Real-time analysis during play
- LLM-powered coaching (v2.0)
- Scout mode, YouTube/pro comparison, training modes
- Progress journal / longitudinal narrative
- Coach tier / multi-player management
- Community features, social sharing, cloud sync
- Serve, push, chop, or other stroke types beyond forehand/backhand topspin
- Gamification of any kind

### Growth Features (Post-MVP)

- Additional stroke types: serve, forehand/backhand chop, push (each is a new StrokeProfile, not new architecture)
- LLM-powered coaching (on-device or Claude API) with access to player history
- Progress tracking visualization — "your on-table rate over 20 sessions"
- Coach tier ($19.99/mo) — share analysis with students, multi-player comparison
- YOLO-based ball detection upgrade if frame differencing accuracy insufficient
- Smart segmentation refinement — auto-detect drills vs. matches vs. breaks
- Confidence indicators on observations ("limited visibility this session")

### Vision (Future)

- Scout mode — point at another player to capture their mechanics
- "Scan a Pro" — extract reference models from YouTube footage
- Training modes — volume vs. precision practice structures
- Forward-looking progress journal that writes itself
- Match analysis with scoring integration
- Equipment brand partnerships
- Club/league institutional adoption
- AR glasses integration for real-time overlay (when hardware matures)

## User Journeys

### Journey 1: First Session — "Wait, My On-Table Rate Is Only 58%?"

**Persona:** Marcus, 28. Software engineer. Plays table tennis at his company's club twice a week during lunch. Started a year ago, watches Tom Lodziak videos religiously. His forehand topspin feels decent in practice but falls apart in matches. He's never had a coaching session — the nearest coach charges $50/hour and is a 40-minute drive. He saw PingPongBuddy mentioned in a Reddit thread on r/tabletennis and downloaded it.

**Opening Scene:** Marcus arrives at the club for his Tuesday lunch session. He props his phone on a cheap $15 tripod at the end of the table, about 3 meters away at a side angle. He opens PingPongBuddy for the first time. No account creation — just a brief camera setup guide ("Position phone at table height, 2-4 meters from the playing area, side angle"). He taps Record. Total setup: 45 seconds. He sets the phone down and forgets about it.

**Rising Action:** Marcus drills forehand topspins with his regular partner for 20 minutes, then they play two practice games. He's not thinking about the app. He's playing. After 35 minutes, they wrap up. Marcus picks up his phone, stops the recording, and taps "Analyze Session." A progress indicator appears: "Analyzing your session... 12%." He heads to the locker room, showers, grabs lunch. Seven minutes later, a notification: "Your session summary is ready."

**Climax:** Marcus opens the summary. He sees:
- **47 forehand topspins detected, 31 backhand topspins, 26 other strokes**
- **Session on-table rate: 58%**
- **Forehand topspin on-table rate: 62%**
- **Backhand topspin on-table rate: 49%**

He stares at the number. *58%.* He thought he was hitting closer to 75%. The backhand at 49% stings — basically a coin flip. He's never had a number for this before. He's never known. The observation reads: "You hit 104 total strokes this session. Your forehand topspin was your most consistent stroke at 62% on-table. Your backhand topspin landed on the table less than half the time."

No coaching tip yet — this is session 1. But Marcus doesn't need one. The number itself is the aha moment.

**Resolution:** Marcus takes a screenshot of the summary and texts it to his playing partner: "Bro, my backhand is literally a coin flip." The session summary is designed to be screenshot-worthy by default — clean layout, clear numbers, no cropping needed. He's already thinking about Thursday's session. He wants to see if the number changes.

**Requirements revealed:** First-use onboarding (no account, camera guide), recording UX (one-tap start/stop), post-session analysis with progress indicator and notification, session summary screen (stroke counts by type, on-table rates by type and overall), session summary designed for native sharing/screenshot from day one.

---

### Journey 2: Trust Ladder — "My Shoulder Rotation Is Doing What Now?"

**Persona:** Marcus again, three weeks later. He's completed 5 sessions. His on-table rates have been: 58%, 61%, 57%, 63%, 65%. He's noticed the forehand improving but isn't sure why.

**Opening Scene:** Marcus finishes session 6 and opens his summary. This time, something new appears below the observation.

**Rising Action:** The app has been silently building Marcus's personal baseline across 5 sessions — tracking his shoulder rotation angle, elbow angle at contact, wrist velocity, hip rotation, and follow-through arc for both forehand and backhand topspins. It's been computing the variance across sessions, correlating mechanical changes with on-table rate changes.

**Climax:** The session summary shows the familiar observations — 52 forehand topspins, 64% on-table rate. But underneath, for the first time, there's a coaching insight:

*"Your shoulder rotation has gradually increased over your last 3 sessions — and your forehand on-table rate has climbed with it (57% → 63% → 64%). Keep pushing that rotation. It's working."*

Marcus reads it twice. He *felt* something clicking in his forehand lately but couldn't name it. The app just named it. And it connected the mechanical change to the result change. He didn't just *feel* better — the ball is actually going on the table more. The app saw both.

**Resolution:** Thursday at the club, Marcus consciously focuses on shoulder rotation during his forehand drills. His session 7 summary: forehand on-table rate 69%. The tip was right. The reinforcement loop closes. Marcus is hooked — not on the app, but on the feeling of deliberate improvement. The app just showed him the path.

**Requirements revealed:** Personal-baseline persistence (session-over-session metric storage), cross-session trend computation, correlation engine (mechanical change → outcome change), coaching tip generation (rule-based, forward-looking, positive framing), trust ladder logic (withhold tips until baseline threshold met), progress data accessible on demand.

---

### Journey 3: Bad Conditions — "Lighting Was Tough Today"

**Persona:** Priya, 34. Plays at a community center with inconsistent fluorescent lighting and six tables packed close together. She's been using PingPongBuddy for two weeks (4 sessions). Today the lighting is particularly dim and the table next to hers has two players warming up, occasionally drifting into her camera's field of view.

**Opening Scene:** Priya sets up her tripod in the usual spot. The app's camera preview shows the table but the lighting is noticeably darker than her previous sessions. She taps Record and plays for 25 minutes.

**Rising Action:** During post-session analysis, the app encounters challenges. Pose landmark confidence scores are lower than usual on 30% of frames — the dim lighting reduces MediaPipe's accuracy. Two players from the adjacent table occasionally appear in frame, triggering brief false pose detections. Ball detection via frame differencing picks up motion from the neighboring table.

The app's pipeline handles this through established degradation protocols:
- Frames with landmark confidence below threshold are dropped from analysis (not included in metrics)
- False pose detections from non-target players are filtered by position consistency (the target player stays in a consistent zone relative to the table)
- Ball detection events outside the defined table region are discarded
- The session produces metrics from 70% of frames instead of the usual 90%+

**Climax:** Priya's session summary appears with a note she hasn't seen before:

*"Session analyzed with limited visibility — lighting conditions reduced data quality for some portions of your session. Observations are based on 70% of detected strokes."*

Below, her numbers: 38 forehand topspins detected (likely undercounted), session on-table rate: 61% (with a confidence note). No coaching tip this session — the app's confidence in its observations doesn't meet the threshold for generating coaching advice.

The summary is honest. It tells her what it saw, acknowledges what it couldn't see, and doesn't fabricate an insight it can't back up.

**Resolution:** Below the session summary, the app offers an adaptive setup tip based on the conditions it detected: *"Tip: Your session had reduced visibility from lighting. Next time, try positioning your phone where the overhead lights are brightest, or angle it so the light source is behind the camera."* Priya adjusts her tripod position next session to a better-lit angle and the data quality returns to normal. She never lost trust because the app never pretended to see more than it did — and it helped her fix the problem.

**Edge Cases Within This Journey:**

- **Zero valid frames:** If conditions are so bad that confidence drops below threshold on every frame, the app displays: "We couldn't analyze this session — visibility was too low for reliable data. Here are some tips for better positioning next time." No empty or nonsensical data is ever shown.
- **Mid-session lighting change:** Lights go off in part of the club, then come back. The pipeline handles segments of good data interspersed with bad — dropping the bad segments and computing metrics from valid portions only. The summary notes the reduced data set.
- **Camera bumped on tripod:** Camera angle shifts mid-recording. Pose landmarks jump discontinuously. The pipeline detects the disruption (sudden position shift of all landmarks), segments around it, and excludes the transition frames. If the new angle is still usable, analysis continues from the new position.

**Requirements revealed:** Landmark confidence scoring and frame filtering, multi-person detection and target player isolation, table region masking for ball detection, graceful degradation messaging ("limited visibility"), confidence thresholds for coaching tip generation (honest or silent), adaptive camera setup guidance based on detected conditions, zero-valid-frames handling, mid-session disruption detection, camera shift detection and recovery.

---

### Journey 4: Free-to-Pro — "I've Used My Free Sessions. Now What?"

**Persona:** Marcus again, one month in. He's completed 8 sessions and used up his free tier allocation for the month. His on-table rate has climbed from 58% to 67%. He's received three coaching tips so far — two about his forehand shoulder rotation and one about his backhand elbow angle. He arrives at the club on a Thursday and opens the app.

**Opening Scene:** Marcus taps Record. A screen appears: "You've used your free analyses for this month. Your session will still be recorded — upgrade to Pro to analyze it."

The app lets him record. It doesn't block the camera. It doesn't interrupt his session. He plays for 30 minutes as usual.

**Rising Action:** After the session, Marcus taps "Analyze Session." The app checks his tier status before starting analysis — never mid-analysis. The upgrade screen appears:

*"You've completed 8 sessions. Your forehand on-table rate has improved from 58% to 67%. Want to keep tracking your progress?"*

It shows his trajectory — the numbers he's watched climb over a month. Below: **Pro — $7.99/mo or $49.99/yr.** Unlimited analyses, progress tracking across all sessions, all coaching insights.

The app doesn't nag. It doesn't use urgency tactics or countdown timers. It shows him his own data — data he earned through practice — and offers to keep the relationship going.

**Climax:** Marcus thinks about it. $8/month versus $50 for a single coaching session. He's improved more in a month with the app than in the previous six months of watching YouTube. He subscribes.

**Resolution:** His session 9 analyzes immediately — no delay, seamless transition. The coaching insight: *"Your backhand elbow angle has started tightening — your backhand on-table rate dipped this session. Try keeping that elbow relaxed, like your forehand."* The app connected a regression in one stroke to a pattern it already solved in another. Marcus grins. Worth it.

**Requirements revealed:** Free tier session tracking and limit enforcement, recording allowed even when analysis is paywalled (never block the camera), tier status checked before analysis starts (never mid-analysis), upgrade screen with personal progress data (not generic marketing), subscription management (monthly/annual), seamless transition from free to pro (analyze queued session immediately upon upgrade), progress data retained across free/pro transition, video storage management policy for unanalyzed recordings (free users may have saved videos awaiting analysis).

---

### Journey 5: Returning After a Break — "Where Was I?"

**Persona:** Marcus, two months in. He subscribed to Pro, used the app consistently for 5 weeks (12 sessions total), and then went on a two-week vacation. He's back at the club for the first time in 21 days. His muscle memory feels rusty.

**Opening Scene:** Marcus opens PingPongBuddy for the first time in three weeks. The app doesn't nag — no "We missed you!" push notification, no guilt trip about his streak. It opens to the recording screen, ready to go. He sets up and records a 25-minute session.

**Rising Action:** Post-analysis, the session summary opens. His numbers tell the story: forehand on-table rate 59% (down from his peak of 69%), backhand at 46%. The rust is real. But the app doesn't frame this as failure.

**Climax:** The observation reads: *"Welcome back — your last session was 21 days ago. Your forehand on-table rate dropped to 59% today, compared to your 5-session average of 66%. This is normal after a break."*

The coaching insight: *"Your shoulder rotation — which had been improving steadily — dropped back this session. That rotation was your biggest forehand driver. Focus on getting it back and the on-table rate will follow."*

The app acknowledges the gap without judgment, contextualizes the regression as expected, and gives Marcus a clear re-entry point: the specific mechanic that was working before the break.

**Resolution:** Marcus feels oriented, not demoralized. He knows exactly what to focus on. Two sessions later, his forehand on-table rate is back to 64% and climbing. The baseline picks up where it left off, incorporating the break as a data point rather than a reset.

**Requirements revealed:** Gap detection in session history (identify breaks > N days), contextual messaging for returning users (acknowledge break without judgment), regression framing (normal after a break, not failure), baseline continuity across breaks (don't reset, incorporate), re-entry coaching (surface the most impactful mechanic from pre-break sessions), no push notifications for inactivity (pull-not-push philosophy).

---

### Journey-to-FR Traceability

| Journey | Capability Area | Functional Requirements |
|---------|----------------|------------------------|
| **J1: First Session** | Onboarding | FR3, FR8, FR9, FR10, FR12 |
| | Recording | FR1, FR2, FR4, FR6, FR7 |
| | Analysis | FR13, FR14, FR15, FR16, FR17, FR18, FR19, FR22, FR24, FR25 |
| | Summary & Sharing | FR34, FR35, FR36, FR37, FR39, FR40 |
| **J2: Trust Ladder** | Baseline & Progress | FR44, FR45, FR51 |
| | Coaching | FR52, FR53, FR54, FR56 |
| | Summary | FR38 (pre-threshold progress) |
| **J3: Bad Conditions** | Degradation | FR27, FR28, FR29, FR30, FR31, FR32, FR33 |
| | Setup Guidance | FR11 (contextual tips) |
| **J4: Free-to-Pro** | Recording (paywalled) | FR5 |
| | Monetization | FR59, FR60, FR61, FR62, FR63, FR64, FR65, FR66, FR67 |
| | Data Continuity | FR50 |
| **J5: Returning After Break** | Gap Detection | FR46, FR47, FR48 |
| | Coaching | FR55 (regression + re-entry) |
| | Data Integrity | FR49 |
| **All Journeys** | System Constraints | FR72, FR73, FR74, FR75, FR76, FR77, FR78 |
| | Video Review | FR41, FR42, FR43 |
| | Settings | FR69, FR70, FR71 |
| | Feedback | FR57, FR58 |

## Innovation & Novel Patterns

### Detected Innovation Areas

**1. Two-Layer Intelligence: Body Mechanics + Outcomes, Causally Connected**
No commercial product connects body mechanics to ball outcomes causally for any racket sport. SwingVision tracks shot placement and speed for tennis, but doesn't analyze the player's biomechanics (joint angles, rotation, swing path) or correlate specific mechanical changes to outcome changes. SwingVision knows *where* the ball went. PingPongBuddy knows *why* the ball went there, traced back to the player's body. This is a new category, not an incremental improvement. Critically, the app is valuable as an observation-only tool even without the correlation layer — session on-table rate, stroke counts, and consistency metrics don't require the correlation engine. The coaching tips are the top of the value pyramid, not the foundation. The foundation is observation accuracy.

**2. Personal-Baseline Coaching: Productizing an Established Methodology**
Sports coaches have always tracked individual athletes against their own baselines — this is established coaching methodology. The innovation is automating it for a consumer audience without a human coach in the loop. PingPongBuddy compares you to yourself over time, using coaching principles to interpret what changed and whether that change improved your results. This solves the anthropometric diversity problem (different body types have different optimal mechanics) without requiring player-specific calibration. No commercial product has productized this approach.

**3. Trust Ladder: Observations Before Coaching**
Every competitor leads with data, scores, or tips from session one. PingPongBuddy deliberately withholds coaching until it has built a personal baseline — earning trust through accurate observation before claiming the authority to coach. This is a UX innovation rooted in how human coaching relationships actually work: a good coach watches before they speak.

**4. Restraint as Product Architecture**
The Eleven Commandments function as an architectural constraint system — they're not aspirational guidelines but hard rules that shape every product decision. "Invisible during play," "honest or silent," "one insight not ten" — these constraints produce a fundamentally different product than the feature-maximization approach every competitor takes. The innovation is in what the product *refuses* to do.

### Market Context & Competitive Landscape

- **Market share for this category: 0%.** Phone-camera body-form analysis for table tennis doesn't exist as a commercial product.
- **SwingVision** validated the phone-camera sports analysis model for tennis ($10M+ funded, 200K+ MAU). It tracks shot placement and speed but does not analyze the player's biomechanics or correlate mechanical changes to outcome changes.
- **SportsReflector** (March 2026) offers pose estimation across 20+ sports but with generic coaching, no sport-specific intelligence, and no outcome-to-mechanics correlation.
- **The Nanjing 2025 study** validated the scientific basis but no one has productized it for consumers.
- **First-mover window: ~6-12 months** before generalist platforms could meaningfully enter with TT-specific depth.

### Validation Approach

| Innovation | Validation Method | Gate |
|-----------|------------------|------|
| Two-layer intelligence | PoC: Does frame differencing + pose estimation produce correlatable data from the same session? | PoC go/no-go |
| Personal-baseline model | Beta: Do players confirm that cross-session observations match their experience? Measured via optional accuracy feedback signal on session summary. | Beta user feedback |
| Trust ladder | Beta: Do users who hit the trust ladder threshold (session 5+) express higher satisfaction with tips? Qualitative feedback from 10-15 beta users. | Beta qualitative |
| Restraint architecture | Beta: Do users feel the app is "not enough" or "just right"? | Qualitative beta feedback |

**Feedback mechanism:** An optional, unobtrusive accuracy signal (thumbs-up/thumbs-down) on observations and tips in the session summary. Not a modal or popup — a quiet toggle the user can ignore. Collect-only for MVP (no adaptive behavior from the signal). Data feeds into the v2 LLM coaching upgrade to inform personalization.

### Risk Mitigation

| Innovation Risk | Likelihood | Mitigation |
|----------------|-----------|------------|
| Two-layer correlation is too noisy to be useful | Medium | Start with strongest correlations only (shoulder rotation ↔ on-table rate). Expand as confidence grows. Fall back to observation-only mode — the app delivers genuine value (on-table rate, stroke counts, consistency) without the correlation engine. Observation is the foundation; correlation is the premium layer. |
| Personal baseline needs too many sessions to be useful | Low-Medium | Lower the baseline threshold if needed (3 sessions instead of 5). Offer general coaching principles as "getting started" observations before baseline is established — clearly labeled as general, not personal. |
| Trust ladder frustrates impatient users | Medium | Session 1 observations (on-table rate, stroke counts) ARE the value — framed as the first aha moment. The trust ladder isn't withholding value, it's delivering different value at each stage. |
| Restraint feels like "not enough product" | Low | Market research shows players want one actionable insight, not a dashboard. If beta users consistently ask for more, the growth features (progress visualization, additional strokes) address it without violating the Commandments. |

## Mobile App Specific Requirements

### Platform Requirements

| Platform | Minimum Version | Rationale |
|----------|----------------|-----------|
| **Android** | API 31 (Android 12) | Minimum for `flutter_pose_detection` MediaPipe integration |
| **iOS** | 14.0+ | Minimum for CoreML/Metal-accelerated MediaPipe inference |
| **Flutter** | 3.20+ | Cross-platform framework, single codebase |

**Target devices:** Mid-range and above. The processing floor is a device that can run MediaPipe Pose Landmarker at ≥13ms/frame (NPU) or ≥17ms/frame (CPU). Approximate benchmark: Pixel 7a / iPhone 13 or newer.

**App size budget:** ≤100MB ceiling (Flutter framework ~15-20MB + MediaPipe models 6-26MB depending on variant + app code + assets). See NFR25 for binding requirement.

### Device Permissions

| Permission | Purpose | When Requested |
|-----------|---------|----------------|
| **Camera** | Video recording of table tennis sessions | First time user taps Record |
| **Storage / Photos** | Save recorded video files to device | First time user taps Record |
| **Notifications** | "Analysis complete" notification when processing finishes in background | After first analysis is triggered |

**Permission philosophy:** Request only when needed (just-in-time), never at app launch. Explain why each permission is needed in plain language before the OS prompt. No account or login required for first use — camera permission is the only gate to getting started.

### Offline Mode

PingPongBuddy is **offline-first by architecture, not by fallback.** The entire product works without internet:

- Video recording: local file storage
- Analysis pipeline: on-device ML inference (MediaPipe, frame differencing)
- Data persistence: local SQLite via Drift
- Coaching engine: rule-based, runs locally
- Session history and progress: local database queries

**Internet required for:** App Store updates, subscription validation (periodic, not per-session), future cloud-optional features (v2+).

**Subscription validation:** Cache subscription status locally for up to 7 days. After 7 days without connectivity to validate, downgrade to free tier behavior. This prevents abuse while being generous to users who play at clubs with no WiFi.

### Push Notification Strategy

**One notification type. Nothing else.**

| Notification | Trigger | Content |
|-------------|---------|---------|
| **Analysis complete** | Post-session processing finishes while app is backgrounded | "Your session summary is ready." |

**Explicitly prohibited notifications:**
- No "you haven't practiced in X days" reminders
- No marketing or upsell pushes
- No "new feature" announcements via push
- No social notifications
- No streak or gamification nudges

This aligns with the Eleven Commandments: invisible during play, pull-not-push, anti-gamification. The app never initiates contact except to say "the thing you asked me to do is done."

### Store Compliance

**Apple App Store:**
- On-device ML processing — strongest compliance posture for AI apps under guideline 5.1.2
- No personal data sent to third-party AI systems in MVP
- MediaPipe models bundled with app binary, not downloaded from external servers
- Privacy nutrition label: camera access, local storage only, no data collection
- If LLM coaching added in v2 (cloud-based): requires just-in-time opt-in consent screen naming the AI provider

**Google Play Store:**
- Data Safety section accurately reflects on-device-only processing
- No additional AI-specific requirements beyond standard data handling disclosures
- Standard Flutter build pipeline for submission

**Both stores:**
- App Review may require demo video showing the analysis workflow
- Description must not overclaim AI accuracy — "observations" and "insights" not "diagnoses" or "coaching certifications"
- In-app purchases (Pro subscription) follow standard StoreKit / Google Play Billing

### Implementation Considerations

**Hardware acceleration fallback chain:** GPU → NPU → CPU. The app must detect available hardware and select the optimal inference path automatically. If GPU is unavailable, fall back to NPU; if NPU unavailable, fall back to CPU. User is never aware of the selection — performance just varies.

**Background processing:** Analysis runs in Dart isolates via IsolateKit. The user can background the app during analysis — processing continues. If the app is killed by the OS mid-analysis, the recorded video is preserved and analysis can be restarted from scratch. Checkpoint-resume (resuming from the interrupted frame) is a future optimization, not MVP scope.

**Video storage:** Recorded sessions are saved as H.264 MP4 to device storage. The app must track video files and their analysis status. Unanalyzed videos (free tier limit reached, analysis interrupted) are retained until the user explicitly deletes them. The app never auto-deletes video without user consent.

**Battery:** Post-session analysis targets phone at 70%+ after processing a 30-minute session. NPU path preferred for long sessions (lower power consumption). GPU path available for users who prefer speed over battery.

**Data integrity:** Database schema migrations (via Drift) must preserve all historical session data. Data loss during an app update is a critical defect. Every session contributes to the personal-baseline model — losing sessions resets the trust ladder and degrades coaching quality.

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Approach:** Problem-Solving MVP — the minimum product that proves the feedback gap can be closed by a phone on a tripod. Not a platform play, not a revenue play. The question is: "Does this work, and do people care?"

**Resource Requirements:** Solo developer, 4-6 months (revised to reflect forehand + backhand scope), ~$325-625 development cost. No team dependencies. PoC validates the core technical risk before the main build begins.

**Scope Discipline:** The Eleven Commandments function as a constitutional scope limiter — every proposed feature must pass "does this violate any commandment?" If yes, it doesn't ship. This prevents scope creep by design, not by willpower.

### MVP Build Dependency Chain

The MVP pipeline stages are **sequential, not parallel** — every stage is on the critical path. If any stage takes longer than expected, everything downstream slips. The PoC de-risks the two highest-risk stages (pose estimation + ball detection) before the main build begins.

```
1. Recording Pipeline → 2. Pose Estimation → 3. Stroke Classification →
4. Ball Detection → 5. Session Summary (Observations) → 6. Personal Baseline →
7. Coaching Engine → 8. Monetization → 9. Onboarding & Polish
```

**Graceful degradation is not step 9.** It is a quality attribute built into each pipeline stage as it is developed — confidence scoring in pose estimation, frame filtering in stroke classification, "limited visibility" messaging in session summary, honest-or-silent logic in coaching engine. Retrofitting degradation after the pipeline is built requires touching every downstream consumer and is significantly more expensive.

### MVP Feature Set (Phase 1)

**Core User Journeys Supported:**
All five mapped journeys are fully supported in MVP:
- Journey 1: First Session (onboarding → recording → analysis → observation)
- Journey 2: Trust Ladder (baseline building → coaching tip delivery)
- Journey 3: Bad Conditions (graceful degradation → honest messaging)
- Journey 4: Free-to-Pro (tier limit → upgrade with personal data → seamless transition)
- Journey 5: Returning After Break (gap detection → regression context → re-entry coaching)

**Must-Have Capabilities:**

| Capability | Justification |
|-----------|---------------|
| GoPro recording model | Core interaction paradigm — without this, the app isn't PingPongBuddy |
| Pose estimation (33 landmarks) | Foundation of all observation and coaching |
| Ball on/off table detection | Enables session on-table rate — the truth metric |
| Three-bucket stroke classification | Forehand topspin, backhand topspin, other — minimum for meaningful observations |
| Session summary with observations | The first-session aha moment. Without this, no retention. |
| Personal-baseline tracking | The trust ladder requires cross-session comparison |
| Coaching tip generation (rule-based) | The coaching aha moment. Without this, no differentiation. |
| On-device processing | Privacy commandment, offline-first architecture, zero cloud cost |
| Cross-platform (Android + iOS) | Day-one Android parity is a competitive differentiator |
| Free tier with generous session count | Trust ladder needs multiple sessions before coaching kicks in |
| Pro tier subscription | Revenue path, even if monetization is secondary to product validation |
| Graceful degradation (per-stage) | Commandment 9 — built into each pipeline stage, not a polish phase |
| Camera setup guidance | Reduces setup friction, improves data quality |
| Optional accuracy feedback (thumbs-up/down) | Collect-only signal for v2 coaching improvement |

**Timeline Pressure Deferral List:** If the solo developer is at month 5 and not in polish, cut these in order — none are launch-critical:
1. Smart segmentation (drills vs. matches vs. breaks)
2. Confidence indicators on observations
3. Break-aware re-entry coaching (Journey 5 specifics — the app still works for returning users, just without the contextual "welcome back" messaging)

### Post-MVP Features

**Phase 2 — Growth (v1.1–1.x):**

| Feature | Trigger to Build |
|---------|-----------------|
| Additional stroke types (serve, chop, push) | MVP validates pipeline; each stroke is a new StrokeProfile, not new architecture |
| YOLO-based ball detection upgrade | Frame differencing doesn't meet ±15% accuracy threshold |
| Progress tracking visualization | Users ask "show me my improvement over time" |
| Confidence indicators on observations | Improve transparency for degraded-condition sessions |
| Smart segmentation (drills vs. matches vs. breaks) | Refine observation granularity beyond session-level |
| LLM-powered coaching (on-device or Claude API) | Rule-based tips validated; LLM adds personalization depth |

**Phase 3 — Expansion (v2.0+):**

| Feature | Strategic Value |
|---------|----------------|
| Coach tier ($19.99/mo) | B2B2C growth — one coach brings 10-20 students |
| Scout mode | Point at another player to capture mechanics |
| "Scan a Pro" reference models | Extract technique from YouTube footage |
| Training modes (volume vs. precision) | Structure practice sessions like a real coach |
| Forward-looking progress journal | Auto-generated coaching narrative |
| Match analysis with scoring | Competitive players want match-level insights |
| Community/sharing features | Social retention and viral acquisition |
| AR glasses integration | When hardware matures — real-time overlay during play |

### Risk Mitigation Strategy

**Technical Risks:**

| Risk | Likelihood | Impact | Mitigation | Gate |
|------|-----------|--------|------------|------|
| Ball detection accuracy insufficient (frame differencing) | Medium | High | YOLO upgrade path is well-defined. On-table rate is a core dependency — if frame differencing doesn't hit ±15%, upgrade is mandatory, not optional. | PoC go/no-go |
| Pose estimation unreliable in side-angle TT conditions | Low | Critical | Nanjing 2025 study provides strong counter-evidence. PoC validates with real footage before any app development. Heavy model variant + temporal smoothing as fallbacks. | PoC go/no-go |
| Processing time exceeds user tolerance (>10 min for 30 min session) | Low-Medium | Medium | Adjustable frame sampling rate. GPU mode for speed. Progressive results. NPU provides good balance. | Phase 5 benchmark |
| Stroke classification (FH vs BH vs other) below 80% | Medium | Medium | Arm position relative to body centerline is a strong signal. If heuristic classification underperforms, fall back to "all strokes" observation without per-type breakdown. | Phase 2 validation |

**Market Risks:**

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| First-session observations aren't compelling enough | Medium | High | Session on-table rate is a number no casual player has ever seen. If still insufficient, add a form overlay (skeleton visualization) as immediate visual value. |
| Rule-based coaching tips feel generic despite being technically correct | Medium | High | The gap between "technically correct" and "coaching moment that lands" is a product design challenge. Founder validates all coaching tip templates during beta. Tip language must feel personal and contextual ("your shoulder rotation increased over 3 sessions") not clinical ("shoulder rotation: +5°"). |
| Players don't return after session 1 | Medium | High | The number itself ("my backhand is 49%") creates curiosity about whether it changes. Track 7-day return rate in beta. |
| SportsReflector or sportFX adds TT-specific depth | Medium | Medium | First-mover advantage + deep TT domain knowledge + community trust. Speed to market matters — 6-12 month window. |
| Free tier is too generous (no conversion pressure) | Low | Medium | Monetization is secondary. Start generous, tighten based on data. Observations are free tier value; coaching tips can be a Pro differentiator if needed. |

**Resource Risks:**

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Solo dev scope exceeds 6 months | Medium-High | Medium | PoC-first strategy de-risks the hardest technical work early. Explicit deferral list: smart segmentation, confidence indicators, break-aware coaching. Each pipeline stage is a discrete milestone with visible progress. |
| Developer burnout on solo project | Medium | Medium | Modular architecture means each pipeline stage is a discrete milestone with visible progress. Community "build in public" engagement provides external motivation. |
| Testing on insufficient device range | Low-Medium | Medium | Minimum 5 devices for hardware matrix (2 Android, 2 iOS, 1 budget). Beta testers provide additional device coverage. |

## Functional Requirements

### Session Recording

- **FR1:** Player can start a video recording session with a single tap
- **FR2:** Player can stop a recording session and retain the video file on device
- **FR3:** Player can record a session without creating an account or signing in
- **FR4:** Player can record a session while offline (no internet required)
- **FR5:** Player can record a session even when their free tier analysis limit is reached
- **FR6:** System records video as standard H.264 MP4 to local device storage
- **FR7:** System continues recording uninterrupted regardless of on-screen activity or app backgrounding

### Onboarding & Camera Setup

- **FR8:** Player sees a static camera setup guide on first use explaining optimal phone positioning (height, distance, angle)
- **FR9:** System requests device permissions (camera, storage, notifications) just-in-time with plain-language explanation, never at app launch
- **FR10:** Player can begin recording within 60 seconds of opening the app for the first time
- **FR11:** System provides contextual setup tips on subsequent sessions based on conditions detected in prior sessions
- **FR12:** Player can skip or dismiss onboarding and proceed directly to recording

### Analysis Pipeline

- **FR13:** Player can select a recorded video and trigger post-session analysis
- **FR14:** System extracts body pose landmarks (33 keypoints) from recorded video frames
- **FR15:** System detects ball on/off table events across the full session
- **FR16:** System classifies detected strokes into three buckets: forehand topspin, backhand topspin, and other
- **FR17:** System computes biomechanical metrics per stroke (full metric catalog defined in architecture — includes joint angles, rotational velocity, swing timing at minimum)
- **FR18:** System computes session on-table rate across all detected strokes
- **FR19:** System computes on-table rate per recognized stroke type (forehand topspin, backhand topspin)
- **FR20:** System runs all analysis on-device with no cloud dependency
- **FR21:** System selects optimal hardware acceleration (GPU/NPU/CPU) automatically based on device capabilities
- **FR22:** System performs analysis in background isolates, keeping the UI responsive
- **FR23:** Player can background the app during analysis and processing continues
- **FR24:** Player receives a local notification when analysis completes while the app is backgrounded
- **FR25:** Player sees a progress indicator during analysis showing percentage complete
- **FR26:** If the app is killed mid-analysis, the recorded video is preserved and analysis can be restarted from scratch

*Explicit MVP exclusion: resumable analysis (picking up mid-pipeline after interruption) is out of scope. Analysis restarts from frame one.*

### Graceful Degradation

- **FR27:** System assigns confidence scores to pose landmark detections per frame (confidence thresholds are configurable parameters)
- **FR28:** System drops frames where landmark confidence falls below the configured threshold — this naturally filters frames degraded by camera bumps, lighting changes, obstructions, and angle shifts
- **FR29:** System performs best-effort single-player isolation from other people in the frame using position consistency; analysis quality degrades proportionally with the number of visible people
- **FR30:** System discards ball detection events outside the defined table region
- **FR31:** System handles sessions with zero valid frames by displaying an explanatory message with setup tips, never showing empty or nonsensical data
- **FR32:** System reports reduced data quality to the player when a session is analyzed with limited visibility (e.g., "observations based on 70% of detected strokes")
- **FR33:** System withholds coaching tips when observation confidence does not meet the threshold for generating reliable advice

*Camera disruption handling (bumps, sudden angle shifts) is covered by confidence-based frame filtering (FR27–28) rather than a separate detection mechanism. Explicit disruption classification deferred to post-MVP.*

### Session Summary & Observations

- **FR34:** Player can view a session summary after analysis completes
- **FR35:** Session summary displays total stroke count and stroke count per recognized type
- **FR36:** Session summary displays session on-table rate and on-table rate per recognized stroke type
- **FR37:** Session summary displays a text observation describing what the system detected in the session
- **FR38:** Session summary displays baseline progress toward the coaching threshold during pre-threshold sessions (e.g., "37/100 forehand topspins tracked — building your baseline")
- **FR39:** Session summary is designed for screenshot sharing — clean layout, all key data visible without scrolling or cropping
- **FR40:** Player can share the session summary via the device's native share functionality

### Video Review

- **FR41:** Player can play back a recorded session video with standard controls (play, pause, scrub)

*Post-MVP vision: stroke-linked playback with comparative examples — "here's a flat stroke that missed vs. one with higher rotation that landed." Phase 2 capability.*

### Session History & Management

- **FR42:** Player can view a chronological list of all recorded sessions showing duration, thumbnail, and analysis status (unanalyzed / analyzed / analyzing)
- **FR43:** Player can select an unanalyzed session from the list and trigger analysis
- **FR44:** System persists session-level aggregated metrics (stroke counts, on-table rates, biomechanical averages) across sessions
- **FR45:** System computes cross-session trends for biomechanical metrics and on-table rates
- **FR46:** System detects gaps in session history (breaks longer than a configurable threshold)
- **FR47:** System contextualizes post-break sessions with appropriate messaging (e.g., "your last session was 21 days ago — this is normal after a break")
- **FR48:** System maintains baseline continuity across breaks — baselines are not reset, breaks are incorporated as data points
- **FR49:** System retains all session history and progress data across app updates without data loss
- **FR50:** System retains all session history and progress data across free-to-pro tier transitions

### Coaching Engine

- **FR51:** System withholds coaching tips until the player has accumulated 100+ strokes of a recognized type across one or more sessions (trust ladder threshold)
- **FR52:** System generates one coaching insight per session — either an observation or a tip, never more
- **FR53:** System correlates changes in biomechanical metrics with changes in on-table rate to identify causal relationships
- **FR54:** Coaching tips use forward-looking language patterns (e.g., "try increasing rotation" not "your rotation was too low"; "your on-table rate climbed when..." not "you missed too many")
- **FR55:** System detects regression in previously improving metrics and surfaces re-entry coaching for returning users
- **FR56:** System connects coaching for one stroke type to patterns observed in another when relevant correlations exist

*MVP note: Cross-type coaching rules are expected to be limited in initial release and expand as the coaching template library grows with real player data.*

- **FR57:** Player can provide optional accuracy feedback (thumbs-up/thumbs-down) on observations and tips in the session summary
- **FR58:** System stores accuracy feedback signals for future coaching improvement (collect-only in MVP — no adaptive behavior)

### Monetization & Subscription

- **FR59:** Player can use the app on a free tier with a system-configurable number of session analyses per month (not user-facing; default set by developer)
- **FR60:** System tracks free tier session usage and enforces the analysis limit
- **FR61:** System checks tier status before starting analysis, never interrupts mid-analysis with a paywall
- **FR62:** Player sees an upgrade screen displaying their personal progress data when the free tier limit is reached
- **FR63:** Player can subscribe to the Pro tier ($7.99/mo or $49.99/yr) via in-app purchase
- **FR64:** On upgrade, previously recorded unanalyzed sessions become available for player-initiated analysis (player selects which to analyze, not automatic)
- **FR65:** System caches subscription status locally for up to 7 days for offline use
- **FR66:** System downgrades to free tier behavior after 7 days without subscription validation
- **FR67:** System retains unanalyzed video files until the player explicitly deletes them, never auto-deletes
- **FR68:** System requires network connectivity only for subscription purchase and validation; all other functionality operates offline

### App Settings & Preferences

- **FR69:** Player can access an app settings screen
- **FR70:** Player can view storage space used and manage local video/session data (delete individual sessions or videos)
- **FR71:** Player can delete all personal data from the device

### System Constraints

- **FR72:** System produces zero sounds, notifications, or visual interruptions while a recording session is active
- **FR73:** System never sends push notifications for inactivity, marketing, or engagement purposes — only "analysis complete"
- **FR74:** System never uploads video or analysis data to any external server without explicit player permission
- **FR75:** System processes all ML inference and coaching logic on-device
- **FR76:** System never displays gamification elements (streaks, confetti, leaderboards, badges)
- **FR77:** Analysis pipeline stages execute sequentially — each stage depends on the prior stage's output; no stage can be parallelized or skipped
- **FR78:** System provides App Store and Google Play compliant privacy disclosures and data safety declarations
- **FR79:** Player sees estimated storage requirement before starting a recording session (based on expected duration)

## Non-Functional Requirements

*Performance and battery NFRs are targets validated during PoC. If targets cannot be met, frame sampling rate is the primary adjustment lever before reconsidering scope.*

### Performance

- **NFR1:** Post-session analysis of a 30-minute session completes within 15 minutes on mid-range devices (2022+ Android, iPhone 12+); frame sampling rate is adjustable to meet this target
- **NFR2:** Post-session analysis of a 30-minute session completes within 5 minutes on flagship devices (2024+ Android, iPhone 15+)
- **NFR3:** Video recording maintains stable 30 FPS capture with no dropped frames during active sessions
- **NFR4:** MediaPipe pose estimation maintains 30+ FPS processing throughput in GPU mode
- **NFR5:** UI remains responsive (< 100ms touch response) during background analysis
- **NFR6:** Session summary screen loads within 2 seconds after analysis completes
- **NFR7:** App launches to recording-ready state within 3 seconds (after first-use onboarding is complete)
- **NFR8:** Session history list loads within 1 second for up to 100 sessions
- **NFR9:** Progress indicator updates at least every 5 seconds during analysis

### Security & Privacy

- **NFR10:** All session data (video, metrics, baselines) stored in app-sandboxed storage, inaccessible to other apps
- **NFR11:** No personally identifiable information transmitted off-device except subscription purchase receipt to Apple/Google store APIs
- **NFR12:** Video files excluded from device cloud backups by default (iCloud/Google backup opt-out)
- **NFR13:** "Delete all data" (FR71) performs complete removal — no residual data in caches, temp files, or database WAL
- **NFR14:** App does not use device advertising identifiers (IDFA/GAID) for tracking

### Reliability & Data Integrity

- **NFR15:** Zero data loss during app updates — database migrations preserve 100% of historical sessions, metrics, and baselines
- **NFR16:** Analysis pipeline produces functionally equivalent results when the same video is analyzed twice — same stroke classifications, on-table rates within ±1%, and identical coaching output
- **NFR17:** Subscription cache operates correctly during network outages up to 7 days
- **NFR18:** App recovers gracefully from unexpected termination — no corrupted database state, no orphaned temp files
- **NFR19:** Session data write operations are atomic — partial writes do not corrupt existing data

### Battery & Resource Efficiency

- **NFR20:** Analysis of a 30-minute session targets ≤15% battery consumption on mid-range devices; validated during PoC with frame sampling rate as primary lever if exceeded
- **NFR21:** Recording a 60-minute session consumes no more than 20% battery (comparable to native camera app)
- **NFR22:** App idle state (not recording, not analyzing) consumes negligible battery (no background processing)
- **NFR23:** Background analysis does not trigger system thermal warnings on mid-range devices at room temperature (20-25°C)

### Storage Efficiency

- **NFR24:** Analysis metadata (metrics, baselines, coaching data) for 100 sessions consumes less than 50MB of storage
- **NFR25:** App binary size does not exceed 100MB including bundled ML models
- **NFR26:** Temporary processing artifacts are cleaned up within 60 seconds of analysis completion
- **NFR27:** Video storage estimation accuracy is within ±10% of actual recorded file size

### Accessibility

- **NFR28:** All text meets WCAG 2.1 AA contrast ratios (4.5:1 for body text, 3:1 for large text)
- **NFR29:** All interactive elements have minimum 44x44pt touch targets
- **NFR30:** Screen reader compatibility (VoiceOver/TalkBack) for session summary, session history, and primary navigation
- **NFR31:** No information conveyed through color alone — supplementary text or icons for all status indicators

### Maintainability & Extensibility

- **NFR32:** Adding a new stroke type classification requires only a new StrokeProfile configuration — no changes to the pipeline framework, analysis infrastructure, or coaching engine core logic
- **NFR33:** Minimum supported device floor: 4GB RAM, GPU-capable SoC, Android API 31+, iPhone 12+
