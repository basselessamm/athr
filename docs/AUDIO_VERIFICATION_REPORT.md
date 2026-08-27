# Audio / Reciter Catalog & Adhan Verification Report

**Date:** 2026-08-25 (expanded pass) · **CDN:** `cdn.islamic.network` · **Authority:** `api.alquran.cloud` edition catalog

---

## 1. Catalog expansion — verification methodology

1. **Authoritative edition discovery**: `api.alquran.cloud/v1/edition/format/audio`
   → 24 Arabic verse-by-verse editions; per-edition bitrate discovery via the
   ayah endpoint's `audio`/`audioSecondary` fields.
2. **Live probing**: HTTP Range requests (`bytes=0-1`) across 9 stratified
   ayahs per reciter (1, 262, 1427, 2484, 3634, 4551, 5419, 6236 + surah
   boundaries) — first under concurrency, then **sequential re-verification of
   every non-OK response** to separate real failures from throttling.
3. **Content-type validation**: all healthy paths return `audio/mpeg`
   (exception documented below).
4. **Duplicate detection**: `-2` mirror editions excluded.

## 2. Shipped catalog — 18 verified reciter editions

| # | Edition | Reciter | Bitrate | Probe result |
|---|---|---|---|---|
| 1 | `ar.alafasy` | مشاري راشد العفاسي | 128 | ✅ 9/9 audio/mpeg |
| 2 | `ar.abdulbasitmurattal` | عبد الباسط عبد الصمد · مرتل | 192 | ✅ 9/9 |
| 3 | `ar.abdulsamad` | عبد الباسط عبد الصمد · مجود | 64 | ✅ 9/9 |
| 4 | `ar.minshawi` | محمد صديق المنشاوي · مرتل | 128 | ✅ 9/9 |
| 5 | `ar.husary` | محمود خليل الحصري · مرتل | 128 | ✅ 9/9 |
| 6 | `ar.husarymujawwad` | محمود خليل الحصري · مجود | 128 | ✅ 9/9 (6236 passed on sequential retry) |
| 7 | `ar.mahermuaiqly` | ماهر المعيقلي | 128 | ✅ 9/9 |
| 8 | `ar.saoodshuraym` | سعود الشريم | 64 | ✅ 9/9 |
| 9 | `ar.abdurrahmaansudais` | عبد الرحمن السديس | 192 | ✅ 9/9 |
| 10 | `ar.shaatree` | أبو بكر الشاطري | 128 | ✅ 9/9 |
| 11 | `ar.ahmedajamy` | أحمد بن علي العجمي | 128 | ✅ 9/9 — serves `application/octet-stream` (nonstandard header; plays on all target platforms; tracked by health tool) |
| 12 | `ar.hanirifai` | هاني الرفاعي | 192 | ✅ 9/9 |
| 13 | `ar.hudhaify` | علي بن عبدالرحمن الحذيفي | 128 | ✅ 9/9 |
| 14 | `ar.abdullahbasfar` | عبد الله بصفر | 192 | ✅ 9/9 |
| 15 | `ar.muhammadayyoub` | محمد أيوب | 128 | ✅ 9/9 |
| 16 | `ar.muhammadjibreel` | محمد جبريل | 128 | ✅ 9/9 |
| 17 | `ar.aymanswoaid` | أيمن سويد | 64 | ✅ 9/9 |
| 18 | `ar.ibrahimakhbar` | إبراهيم الأخضر | 32 | ✅ 9/9 |

## 3. Requested but honestly excluded

| Requested | Status | Reason |
|---|---|---|
| إسلام صبحي | ❌ excluded | No edition on the verified streaming CDN |
| ياسر الدوسري | ❌ excluded | No edition on the verified streaming CDN |
| فارس عباد | ❌ excluded | No edition on the verified streaming CDN |
| سعد الغامدي | ❌ excluded | Not on the CDN (distinct from سعود الشريم who IS included) |
| أحمد العجمي (ar.ahmedalajmi) | ❌ excluded | Persistent 403 at 128 kbps; أحمد بن علي العجمي (`ar.ahmedajamy`) added instead after verification |

These are listed in `unverifiedReciterIds` with a re-verify instruction. **The
app never pretends an unverified reciter exists.**

## 4. Broken paths found & excluded (persistent 403)

