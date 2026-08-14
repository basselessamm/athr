# تقرير الجاهزية الميدانية (Field Readiness) — تطبيق أَثَر

**التاريخ:** 14 أغسطس 2026
**الجهاز المستخدم:** `emulator-5554` (Android API 28)
**هوية المرشح (APK):** `a8d6aaf617ef3cbe8df3743f1546871e19733812ecd7815a96bdeb85774c24d8`

## ملخص الجولة الميدانية

تم تنفيذ أقصى تغطية ممكنة من الاختبارات التشغيلية والبصرية على المحاكي لمحاكاة ظروف الاستخدام الحقيقي. تم إثبات عمل قنوات الصوت المحلية، جدولة التنبيهات، العودة الدقيقة للمصدر، والتعامل مع فقد الشبكة وصلاحيات GPS. بقيت السيناريوهات المرتبطة حصريًا بالعتاد الفيزيائي (مثل سماعة الهاتف الفعلية أو سلوك OEM الخاص) مسجلة كـ **NOT VERIFIED**.

### مصفوفة التحقق الميداني (Field QA Matrix)

| السيناريو | الاختبار | النتيجة | الدليل (Evidence) |
|---|---|---|---|
| **Prayer notification** | محاكي + اختبار فوري | **PASS** — verified on emulator | `field_pass_prayer_audio_foreground_notification_dump.txt` |
| **Prayer audio** | تشغيل ملف WAV محلي | **PASS** — verified on emulator | سجل قناة الصوت (`USAGE_ALARM`) ومحتوى APK |
| **Prayer tap** | إشعار الفجر ← وجهة الفجر | **PASS** — verified on emulator | `field_pass_prayer_tap_destination.png` |
| **Memory reminder** | خيط ← تذكير ← جدولة Alarm | **PASS** — verified on emulator | `field_pass_memory_short_future_alarm_dump.txt` (`RTC_WAKEUP`) |
| **Quran exact resume** | حفظ 1:1 ← بطاقة القائمة ← 1:1 | **PASS** — verified on emulator | `field_pass_quran_list_resume_final.png` |
| **Quran marker** | نقر علامة الآية ← خيارات | **PASS** — verified on emulator | `field_pass_quran_marker_options.png` |
| **Quran audio** | بث خارجي / تبديل / فشل | **PASS** — verified on emulator | `field_pass_quran_audio_playback_log_excerpt.txt` |
| **Azkar repetition** | عداد محافظ بلا اختراع | **PASS** — verified on emulator | `field_pass_azkar_reading.png` |
| **GPS denied** | رفض الصلاحية ← لا تعطل | **PASS** — verified on emulator | `field_pass_gps_denied_result.png` |
| **GPS allowed** | منح الصلاحية ← تحديث | **PASS** — verified on emulator | `field_pass_gps_allow_result_retry.png` |
| **GPS disabled** | إغلاق GPS ← استخدام cache | **PASS** — verified on emulator | `field_pass_gps_disabled_result.png` |
| **Network loss** | وضع الطيران ← Home مستقر | **PASS** — verified on emulator | `field_pass_prayer_network_loss_home.png` |
| **RTL/Scaling** | تكبير الخط 130% + RTL | **PASS** — verified on emulator | `field_pass_settings_font_scale_130.png` |
| **Prayer cold start** | نقر إشعار بعد إغلاق قسري | **NOT VERIFIED** — emulator limitation | `field_pass_prayer_cold_start_shade.xml` (قيود المحاكي) |
| **DND / Silent** | سلوك الصوت تحت DND | **NOT VERIFIED** — physical device required | يتطلب عتادًا فيزيائيًا للتحقق من كتم السماعة |
| **Battery optimization** | تسليم الخلفية مع القيود | **NOT VERIFIED** — physical device required | يتطلب سلوك OEM حقيقي (Doze/App Standby) |

## الملاحظات التقنية والأدلة

1.  **هوية الـ APK:** تم التأكد من أن الملف `app-release.apk` (95.4 MB) لا يحتوي على ملفات تلاوة ضخمة، بل يعتمد على البث الخارجي (`cdn.islamic.network`) مع معالجة محترمة للفشل وطلب إعادة المحاولة.
2.  **صوت الصلاة:** أثبت سجل النظام استخدام قناة `prayer_audio_fajr_v2` مع `android.resource://com.athr.athr/2131558402` (ملف `Fq.wav` المحلي)، مما يضمن استقلالية الصوت عن الإنترنت لحظة الصلاة.
3.  **العودة (Return Flow):** تم التحقق من أن "العودة إلى المصدر" تفتح السورة والآية المحددة بالضبط (مثل الملك 67:3 أو الفاتحة 1:1) عبر الـ canonical SourceReference.
4.  **الاستقرار:** لم يُسجل أي Crash أو ANR أثناء سحب الصلاحيات أو فقد الشبكة أو التبديل السريع بين القراء.

## قرار الجاهزية (Readiness Decision)

-   **GO لمرشح الإصدار (Release Candidate):** التطبيق مستقر وظيفيًا وبصريًا على بيئة Android القياسية.
-   **NO-GO للنشر العام الواسع:** يجب إجراء "فحص سماعة" أخير على جهاز فيزيائي واحد على الأقل للتأكد من مسموعية ملفات WAV تحت ظروف DND/Silent المختلفة قبل الرفع للمتجر.

**المرفقات:**
- `athr_final_pass_contact_sheet.jpg`: لوحة الأدلة البصرية الكاملة.
- `field_pass_final_qa_run.log`: سجل الاختبارات الآلية (47/47 ناجحة).
- `field_pass_candidate_identity.log`: توثيق SHA ونسخة النظام.
