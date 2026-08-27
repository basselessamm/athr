# Midrar — Ownership Delivery Report

**Date:** 2026-08-25 · **Baseline:** commit `0298f07` (Athr 1.0.0+1) · **Delivered as:** Midrar (مِدرار)

---

## A. Audit → Fix Traceability (every confirmed P0/P1 addressed)

| # | Confirmed issue | Status | Where |
|---|---|---|---|
| P0-1 | Situations hadith resolver `limit(120)` misses chapters at indices 2289–6661 | ✅ FIXED | Full-corpus indexed SQL query + normalized full-text fallback + wrong dua category corrected (`situations_providers.dart`); regression tests |
| P0-2 | Notification cold-start deep links lost (`init()` never called) | ✅ FIXED | `init()` awaited in `main()` before `runApp`; launch-details payload delivered deterministically; invalid payloads ignored safely |
| P0-3 | Release signed with debug keystore | ✅ FIXED | Fail-fast `release` signing config reading `key.properties`/env (`MIDRAR_SIGNING_*`); secrets git-ignored; `RELEASE_SIGNING.md`; **release APK built & verified: `CN=Midrar` V2 signature** |
| P0-4 | iOS non-functional (no Podfile, no location strings, Android-only init) | ✅ FIXED (config-level) | Podfile created; Info.plist: `NSLocationWhenInUseUsageDescription`, `UIBackgroundModes: audio`, display name; Darwin notification settings; bundle id `com.midrar.app`. **Not device-verified** (see Remaining Risks) |
| P0-5 | Interrupted hadith seed permanently partial | ✅ FIXED | `seed_state_table` (schema v7) with per-dataset content versions + expected counts (Bukhari 7277 / Muslim 7459 / Tafsir 6236 / Azkar 134); incomplete → transactional delete-and-repair; bookmarks preserved across repairs |
| REL-1 | Prayer alarms expire after ~31 days | ✅ FIXED | 60-day window (3-month fetch); `prayerAlarmMaintenanceProvider` reschedules from cache at startup **and** on every app resume (WidgetsBindingObserver); midnight staleness invalidated on resume |
| REL-2 | Asr hardcoded to one madhhab | ✅ FIXED | `AsrSchool` setting (الجمهور/حنفي) persisted, sent as `school=` param, cache-keyed, disclosed in UI as legitimate scholarly difference |
| REL-3 | Hijri methodology hidden | ✅ FIXED | Disclosure on card ("حساب فلكي · قد يختلف عن الرؤية المحلية") + settings note |
| REL-4 | Bookmarks clobbered by last-read | ✅ FIXED | Independent `bookmarkProvider` (explicit) vs `lastReadProvider` (automatic); legacy keys seed last-read once; continue-reading uses last-read; regression tests |
| REL-5 | Quran font-size setting dead for Quran | ✅ FIXED | Mushaf scale = OS accessibility scale × user setting (clamped); label updated to be accurate |
| REL-6 | Diacritics-sensitive hadith/azkar search | ✅ FIXED | Schema v7 adds `hadith_text_ar_norm` / `dua_text_norm` (backfilled in migration); shared `normalizeArabic` (harakat, hamza, teh marbuta, **Farsi yeh/keheh**); wildcard-input neutralized (degenerate `%%` bug caught by test); stale-response race fixed; search errors surfaced |
| REL-7 | google_fonts runtime fetching contradicted offline-first | ✅ FIXED | Amiri + Cairo TTFs bundled (`assets/google_fonts/`, OFL); `allowRuntimeFetching = false`; offline labels honest |

## B. Additional defects found & fixed during ownership pass

1. **`gradle.properties` pinned a Linux JVM path** → Windows builds broken; removed.
2. **Dead subsystem removed**: `page_flip/` widget tree (mutating, leaky), `page_flip_builder` dep, never-seeded daily sunnah/task tables + providers + `seedDatabase()`, dead `dailyVerseProvider` landmine, unused `AthrCard`. Tables dropped cleanly in v7.
3. **Search race + silent errors**: generation token discards stale results; error state now visible.
4. **Audio lifecycle**: controller no longer `autoDispose` (playback survives navigation); reciter persisted; audio-focus configured via `audio_session`.
5. **Global error capture**: `runZonedGuarded` + `FlutterError.onError` + `PlatformDispatcher.onError` (previously silent crashes).
6. **Deep-link handler** moved out of `build()` into `initState` (was re-registered per rebuild with discarded futures).
7. **iOS `requestPermission()`** returned false unconditionally; Darwin settings now declared (runtime permission still requested through plugin API).
8. **Notification init split**: prayer-audio URI resolution deferred out of cold-start path.

## C. UI/UX Before → After (summary)

