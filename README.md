# SideQuest

> Stop scrolling. Start doing.

A gamified social bucket list app where users create quests, complete them with photo/video proof, earn XP and badges, and share the results. Built for people who want to do more — and bring their friends along.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod (code generation) |
| Navigation | GoRouter |
| Backend | Firebase (Auth, Firestore, Storage, FCM) |
| Cloud Functions | TypeScript (Node 18) |
| Models | Freezed + json_serializable |
| Ads | Google AdMob |
| Subscriptions | RevenueCat |

---

## Features

- **Quest Builder** — Modular block system (category, difficulty, location, people, time limit, stages, proof type, repeat, constraints, bonus XP, wildcards)
- **Explore Feed** — Discover public quests with intent/category filtering and a worth-it rating system
- **Proof Submission** — Photo/video proof with auto-generated share cards
- **XP & Tiers** — Novice → Explorer → Adventurer → Trailblazer → Legend
- **Badges** — Milestone, category mastery, social, and streak badges
- **Weekly Streaks** — Weekly cadence (not daily) with streak freeze support
- **Social** — Friend challenges, activity feed, leaderboards
- **Sharing** — Branded share cards formatted for Instagram, Snapchat, TikTok, X

---

## Project Structure

```
lib/
├── core/
│   ├── components/       # Shared SQ-prefixed UI components
│   ├── constants/        # Enums: categories, intents, difficulties, tiers, badges
│   ├── theme/            # Design tokens: colors, typography, spacing, radius, shadows
│   └── utils/            # Validators, share card generator, JSON converters
├── features/
│   ├── auth/             # Sign in, sign up, age gate, welcome
│   ├── onboarding/       # Intent picker
│   ├── home/             # Personal quest list
│   ├── explore/          # Public quest discovery
│   ├── quest_builder/    # Block-based quest creation
│   ├── quest_detail/     # Quest view + add to list
│   ├── proof/            # Proof submission + share card
│   ├── activity/         # Activity feed + reactions
│   ├── social/           # Friends + challenges
│   ├── leaderboard/      # Global + weekly rankings
│   ├── profile/          # User profile + badge showcase
│   └── settings/         # Account, notifications, subscription
├── models/               # Freezed data models
├── repositories/         # All Firestore access (never skip this layer)
├── services/             # Business logic (seed, share, etc.)
└── providers/            # Riverpod providers
```

---

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase CLI (`firebase-tools`)
- A Firebase project configured via FlutterFire CLI

### Install & Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Cloud Functions

```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

---

## Architecture Rules

- **Widgets → Providers → Repositories → Firestore.** Never skip layers.
- All Firestore reads use `.withConverter<T>()` for type safety.
- No raw color/font/spacing values in widget code — use `AppColors`, `AppTypography`, `AppSpacing`, etc.
- No `Navigator.push()` — use `context.go()` / `context.push()` from GoRouter.
- No `setState()` for app state — Riverpod only.

See [`CLAUDE.md`](CLAUDE.md) for full coding conventions and [`spec.md`](spec.md) for the product specification.

---

## Publisher

Surge Studios, LLC
