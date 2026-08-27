# Midrar — APK Size Optimization Report

**Date:** 2026-08-25 · Baseline: post-audio-pass release build

---

## Headline numbers

| Artifact | Before | After | Δ |
|---|---|---|---|
| Universal APK (all ABIs) | **90.8 MB** | **74.3 MB** | **−16.5 MB (−18.2%)** |
| **arm64 APK (typical device download)** | 90.8 MB* | **31.1 MB** | **−59.7 MB (−65.7%)** |
| armeabi-v7a APK | — | 29.1 MB | — |
| x86_64 APK (emulators) | — | 32.6 MB | — |
| Android App Bundle (Play upload) | — | 69.6 MB | delivers ≈31 MB to arm64 devices |

\* before = the same 90.8 MB universal APK was the only artifact; every user downloaded all three ABIs' native code.

---

## Where the 90.8 MB actually went (measured, entry-level, compressed)

| Contributor | Before | After | Note |
|---|---|---|---|
| libflutter.so ×3 ABIs | 31.4 MB | 31.4 MB | Flutter engine — irreducible per ABI |
| libapp.so ×3 ABIs (AOT Dart) | 28.8 MB | 28.8 MB | shrinks only with less Dart code |
| libsqlite3.so ×3 (drift) | 4.4 MB | 4.4 MB | required for offline DB |
| **quran_flutter translation .txt ×30+** | **12.5 MB** | **0** | **removed — never used** |
| bukhari.json | 2.93 MB | 2.93 MB | kept (offline Hadith feature) |
| muslim.json | 2.26 MB | 2.26 MB | kept (offline Hadith feature) |
| **tafseer.json (2 editions)** | **1.51 MB** | **0.60 MB** | stripped to the shipped edition (التفسير الميسّر) |
| dex + Android res + fonts + images | ~3.0 MB | ~2.6 MB | fonts kept at full quality |
| **quran_text.json (join key only)** | **0.39 MB** | **0** | replaced by arithmetic |
| duas.json | 0.03 MB | 0.03 MB | kept |

## Every optimization performed

1. **Vendored quran_flutter → `lib/vendor/quran_core/`** (MIT, attribution preserved in `LICENSES/quran_flutter-MIT` and README).
   - Discovered `Quran.initialize()` **eagerly loaded all 30+ translation files into memory** on every Quran feature start (~40 MB text parsed on the UI isolate). The app is Arabic-only and never read them.
   - Vendored the 14-file core, **deleted the entire translation corpus and loader**, kept the Uthmani text + metadata APIs byte-identical.
   - APK: −12.5 MB. Startup: Quran init now parses 1.3 MB instead of ~41 MB.
2. **Removed the dependency** from pubspec (plus the already-dead `page_flip_builder`).
3. **Stripped `tafseer.json` to the shipped edition** (التفسير الميسّر, 6,236 rows verified complete post-strip): 13.6 MB → 3.0 MB raw, 1.51 → 0.60 MB in APK. Seeder content version bumped to 3 (one transparent re-import for existing installs).
4. **Deleted `quran_text.json` (4.3 MB raw)** — it existed only as a pk→(surah,ayah) join key for tafseer seeding. Replaced with `computeAyahPkMap()` arithmetic over the canonical Hafs counts; anchors verified by test (pk1=1:1, pk8=2:1, pk262=2:255, pk6236=114:6, strict sequential order).
5. **ABI splitting + AAB**: `flutter build apk --split-per-abi` and `flutter build appbundle`. The universal APK remains available for sideloading, but Play will deliver ~31 MB to arm64 devices.

## Intentionally NOT removed (and why)

- **Bukhari/Muslim JSON (5.2 MB)** — they ARE the offline Hadith feature. Already deflate-compressed in the APK; repacking would save nothing meaningful.
- **Amiri Regular+Bold + Cairo VF (0.66 MB)** — required for scripture rendering and every UI weight; quality preserved per the no-visible-degradation rule.
- **All 18 verified reciters** — untouched; audio remains 100% streamed (0 bytes of recitation in any artifact).
- **duas.json, quran.txt, brand assets** — all user-facing.
- **libsqlite3 ×3** — required by drift on every ABI.
- **x86_64 in the universal APK** — kept for emulator/sideloading use; Play delivers correct ABIs from the AAB.

## Verification (post-optimization)

| Check | Result |
|---|---|
| A) Release builds | ✅ universal 74.3 MB · arm64 31.1 · v7a 29.1 · x86_64 32.6 · AAB 69.6 |
| B) Exact sizes | measured from artifacts (above) |
| C) `flutter analyze` | No issues found |
| D) Full test suite | **68/68** (+2 new pk-map tests) |
| E) Quran browsing/search | vendored core API byte-identical; quran.txt bundled; tests green |
| F) Tafsir | 6,236/6,236 coverage re-verified after strip; pk-map anchors tested |
| G) Hadith | corpora untouched; 7,277+7,459 integrity tests green |
| H) Duas/situations | untouched; category-existence tests green |
| I) Bookmarks/last-read | independence tests green |
| J) Prayer calculations | real-payload parse tests green (02:37/13:07/17:17/20:49/23:19 exact) |
| K) Adhan scheduling | planner tests green; exact-minute chain proven |
| L) Audio streaming (18 reciters) | `tool/verify_audio_catalog.dart`: **All 18 paths healthy** |
| M) Audio caching | LockCachingAudioSource path unchanged (device QA item) |
| N) Player controls | state-logic tests green |
| O) Follow-along | unchanged (device QA item) |
| P) Dark/light | themes untouched |
| Q) Arabic UI | untouched; RTL enforced |
| R) Cold start | improved — Quran init no longer parses ~40 MB of translations |
| S) Notifications/deep links | deep-link + scheduling tests green |
| T) Regression | full suite + health tool + release build all green |

## Remaining opportunity (honest ledger)

1. **Per-ABI distribution is the real win** — ship the AAB; the universal APK is a sideload convenience.
2. **libapp.so ≈ 9–10 MB/ABI**: could shrink via `--obfuscate` (small) — not applied to keep stack traces debuggable for this stage.
3. **Hadith JSONs (5.2 MB compressed)**: converting the seed source to a pre-shrunk SQLite or zstd+index could save ~2–3 MB compressed — deferred (schema/migration risk vs modest gain; seeding already works and is recoverable).
4. **libflutter.so is Flutter's floor** (~8–12 MB/ABI) — not addressable without changing frameworks.
5. Translation files for *hadith* English text (`hadithTextEn`) are seeded but unused by UI — dropping the column would save ~1 MB compressed; deferred to avoid a schema change this close to release.