- **Identity**: أَثَر vintage-paper look → **Midrar**: deep-pine/warm-paper/brass token system; intentional dark palette (#101714 base, mint accents) rather than gray inversion; splash + launcher + adaptive icons rebuilt from the new mark.
- **Design tokens**: `AppColors` now carries semantic palette + spacing scale (4pt) + radius scale; theme consumes them (chips, snackbars, dialogs previously unstyled).
- **Home**: prayer card discloses Hijri methodology inline; continue-reading now reflects true last-read position.
- **Reader**: font-size setting genuinely scales the mushaf; explicit bookmark action renamed/clarified ("علّمة هذا الموضع") so autosave can't destroy pins.
- **Settings**: Asr madhhab dropdown with fiqh framing; calculation-method copy avoids claiming authority; honest font-size label.
- **Search**: consistent normalization across Quran/Hadith/Azkar tabs; visible error state.
- **Splash**: brand mark + wordmark on paper; native splash dark-mode aware.

## D. New Brand Identity

- **Name:** **Midrar — مِدْرَار** (classical Arabic: continuous, abundant flow — like unceasing rain). Chosen to embody steady daily practice without gamification.
- **Uniqueness checks performed** (iTunes Search API US+SA, Google Play EN+AR, GitHub Search, web search):
  - Rejected with evidence: *Wird* (2 Quran apps), *Awwab* (app), *Riwaq* (Riwaq Al Quran), *Meead* (shift app), *Manzil/Munzal* (many), *Thikra* (Zikra), *Awrad* (many), *Wasl* (Wasl Dubai), *Sakina* (2), *Itminan* (prayer app), *Tuma'nina*, *Mutmain* family (Motmaina/Motmaan/Motmaen), *Tamaneen* family (5 Play variants), *Tadabbur* (10+), *Rawnaq*, *Sadeem* (4-app suite), *Thabat* (2 Muslim apps), *Salsabeel* (Islamic apps), *Rawq* (Rwaq).
  - **Midrar**: zero store hits (US/SA), GitHub total=0 for product repos. Accepted-risk note: "Medrar" (مدرر — different word, records/registers, different category) exists; distinct root, spelling, and market. No global-uniqueness guarantee is claimed.
- **Logo**: geometric mark — a sheltering arch, a floating source-drop, and a descending stream (the midrar). No crescents, no mosque clip-art, works in monochrome and at 16 px (legibility strip generated).
- **System**: pine #2F5D50 / paper #F8F6F1 / brass #B08A3E; dark #101714 + mint #8FBFA9; Amiri (scripture) + Cairo (UI), both bundled; tone of voice: calm, non-pressuring, source-disclosing.

## E. Audio/Sheikh Verification

Full report: `docs/AUDIO_VERIFICATION_REPORT.md`. 10 reciter@bitrate pairs verified
(incl. first/mid/last ayah coverage); 1 broken reciter removed, 1 fixed to its working
bitrate, 4 broken bitrate paths excluded.

## F. Religious Content Review

**Verified programmatically (this pass):**
- Quran: 6,236 ayat, Hafs counts exact, no dupes/empties; Basmala logic correct (1:1, 2:1 merged per edition, surah 9 exempt).
- Tafsir Al-Muyassar: pk-join alignment sound; 6,236/6,236 coverage; edition filter correct.
- Hadith: 7,277 + 7,459 rows, zero null/dup ids, zero dangling chapters; attribution rendered from source metadata.
- Azkar: all 134 categories referenced; references now surfaced via `dua_table.reference`.
- Situations: all 8 dua categories exist in dataset (incl. corrected 'دعاء الغضب').

**Requires qualified human scholarly review (flagged, not altered):**
1. Hadith numbering convention of the dataset vs print editions — spot-check ~20 narrations before public launch.
2. Tafsir Al-Muyassar text fidelity + publisher attribution string.
3. Azkar repetition counts (~7 patterns not machine-detectable; parser deliberately refuses to guess).
4. Sajdah markers absent — add after sign-off on the 15-location list.
5. Hijri presentation is astronomical (Umm al-Qura) — disclosed; local-sighting users adjust externally.

## G. Test Report

- **Automated:** 53/53 passing, including new regression suites: situations resolver (deep-corpus + fallback), Asr madhhab persistence, bookmark/last-read independence + legacy seeding, seed-state repair semantics, normalization (diacritics/Farsi yeh), wildcard-input safety. `flutter analyze`: **0 errors/warnings** (2 style infos resolved during pass → final run clean).
- **Build:** `flutter build apk --release` ✅ (90.6 MB) — signed with dedicated `CN=Midrar` keystore, verified via `apksigner` (V2). Debug/release configs fully separated.
- **API verification:** aladhan + alquran.cloud + CDN probes executed live (see E).
- **Manual/device testing:** **NOT PERFORMED in this environment** (no emulator/device attached). Required before store submission: cold-start notification tap, Athan firing across reboot/DND, mushaf rendering matrix (small/large screens, font scaling, dark), audio interruption scenarios, iOS device boot.

## H. Remaining Risks (nothing hidden)

1. **iOS unproven on hardware** — config is correct-by-inspection (Podfile, plist, entitlements-free local notifications) but `pod install` + device run must be executed on macOS.
2. **APK size 90.6 MB** — dominated by bundled JSON corpora + fonts. Split-per-ABI or asset compression (e.g., SQLite prebundle) is the next optimization lever.
3. **Azkar counter model** remains category-level (one counter per category page). Per-zikr counters require data-model rework — deliberately deferred; UI copy is honest about counts.
4. **Prayer cache unbounded growth** — months accumulate in SharedPreferences; eviction policy recommended (low urgency, few KB/month).
5. **Notification ID hash space** — cross-domain collision still theoretically possible (low); separate ranges recommended in a future pass.
6. **Scholarly review items** (F above) are open by design — the product does not fabricate certainty.
7. **Medrar adjacency** accepted-risk documented in D.
8. **No CHANGELOG/version bump discipline yet** — version remains 1.0.0+1; set release version at tagging.

---

**Final gate:** Religious integrity ✅ (with flagged scholarly items) · Calculations ✅ (disclosed, dual-madhhab) · Mobile quality ✅ Android (iOS pending device QA) · UX ✅ calm/no dark patterns · Accessibility ✅ RTL + scaling + semantics foundations · Privacy ✅ exemplary · Reliability ✅ (alarms maintained, seeds recoverable) · Trust ✅ (sources + methodology disclosed in-app).

**Recommendation:** GO for Android internal testing track. Public store submission after the manual device matrix (G) and scholarly spot-checks (F).
