# مِدرار — Midrar

<div align="center">
  <img src="assets/brand/logo_primary_1024.png" width="120" alt="Midrar" />
  <p><em>تدفّقٌ يوميّ هادئ — a calm daily flow of Quran, Hadith, and Azkar.</em></p>
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat-square&logo=Flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=flat-square&logo=Dart&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square" />
</div>

---

## Overview

**Midrar (مِدرَار)** is an offline-first, privacy-respecting Islamic companion.
The name is classical Arabic for *continuous, abundant flow* — like rain that
does not stop. That is the product philosophy: steady daily engagement with
revelation, without streaks, guilt, or noise.

### What's inside

- **Mushaf** — full Uthmani Quran (Tanzil text), page-flip reading, per-ayah
  Tafsir (**التفسير الميسّر**), streaming recitation from verified reciters.
- **Hadith** — صحيح البخاري (7,277) and صحيح مسلم (7,459) fully offline, with
  book/chapter attribution on every narration and diacritics-tolerant search.
- **Azkar & Ad`iyah** — 134 categorized collections from *الذكر والدعاء
  والعلاج بالرقى* by سعيد بن علي بن وهف القحطاني, with inline references.
- **Prayer times** — aladhan-based, three selectable calculation methods,
  **both Asr madhhabs** (Shafi'i/Hanafi), exact alarms, honest Hijri-method
  disclosure.
- **Threads of Return** — capture any verse/hadith/zhikr into a private
  thread, reflect, and return on your own schedule. Opt-in reminders only.
- **Muhasaba** — a daily honesty checklist. No scores, no streaks, no shame.

### Principles

| Principle | Practice |
|---|---|
| Privacy by design | No accounts, no analytics, no ads, no cloud. Everything stays on device. |
| Offline first | Quran, Tafsir, Hadith, Azkar, bookmarks — fully usable in airplane mode. Prayer times cache locally; audio streaming is the only online feature and is labeled as such. |
| Religious care | Sources are attributed in-app; calculation methods are disclosed, never presented as authoritative; disputed matters are labeled as such. |
| Calm UX | No engagement mechanics around worship. Motion is subtle and reducible. |

## Tech stack

Flutter · Riverpod · Drift (SQLite) · GoRouter · flutter_local_notifications ·
just_audio · bundled Amiri/Cairo typography (OFL).

## Building

```bash
flutter pub get
flutter run --release   # debug signing for local runs
```

**Release builds require production signing** — see
[RELEASE_SIGNING.md](RELEASE_SIGNING.md). Debug-signed releases are
rejected by the build system by design.

## Content sources

- Quran text: [Tanzil.net](https://tanzil.net) (Uthmani), served by a vendored
  core (lib/vendor/quran_core, MIT — see LICENSES/quran_flutter-MIT).
- Tafsir: التفسير الميسّر (compilation, Presidency of Islamic Research, Egypt)
  via the open Quran-Tafseer dataset.
- Hadith corpus: [AhmedBaset/hadith-json](https://github.com/AhmedBaset/hadith-json)
  layout; numbering follows that dataset's `idInBook` convention.
- Azkar: سعيد القحطاني، *الذكر والدعاء والعلاج بالرقى من الكتاب والسنة*.
- Prayer timetable: [aladhan.com](https://aladhan.com) API (method selectable
  in-app; Hijri dates are astronomical Umm-al-Qura based and disclosed as such).
- Recitation: cdn.islamic.network (every reciter/bitrate pair verified; see
  `docs/AUDIO_VERIFICATION_REPORT.md`).

## License

MIT — see [LICENSE](LICENSE). Bundled fonts are licensed under the
SIL Open Font License.
