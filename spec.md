# SideQuest — App Specification

**Version:** 0.6 (MVP)
**Author:** Eli / Surge Studios, LLC
**Date:** April 3, 2026
**Status:** Planning — Pending Founder Review

---

## 1. Vision & Mission

### The Why

People are stuck in loops — scrolling, consuming, watching others live. SideQuest exists to break that loop. It's built on the belief that every person has a list of things they've always meant to do, try, or become — and that doing those things alongside others is what builds real friendships and real growth.

Some quests are about pushing your limits. Some are about deepening a friendship. Some are just about having fun on a Tuesday night. All of them matter. The common thread is *doing* — getting off the couch, out of the routine, and into something that makes you feel alive.

### Infinite Mindset

SideQuest is not optimizing for time-on-app. It's optimizing for **things done in the real world**. Every design decision filters through this lens:

- Does this feature encourage a user to *do* something, or just scroll?
- Does this feature strengthen a real-world relationship, or create a parasocial one?
- Does this feature help someone grow, laugh, or connect — or just chase metrics?

The north star is a user who opens the app, gets inspired, goes and does something meaningful (or fun, or scary, or kind), proves they did it, and feels a genuine sense of accomplishment — then inspires someone else to do the same.

### Strategic Positioning

SideQuest does not seek to replace established social media. It **builds on top of it** to create a brighter, healthier environment. Instagram, Snapchat, and TikTok are distribution channels, not competitors. SideQuest is the engine that gives people something worth posting about.

### One-Liner

**SideQuest: Stop scrolling. Start doing.**

### Core Values (embedded in product decisions)

1. **Action over consumption** — The feed exists to inspire doing, not passive browsing
2. **Real connection** — Challenges between friends should feel personal, not transactional
3. **Growth at your own pace** — Weekly streaks, not daily. Bucket list pacing, not burnout
4. **Joy counts** — "Eat a donut bigger than your face" is as valid as "Run a marathon." Fun is growth too
5. **Your journey, shared** — Personal lists are private by default. You choose what to share and when
6. **Everyone runs their own race** — Badges and personal milestones are celebrated over raw XP ranking. The leaderboard exists but is not the primary status signal

---

## 2. Target Users

**Primary:** 18–35 year olds who are socially active, experience-driven, and already use apps like BeReal, Strava, or Duolingo. They respond to gamification, social proof, and competitive mechanics — but more importantly, they want to *feel something* and share that with their people.

**Secondary:** Friend groups and niche communities (hikers, foodies, travelers, fitness enthusiasts) who want shared challenge lists and group accountability.

**Anti-user:** Passive scrollers. SideQuest rewards doing, not watching.

**Age Gate:** 13+ minimum (COPPA compliance). Age verification during signup. Users under 13 are blocked from creating accounts.

---

## 3. Launch Strategy

**Phase 1 — Auburn Campus Beta:** Closed beta via TestFlight with 50–100 Auburn University students. Dense friend graphs in a small geography ensure the activity feed is alive from day one. Iterate on feedback before public launch.

**Phase 2 — Auburn Open Launch:** Public App Store + Play Store release. Marketing concentrated on Auburn campus — flyers, student org partnerships, word of mouth. Goal: 500 active users in a single social graph.

**Phase 3 — Campus Expansion:** Replicate the Auburn playbook at 3–5 additional SEC/Southern universities. Each campus gets a localized seed quest library.

**Phase 4 — Organic Growth:** Share cards and deep links drive viral acquisition beyond campuses. The product should be self-distributing by this point.

**Publisher:** Surge Studios, LLC (Apple Developer account active)

---

## 4. Core Loop

```
Discover/Create Quest → Add to Personal List → Attempt Quest → 
Submit Proof → Earn XP/Streak → Earn Badges → 
Share to Social (2 taps) → Inspire Others → Discover Next Quest
```

### 4.1 Quest Lifecycle

1. **Created** — User builds a quest using Quest Blocks or adds one from the public feed
2. **Active** — Quest is on user's personal list (in progress)
3. **Proof Submitted** — User uploads photo/video evidence matching the quest's proof requirements
4. **Completed** — Proof is accepted (auto-accepted with community spot-checks)
5. **Archived** — Completed quests live in a trophy case / history

### 4.2 Quest Types

- **Personal** — Created by user, visible only to them unless shared
- **Public** — Visible in the global feed, anyone can add to their list
- **Challenge** — Sent directly to a friend ("I dare you to...")
- **Seed** — Curated by SideQuest team, pre-loaded at launch and for new users
- **Sponsored** — Brand-created quests (v2, monetization path)

### 4.3 Quest Repeatability

Quest creators choose whether a quest is **one-time** or **repeatable** at creation.

- **One-time:** Can only be completed once per user. Trophy case shows single proof. ("Skydive for the first time")
- **Repeatable:** Can be completed multiple times. Each completion generates a separate proof entry and earns XP. ("Try a restaurant you've never been to")

### 4.4 Quest Intent Tags (visible on quest cards)

Every quest carries an intent signal that helps users find quests aligned with what they need right now:

- 🌱 **Growth** — Push your limits, learn something, level up
- 🤝 **Connection** — Requires or deepens a real relationship
- 🎉 **Fun** — Pure joy, no justification needed
- 💪 **Challenge** — Competitive, difficult, or fear-facing
- 🌍 **Explore** — Go somewhere new, see something different
- 🎨 **Create** — Make something that didn't exist before

Quests can have 1–2 intent tags. These are separate from categories — a "Food & Drink" quest could be tagged 🌱 Growth ("cook a dish from a culture you know nothing about") or 🎉 Fun ("eat the spiciest thing on the menu").

---

## 5. Quest Blocks — The Builder System

### 5.1 Concept

Quest creation is not a form. It's a builder. Users assemble quests from modular **Quest Blocks** — visual, draggable pieces that snap together like puzzle pieces. Each block defines one dimension of the quest. The minimum viable quest requires only a Title Block + one Proof Block. Everything else is optional, making simple quests fast to create while giving power users rich creative tools.

**The builder is the default creation experience.** Quick Create exists as a shortcut but routes through the same block data model under the hood.

### 5.2 Block Types

**Core Blocks (always available):**

