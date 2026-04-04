# CLAUDE.md — SideQuest Project Instructions

## Project Overview
SideQuest is a gamified social bucket list app built with Flutter + Firebase. Users create quests using a modular block builder, complete them with photo/video proof, earn XP and badges, and share to social media.

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (with code generation)
- **Navigation:** GoRouter
- **Backend:** Firebase (Auth, Firestore, Storage, FCM, Cloud Functions)
- **Models:** Freezed + json_serializable
- **Ads:** Google AdMob
- **Subscriptions:** RevenueCat

## Architecture Rules

### File Structure
- Features live in `lib/features/<feature>/screens/` and `lib/features/<feature>/widgets/`
- Models live in `lib/models/`
- Repositories live in `lib/repositories/` — ALL Firestore access goes through repositories
- Services live in `lib/services/` — business logic that isn't data access
- Providers live in `lib/providers/`
- Shared components live in `lib/core/components/` with `sq_` prefix
- Theme tokens live in `lib/core/theme/`

### Patterns
- Use Freezed for all data models. Every model must have `fromJson`/`toJson`.
- Use Riverpod for all state. No `setState()` except in self-contained animations.
- Use GoRouter for all navigation. No `Navigator.push()`.
- Repository pattern: widgets → providers → repositories → Firestore. Never skip layers.
- All Firestore reads should use `.withConverter<T>()` for type safety.

### Naming
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Providers: `camelCaseProvider` suffix
- Screens: `PascalCaseScreen`
- Widgets: `PascalCase` (descriptive, no "Widget" suffix)
- Theme components: `sq_` prefix files, `SQ` prefix classes

## Design System — MANDATORY

### No Raw Values
**NEVER use raw color values, font sizes, padding numbers, or border radii in widget code.**
- Colors: `AppColors.sunsetOrange` not `Color(0xFFE8734A)`
- Typography: `AppTypography.cardTitle` not `TextStyle(fontSize: 18)`
- Spacing: `AppSpacing.md` not `EdgeInsets.all(16)`
- Radius: `AppRadius.card` not `BorderRadius.circular(16)`
- Shadows: `AppShadows.card` not `BoxShadow(...)`

### Component Usage
Use the `SQ` prefixed components for all UI:
- `SQButton.primary()`, `SQButton.secondary()`, `SQButton.destructive()`
- `SQCard()` for all card surfaces
- `SQInput()` for all text fields
- `SQChip()` for category and intent tags
- `SQToast.success()`, `SQToast.error()`
- `SQBottomSheet()` for all modal sheets

### Colors Quick Reference
**Light mode primary:** Navy `#1B2A4A`, White `#FFFFFF`
**Accents:** Yellow `#F5A623`, Orange `#E8734A`, Red `#D94F4F`, Teal `#2A9D8F`
**Dark mode backgrounds:** Deep Navy `#0D1B2A`, Card Navy `#1B2D45`

## Quest Blocks Contract

Every block widget implements `QuestBlockWidget`:
- Has a `BlockMeta get meta` (id, label, emoji, color)
- Accepts `isExpanded`, `onConfigChanged`, `onTap`, `onRemove`
- Returns its typed config via `onConfigChanged`
- Uses theme tokens for all styling
- Is self-contained — no dependencies on other blocks

## Code Quality

### Required for Every File
- Dart doc comment on every public class and method
- `const` constructors where possible
- `final` for all instance variables
- No `print()` — use `debugPrint()` or a logger
- No `dynamic` types except in JSON deserialization boundaries
- No `!` null assertions except on values guaranteed non-null by Firestore schema

### Required for Every Session
- Run `dart analyze` before finishing — zero warnings
- Run `flutter test` — all tests pass
- Generate a test file for every new file created
- Run `build_runner` if any Freezed or Riverpod annotations were added:
  `dart run build_runner build --delete-conflicting-outputs`

## Build & Test Commands
```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

## Git Conventions
- Branch per feature: `feature/<feature-name>`
- Commit messages: imperative, present tense ("Add quest builder screen" not "Added quest builder screen")
- Commit after each working feature — small, atomic commits
- Never commit generated files (*.g.dart, *.freezed.dart) — they're in .gitignore

## Key Reference Files
- `spec.md` — Full product specification (read Section 5 for Quest Blocks, Section 6 for sharing)
- `architecture.md` — Dart models, provider structure, router config, Firestore indexes
- `lib/core/constants/` — Enums for categories, intents, difficulties, tiers, badges
- `lib/core/theme/` — All design tokens
- `lib/models/blocks/block_config.dart` — Block interface contract

## What NOT to Do
- Do NOT create new color values — use `AppColors`
- Do NOT create new text styles — use `AppTypography`
- Do NOT access Firestore directly from widgets or providers — use repositories
- Do NOT use `Navigator.push` — use `context.go()` or `context.push()` from GoRouter
- Do NOT use `setState` for app state — use Riverpod providers
- Do NOT skip writing tests
- Do NOT use `late` unless absolutely necessary
- Do NOT store sensitive data in SharedPreferences — use Firebase Auth for tokens
