# أَثَر — خيوط العودة
## تقرير Production Readiness النهائي

**الإصدار المرشح:** `1.0.0` · **الحزمة:** `com.athr.athr` · **تاريخ الفحص:** 14 أغسطس 2026 · **بيئة التشغيل:** `emulator-5554`، Android API 28

> هذا التقرير يميّز عمدًا بين **نجاح التنفيذ والاختبار على المحاكي** وبين **الجاهزية للنشر الواسع**. لا يُعدّ أي بند غير موصوف كـ Verified نجاحًا ضمنيًا.

## القرار التنفيذي

القرار الحالي هو: **GO — مرشح جاهز لتسليم QA والمراجعة الداخلية**، و**NO-GO — ليس جاهزًا بعد للنشر الواسع على أجهزة Android فعلية**.

المرشح يحقق جوهر الأطروحة: **MemoryThread** هو الوحدة الأساسية، والمستخدم يستطيع اكتشاف مصدر موثّق، ترك أثر، العودة إليه لاحقًا، واستكمال القراءة أو التأمل اختياريًا. لا يعتمد مسار العودة على streak أو score أو guilt أو إشعارات engagement. كما أن التحقق الآلي والبناء النهائي ناجحان، والتفاعل البصري لعلامة الآية، Continuation Canvas، Thread Detail، ومجرى إشعار الصوت الخلفي للصلاة تحقق على المحاكي. أما قرار النشر الواسع فيظل محجوزًا إلى أن يُنفّذ اختبار جهاز فعلي، واختبار GPS والصوت وDND/OEM والقفل وReminderIntent مستقبلية حقيقية.

| بوابة القرار | الحالة | الدليل |
|---|---|---|
| Phase 0–5 والتنفيذ المنتجـي الأساسي | **مكتمل** | سجل التغييرات والجرد الكامل في [`final_pass_change_inventory.txt`](evidence/final_pass_change_inventory.txt) |
| الاختبارات الآلية | **PASS — 47/47** | [`final_pass_full_test.log`](evidence/final_pass_full_test.log) |
| `git diff --check` | **PASS — clean** | [`final_pass_git_diff_check.log`](evidence/final_pass_git_diff_check.log) |
| Release build | **PASS** | [`final_pass_release_build.log`](evidence/final_pass_release_build.log) |
| Visual QA على المحاكي | **PASS جزئيًا حسب الجدول أدناه** | [`athr_final_pass_contact_sheet.jpg`](screens_delivery/athr_final_pass_contact_sheet.jpg) |
| اختبار جهاز Android فعلي | **NOT VERIFIED** | لا يوجد جهاز فعلي متصل |
| ReminderIntent: Thread → Notification → Tap → Exact Source | **NOT VERIFIED كمسار زمني مستقبلي كامل** | قيود منتقي الوقت في المحاكي؛ guard جديد واختبارات domain ناجحة |
| النشر الواسع | **NO-GO حاليًا** | يلزم إغلاق حدود التحقق الميداني المذكورة في هذا التقرير |

## هوية مرشح الإصدار

أُعيد بناء APK release بعد إصلاح التحقق من مواعيد التذكير، ثم أُعيد تثبيته بنجاح على المحاكي. حجم الملف **95,434,536 bytes**، وSHA-256 هو `a8d6aaf617ef3cbe8df3743f1546871e19733812ecd7815a96bdeb85774c24d8`. سجل إعادة التثبيت ومسار الحزمة موجودان في [`final_pass_final_reinstall.log`](evidence/final_pass_final_reinstall.log)، وبيانات الحجم والـSHA في [`final_pass_apk_metadata.txt`](evidence/final_pass_apk_metadata.txt).

## ما تم تنفيذه مقارنة بالأطروحة

### Memory Foundation وsource/user boundary

أضيفت طبقة الذاكرة الدائمة باستخدام Drift للكيانات `MemoryThread` و`SourceReference` و`UserContext` و`ReflectionEntry` و`ReadingAnchor` و`ReturnEvent` و`ReminderIntent`. المصدر الديني يحتفظ به كمرجع canonical مستقل، بينما السياق والملاحظة والانعكاس بيانات شخصية منفصلة. migration الخاصة بالـFavorites والـBookmark القديمة تدريجية، مع legacy fallback وعدم حذف بيانات قديمة بلا مسار رجوع.

### Capture Flow

أصبح الالتقاط يبدأ من مصدر ديني حقيقي ويعرض بوضوح قسم **من المصدر** قبل الإنشاء. إنشاء الخيط سريع ولا يتطلب note أو context؛ كلاهما اختياري. المصدر لا يُستبدل بمحتوى المستخدم، والـcanonical reference يحتفظ بالـsurah/ayah أو مسار المصدر الدقيق. اختبارات CaptureSheet وsource/user boundary وpersistence ناجحة ضمن 47 اختبارًا.

