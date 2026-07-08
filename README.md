# ATHR

`ATHR` is an offline-first Flutter application for Arabic Islamic daily practice.
It is designed around a simple idea: help the user do something meaningful today,
not just browse content.

## Product Direction

- Offline only during normal runtime
- No sign-in, no cloud sync, no ads, no analytics SDKs
- Arabic-first and RTL-first experience
- Quran, tafseer, azkar, hadith, life situations, favorites, and daily actions
- Private-by-default: user data remains on-device

## Current Stack

- Flutter + Dart
- Riverpod for state management
- go_router for navigation
- Drift + SQLite for local persistence
- shared_preferences for lightweight settings
- flutter_local_notifications for reminders
- quran_flutter for Quran text and metadata
- google_fonts for Arabic typography

## Main App Structure

```text
lib/
  core/
    database/
    router/
    services/
    theme/
    widgets/
  features/
    azkar/
    challenges/
    favorites/
    hadith/
    home/
    quran/
    settings/
    situations/
    splash/
```

## Key Features Implemented

- Daily home flow with verse, hadith, dua, database-backed sunnah, and actionable task
- Quran browsing with reading progress bookmark and tafseer bottom sheet
- Azkar category browsing and reading flow
- Hadith books and paginated hadith reading
- Favorites saved locally for verses, hadiths, and duas
- Life situations screen with practical steps, verses, duas, and supporting hadith
- Progress dashboard for daily completions, favorites, and muhasaba history
- Daily muhasaba screen with local persistence and notes
- Theme mode, font size, and daily reminder settings

## Content Sources

- Quran text: `quran_flutter`
- Tafseer: seeded from `assets/json/tafseer.json`
- Quran mapping data: `assets/json/quran_text.json`
- Hadith: seeded from `assets/json/bukhari.json` and `assets/json/muslim.json`
- Duas and azkar: seeded from `assets/json/duas.json`

Important: no AI-generated religious content should be added to the app. All
religious text must come from the approved bundled sources.

## Getting Started

1. Install Flutter stable.
2. Run `flutter pub get`.
3. Generate Drift code with `dart run build_runner build --delete-conflicting-outputs`.
4. Start the app with `flutter run`.

## Quality Commands

- Static analysis: `flutter analyze`
- Tests: `flutter test`
- Regenerate database code: `dart run build_runner build --delete-conflicting-outputs`

## Notes For Development

- If Drift schema changes, regenerate `lib/core/database/app_database.g.dart`.
- The database seeds itself from bundled JSON on first launch.
- Top-level navigation is available from home, Quran, azkar, hadith, and favorites.
- Keep religious source attribution visible in the UI whenever content is shown.
