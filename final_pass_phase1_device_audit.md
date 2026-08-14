# Final Pass Phase 1 — Device and Artifact Audit

The current release artifact is `/home/ubuntu/athr/build/app/outputs/flutter-apk/app-release.apk`, size 95,434,536 bytes, SHA-256 `131d3f7ae9a7df3929a6791be8ecac9618ff5d9f0cd3b4d54ccdf385ab2dd0e8`. Flutter 3.47.0 and Dart 3.13.0 are available and runnable.

`adb devices -l` reports exactly one connected target: `emulator-5554`, Android API 28, generic x86_64 emulator. No Android physical device is connected or exposed in the current environment. Therefore physical speaker loudness, OEM battery optimization, DND behavior, screen-lock alarm policy, and physical-device cold-start behavior cannot be honestly marked as verified in this pass. Emulator-based E2E remains available and will be rerun on the final artifact after code changes.

The project has uncommitted product work from the previous phases, including Quran, Azkar, Home, Prayer, MemoryThread, Android local audio, migration, and tests. The final artifact must be rebuilt after all remaining changes; the current SHA is a baseline, not the final pass artifact.

## ReminderIntent E2E progress

A real MemoryThread created from Quran 1:1 is open in Thread Detail. The optional reminder card was opened through the product UI, and Android date/time pickers were reached with the current day selected. The default time was 4:59 PM. The exact near-future time entry and resulting scheduled notification delivery remain in progress; no ReminderIntent E2E delivery is claimed yet.

The first time-picker attempt was not accepted because it used the then-current 4:59 PM value or an already-past minute; the thread returned to its unchanged reminder state. The picker was reopened after 5:00 PM, and minute 05 is now being selected as a valid near-future target. No scheduled reminder is recorded until the UI displays the changed appointment and Android shows its scheduled/delivered notification.

## ReminderIntent delivery status

The product UI successfully reached the native date picker and time picker from a persisted real Quran MemoryThread. However, repeated emulator coordinate attempts to select a future minute on the OEM/system time dial did not update the selected minute; the reminder therefore remained unsaved and no notification was scheduled. This is recorded as **NOT VERIFIED**, not a parser or unit-test substitute. The thread, optional reminder card, source route generation, and deep-link tests remain verified separately.

## Physical Android device verification

No physical Android device is available through ADB in this environment. Only `emulator-5554` is connected. The requested physical-device cases—screen locked audio audibility, battery optimization, OEM alarm policy, DND behavior, and cold-start notification behavior on handset hardware—are blocked by hardware availability and are explicitly NOT VERIFIED.

## Latest-release Azkar visual verification

The latest APK displayed a distinct Azkar categories surface with calm Arabic hierarchy and large touch targets. The Azkar Al-Adhan reader showed a book-like paper surface, Arabic typography, source-aware category identity, and an honest counter message: when the stored material has no explicit count, it says the button is only for confirming reading. The primary control reads “قرأت,” not an invented religious repetition count. This verifies the conservative repetition presentation on the release emulator.