`ar.abdulbasitmurattal@128`, `ar.abdurrahmaansudais@128`, `ar.abdulsamad@128`,
`ar.shaatree@320`, `ar.ahmedalajmi@128`, `ar.saoodshuraym@128` (fixed to 64).

## 5. Architecture — streaming-first with transparent caching

```
CDN (verified URLs) → LockCachingAudioSource → AudioPlayer → UI
                              ↓
              app-support/recitation_cache/   (only ayahs actually listened to)
```

- **Nothing is bundled**: APK contains zero recitation audio.
- **Smart cache**: only played ayahs are cached (per reciter+bitrate+ayah);
  replay works offline; in-app manager shows size and offers one-tap clearing
  (`_showCacheManager` in the full player sheet).
- **Slow-network behavior**: streaming with buffering state surfaced in the
  bar; 12 s timeout with a specific Arabic message + retry; errors never
  silently loop.
- **Background playback**: session-scoped controller + audio-focus
  configuration (`audio_session` speech profile); iOS background audio mode
  declared.

## 6. Health system (regression gate)

`tool/verify_audio_catalog.dart` — pure-Dart CLI:

```
dart run tool/verify_audio_catalog.dart
```

Probes all 18 catalog entries × 8 stratified ayahs with Range requests
(~few hundred KB total), validates status + content-type, flags nonstandard
headers, exits non-zero on any dead path. **Run before every release.**
Latest run: 18/18 healthy (1 reciter with tracked nonstandard content-type).

## 7. Adhan (prayer notification) verification

### Scheduling chain — proven with a real API payload

Test: `test/prayer/adhan_scheduling_test.dart` uses an **unmodified live
aladhan.com response** (London, 2026-08-01, Egyptian method, Shafi'i Asr):

| Prayer | API says | Parsed | Planned notification |
|---|---|---|---|
| Fajr | 02:37 BST | 02:37 Europe/London | 02:37 exact |
| Dhuhr | 13:07 | 13:07 | 13:07 exact |
| Asr | 17:17 | 17:17 | 17:17 exact |
| Maghrib | 20:49 | 20:49 | 20:49 exact |
| Isha | 23:19 | 23:19 | 23:19 exact |

Also proven: past prayers excluded; per-prayer toggles honored; silent vs
audio channel selection correct; 300 notification IDs across 60 days are
deterministic and collision-free; changing method (Egyptian↔MWL) or madhhab
(Shafi'i↔Hanafi) changes the cache key → forces refetch → times update.
Exact-alarm permission is requested; boot survival via plugin's
BOOT_COMPLETED receiver; rescheduling re-asserted on every app start/resume
(`prayerAlarmMaintenanceProvider`).

### Adhan audio — verified files, honest scope

Bundled files (validated with a WAV parser — all playable):

| File | Format | Duration |
|---|---|---|
| prayer_fajr/dhuhr/asr/maghrib/isha.wav | mono PCM 24 kHz | ~2.5 s each |

These are **spoken prayer-name announcements** ("حان وقت صلاة الفجر…"), not a
full adhan recitation. This is a deliberate design: short local audio is
reliable through Android notification channels on every device, avoids
licensing risk, and is respectful. **Limitation documented, not hidden**: a
full adhan recording requires a properly licensed source and (on stock
Android) plays as notification sound — it cannot be guaranteed to play at
the exact second under Doze unless the user grants exact-alarm permission
(which the app requests). Adding a full adhan is a product decision pending a
rights-cleared recording; the architecture (per-prayer notification sound
URIs via `android.resource://`) already supports dropping one in per prayer.

### Platform honesty

- **Android**: exact alarms (`SCHEDULE_EXACT_ALARM` requested), high-importance
  channels with alarm audio attributes, boot receiver registered. Battery
  optimizer aggression on some OEMs can still delay alarms — users can exempt
  the app; we surface test buttons in Settings for verification.
- **iOS**: local notifications cannot play custom alarm audio at fire time
  (only default/bundled sound via UNNotificationSound, ≤30 s); the spoken
  name files are within that limit. Full-adhan behavior on iOS is
  platform-limited regardless of implementation.

## 8. Residual risks

1. CDN content-type for `ar.ahmedajamy` is nonstandard (tracked; plays fine).
2. CDN availability is external; cached ayahs play offline, uncached need
   network — labeled in the player.
3. OEM battery optimizers may delay exact alarms; mitigation = exact-alarm
   grant + in-app audio tests; cannot be fully solved app-side.