### Return Flow

أضيف Thread Detail مع exact source reopen، وحفظ ReadingAnchor، وإضافة ReflectionEntry خاصة، وسجل ReturnEvent، وعناصر archive/delete، ومفتاح محلي للتحكم في resurfacing. لا توجد دلالات streak أو score أو guilt. أضيف في الإغلاق الأخير حارس صريح يمنع حفظ ReminderIntent في وقت ماضٍ، مع اختباري regression مستقلين في [`reminder_time_validation_test.dart`](test/memory/reminder_time_validation_test.dart).

### Continuation Canvas وProduct IA

أصبحت Home تعرض مسار العودة بدل Dashboard gamified: Quick Access، بطاقة الصلاة، ومقطع **خيوط العودة** الذي يعرض المصدر المحفوظ ويفتح المصدر بدقة. حالات الخيط الواحد والعودة إلى المصدر ظاهرة بصريًا. التنفيذ لا يعيد تسمية Favorites فقط؛ بل يعرض MemoryThread ببيانات source/context/return مستقلة.

### Quran Premium Mushaf

تدعم التجربة قائمة السور، exact resume، صفحة مصحف حقيقية، عنصر وصول مستقل لكل علامة آية، Verse Actions، حفظ الموضع، Capture من المصدر، ومشغل التلاوة مع اختيار عشرة قراء. تم التحقق على المرشح النهائي من أن علامة الآية الأولى ظهرت كـ`android.widget.Button` مستقلة وأن الضغط عليها فتح Verse Actions؛ كما يظهر في [`final_pass_marker_actions.xml`](evidence/final_pass_marker_actions.xml) ولقطة [`final_pass_marker_opens_verse_actions_latest_release.png`](evidence/final_pass_marker_opens_verse_actions_latest_release.png). اختبار الـWidget المقابل ناجح.

### Azkar Premium

قارئ الأذكار يعرض عدادًا محافظًا لا يخترع عددًا تعبديًا من نص وصفي، مع progress state وتمييز بين العدد الصريح والتأكيد الشخصي. لا توجد mechanics للـstreak أو score أو guilt. لقطتا الفئات والقراءة موجودتان في Contact Sheet وفي [`final_pass_visual_findings.md`](evidence/final_pass_visual_findings.md).

### Prayer Audio وLocal Notifications

صُممت تنبيهات الصلاة محليًا عبر `flutter_local_notifications` و`exactAllowWhileIdle`، مع قنوات منفصلة للصوت، `USAGE_ALARM`، ملفات WAV صغيرة داخل `res/raw`، مفتاح مستقل لتفعيل صوت الصلاة، واختبار فوري واختبار في الخلفية. لا يعتمد الموعد على الإنترنت لحظة التنبيه. في هذا المرشح تم تنفيذ **اختبار في الخلفية** من الواجهة، ثم إخراج التطبيق إلى launcher؛ ظهر التنبيه فعليًا في notification shade بعنوان اختبار صلاة الفجر. كما يثبت dump الخام قناة `prayer_audio_fajr_v2`، وملف `android.resource://com.athr.athr/...`، و`USAGE_ALARM` و`mIsInterruptive=true` في [`final_pass_prayer_audio_background_notification_dump.txt`](evidence/final_pass_prayer_audio_background_notification_dump.txt). هذا يثبت وصول Notification والقناة المحلية على API 28، لكنه لا يثبت إدراك الصوت كما يسمعه مستخدم على هاتف فعلي.

## Final QA الفعلي

| الفحص | النتيجة الفعلية | التفسير |
|---|---:|---|
| `flutter test` الكامل | **47/47 ناجحة** | نهاية السجل هي `All tests passed!`؛ يشمل اختباري منع الموعد الماضي |
| `flutter analyze` الكامل | **Exit 1 بسبب 8 `info` فقط** | لا توجد warning/error؛ هذه نفس legacy baseline المعتمد سابقًا، ولم تُخفَ بإعداد أو suppression |
| `git diff --check` | **Clean** | الملف الناتج فارغ |
| `flutter build apk --release` | **PASS** | APK release بُني مرتين في الجولة الأخيرة بنجاح |
| إعادة تثبيت المرشح | **PASS** | `adb install --no-streaming -r` أعاد `Success` |

الملاحظات الثماني هي: `unnecessary_library_name` واحد، `use_super_parameters` أربعة، `deprecated_member_use` واحد في page-flip، و`curly_braces_in_flow_control_structures` اثنتان. كلها `info` وليست warning أو error، ولم تغيّر إعدادات analyzer. التفاصيل في [`final_pass_qa_findings.md`](evidence/final_pass_qa_findings.md) وسجل analyzer الكامل في [`final_pass_full_analyze.log`](evidence/final_pass_full_analyze.log).

