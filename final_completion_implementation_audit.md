# أَثَر — Final Product Completion Pass
## Implementation Audit and Acceptance Matrix

**Date:** 14 August 2026  
**Scope:** Quran premium reader, Azkar premium reader, Home balance, Prayer Times, Prayer Audio, Quran Audio, notification exact destinations, visual proof, final build.

## Current evidence policy

A feature is not called verified merely because a unit test passes. The completion report distinguishes five evidence classes: **Implemented** means the code path exists; **Automated Tested** means an executed test covered the behavior; **Visually Verified** means a real APK screen was captured and inspected; **Verified on a real device** means a physical Android device was used; **Not verified — limitation** means the requested evidence could not be obtained in the available emulator/session.

## Baseline findings

The installed release APK reached Home only after approximately 35 seconds on emulator-5554. At around 10 seconds it was still on Splash, while a later screenshot showed Home. The route itself uses a 1.5-second Splash animation, so the visible delay is likely caused by synchronous work during Home build, especially the hard-coded source discovery card calling `Quran.getVerse` before Quran initialization is prepared. This is a priority blocker for a premium first launch and will be fixed by making Home source discovery asynchronous/non-blocking.

The current Quran reader already has a page-flip foundation, Arabic/RTL layout, Amiri typography, basmala handling, ayah markers, ayah tap interaction, current-ayah highlighting, a bottom audio bar, and an end-of-surah page. Its gaps are exact resume persistence, a bookmark model that stores only surah and raw scroll offset, richer verse-sheet hierarchy, clear loading/error states for audio, and an explicit premium reading control surface.

The current Azkar reader has page flipping, category context, reference display, capture action, haptic repetition, counter reset, completion state, and focus-item reopening. Its main risks are heuristic repetition extraction from text, interaction being concentrated on one circular counter, and limited state/a11y feedback for loading, errors, and completion.

The current Home contains Welcome, Prayer Times, Quick Access, Continuation Canvas, Source Discovery, and prayer/reflection utilities. It is not empty, but the screenshot shows the lower quick-access content competing with the bottom navigation and the key MemoryThread/source-discovery content below the fold. The pass will rebalance information density without restoring gamification or engagement pressure.

## Acceptance matrix

| Area | Implemented baseline | Automated tested baseline | Visual evidence baseline | Real-device status | Final-pass action |
|---|---|---|---|---|---|
| Quran list | Yes | Partial | Yes, existing release screenshots | Not tested on physical device | Improve surah hierarchy, metadata, resume affordance, empty/loading/error states |
| Quran reader | Yes | Partial | Yes, existing release screenshots | Not tested on physical device | Strengthen Mushaf presentation, exact resume, controls, verse sheet, scaling/dark mode |
| Quran text integrity | Source package and current text path exist | Existing tests | Existing reader screenshots | Not applicable | Do not alter source text or references; add regression checks if needed |
| Quran Audio | External CDN, ten reciters, play/pause/next/previous/seek code | Partial | Existing streaming/reciter screenshots | Network/device limitation | Improve loading/buffering/error states and premium player hierarchy; test network failure |
| Azkar categories | Yes | Existing provider tests | Existing category screenshot | Not tested on physical device | Improve category cards, hierarchy, loading/error/empty states |
| Azkar reading | Yes | Existing capture/return tests | Existing reading screenshot | Not tested on physical device | Make repetition model explicit where schema allows, improve counter affordance and states |
| Home | Yes | Continuation tests | Baseline release screenshot | Not tested on physical device | Remove startup blocking, rebalance density, preserve MemoryThread and original entry points |
| Prayer Times | Yes, real API/location/timezone path | Existing domain tests | Existing release screenshot | Not tested on physical device | Improve premium card and permission/network/stale/midnight states |
| Prayer Audio | Five local short WAVs, alarm channels, dynamic resolver | Existing native/service path | Existing release confirmation and notification shade | Emulator only | Re-run after final build; distinguish emulator evidence from physical-device evidence |
| Prayer notification destination | Payload/deep-link code exists | Unit deep-link tests | No complete E2E tap chain yet | Not verified | Execute foreground/background/cold-start paths where emulator permits; record limitation honestly |
| MemoryThread reminder | ReminderIntent and deep-link code exist | Existing notification deep-link tests | No complete E2E tap chain yet | Not verified | Execute a real selected-thread reminder flow or mark blocked by available data/UI setup |
| Visual proof | 97 prior screenshots plus new baseline | N/A | Yes for many surfaces | Emulator only | Capture final screenshots/contact sheet/ZIP from final APK |

## Non-negotiable product constraints

The final pass must not rewrite Quran, hadith, azkar text, citations, or references; add religious AI or generated religious explanations; restore streaks, scores, challenges, guilt, engagement notifications, social mechanics, or mood inference; store Quran recitations inside the APK; or call emulator evidence real-device evidence.

## Priority order

First remove the startup blocker and stabilize the final APK launch. Then improve Quran UX and exact resume, followed by Azkar, Home/Prayer presentation, notification destination E2E, visual proof, and finally the full Flutter/analyzer/build matrix. All screenshots must come from the running application; generated mockups are not acceptable evidence for this pass.
