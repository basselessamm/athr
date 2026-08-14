# Final Completion Pass — baseline findings

## Baseline evidence

The currently installed release APK was launched on emulator-5554. After roughly ten seconds, `final_completion_baseline_home.png` still showed the branded Splash screen. After a further twenty-five seconds, `final_completion_baseline_home_35s.png` showed Home. The focus stayed on `com.athr.athr.MainActivity`, so the issue is a slow user-visible startup path rather than an activity crash.

The Home that eventually appeared already contains a real welcome header, real prayer times with a next-prayer countdown, a four-item quick-access grid, RTL navigation, and a light visual system. However, the screenshot shows the bottom of the quick-access grid clipped by the navigation bar at the current viewport, and Continuation Canvas/source discovery are below the fold. The Home is not empty, but the first-use path is delayed enough to be a product blocker for a premium first impression.

## Scope guardrails

This pass must preserve Quran, hadith, and azkar source text and citations exactly. Improvements may change presentation, typography, layout, interaction, loading/error states, navigation, audio controls, and persistence handling only. No streak, score, challenge, guilt, engagement notification, social, mood inference, or religious AI mechanics may be introduced.

## Evidence classification policy

Every final feature will be classified separately as Implemented, Automated Tested, Visually Verified on the emulator, Verified on a real device, or Not verified because of a stated limitation. Emulator screenshots are not real-device evidence. A test passing alone will not be described as visual or operational verification.

## Release validation after the location-flow change

A clean interim release APK built and installed successfully. Ten seconds after launch, Android focus was still `com.athr.athr.MainActivity` and the short logcat slice contained no ANR, fatal exception, or Geolocator service error. However, the captured release screen still showed the branded Splash rather than Home. The location-flow change removed the immediately observed debug Geolocator ANR from the release trace, but it did **not** establish the desired premium startup time. The separate Home source-discovery/Quran initialization block remains the next suspected startup constraint and must be addressed before marking startup visually verified.

## Release startup after deferred Source Discovery

The clean release rebuilt after making Home source discovery asynchronous still showed a blank frame at approximately four seconds and the branded Splash (with its progress indicator) at approximately ten seconds. There was no ANR/fatal line in the short Android logcat scan and MainActivity retained focus, but the improvement did **not** make Home ready within the expected time. Therefore the asynchronous Quran card change is retained as a correct non-blocking presentation boundary, but it is not credited as a completed startup-performance fix. The next investigation must isolate post-first-frame memory/bootstrap work and any other synchronous first-frame path.

## Direct Home route result

When the router started directly at `/`, clean-release screenshots at four and ten seconds were still entirely blank. This proves the previous Flutter Splash route was not the root cause; the delay occurs before the first visible Flutter frame is rendered. The direct-HOME change is therefore not retained as a credited startup fix until its routing implications are re-evaluated. The next measurement must wait longer and inspect launch timing/logs, then isolate pre-`runApp` work rather than continuing to alter Home UI.

## Deferred Home/bootstrap result

With Memory migration delayed ten seconds and the database-backed Continuation Canvas/Quran discovery withheld from the initial Home build, the clean release still had a blank frame at approximately four seconds but displayed an interactive Home at approximately ten seconds. The visible Home showed the intended actionable location state rather than a fabricated prayer time, Quick Access, and RTL navigation; the short logcat scan contained no ANR or fatal exception. This is an operational improvement over the previous 35-second wait, but a four-second blank native/Flutter startup remains a documented performance debt and is not represented as an instant startup success.

## Quran release visual verification (partial)

The release build displayed a readable RTL Quran list with actual surah names and counts, and opened Surat Al-Fatihah in the framed Mushaf reader. The reader visibly includes the Arabic text, ornamental ayah markers, a prominent non-downloaded streaming-audio control surface, a reader choice affordance, and a top-level save-reading-position control. Pressing the latter showed the user-visible confirmation “حُفظ موضع القراءة للعودة إليه لاحقًا.” This verifies the saved-anchor action visually on the emulator. The follow-up list-card resume/open path remains to be exercised separately before it is called end-to-end verified.

## Quran exact resume — release emulator verified

After saving the first ayah of Al-Fatihah, the Quran list showed an actionable card reading “إكمال القراءة من سورة الفاتحة، الآية 1.” Activating that card reopened the reader at the same source anchor and displayed the ayah workspace for **Surat Al-Fatihah, ayah 1**, including the exact provenance string `القرآن الكريم · 1:1`, listen action, save-position action, copy/favorite/capture controls, and tafseer section. This is verified end-to-end on the release APK running in the emulator. It is not a physical-device verification.

## Quran audio release verification