## Visual QA والأدلة

تم تحديث Contact Sheet من الملفات الموجودة فعليًا فقط عبر [`build_contact_sheet.py`](build_contact_sheet.py). الناتج هو [`athr_final_pass_contact_sheet.jpg`](screens_delivery/athr_final_pass_contact_sheet.jpg)، وسجل البناء في [`final_pass_contact_sheet_build.log`](evidence/final_pass_contact_sheet_build.log). جميع الملفات الإثني عشر المدرجة أدناه موجودة، ولا يستخدم الـContact Sheet placeholders.

| الدليل البصري | ما تم التحقق منه |
|---|---|
| [`final_pass_home_latest_release.png`](evidence/final_pass_home_latest_release.png) | Home بعد موقع محاكى اصطناعي: التاريخ الهجري، الصلاة التالية، العد التنازلي، الصلوات الخمس، وزر عرض كل المواقيت |
| [`final_pass_home_continuation_latest_release.png`](evidence/final_pass_home_continuation_latest_release.png) | Quick Access وخيوط العودة وبطاقة الخيط المحفوظ والعودة إلى المصدر |
| [`final_pass_thread_detail_latest_release.png`](evidence/final_pass_thread_detail_latest_release.png) | المصدر canonical، resurfacing، تذكير اختياري، العودة إلى المصدر، الانعكاسات، anchor، وسجل العودة |
| [`final_pass_quran_list_latest_release.png`](evidence/final_pass_quran_list_latest_release.png) | قائمة القرآن وبطاقة exact resume للفَاتحة 1:1 |
| [`final_pass_marker_opens_verse_actions_latest_release.png`](evidence/final_pass_marker_opens_verse_actions_latest_release.png) | الضغط المباشر على علامة الآية يفتح Verse Actions |
| [`final_pass_mushaf_verse_actions_latest_release.png`](evidence/final_pass_mushaf_verse_actions_latest_release.png) | المصحف وورقة إجراءات الآية ومصدرها |
| [`final_pass_quran_audio_player_latest_release.png`](evidence/final_pass_quran_audio_player_latest_release.png) | ورقة الآية مع زر الاستماع؛ اكتمال network playback في هذه المحاولة النهائية غير مدّعى |
| [`final_pass_reciter_picker_latest_release.png`](evidence/final_pass_reciter_picker_latest_release.png) | قائمة القراء المتعددة، وتظل دليلًا داعمًا لمسار اختيار القارئ |
| [`final_pass_azkar_categories_latest_release_verified.png`](evidence/final_pass_azkar_categories_latest_release_verified.png) | فئات الأذكار |
| [`final_pass_azkar_reading_latest_release.png`](evidence/final_pass_azkar_reading_latest_release.png) | قارئ الأذكار والعداد المحافظ |
| [`final_pass_prayer_screen_latest_release.png`](evidence/final_pass_prayer_screen_latest_release.png) | شاشة مواقيت الصلاة الكاملة، ومواعيد الفجر والظهر والعصر والمغرب والعشاء |
| [`final_pass_prayer_notification_latest_release.png`](evidence/final_pass_prayer_notification_latest_release.png) | Notification shade بعد اختبار الخلفية، مع إشعار صلاة الفجر الظاهر فعليًا |

## ما تم التحقق منه وما لم يتم التحقق منه

| المسار | الحكم | الحدود |
|---|---|---|
| Marker → Verse Actions | **VERIFIED** | تحقق Widget + تحقق بصري من المرشح النهائي على المحاكي |
| Exact Quran resume | **VERIFIED جزئيًا** | persistence وعودة بطاقة المصدر اختُبرا؛ لا يُعامل ذلك كاختبار شامل لكل صفحات المصحف |
| Capture بدون note/context | **VERIFIED آليًا** | اختبارات capture وboundary وpersistence ناجحة |
| Thread Detail وsource reopen | **VERIFIED جزئيًا** | الشاشة والـcanonical id ظهرا، والاختبارات الخاصة بالعودة ناجحة |
| Prayer screen | **VERIFIED على المحاكي** | الموقع كان synthetic emulator location، لا GPS فعلي |
| Prayer background notification delivery | **VERIFIED على API 28 emulator** | Notification ظهر، والقناة والصوت المحلي موثقان؛ audibility الميدانية غير مثبتة |
| Prayer audio network independence at trigger | **VERIFIED تصميميًا/جزئيًا** | ملفات الصلاة محلية؛ اختبار جهاز فعلي مع فقد شبكة غير منفذ |
| Quran audio network/timeout/retry/switching | **PARTIALLY VERIFIED** | repository وقرّاء وURL وحالات الواجهة مغطاة؛ network loss فعلي متقلب لم يُغلق كاختبار ميداني |
| ReminderIntent future delivery and tap to exact source | **NOT VERIFIED** | تم كشف قبول وقت قديم في build سابق وإصلاحه؛ الاختبارات الجديدة ترفض الماضي، لكن trigger مستقبلي فعلي ثم tap لم يكتمل على المحاكي |