| Block | Purpose | Options |
|-------|---------|---------|
| 📝 **Title** | Quest name + short description | Title (100 char), description (500 char) |
| 📸 **Proof** | How completion is verified | Photo required, Video required (Pro only), Photo or Video, Before & After (2 photos) |
| 📍 **Location** | Where the quest happens | Specific place (map pin), City/Region, Category ("any beach"), Anywhere |
| 👥 **People** | Social requirements | Solo, With 1 friend, With a group (min #), With a stranger |
| ⏱️ **Time** | Time constraints | Deadline (specific date), Duration limit ("under 60 minutes"), Time of day ("before sunrise"), Open-ended |
| 🏷️ **Category** | What kind of quest | One predefined category (Travel, Food, Fitness, Creative, Social, Career, Thrill, Wildcard) |
| 🎯 **Difficulty** | How hard is it | Easy (1x XP), Medium (1.5x), Hard (2x), Legendary (3x) |
| 🪜 **Stages** | Multi-step quest with tracked progress | List of stages, each with: title, optional description, proof required (yes/no), XP reward. Stages are completed sequentially over time |

**Flavor Blocks (optional, add personality):**

| Block | Purpose | Options |
|-------|---------|---------|
| 🎲 **Wildcard** | Adds randomness | "Flip a coin to decide...", "Roll a die for which option...", Random from list |
| 💬 **Prompt** | Reflection after completion | Custom question the completer must answer with proof ("What surprised you?") |
| 🔗 **Chain** | Links quests together | "Complete Quest X first" (prerequisite), "Part 2 of 3" (series) |
| 🏅 **Bonus** | Extra XP conditions | "Complete within 24 hours of adding: +50 XP", "Complete with 3+ friends: +25 XP" |
| 🚫 **Constraint** | Makes it harder/funnier | "No phone allowed", "Must be done in costume", "Left hand only", Custom text |
| 🎭 **Intent** | Why this quest matters | Growth 🌱, Connection 🤝, Fun 🎉, Challenge 💪, Explore 🌍, Create 🎨 (pick 1–2) |
| 🔄 **Repeat** | Quest repeatability | One-time or Repeatable |

**Architecture note:** All 14 blocks ship in MVP. Each block follows an identical interface contract (typed config in, widget out) enabling parallel AI development via subagents. The block system is the product differentiator and will not be scoped down. The Stages block is the most complex block — it renders as a vertical stepper in the builder and a progress tracker in the quest detail view.

### 5.3 Builder UX

- Blocks are displayed as colorful, rounded cards in a tray at the bottom of the screen
- User drags blocks up into the build area, where they snap into a vertical stack
- Each block expands when tapped to reveal its options
- Blocks have **full magnetic snap animations** when placed — this is the signature UX moment
- The Title Block is always pre-placed at the top (can't be removed)
- **Real-time preview:** A mini quest card shows how the quest will look in the feed as blocks are added
- **Quick Create shortcut:** For users who don't want to build, a "Quick Quest" button opens a simplified flow: title → category → difficulty → proof type → done. Creates the same block structure under the hood
- **Full animation polish is required for MVP** — the builder IS the product differentiator

### 5.4 Builder Data Model

A quest's block configuration is stored as a structured JSON map within the quest document. This keeps reads fast, the data portable, and the structure trivially feedable to an LLM for v2 AI features.

```
quests/{questId}
  - ...standard quest fields...
  - blocks: {
      proof: { type: "photo" | "video" | "photo_or_video" | "before_after" },
      location: { type: "specific" | "city" | "category" | "anywhere", value: string?, lat: num?, lng: num? }?,
      people: { type: "solo" | "with_friend" | "group" | "stranger", minCount: int? }?,
      time: { type: "deadline" | "duration" | "time_of_day" | "open", value: string? }?,
      wildcard: { options: string[] }?,
      prompt: { question: string }?,
      chain: { prerequisiteQuestId: string?, seriesIndex: int?, seriesTotal: int? }?,
      bonus: { condition: string, xpBonus: int }?,
      constraint: { text: string }?,
      repeat: { type: "one_time" | "repeatable" },
      stages: {
        items: [
          {
            id: string,
            title: string,
            description: string?,
            proofRequired: bool,
            proofType: "photo" | "video" | "photo_or_video" | "before_after"?,
            xp: int
          }
        ]
      }?
    }
```

---

## 6. Social Media Integration — First-Class, Not Afterthought

### 6.1 Design Principle

Sharing is not buried in a menu. It's celebrated. When a user completes a quest, the *very next screen* after proof submission is a beautiful, branded share card with a prominent "Share to..." row. Two taps to any platform. The goal: every completed quest is a potential viral moment.

### 6.2 Share Card System

When a quest is completed, SideQuest auto-generates a **Share Card** — a visually striking image designed to look native on each target platform:

**Card Contents:**
- User's proof photo as the hero image
- Quest title overlaid in branded typography
- Difficulty badge + XP earned
- Intent tag emoji
- User's tier badge and streak count
- SideQuest branding (subtle logo + "sidequestapp.com")
- QR code linking directly to the quest (so viewers can add it to their own list)
- Dynamic background color based on quest category

**Card Formats (auto-generated per platform):**
- **Instagram/Snapchat Story:** 9:16 vertical, optimized for story dimensions
- **Instagram Feed/Post:** 1:1 square or 4:5 portrait
- **TikTok:** 9:16 (video proof for Pro users, static card for free)
- **X (Twitter):** 16:9 horizontal with key info visible in preview
- **General/Copy Link:** Universal card with deep link

### 6.3 Share Flow (The "2-Tap Promise")

```
Complete Quest → Proof Accepted Screen → 
  [Share Card Preview — auto-generated, looks great already]
  [Row of platform icons: Instagram, Snapchat, TikTok, X, More...]
  
  Tap 1: Select platform
  Tap 2: Confirm in native share sheet → opens platform with card pre-loaded
```

- Instagram: Opens Instagram Stories with share card pre-loaded as sticker
- Snapchat: Opens Snapchat with share card ready to send/post
- TikTok: Opens TikTok share flow
- X: Pre-composed tweet with card image + link
- Copy Link: Deep link copied to clipboard with mini toast confirmation
- "Share Later" option saves the card to camera roll for manual posting

### 6.4 Video Proof & Social Media Link-Back

**Free users:** Photo proof only (stored in Firebase Storage).

**Pro users:** Video proof up to 30 seconds (stored in Firebase Storage, compressed via Cloud Functions).

**Instagram/TikTok link-back (all users):** Users can post video proof to Instagram or TikTok natively, then link the post back to their SideQuest completion. This offloads video storage to the platform while SideQuest gets the attribution. Implementation: user pastes post URL, SideQuest stores the link and displays an embedded preview on the quest proof page.

### 6.5 Inbound Social Integration

- **Contact sync** (opt-in): Find friends who already have SideQuest
- **Invite via social:** Share an invite link to Instagram DM, Snapchat, text, etc.
- **Deep links:** When someone scans a QR code or taps a shared link, it opens the quest in-app (or App Store if not installed)
- **Social auth:** Sign in with Google or Apple (social graph import v2)

### 6.6 Technical Implementation

- Share cards generated client-side using Flutter's RepaintBoundary + canvas rendering (fast, no server round-trip)
- Platform-specific sharing via share_plus package + platform share sheets
- Instagram Stories integration via Instagram's custom URL scheme (instagram-stories://share)
- Snapchat integration via Snap Creative Kit
- Deep links via Firebase Dynamic Links
- QR codes generated client-side with qr_flutter package

---

## 7. Content Quality & Moderation

### 7.1 Launch Content Strategy

The public feed is seeded with a **curated library of 100+ high-quality quests** created by the SideQuest team before launch. These seed quests:
- Cover all 8 categories and all 6 intent tags
- Range across all 4 difficulty levels
- Include Auburn-specific quests for the beta ("Visit Toomer's Corner," "Eat at every restaurant on College Street")
- Use creative block combinations to demonstrate what the builder can do
- Are marked as "Seed" type (cannot be deleted, attributed to @SideQuest official account)

After launch, any user can submit quests to the public feed via open submission.

### 7.2 Community Quality Signals (Community Notes Model)

Inspired by X's Community Notes, public quests receive quality signals from the community:

- Users can mark a public quest as **"Worth It"** (positive signal) or **"Needs Work"** (constructive signal)
- Quests with high "Worth It" ratios surface higher in the Explore feed algorithm
- Quests with high "Needs Work" ratios are deprioritized (not removed — the creator can improve them)
- Quality signals are anonymous to prevent social friction
- Threshold-based: signals only affect ranking after a minimum number of ratings (e.g., 10+)

### 7.3 Moderation (MVP — Required for App Store Approval)

**Report system:**
- Report button on every public quest, every proof photo, and every user profile
- Report categories: Dangerous/Harmful, Inappropriate Content, Spam, Harassment, Other
- Reported content is flagged for moderator review
- 3+ reports on the same content automatically hides it from public feed pending review

**Block system:**
- Block user: hides all their content from your feed, prevents them from challenging you or sending friend requests
- Blocked users cannot see your profile or activity

**Keyword filter:**
- Basic automated filter on quest titles and descriptions at publish time
- Blocks obvious dangerous terms, slurs, and explicit content
- Flagged quests go to a manual review queue instead of being rejected outright (avoids false positives)

**Moderation policy page:**
- Accessible from Settings and from the report flow
- Clear community guidelines explaining what's allowed and what isn't
- Required for App Store and Play Store approval

**Moderator queue:**
- Admin dashboard (web-based, can be simple) for reviewing reported content
- At launch, Eli and Christopher serve as moderators
- Moderation actions: approve, remove content, warn user, suspend user

### 7.4 Proof Verification (Community Spot-Checks)

Proof is auto-accepted upon submission, but the community provides a verification layer:

- Randomly selected completed quests appear in friends' activity feeds with a subtle "Legit?" prompt
- Friends can tap "Legit ✓" or "Hmm... 🤔" (low-friction, not accusatory)
- Multiple "Hmm" reactions on the same proof trigger a flag for review
- This is lightweight, social, and mirrors BeReal's authenticity culture
- No XP is removed automatically — flagged proofs are reviewed by moderators

---

## 8. Feature Breakdown — MVP Scope

### 8.1 Authentication
- Email/password signup + login
- Social auth: Google, Apple Sign-In
- Age verification: date of birth during signup, block under-13
- Profile creation: display name, username, avatar, short bio
- Account deletion / data export (GDPR/App Store compliance)
- Deleted accounts: username becomes available after 30 days, public quests persist with creator shown as "SideQuest Community"

### 8.2 Personal Quest List (Home Screen)
- User's active quests displayed as cards showing block summary (icons for location, people, time, etc.)
- Add quest: build with Quest Blocks (default)
- Add quest: Quick Create shortcut
- Add quest: from public feed (one-tap add)
- Reorder quests by priority (drag and drop)
- Filter by category, status (active / completed), intent tag
- Quest detail view: full block breakdown, description, completion proof (if done)
- Motivational empty state: "Your quest list is empty. What have you always wanted to do?" with suggested starter quests

### 8.3 Public Quest Feed (Explore Screen)
- **Algorithm-blended feed:** Mix of trending quests, newly published quests, and personalized recommendations based on user's category preferences and intent stats
- Global rankings: most-added quests, most-completed quests, rising quests
- Filter by predefined category and intent tag
- Search by keyword (Firestore prefix matching on title + exact match on category/tags for MVP; Algolia migration path for scale)
- "Add to my list" action on any public quest
- Quest cards show: title, category, intent tag(s), block summary icons, completion count, difficulty, top proof photo
- Community quality signals ("Worth It" count displayed on popular quests)

### 8.4 Predefined Categories
- Travel & Adventure
- Food & Drink
- Fitness & Sports
- Creative & Arts
- Social & Community
- Career & Learning
- Thrill & Adrenaline
- Random / Wildcard

Users can also add freeform tags (up to 5 per quest) for niche discoverability.

### 8.5 Quest Completion & Proof
- Proof type determined by the quest's Proof Block (or per-stage proof type for staged quests)
- Free users: photo proof only (camera or gallery)
- Pro users: photo or video proof (up to 30 seconds)
- All users: can link an Instagram/TikTok post URL as supplementary proof
- Optional caption / story with the proof
- If quest has a Prompt Block, user must answer the reflection question
- Proof is auto-accepted with community spot-check layer
- **Staged quests:** Each stage is completed independently. Stages with proofRequired=true prompt a proof submission. Stage completions can happen days or weeks apart. Progress is visible as a stepper/progress bar on the quest detail screen. The quest is marked "Completed" only when all stages are done
- **Immediate share card generation** after full quest completion (or optionally after individual stage completions)
- Completed quests show proof in trophy case on user's profile
- Repeatable quests: each completion creates a separate proof entry

### 8.6 Gamification System

**XP (Experience Points):**
- Complete a quest: +100 XP base (for non-staged quests)
- Difficulty multiplier: Easy (1x), Medium (1.5x), Hard (2x), Legendary (3x)
- **Staged quests:** XP is set by the creator per stage. Each stage awards its XP upon stage completion. Difficulty multiplier applies to each stage's XP individually. Total quest XP = sum of all stage XPs × difficulty multiplier
- First to complete a public quest: +50 XP bonus
- Complete a challenge from a friend: +25 XP bonus
- Bonus Block conditions: variable XP as defined by quest creator
- People Block bonus: +10 XP per additional person (group quests reward togetherness)
- Creator XP: +10 XP when your public quest reaches 10 adds, +25 at 50, +50 at 100, +100 at 500

**XP Philosophy:** XP scales with quest complexity (more blocks, higher difficulty = more XP). Simple self-created easy quests earn minimal XP. But SideQuest does not aggressively police XP farming — everyone is running their own race. The real status symbols are badges, not raw XP totals.

**Streaks:**
- Complete at least 1 quest per week to maintain streak
- Weekly streak (not daily — bucket list pacing, not burnout)
- Streak milestones at 4, 12, 26, 52 weeks with bonus XP
- Streak freeze: 1 free per month, additional available to Pro subscribers

**Tier Rankings:**
- Novice (0–499 XP)
- Explorer (500–1,999 XP)
- Adventurer (2,000–4,999 XP)
- Trailblazer (5,000–14,999 XP)
- Legend (15,000+ XP)

**Badges (primary status signal — more prominent than XP in UI):**
- Category-specific (e.g., "Globetrotter" for 10 Travel quests)
- Intent-specific (e.g., "Connector" for 10 Connection-tagged quests)
- Milestone badges (first quest, 10th quest, 100th quest)
- Social badges (challenged 5 friends, completed 5 challenges)
- Builder badge (created a quest that 50+ people added)
- Notoriety badges: completing specific high-profile quests that have gained community recognition awards special badges at bronze/silver/gold levels based on the quest's addedCount thresholds
- Badges are displayed prominently on profiles, in the activity feed, and on leaderboard entries — they are the primary achievement signal, not XP

### 8.7 Leaderboards (Rankings Screen)
- **Global** — All users, all time (exists but is NOT the primary ranking surface)
- **Friends** — Only users you're connected with (primary competitive surface)
- **Category** — Top users in each predefined category
- **Weekly** — Resets every Monday, drives ongoing engagement (most prominent leaderboard)
- Leaderboard entry shows: rank, avatar, username, **badge showcase (top 3 badges)**, tier, XP, quests completed
- **Design note:** Friends and Weekly leaderboards are shown first. Global all-time is accessible but deprioritized. The UI should celebrate badges and recent activity over raw XP accumulation

### 8.8 Social Features
- **Friends:** Mutual connection (send/accept request)
- **Friend discovery:** Search by username or display name + contact sync (opt-in)
- **Challenge:** Send a specific quest to a friend with optional message
- **Challenge XP:** Challenger earns +25 XP when the challenged friend completes the quest. No chain XP — only direct challenge completions count
- **Activity Feed:** Friends' completions + public profiles you interact with most (Instagram Stories-style ranking). Feed settings can filter to friends-only
- **Reactions:** React to friends' completed quests (emoji reactions)
- **Share Out:** 2-tap sharing to Instagram, Snapchat, TikTok, X (see Section 6)
- **Deep Link Invites:** Share a quest or profile link that works even for non-users

### 8.9 User Profile
- Avatar, display name, username, bio
- **Badge showcase** (top 3 badges, user-selected — most prominent element)
- Tier badge and XP total
- Current streak display
- Intent breakdown chart (how many Growth vs Fun vs Connection quests completed)
- Trophy case: grid of completed quest proofs
- Stats: total completed, category breakdown, badges earned
- "What kind of quester are you?" — personality summary based on intent distribution
- Public profile viewable by anyone (privacy toggle v2)

### 8.10 Notifications
- Push notifications for: friend requests, incoming challenges, streak reminders (day 6 of week with no completion), friend completed a quest, leaderboard position changes, badge earned
- In-app notification center
- Notification tone: encouraging, not nagging. "Your streak is on fire" not "Don't lose your streak!"

---

## 9. Screens (Navigation Map)

```
Bottom Nav:
├── Home (Personal Quest List)
├── Explore (Public Feed + Search + Rankings)
├── + (Quest Builder — full screen with block tray)
├── Activity (Friend activity feed + notifications)
└── Profile (Stats, badge showcase, trophy case, settings)

Secondary Screens:
├── Quest Detail (full block breakdown + proof gallery + stage progress tracker)
├── Quick Create (simplified quest creation)
├── Proof Submission (Camera/Gallery + Caption + Prompt answer)
├── Share Card Preview (post-completion, 2-tap share)
├── Friend Search (username + display name + contact sync)
├── Friend's Profile
├── Leaderboard Detail (Weekly / Friends / Category / Global)
├── Challenge Flow (Pick quest → Pick friend → Send)
├── Report Flow (select reason → submit → confirmation)
├── Settings (Account, notifications, linked socials, subscription, moderation policy, logout)
├── Onboarding (3-screen intro + intent/category picker)
└── Admin: Moderation Queue (web-based, not in mobile app)
```

---

## 10. Visual Identity & Design System

### 10.1 Brand Concept

**"Sunset over ocean."** Warm, energizing accent colors (the sunset) grounded by deep, confident primary colors (the ocean). The palette should feel adventurous and alive without being childish — a college student should feel cool using this app, not like they opened a kids' game.

### 10.2 Color Palette — Light Mode

**Primary Colors:**
- **Navy** — `#1B2A4A` — Primary text, headers, navigation bar backgrounds, key UI surfaces
- **White** — `#FFFFFF` — Page backgrounds, card backgrounds, input fields
- **Off-White** — `#F5F6F8` — Secondary backgrounds, grouped table views, subtle separation

**Accent Colors (Sunset Gradient):**
- **Warm Yellow** — `#F5A623` — Streak indicators, XP displays, positive highlights, star ratings
- **Sunset Orange** — `#E8734A` — Primary CTA buttons, badges, notification dots, active states
- **Ember Red** — `#D94F4F` — Challenges, legendary difficulty, urgent notifications, destructive actions

**Supporting Colors:**
- **Ocean Teal** — `#2A9D8F` — Success states, completed quests, "Worth It" signals, Growth intent
- **Soft Gray** — `#8E99A4` — Secondary text, placeholders, disabled states, dividers
- **Light Gray** — `#E8ECF0` — Borders, card shadows, inactive toggle backgrounds

### 10.3 Color Palette — Dark Mode

The sunset/ocean palette is preserved but adapted for dark surfaces. Accents stay vibrant; backgrounds go deep navy instead of pure black.

**Primary Colors:**
- **Deep Navy** — `#0D1B2A` — Page backgrounds
- **Card Navy** — `#1B2D45` — Card backgrounds, elevated surfaces
- **Slate** — `#243447` — Secondary backgrounds, input fields, grouped sections

**Accent Colors (same hues, slightly adjusted for dark background contrast):**
- **Warm Yellow** — `#F5B041` — Slightly warmer for readability on dark
- **Sunset Orange** — `#EB7F56` — Slightly lighter for contrast
- **Ember Red** — `#E05555` — Slightly lighter for contrast

**Supporting Colors:**
- **Ocean Teal** — `#34B3A3` — Slightly brighter for dark background
- **Light Text** — `#E8ECF0` — Primary text on dark
- **Muted Text** — `#8E99A4` — Secondary text (same as light mode)

### 10.4 Intent Tag Colors

Each intent tag has a consistent color used for its emoji background, filter chips, and chart segments:

- 🌱 Growth — Ocean Teal (`#2A9D8F`)
- 🤝 Connection — Sunset Orange (`#E8734A`)
- 🎉 Fun — Warm Yellow (`#F5A623`)
- 💪 Challenge — Ember Red (`#D94F4F`)
- 🌍 Explore — Navy (`#1B2A4A`)
- 🎨 Create — `#8B5CF6` (Purple — creative energy, distinct from other accents)

### 10.5 Category Colors

Each predefined category gets a distinct color for card accents and filter chips:

- Travel & Adventure — `#2A9D8F`
- Food & Drink — `#E8734A`
- Fitness & Sports — `#D94F4F`
- Creative & Arts — `#8B5CF6`
- Social & Community — `#F5A623`
- Career & Learning — `#1B2A4A`
- Thrill & Adrenaline — `#E05555`
- Random / Wildcard — `#8E99A4`

### 10.6 Typography

**Direction:** Clean, modern, high readability. One display font for personality, one body font for everything else.

**Recommendations (to be finalized):**
- **Display/Headings:** Inter Bold or Poppins SemiBold — geometric, confident, legible at all sizes
- **Body/Content:** Inter Regular — clean, neutral, excellent readability on mobile
- **Monospace (XP/stats):** JetBrains Mono or SF Mono — for XP counts, leaderboard numbers, giving stats a "scoreboard" feel

**Type Scale (mobile-first):**
- Hero/Title: 28px Bold
- Section Header: 22px SemiBold
- Card Title: 18px SemiBold
- Body: 16px Regular
- Caption/Label: 14px Regular
- Overline/Badge: 12px Medium (uppercase tracking)

### 10.7 Component Design Standards

**This section is the visual contract for every AI session.** Every component must be defined once and referenced everywhere. No one-off styling.

**Buttons:**
- **Primary CTA:** Sunset Orange (`#E8734A`) background, White text, 12px corner radius, 48px min height, subtle shadow. Used for: "Add to My List," "Complete Quest," "Share"
- **Secondary:** Navy (`#1B2A4A`) background, White text, same radius/height. Used for: "Challenge a Friend," "Create Quest"
- **Tertiary/Ghost:** Transparent background, Navy text, 1px Navy border. Used for: "Cancel," "Skip," "Share Later"
- **Destructive:** Ember Red background, White text. Used for: "Delete Quest," "Block User"
- **Disabled:** Light Gray background, Soft Gray text, no shadow

**Cards:**
- White background (Card Navy in dark mode), 16px corner radius, subtle shadow (`0 2px 8px rgba(0,0,0,0.08)`)
- 16px internal padding
- Quest cards: category color as a thin left border or top accent stripe

**Text Inputs:**
- Off-White background (Slate in dark mode), 12px corner radius, 1px Light Gray border
- 16px internal padding, 48px height
- Focus state: 2px Sunset Orange border
- Error state: 2px Ember Red border + error message below

**Bottom Navigation:**
- Navy background (Deep Navy in dark mode)
- Inactive icons: Soft Gray
- Active icon: Sunset Orange with label
- Center "+" button: Sunset Orange circle, elevated above nav bar

**Chips/Tags:**
- 20px corner radius (pill shape), 8px horizontal padding, 32px height
- Category chips: category color at 15% opacity background, category color text
- Intent chips: intent color at 15% opacity background, intent color text
- Selected state: full color background, white text

**Toast/Snackbar:**
- Navy background, White text, 12px corner radius, appears from bottom
- Success variant: Ocean Teal left accent
- Error variant: Ember Red left accent

**Modals/Bottom Sheets:**
- 24px top corner radius, drag handle indicator
- White background (Card Navy dark mode)
- Overlay: Black at 40% opacity

**Quest Block Cards (Builder):**
- Each block type has a distinct accent color from the category/intent palette
- 16px corner radius, subtle shadow, category-colored left border
- Drag handle on the left, expand/collapse chevron on the right
- Magnetic snap animation: 200ms ease-out with subtle haptic feedback

### 10.8 Design Token Implementation

All colors, typography, spacing, and component styles must be defined as **Dart constants in a single theme file** (`lib/core/theme/`). This file is referenced by every widget and included in the CLAUDE.md project instructions so every AI session uses the same tokens.

```
lib/core/theme/
  ├── app_colors.dart      (all color constants, light + dark)
  ├── app_typography.dart   (text styles, type scale)
  ├── app_spacing.dart      (padding/margin constants: 4, 8, 12, 16, 24, 32, 48)
  ├── app_shadows.dart      (elevation/shadow definitions)
  ├── app_radius.dart       (corner radius constants)
  ├── app_theme.dart        (ThemeData composition, light + dark)
  └── components/
      ├── sq_button.dart    (all button variants)
      ├── sq_card.dart      (base card component)
      ├── sq_input.dart     (text input component)
      ├── sq_chip.dart      (tag/filter chip component)
      ├── sq_toast.dart     (toast/snackbar component)
      └── sq_bottom_sheet.dart
```

**Rule:** No raw color values, font sizes, or padding values anywhere in the codebase. Everything references theme tokens. This is non-negotiable and will be enforced in CLAUDE.md.

---

## 11. Tech Stack

### Mobile App
- **Framework:** Flutter (Dart)
- **State Management:** Riverpod
- **Navigation:** GoRouter
- **Local Storage:** SharedPreferences (settings), Hive (offline quest cache)
- **Sharing:** share_plus + platform-specific creative kits (Snap Creative Kit, Instagram Stories URL scheme)
- **QR Codes:** qr_flutter
- **Image Rendering:** RepaintBoundary for share card generation

### Backend
- **Platform:** Firebase
- **Auth:** Firebase Authentication (email, Google, Apple)
- **Database:** Cloud Firestore
- **Storage:** Firebase Storage (photo proof + video proof for Pro users)
- **Push Notifications:** Firebase Cloud Messaging (FCM)
- **Analytics:** Firebase Analytics
- **Functions:** Cloud Functions (Node.js) for leaderboard computation, XP calculations, streak checks, keyword filtering
- **Deep Links:** Firebase Dynamic Links
- **Search (MVP):** Firestore prefix queries + category/tag exact match
- **Search (scale migration):** Algolia with Firestore sync extension

### External
- **Image/Video Processing:** Cloud Functions for thumbnail generation, video compression (Pro video only)
- **Ads:** Google AdMob (banner + interstitial)
- **Subscriptions:** RevenueCat (manages App Store + Play Store subscriptions)

### Development Approach
- Eli serves as architect: defines spec, reviews, and integrates
- AI agents generate code: Claude Code + Cursor, spec-driven workflow
- Each Quest Block gets a dedicated subagent with shared interface contract
- Session-by-session development following the task decomposition in Section 18

---

## 12. Data Models

### User
```
users/{userId}
  - uid: string
  - email: string
  - displayName: string
  - username: string (unique, lowercase, alphanumeric + underscore)
  - avatarUrl: string?
  - bio: string? (max 150 chars)
  - dateOfBirth: timestamp (age verification)
  - xp: int
  - tier: string (computed from XP thresholds)
  - currentStreak: int (weeks)
  - longestStreak: int (weeks)
  - lastCompletionDate: timestamp?
  - streakFreezeAvailable: int (resets monthly)
  - questsCompleted: int
  - friendCount: int
  - badges: string[] (badge IDs)
  - badgeShowcase: string[3] (user-selected top 3 badges for profile)
  - categoryPreferences: string[] (chosen during onboarding)
  - intentStats: { growth: int, connection: int, fun: int, challenge: int, explore: int, create: int }
  - isPro: bool
  - blockedUsers: string[] (userIds)
  - createdAt: timestamp
  - updatedAt: timestamp
```

### Quest
```
quests/{questId}
  - id: string
  - creatorId: string (userId, or "deleted" for orphaned quests)
  - type: enum (personal, public, challenge, seed)
  - title: string (max 100 chars)
  - description: string (max 500 chars)
  - category: string (from predefined list)
  - tags: string[] (max 5, user-defined)
  - difficulty: enum (easy, medium, hard, legendary)
  - visibility: enum (personal, public)
  - intent: string[] (max 2, from intent enum)
  - repeatable: bool
  - blocks: {
      proof: { type: "photo" | "video" | "photo_or_video" | "before_after" },
      location: { type: "specific" | "city" | "category" | "anywhere", value: string?, lat: num?, lng: num? }?,
      people: { type: "solo" | "with_friend" | "group" | "stranger", minCount: int? }?,
      time: { type: "deadline" | "duration" | "time_of_day" | "open", value: string? }?,
      wildcard: { options: string[] }?,
      prompt: { question: string }?,
      chain: { prerequisiteQuestId: string?, seriesIndex: int?, seriesTotal: int? }?,
      bonus: { condition: string, xpBonus: int }?,
      constraint: { text: string }?,
      stages: {
        items: [
          {
            id: string,
            title: string,
            description: string?,
            proofRequired: bool,
            proofType: "photo" | "video" | "photo_or_video" | "before_after"?,
            xp: int
          }
        ]
      }?
    }
  - addedCount: int
  - completedCount: int
  - worthItCount: int (community quality signal)
  - needsWorkCount: int (community quality signal)
  - featuredProofUrl: string?
  - reportCount: int
  - isHidden: bool (hidden by moderation)
  - createdAt: timestamp
  - updatedAt: timestamp
```

### UserQuest (junction — user's personal list)
```
users/{userId}/quests/{userQuestId}
  - questId: string (ref to quests collection)
  - status: enum (active, completed, archived)
  - addedAt: timestamp
  - completedAt: timestamp?
  - proofUrl: string? (photo URL in Firebase Storage)
  - proofVideoUrl: string? (video URL, Pro only)
  - proofExternalUrl: string? (Instagram/TikTok post link)
  - proofCaption: string?
  - promptAnswer: string? (if quest has a prompt block)
  - xpEarned: int?
  - sortOrder: int
  - completionIndex: int (0 for first completion, 1+ for repeatable re-completions)
  - stageProgress: [
      {
        stageId: string,
        status: enum (locked, active, completed),
        completedAt: timestamp?,
        proofUrl: string?,
        proofCaption: string?
      }
    ]? (only present if quest has Stages block)
```

### Friendship
```
friendships/{friendshipId}
  - id: string
  - userIds: string[2] (sorted for consistent lookup)
  - status: enum (pending, accepted)
  - requesterId: string
  - createdAt: timestamp
  - acceptedAt: timestamp?
```

### Challenge
```
challenges/{challengeId}
  - id: string
  - senderId: string
  - receiverId: string
  - questId: string
  - message: string? (max 200 chars)
  - status: enum (pending, accepted, completed, declined)
  - createdAt: timestamp
```

### Activity (denormalized for fast feed reads)
```
activity/{activityId}
  - id: string
  - userId: string (who performed the action)
  - type: enum (quest_completed, stage_completed, challenge_sent, challenge_completed, badge_earned, streak_milestone, creator_milestone)
  - questId: string?
  - proofUrl: string?
  - metadata: map (flexible payload per type)
  - createdAt: timestamp
```

### Report
```
reports/{reportId}
  - id: string
  - reporterId: string
  - targetType: enum (quest, proof, user)
  - targetId: string
  - reason: enum (dangerous, inappropriate, spam, harassment, other)
  - details: string? (optional text)
  - status: enum (pending, reviewed, actioned, dismissed)
  - createdAt: timestamp
  - reviewedAt: timestamp?
  - reviewedBy: string? (moderator userId)
```

### QualitySignal
```
qualitySignals/{signalId}
  - questId: string
  - userId: string
  - signal: enum (worth_it, needs_work)
  - createdAt: timestamp
```

### DeletedUsername
```
deletedUsernames/{username}
  - username: string
  - deletedAt: timestamp
  - availableAt: timestamp (deletedAt + 30 days)
```

---

## 13. API / Cloud Functions

### Computed / Triggered
- **onQuestCompleted** — Calculates XP (base × difficulty multiplier + bonuses + people bonus), updates user.xp, user.tier, user.questsCompleted, user.intentStats, quest.completedCount, writes activity, checks badge eligibility, checks streak. If challenge: awards challenger +25 XP. Only fires when ALL stages are complete for staged quests
- **onStageCompleted** — For staged quests: awards per-stage XP (stage.xp × difficulty multiplier), updates user.xp and user.tier, writes stage completion activity. Maintains streak (stage completion counts as weekly activity). Does NOT increment quest.completedCount until all stages done
- **onQuestAdded** — Increments quest.addedCount. Checks creator XP milestones (10, 50, 100, 500 adds)
- **weeklyStreakCheck** — Scheduled (Monday 00:00 UTC). Resets streaks for users with no completion in the past 7 days (respects streak freezes)
- **monthlyStreakFreezeReset** — Scheduled (1st of month). Resets streakFreezeAvailable to 1 (or 3 for Pro)
- **computeLeaderboards** — Scheduled (hourly). Writes precomputed leaderboard documents for weekly, friends, category, and global rankings (top 100 each)
- **onFriendAccepted** — Increments friendCount on both users
- **onReport** — Increments reportCount. If reportCount >= 3, sets quest.isHidden = true pending review
- **onAccountDeleted** — Sets creatorId to "deleted" on all user's public quests, queues username for 30-day hold, removes user data per GDPR
- **keywordFilter** — Called on quest create/update. Scans title and description against blocklist. Flags matches for review queue

### Client-Side (no server round-trip)
- Share card generation (RepaintBoundary canvas render)
- QR code generation
- Block builder logic and validation
- Explore feed sorting (client-side reranking of Firestore query results)

---

## 14. Monetization

### Free Tier
- Unlimited personal quests
- Full Quest Blocks builder (all 14 blocks)
- Access to public feed and leaderboards
- Friend challenges
- Photo proof only
- Standard share cards (SideQuest branded)
- 1 streak freeze per month
- Banner ads on Explore and Leaderboard screens

### SideQuest Pro ($4.99/month or $39.99/year)
- Ad-free experience
- **Video proof** up to 30 seconds
- Premium share card designs (additional templates, custom color themes)
- Detailed analytics (quest completion trends, intent breakdown charts, friend comparison)
- Priority placement when creating public quests
- 3 streak freezes per month
- Exclusive "Pro" badge and profile flair
- Unlimited quest history (free tier archives after 6 months)
- Early access to new Quest Blocks as they're released

Managed via RevenueCat for unified App Store + Play Store billing.

---

## 15. Security Rules (Firestore)

- Users can only read/write their own user document
- Users can read any public quest; only creator can edit/delete
- Users can only read/write their own userQuests subcollection
- Friendships readable by both participants; only requester can create, only receiver can accept
- Challenges readable by sender and receiver only
- Activity feed readable by friends of the actor (respects blocked users list)
- Reports: any user can create; only moderators can read/update
- QualitySignals: any user can create one per quest; signals are write-once
- Cloud Functions use admin SDK for cross-user writes (XP, leaderboards, moderation)
- Blocked users: enforced client-side for reads, server-side for writes (challenges, friend requests)

---

## 16. V2 Roadmap — AI Integration

AI is a natural fit for SideQuest but is explicitly deferred from MVP to keep scope tight. The architecture is designed so AI features can be added without schema migrations — quest data is structured JSON, intent tags are enums, and user intentStats are pre-built.

### 16.1 AI-Assisted Quest Building ("Quest Copilot")

**Conversational builder:** User describes what they want in natural language ("I want to do something adventurous outdoors with my roommate this weekend") and AI suggests a complete block configuration that the user can accept, tweak, or rebuild manually. The blocks still snap into the builder so the user sees and owns the structure.

**Block suggestions:** As the user adds blocks, AI suggests complementary ones. Added a Location block for "any beach"? AI suggests a Constraint block ("no shoes allowed") or a Prompt block ("What did you find in the sand?").

**Title/description polish:** User writes a rough title, AI offers a punchier version. "Go hiking" → "Summit a trail you've never been on."

**Template generation:** AI generates themed quest packs based on context — "5 quests for a road trip to Nashville," "A week of connection quests for long-distance friends."

**Long-term vision:** AI builder becomes a potential primary creation method if quality is high enough, sitting alongside the manual block builder as an equal option.

### 16.2 AI-Powered Quest Discovery & Recommendations

**Personalized feed ranking:** Use intent stats, category preferences, completion history, friend activity, and location to rank the Explore feed.

**"What should I do right now?" button:** Considers time of day, weather, day of week, recent completion patterns to suggest 1–3 quests. This is the killer feature for the moment someone is bored and needs a push.

**Friend-aware suggestions:** "3 of your friends completed this quest" or "Sarah challenged you to something similar."

**Seasonal/trending intelligence:** AI identifies emerging patterns and surfaces them. "Hot this week: sunrise quests."

### 16.3 AI Quest Moderation (Safety)

**Proof screening:** Vision model scans proof photos for inappropriate content. Flags for human review rather than auto-rejecting.

**Quest content review:** AI scans quest titles/descriptions for harmful content before publishing to the public feed.

### 16.4 Technical Considerations for v2

- Quest block data is already structured JSON — trivially serializable as LLM context
- Intent tags and categories are enums — clean signals for recommendation models
- User intentStats field is pre-built in the data model for personalization
- Start with Cloud Functions calling an LLM API (Gemini/Claude), graduate to a trained model at scale
- Budget: start with batched recommendations (computed hourly, cached) rather than real-time per-request inference

---

## 17. MVP Cuts (Explicitly Out of Scope)

- No AI features (see Section 16 — v2 roadmap)
- No quest comments (reactions only in MVP)
- No group quests with shared progress tracking (v2)
- No quest templates / quest packs (v2)
- No in-app messaging / chat (v2)
- No sponsored quests (v2)
- No video proof playback in-feed (photo thumbnail only, tap to view)
- No profile privacy toggles (all profiles public in MVP)
- No quest editing after creation (delete and recreate)
- No offline mode (requires connectivity)
- No social graph import from Instagram/Snapchat (v2)
- No in-person QR code friend adding (v2 — strong campus feature)

---

## 18. Onboarding Flow

1. **Welcome screen** — "Stop scrolling. Start doing." Single CTA "Get Started"
2. **Sign up** — Email or social auth + date of birth (age gate)
3. **Profile setup** — Display name, username, avatar (skip-able)
4. **What drives you?** — Pick 2+ intent tags (Growth, Connection, Fun, Challenge, Explore, Create) with descriptions of each
5. **Pick your playgrounds** — Select 3+ categories from the predefined list
6. **Starter quests** — Auto-populate 3 seed quests based on selected intents + categories, pre-built with relevant Quest Blocks ("Take a photo at sunrise" with Location: Anywhere, Proof: Photo, Intent: Explore, Difficulty: Easy)
7. **Home screen** — Quest list with starter quests ready to go

---

## 19. Success Metrics (MVP)

- **Activation:** % of signups who complete onboarding + add 1 quest in first session
- **Core loop:** % of weekly active users who submit at least 1 proof per week
- **Builder engagement:** Average blocks per created quest (target: 3+)
- **Retention:** Day 7 and Day 30 retention
- **Social:** Average friends per user, % of users who send a challenge
- **Sharing:** % of completions that result in a share action, share-to-install conversion rate
- **Quality:** Average "Worth It" ratio on public quests (target: >70%)
- **Safety:** Average time-to-review for reported content (target: <24 hours)
- **Mission alignment:** % of quests with Connection or Growth intent tags

---

## 20. Open Questions

1. Should streak be weekly (bucket list pacing) or configurable by user?
2. Video proof: 30 seconds firm, or should Pro get 60?
3. Quest Blocks: should users be able to create and save custom block presets ("My Adventure Template")?
4. Share cards: should we A/B test different card designs to optimize share-to-install conversion?
5. Community notes: what's the minimum rating threshold before quality signals affect feed ranking?
6. Moderation: at what user count do we need to hire dedicated moderators vs. Eli + Chris handling it?
7. AI integration: start with LLM API calls (Gemini/Claude) or invest in a lightweight recommendation model from the start?
8. Icon style: outlined vs filled vs custom illustration? (Recommend: Lucide icons, outlined style, for consistency and availability)

---

## 21. Competitive Research (TODO)

**Action item:** Before development begins, download and complete 3 quests in each of the following apps to understand UX friction points firsthand:

- **Buckist** — Bucket list app (personal lists, no social)
- **Habitica** — Gamified habit tracker (RPG mechanics)
- **GoChallenge / Dare App** — Social challenge apps
- **BeReal** — Proof-of-life social (spot-check mechanic reference)
- **Strava** — Social fitness with leaderboards and challenges (competitive social reference)
- **Duolingo** — Gamification gold standard (streak, XP, leagues reference)

Document: What do they do well? Where do users churn? What's missing that SideQuest provides?

---

## 22. Task Decomposition (AI Development Phases)

### Phase 1 — Foundation (Sessions 1–4)
- Flutter project scaffolding with folder structure
- **Design system:** app_colors.dart, app_typography.dart, app_spacing.dart, app_shadows.dart, app_radius.dart, app_theme.dart (light + dark ThemeData)
- **Core components:** sq_button, sq_card, sq_input, sq_chip, sq_toast, sq_bottom_sheet
- Shared types/models as Dart classes with Freezed for immutability
- Block interface contract (typed config in, widget out — shared by all 14 blocks)
- Firebase project setup (Auth, Firestore, Storage, FCM)
- GoRouter navigation skeleton with bottom nav
- Auth flow (signup, login, logout, Apple/Google social, age gate)

### Phase 2 — Core Data & Blocks (Sessions 4–8)
- Firestore security rules
- Quest data model with blocks JSON structure
- Quest CRUD operations (create, read, update status, delete)
- Quest Blocks builder UI (block tray, drag-and-drop, magnetic snap animations, real-time preview)
- All 14 block widgets (subagent per block, shared interface)
- Quick Create shortcut flow
- UserQuest subcollection management (including repeatable quest support)
- XP calculation service with block-aware bonuses and creator XP milestones
- Streak tracking logic with freeze support

### Phase 3 — Screens (Sessions 9–16)
- Home screen (personal quest list with block summary icons on cards)
- Quest detail screen (full block breakdown + proof gallery)
- Explore screen (algorithm-blended feed with category + intent filters, prefix search)
- Proof submission flow (camera/gallery + caption + prompt answer + external URL link)
- Share card generation (RepaintBoundary canvas render, platform-specific formats)
- Share flow (platform icon row, 2-tap share, deep link generation)
- Profile screen (badge showcase, intent breakdown, trophy case, stats)
- Leaderboard screen (weekly, friends, category, global — in that priority order)
- Activity feed screen (Instagram Stories-style ranking, friend + public content)

### Phase 4 — Social & Safety (Sessions 17–21)
- Friend request system (send, accept, decline, remove)
- Friend search (username + display name + contact sync)
- Challenge flow (pick quest → pick friend → send message → challenger XP on completion)
- Activity feed population (on quest completion triggers)
- Reactions on friend activity
- Community quality signals (Worth It / Needs Work on public quests)
- Community proof spot-checks (Legit? / Hmm?)
- Report + block + hide system
- Keyword filter on quest publish
- Deep link invite system (share profile/quest to non-users)
- Moderation policy page

### Phase 5 — Monetization & Polish (Sessions 22–26)
- AdMob integration (banner placements on Explore + Leaderboard)
- RevenueCat subscription integration (Pro tier unlock, video proof gate)
- Onboarding flow with intent + category selection + starter seed quests
- Push notification setup + all triggers
- Seed quest library (100+ curated quests loaded into Firestore)
- App icons, splash screen, store screenshots
- Performance profiling + optimization pass
- Platform-specific share kit integration (Snap Creative Kit, Instagram Stories)
- Admin moderation queue (web dashboard)
- TestFlight / internal testing track deployment
- App Store / Play Store submission with correct age rating and UGC flags