The “استمع للآية” action was invoked from the exact-ayah workspace on the release APK. Android audio-HAL output was recorded during the attempt; after closing the sheet through the system back action, the accessible player state identified the active reciter as **مشاري العفاسي** and the active ayah as **7**, with previous/next controls enabled and the central control reading “استئناف التلاوة.” This is consistent with the controller completing the seven-ayah Al-Fatihah sequence and pausing at the end. The emulator also emitted expected generic audio-HAL timing warnings, which are not treated as application errors. The test proves the external streaming playback flow and sequential ayah handoff on the emulator; it does not verify mobile-network robustness or physical-device audio quality.

## Quran reciter selection — release emulator verified

The release player opened a modal “اختر القارئ” selector showing the current choice and several of the expanded verified reciters with their stream bitrate. Selecting **عبد الرحمن السديس** updated the player’s accessible state and visible label to “الآية 7 · عبد الرحمن السديس.” The screenshot then showed the explicit “جارٍ الاتصال بالمصدر الصوتي…”/“جارٍ التحميل” state rather than a falsely successful control. This verifies the in-app selection flow and loading feedback. It does not assert that every remote stream will play on every mobile network; network-loss/error retry still requires a controlled offline validation.

## Prayer Audio and notification destination — latest release E2E

On the latest release APK, the Settings screen exposed an enabled independent “صوت الصلاة المنطوق” switch and a distinct “اختبار في الخلفية” action. The test was scheduled, the app was sent to the background, and Android `dumpsys notification` recorded a new notification titled “اختبار خلفية: حان وقت صلاة الفجر” on channel `prayer_audio_fajr_v2`. The channel used `USAGE_ALARM`, vibration, and the resolved local resource URI `android.resource://com.athr.athr/2131558402`; the filtered native log contained no missing-resource or audio loading error. This is strong emulator evidence of local scheduled background delivery and correct channel/resource setup, but the automated environment cannot independently certify what a human hears through a physical device speaker.

The delivered notification was opened from the Android notification shade. It routed into the new **مواقيت الصلاة** screen and visibly displayed “تنبيه صلاة الفجر,” with an actionable location state and settings path. This verifies the actual notification-tap deep link for the release APK in the emulator. A physical-device cold-start tap and OEM/DND behavior remain separate unverified cases.

## Memory reminder E2E attempt status

A fresh latest-release session returned to the full Home and entered a real Quran list and Surat Al-Fatihah reader. The reader display remained visually valid. The first attempted text-coordinate tap did not open the ayah sheet, so the MemoryThread/ReminderIntent E2E path has not yet been claimed as verified. The next attempt targets the actual ornamental ayah marker instead of free text; no reminder notification has been created by this attempt.

## Quran ayah interaction defect discovered

Two release-emulator attempts to open the Al-Fatihah ayah workspace by tapping both an ornamental ayah marker and the corresponding verse text left the reader unchanged. The source code assigns `TapGestureRecognizer` instances to text spans inside `SelectableText.rich`; selection handling appears to prevent those span callbacks from becoming usable in this UI. Therefore, capture from a real Quran source and the MemoryThread ReminderIntent E2E path remain **unverified** at this point. This is treated as a functional defect to fix, not as a test-environment pass.

## Quran ayah interaction follow-up

The RichText conversion compiled and a release APK was built. A direct tap attempt after navigating to a confirmed Al-Fatihah reader still did not visibly open the ayah workspace. The test sequence was then redirected to the persisted exact-resume route, which had previously shown the same ayah workspace independently of in-page text tapping. The source-ayah text tap remains an unresolved release-emulator interaction defect; no end-to-end capture result has been claimed from it.

## Capture from a real Quran source — release emulator verified

The persisted exact-resume route opened the Al-Fatihah ayah 1 workspace, where the visible capture icon opened the dedicated “اترك أثرًا” sheet. The sheet showed the immutable source block (“القرآن الكريم · 1:1” and the Arabic ayah), optional return-context choices, an explicitly optional private note, and the boundary statement that the note does not become part of the source. Pressing “اترك الأثر الآن” without context or note returned to the ayah workspace, consistent with successful dismissal after creation. The next step is a persistence/UI check in the Threads area; no claim about the ReminderIntent is made yet.

## MemoryThread persistence and ReminderIntent surface — release emulator verified

After creating the source-only capture, Home’s Continuation Canvas showed a “خيوط العودة” card for **القرآن الكريم · 1:1**, with separate actions for returning to the source and opening thread details. The legacy “المفضلة” tab remained empty, which correctly demonstrates that the new thread was not silently rebranded as a Favorite. Thread details displayed the immutable canonical ID `quran:verse:1:1`, the distinct source block, and an optional one-time ReminderIntent card with “اختيار موعد” and no engagement/streak language. This verifies persistence, source/user separation in the UI, and access to reminder setup. It does not yet verify a scheduled MemoryThread notification delivery or its tap destination.