## حدود التحقق غير المغلقة قبل النشر الواسع

لم يتصل جهاز Android فعلي في هذه الجولة. لذلك تبقى **Prayer Audio audibility**، وDND، وإعدادات الصوت، وسلوك OEM battery restrictions، وlock-screen delivery، وcold-start من notification، وسرعة seed على جهاز فعلي، وGPS permission flow الواقعي، واختبار الوقت الفعلي للصلاة غير مغلقة.

كما أن اختبار ReminderIntent الكامل يحتاج إنشاء موعد مستقبلي صالح من الواجهة، انتظار تسليمه، الضغط على الإشعار، والتأكد من فتح المصدر نفسه مع `memoryThreadId` وexact source route. المحاكي قيّد ضبط دقيقة مستقبلية صالحة أثناء الجولة؛ لذلك لا يوجد ادعاء بأن هذا المسار انتهى.

أما Quran audio، فالمصدر الخارجي وقرّاء متعددون والـloading/error/retry موجودة في المنتج والاختبارات، لكن يلزم قبل النشر الواسع اختبار network loss وtimeout وswitching على جهاز فعلي أو بيئة شبكة مضبوطة. لا ينبغي اعتبار لقطة ورقة الآية الحالية إثباتًا لاكتمال playback في كل الظروف.

## الملفات والمكونات الرئيسية المتغيرة

الجرد الدقيق لكل الملفات المتعقبة موجود في [`final_pass_change_inventory.txt`](evidence/final_pass_change_inventory.txt). المكونات الرئيسية هي: Drift schema وgenerated database وseeder؛ `lib/core/memory/**` و`lib/features/memory_return/**`؛ router وmain navigation وnotification service؛ Home وContinuation Canvas؛ Quran list/reading/book page/verse sheet/bookmark/audio providers؛ Azkar categories/reading/providers؛ Prayer times/settings/Android audio bridge؛ وملفات `android/app/src/main/res/raw/` الصوتية. كما أضيفت اختبارات `test/memory/**` و`test/quran/book_page_widget_test.dart` و`test/memory/reminder_time_validation_test.dart`.

لم تُعدّل النصوص الدينية أو مصادرها في هذه الجولة. الملفات المحذوفة المتعلقة بـdaily tasks/progress/challenges ليست إعادة تسمية لـFavorites؛ بل جزء من إعادة توجيه IA نحو الأطروحة المعتمدة، مع إبقاء Favorites والـlegacy fallback كمسار بيانات آمن.

## الإصلاح الأخير في الإغلاق

أظهر الفحص البصري أن Thread Detail من build سابق كان يعرض موعدًا ماضيًا محفوظًا (`14/08 17:00`) في وقت لاحق. هذا لم يُسجّل كنجاح E2E؛ بل عومل كإشارة correctness. أضيفت الدالة الحتمية `isFutureReminderSchedule` داخل [`thread_detail_screen.dart`](lib/features/memory_return/presentation/thread_detail_screen.dart)، بحيث يرفض الاختيار الماضي قبل طلب الصلاحية أو حفظ intent، مع رسالة عربية واضحة واختبارين مستقلين. بعد ذلك نجح البناء النهائي، ونجحت 47/47 اختبارات.

## الخلاصة

**أَثَر جاهز كـ Release Candidate قابل للتسليم إلى QA والمراجعة الداخلية.** المنتج ليس مجرد Daily Companion أجمل، وليس Favorites باسم Threads؛ MemoryThread أصبح primitive حقيقيًا مع source/user boundary وcapture/return persistence وContinuation Canvas. **النشر الواسع مؤجل** حتى إغلاق قائمة الجهاز الفعلي وReminderIntent المستقبلية وnetwork/audio/GPS/OEM checks. هذه ليست عيوبًا مخفية في التقرير، بل حدود تحقق معلنة تمنع تحويل نجاح المحاكي إلى ضمان ميداني غير مستحق.

## الأدلة والمرجعيات المحلية

[1]: evidence/final_pass_qa_findings.md "Final QA findings"
[2]: evidence/final_pass_visual_findings.md "Final visual findings"
[3]: evidence/final_pass_apk_metadata.txt "Final APK metadata"
[4]: evidence/final_pass_prayer_audio_background_notification_dump.txt "Raw background notification dump"
[5]: evidence/final_pass_change_inventory.txt "Final change inventory"
[6]: screens_delivery/athr_final_pass_contact_sheet.jpg "Final visual contact sheet"
