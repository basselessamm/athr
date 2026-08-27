# ATHR (أَثَر) — Islamic App Specialized Audit Report

**Date:** 2026-08-25 · **Version audited:** 1.0.0+1 · **Commit:** `0298f07`
**Scope:** Full specialized audit per Islamic Mobile App Audit Mode — religious content integrity, calculations, Arabic typography, privacy, reliability, UX, store readiness.
**Method:** Static code analysis (all 79 Dart files), programmatic dataset validation of all bundled JSON corpora against accepted standards, dependency/platform-config review, `flutter analyze` + full test suite execution.

---

## VERDICT

| Gate | Status |
|---|---|
| Religious Content Integrity | ⚠️ PASS WITH CONDITIONS |
| Calculation Integrity | ⚠️ PASS WITH CONDITIONS |
| Mobile Quality | ❌ FAIL |
| UX / Respectful Presentation | ✅ PASS |
| Accessibility | ⚠️ PARTIAL |
| Privacy | ✅ PASS (exemplary) |
| Reliability | ❌ FAIL |
| Trust & Transparency | ⚠️ PARTIAL |

**Overall: NOT production-ready. GO for internal testing, NO-GO for public release** — consistent with the repo's own `production_readiness_final.md`. The religious datasets themselves are remarkably sound (verified programmatically below); the blockers are engineering-reliability defects around notifications, seeding resilience, and platform configuration.

---

## 1. FEATURE INVENTORY (discovered from code)

Present: Quran mushaf (page-flip reader), Tafsir (Al-Muyassar), Hadith (Bukhari + Muslim, Arabic), Azkar/Duas (134 categories, from كتاب "الذكر والدعاء والعلاج بالرقى" لسعيد القحطاني), Prayer times (aladhan API) + Athan audio notifications, Hijri date display (via aladhan), Qibla (**absent**), Situations (8 life-situation guides), Muhasaba (daily self-accountability checklist), Threads of Return (capture/resurface system with optional reminders), Search, Favorites/legacy migration, Settings (theme, font size, calculation method, per-prayer notification toggles).

Absent: Qibla compass, Ramadan-specific features, Zakat tools, Tasbeeh counter as standalone, AI features (none present — no AI-risk surface), ads/analytics/tracking (none present).

## 2. RELIGIOUS DATASET INTEGRITY — PROGRAMMATICALLY VERIFIED

### Quran text (`quran_flutter` 1.0.3 → Tanzil.net Uthmani; runtime source)
- ✅ 6,236 ayahs; every surah's ayah count matches the Hafs standard exactly; numbering contiguous 1..n in all 114 surahs; zero duplicates; zero empty texts.
- ✅ Basmala handling verified end-to-end: 1:1 is the Basmala itself; surah 9 correctly exempted; app double-guards against duplication (`book_page_widget.dart:298-306`); package constant codepoint-matches asset bytes.
- ⚠️ Two divergent orthographic editions ship in one binary: runtime Uthmani rasm (Tanzil, with dagger alifs/pause marks) vs `assets/json/quran_text.json` (imlaa'i-style, e.g. `الرَّحْمَنِ` without dagger alif). The JSON edition is used **only** as a pk→(surah,ayah) join key for Tafsir seeding and is never displayed — functionally safe but ~4.3 MB redundant weight and a latent divergence hazard.

### Tafsir (`tafseer.json` → DB)
- ✅ Join alignment **verified correct**: tafseer rows reference `quran_text.ayah` pks; pk sequence strictly follows reading order (pk1=1:1 … pk8=2:1 … pk6236=14:6); edition filter `tafseer == 1` = التفسير الميسّر (content samples confirm).
- ✅ Edition 1 coverage: 6,236/6236 ayahs, 0 dangling refs, 0 empty texts.
- ❌ No provenance stored or shown beyond the label "التفسير الميسّر": no author (المكتب التعليمي للسعودية), no edition info anywhere in-app (`verse_bottom_sheet.dart:285-290`, table has no source column — spec planned one at `TECHNICAL_SPECIFICATION.md:107`).
- ⚠️ A second complete edition exists unused in the payload (id=2 = Tafsir al-Jalalayn by content signature).

### Hadith (`bukhari.json`, `muslim.json` → AhmedBaset/hadith-json layout)
- ✅ Bukhari: 7,277 hadiths, 97 chapters. Muslim: 7,459 hadiths, 57 chapters.
- ✅ Zero null/duplicate `idInBook`, zero dangling chapter references, zero empty Arabic texts in either book.
- ✅ Attribution correct end-to-end: reference string `"صحيح البخاري - حديث N"` built from JSON metadata title (`db_seeder.dart:213-234`) and rendered under each matn (`hadith_page_widget.dart:124-165`).
- ⚠️ Dataset carries no grading metadata (none exists in source) — acceptable since only the two Sahihain are included; app correctly never asserts grades it doesn't have.

### Azkar (`duas.json`)
- ✅ All 134 categories carry footnotes/references (e.g., "البخاري 8/171 ومسلم 4/2061"); author attribution present in the introduction entry (سعيد بن علي بن وهف القحطاني, 1409هـ). Zero empty texts.
- ❌ References are appended to body text while the dedicated `dua_table.reference` column is **never populated** (`db_seeder.dart:122-124`) → the styled reference UI never renders (`azkar_reading_screen.dart:316-358`) and Azkar captures store **no citation** (`azkar_reading_screen.dart:152-157`). This violates the project's own guardrail ("كل عنصر ديني في الواجهة لازم يظهر مصدره", `TECHNICAL_SPECIFICATION.md:306`).

## 3. CRITICAL FINDINGS (ranked)

### P0 — Release blockers
1. **Situations hadith resolver is broken** — `situations_providers.dart:111` loads only the first 120 rows of the target book, but target chapters sit at array indices 2289 (الاستقراض), 6066 (الدعوات), 6172 (الرقاق) — verified unreachable. Users see "لا يوجد حديث مطابق محفوظ محليًا لهذا الموقف" for most situations. Presenting an incomplete religious-content feature is worse than omitting it. Also situation #8 maps to a confessed wrong category ('دعاء طرد الشيطان ووساوسه' instead of existing 'دعاء الغضب', line 77).
2. **Notification cold-start gap** — `NotificationService.init()` is lazily called only from schedule/cancel/show paths; nothing calls it at startup. `getNotificationAppLaunchDetails()` therefore never runs on cold launch → tapping a notification that cold-starts the app delivers **no deep link** (`notification_service.dart:43-47`; handler registered at `main.dart:60` but init never invoked).
3. **Release build signs with debug keystore** — `android/app/build.gradle.kts:32-42` (`signingConfig = signingConfigs.getByName("debug")`). Not distributable.
4. **iOS is effectively non-functional** — no location usage descriptions in Info.plist (geolocator would fail/crash), no Podfile (CocoaPods integration absent → plugins won't build), Android-only notification initialization (`notification_service.dart:30-39`), `requestPermission()` returns false on iOS (`:338`). Either fix or declare Android-only.
5. **Partial-seed becomes permanent** — one emptiness guard covers both hadith books (`db_seeder.dart:36-42`); if the process dies between the two multi-MB batches, installs keep Bukhari without Muslim forever. No expected-count validation, resume, or version marker; asset updates can also never propagate to existing installs.

### P1 — High
6. **Prayer alarms silently expire** — scheduling covers a rolling ~31-day window; nothing reschedules on app start/resume (zero WidgetsBindingObserver in lib/). After a month of not opening the app, Athan stops.
7. **Exact-alarm permission not requested for thread reminders** — gate exists only in `schedulePrayerNotifications` (`notification_service.dart:197-204`), absent in `scheduleReminderIntent` (`:140-173`) → Android 14+ users with revoked SCHEDULE_EXACT_ALARM get silently degraded reminders.
8. **Explicit bookmarks clobbered by auto last-read** — one SharedPreferences keyspace serves page-flip autosave, AppBar bookmark action, and per-ayah save (`bookmark_provider.dart:29-31`; writes at `quran_reading_screen.dart:260-263`). Any browsing destroys a deliberate bookmark despite UI promising otherwise.
9. **Quran font-size setting is dead for the Quran** — slider labeled "حجم خط القرآن والأذكار… يطبّق على تجربة القراءة" (`settings_screen.dart:60-103`) affects azkar/hadith/search/situations but the mushaf ignores it entirely (uses clamped system textScaler 0.9–1.32, `quran_reading_screen.dart:213-215`). Misleading functional claim about the headline feature.
10. **Hadith/Azkar search is diacritics-sensitive** — raw SQL LIKE over fully-vocalized corpora (`app_database.dart:102-105,297-321`); searching unvocalized queries misses matches. A normalizer exists but applies only to the in-memory Quran scan — inconsistent semantics across tabs.
11. **Canonical IDs use autoincrement row ids** — threads store `hadith.id` (DB row id) (`hadith_reading_screen.dart:147-149`); any reseed with changed order repoints historical threads to wrong hadiths. Use stable `book+idInBook`.
12. **google_fonts runtime fetching undermines offline-first claim** — Amiri (all scripture) and Cairo (UI) download at runtime; no bundled fonts (`pubspec.yaml` fonts section empty; README.md:18 overstates offline capability). First launch truly offline renders fallback fonts.
13. **No background audio at all** — streaming recitation dies on backgrounding/screen lock; no audio_service/background mode, no audio focus config (`pubspec.yaml:30-55`, manifest). Reciter selection resets every visit (`quran_audio.dart:263-268,111`).
14. **Stale prayer data across midnight** — no lifecycle/date-change invalidation; card shows yesterday's schedule if left open across midnight until manual refresh (`prayer_times_card.dart:154-165`); `today` matching uses device-local date vs prayer-location timezone (`prayer_times.dart:104-114`).

### P2 — Medium
15. Azkar granularity is category-level: one row/one counter per whole category (~25 zikr entries merged, `db_seeder.dart:115-125`); repetition parser detects only ~12/19 explicit count patterns; first match governs the entire category — structurally cannot represent per-zikr counts accurately.
16. Quran search O(6236) normalize-and-scan per keystroke on UI isolate + stale-response race (`search_providers.dart:107-130`) + silent error swallowing (`:131-139`).
17. Unbounded TTL-less caches in SharedPreferences (prayer months, last location) keyed on 2-dp coords (~1.1 km grid) defeating the "refresh location" affordance (`prayer_times.dart:279-331`).
18. `tz.setLocalLocation` never called — currently harmless by accident; fragile (`notification_service.dart`, `prayer_times.dart`).
19. Notification ID hash collisions possible across prayer/reminder domains (`notification_service.dart:132-138`).
20. Crash vectors: bare `int.parse` on route segment (`app_router.dart:55`); corrupt persisted bookmark values unvalidated → crash loop on Quran tab (`bookmark_provider.dart:33-41`, consumed in build at `quran_list_screen.dart:109`).
21. Dead code/dead weight: entire `lib/core/widgets/page_flip/` tree + `page_flip_builder` dep; `DatabaseSeeder.seedDatabase()` never invoked → daily sunnah/task tables permanently empty + dead providers; `dailyVerseProvider` landmine; ~4.3 MB duplicate quran_text.json.
22. Fire-and-forget async work: deep-link closure discards future with no error zone (`main.dart:61-82`); no runZonedGuarded/FlutterError.onError anywhere.
23. Missing sajdah markers (no U+06E9 anywhere; no logic) — feature gap for a mushaf experience.
24. Premature success claims: instant "بدأت التلاوة…" snackbar before load result (`verse_bottom_sheet.dart:137-141`); copy button always claims success.
25. Search/favorites taps navigate without ayah param, losing position (`search_screen.dart:154`, `favorites_screen.dart:126`).

## 4. PRAYER TIMES / HIJRI METHODOLOGY DISCLOSURE

- Source: api.aladhan.com v1 calendar endpoint; method user-selectable among **3** (Egyptian 5, MWL 3, Umm al-Qura 4), default Egyptian; persisted and cache-keyed correctly (`prayer_times.dart:148-178,329-331`, `settings_screen.dart:167-187`).
- ⚠️ **Asr school hardcoded `school=0` (Shafi'i/Standard)** (`prayer_times.dart:292`) — Hanafi followers get incorrect Asr times with no option or disclosure. This is a genuine fiqh-methodology gap.
- ⚠️ High-latitude rules not configurable/disclosed (API defaults apply silently).
- ⚠️ Hijri date shown from API response (Umm al-Qura basis implied) with **no methodology disclosure** (`prayer_times_card.dart:118-122`) — calculated Hijri differs from local moon-sighting authorities regionally; the app should state its basis.
- Timezone handling is actually solid: tz database from API meta, wall-clock TZDateTime construction, DST-safe (`prayer_times.dart:334-365`).

## 5. PRIVACY & PERMISSIONS

Exemplary posture, verified: no analytics/ads/tracking/cloud sync; all religious-behavior data (muhasaba, threads, reflections, bookmarks) stays local SQLite/prefs; location used only on explicit user tap, cached locally; no secrets committed (repo-wide scan clean). Notification permission requested with context before scheduling. Gaps: permanently-denied location offers no `openAppSettings` escape hatch and no manual-location alternative (users who refuse GPS simply lose prayer times — significant for a privacy-respecting audience); exact-alarm permission flow inconsistent (P1 #7).

## 6. ARABIC TYPOGRAPHY & RTL

Strong: forced ar_SA locale + explicit RTL wrappers across surfaces; justified RichText mushaf layout; correct Arabic-Indic footer numerals; dark mode dual themes; textScaler clamp prevents accessibility scaling from destroying mushaf layout (though clamp choice means large-accessibility settings barely affect Quran text — see P1 #9 conflict). Risks: network-dependent scripture font (P1 #12); ornament-digit stacking via Stack relies on glyph metrics rather than Amiri's designed U+06DD ligature behavior (`book_page_widget.dart:351-371`); decorative bookmark ribbon on odd pages may imply saved-position semantics (`:142-162`). No real-device rendering matrix evidence in repo (reports show emulator-only visual QA, API 28).

## 7. RESPECTFUL UX (verified)

Genuinely de-gamified: anti-perfectionism framing in muhasaba ("سجل اليوم كما كان فعلًا… الهدف هو الصدق مع النفس لا المثالية"), azkar copy explicitly avoids invented counts ("لا يرد عدد صريح في هذه المادة…"), thread reminders opt-in only with "بلا إشعارات تلقائية", no streaks/scores/badges anywhere, conservative repetition parser refuses to guess religious counts (tested). No dark patterns, no ads. This is a model implementation of Section 13 principles.

## 8. QUALITY GATE ANSWERS

- **Religious integrity:** Datasets verified sound and correctly aligned; attribution correct for hadith; azkar references present-but-buried; tafseer provenance thin; situations feature ships missing content (must fix or cut).
- **Calculation integrity:** Transparent method selection (3 methods) but Asr school locked and undisclosed; Hijri methodology undisclosed; alarm window expiry undermines dependability.
- **Mobile quality:** Fails on release signing, iOS support, notification cold-start, lifecycle observers.
- **UX:** Calm, respectful, friction-light journeys; capture→return loop coherent and tested.
- **Accessibility:** Good RTL/semantics foundations; Quran font-setting conflict unresolved; no Arabic screen-reader testing evidence.
- **Privacy:** Exemplary; add location-denied alternatives.
- **Reliability:** Notification pipeline must be hardened (cold-start, expiry, exact-alarm, seed resilience) before users depend on Athan timing.
- **Trust:** Add edition/source disclosures (Tanzil, Al-Muyassar authorship, al-Qahtani azkar already attributed, aladhan method + Hijri basis) in an in-app "المصادر" screen.

## 9. ITEMS FOR QUALIFIED HUMAN SCHOLARLY REVIEW (cannot be certified programmatically)

1. **Hadith corpus fidelity**: AhmedBaset/hadith-json numbering conventions differ across print editions of Bukhari/Muslim (e.g., Fath al-Bari numbering vs other conventions). Spot-check ~20 well-known narrations against canonical print editions before public release; disclose which numbering convention references use.
2. **Tafsir Al-Muyassar text fidelity** vs printed edition; verify publisher attribution string.
3. **Azkar book fidelity** (repetition counts, wording) vs al-Qahtani's printed Hisn-style text; resolve the ~7 undetected repetition patterns manually.
4. **Asr madhhab handling**: product decision + disclosure needed (add Hanafi option).
5. **Hijri presentation**: decide whether to disclose "حساب فلكي (أم القرى)" and/or add ±1 day adjustment.
6. Verse-of-sajdah markers: add with scholarly sign-off on the 15-location list (Hafs convention).

## 10. REMEDIATION ORDER (recommended)

**Wave 1 (blockers):** fix situations resolver (remove limit / search whole book) or hide feature; call `NotificationService.init()` during bootstrap; release keystore; partial-seed repair (per-book guards + expected counts + version marker); remove/fix iOS folder.
**Wave 2 (trust & reliability):** boot/startup rescheduling hook for prayer alarms; exact-alarm gate for reminders; separate pinned-bookmark keyspace; wire fontSizeProvider into mushaf or relabel; normalized hadith search (store normalized column or FTS); populate dua reference column; stable canonical IDs; bundle fonts.
**Wave 3:** Asr school option + methodology disclosures screen; midnight/lifecycle invalidation; delete dead code (page_flip/, seedDatabase path, duplicate quran_text.json after migrating seeder to package data or vice versa); search isolate/race fixes; cache eviction policy.
