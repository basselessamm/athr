# أَثَر — خيوط العودة
## Final Release Report

**المشروع:** أَثَر — خيوط العودة  
**المراجعة:** Final Release Candidate — Prayer Audio + Expanded Quran Reciters + Full QA  
**المؤلف:** Manus AI  
**التاريخ:** 14 أغسطس 2026  
**قرار الإصدار:** **GO — Release Candidate قابل للتثبيت والمراجعة النهائية**، مع بنود hardening موثقة قبل النشر الواسع.

## 1. الخلاصة التنفيذية

أصبح MemoryThread هو الوحدة الأساسية للتجربة، وليس إعادة تسمية سطحية لـ Favorites. المسار المنتجّي المكتمل هو: اكتشاف مصدر ديني موثق، التقاط أثر سريع، تكوين خيط اختياري السياق الشخصي، العودة إلى نفس المصدر عبر مرجع دقيق، ثم الاستكمال أو التأمل دون guilt أو streak أو score أو ضغط engagement. يحافظ التطبيق على فصل مرئي وبياني بين `SourceReference` و`UserContext` و`ReflectionEntry`، ولا يدخل النص الشخصي إلى جداول المصدر الديني.

تضم النسخة الرئيسية Home مبنية حول Continuation Canvas وخيوط العودة، مع الوصول إلى القرآن والأذكار والحديث ومواعيد الصلاة. لم تُحذف المصادر الدينية من أجل تبسيط الواجهة، ولم تتحول Home إلى Daily Companion أو لوحة إنجاز. لا توجد gamification، ولا social features، ولا AI ديني، ولا mood inference، ولا إشعارات هدفها رفع engagement.

الجولة النهائية عالجت النقطة التي كانت ما تزال غير مكتملة: **Prayer Audio ليس صوت إشعار Android عامًا فقط**. لكل صلاة ملف WAV محلي قصير ينطق اسم الصلاة بالعربية، ويُحل مورد الملف ديناميكيًا من Android عبر `getIdentifier` ثم يُربط بقناة خاصة باستخدام `AudioAttributesUsage.alarm`. تم اختبار إشعار الخلفية على APK release المثبت: جرى الضغط على «اختبار في الخلفية»، ظهر تأكيد الجدولة، نُقل التطبيق إلى الخلفية، وبعد أكثر من 15 ثانية ظهر سجل إشعار جديد بعنوان «اختبار خلفية: حان وقت صلاة الفجر» مع المورد المحلي الصحيح وحالة `isNoisy=true` و`isInterruptive=true`.

> **النتيجة:** وظيفة الصلاة الصوتية المحلية اجتازت التحقق التشغيلي على محاكي Android API 28. الدليل يثبت نشر الإشعار المسموع بالمورد المحلي بعد وضع التطبيق في الخلفية؛ أما اختبار السماع البشري على مكبر صوت جهاز Android حقيقي واختلافات OEM وDo Not Disturb فتبقى بنود hardening قبل النشر الواسع.

## 2. بوابة الأطروحة والقبول المنتجّي

| معيار القبول الأساسي | نتيجة الإصدار النهائي | الحكم |
|---|---|---|
| MemoryThread هو domain primitive | خيط العودة حاضر في domain، persistence، capture، return، وContinuation Canvas | ناجح |
| يبدأ المستخدم من مصدر ديني حقيقي | Capture يبدأ من Quran/Azkar/Hadith source reference موثق، مع تسمية «من المصدر» | ناجح |
| التقاط سريع بلا note أو context | إنشاء Thread مباشر ممكن؛ `UserContext` و`ReflectionEntry` اختياريان | ناجح |
| exact source anchor/reopen | المرجع canonical محفوظ ويُعاد حله مع deep link دقيق | ناجح |
| العودة بلا guilt/streak/score | لا توجد semantics أو إشعارات تلقائية لهذا الغرض | ناجح |
| فصل المصدر عن المستخدم | source tables منفصلة عن context وprivate note، ومدعومة باختبارات boundary | ناجح |
| Home ليست Favorites باسم Threads | Continuation Canvas تعرض خيوطًا قابلة للعودة إلى المصدر، لا قائمة bookmarks معاد تسميتها | ناجح |
| Prayer Audio يعمل دون Internet لحظة التنبيه | ملفات WAV داخل `res/raw` وقنوات محلية، مع جدولة Android محلية | ناجح على المحاكي |

لذلك لا تنطبق بوابة الفشل التي حددها المستخدم: الناتج ليس Daily Companion أجمل، وليس Dashboard للإنجاز، وليس Favorites باسم Threads. وحدة التجربة هي الخيط الذي يحتفظ بالمصدر الدقيق ويترك للمستخدم اختيار context أو reflection أو التذكير.

## 3. المراحل والمكونات المنفذة

| المرحلة | التنفيذ المنجز | تحقق القبول |
|---|---|---|
| Phase 0 — Contract and Test Harness | اعتماد العقود النهائية لـ `MemoryThread`, `SourceReference`, `UserContext`, `ReflectionEntry`، واختبارات source/user boundary | التنفيذ والاختبارات اجتازا البوابة، مع تسجيل baseline analyzer المعتمد |
| Phase 1 — Memory Foundation | Drift schema، migrations، repositories/providers، migration آمنة من Favorites وBookmark مع legacy fallback وidempotency | persistence، hydration، delete، migration، وفصل المصدر عن المستخدم اختُبرت |
| Phase 2 — Capture Flow | Capture action، CaptureSheet، إنشاء Thread من مصدر حقيقي، context/private note اختياريان، exact anchor | اختبارات capture والـ provenance والـ optional fields ناجحة |
| Phase 3 — Return Flow | Thread Detail، exact resume/open، ReadingAnchor، Reflection، ReturnEvent، archive/delete، وresurfacing controls | اختبارات return و14-day clock وdeep-link ناجحة |
| Phase 4 — Continuation Canvas + IA | Home الجديدة، عرض zero/one/many/unfinished/returning states، وإعادة IA بما يخدم الأطروحة مع Arabic/RTL/dark/text scaling | اختبارات Continuation Canvas ولقطات release التشغيلية ناجحة |
| Phase 5 — Notifications + Legacy Retirement | `ReminderIntent` user-selected فقط، deep links، migration/fallback دون حذف غير آمن للـlegacy | اختبارات reminder/deep-link وmigration ناجحة؛ لا daily guilt reminders |
| Final hardening | Prayer Audio المحلي، خمسة clips، dynamic resolver، قنوات alarm، توسيع Quran reciters إلى عشرة، وFinal QA/build | اجتاز الفحص التشغيلي النهائي كما هو موثق أدناه |

## 4. Prayer Audio المحلي — التنفيذ والتحقق

يحتوي التطبيق على خمسة مقاطع قصيرة في `android/app/src/main/res/raw/`: `prayer_fajr.wav`, `prayer_dhuhr.wav`, `prayer_asr.wav`, `prayer_maghrib.wav`, و`prayer_isha.wav`. أحجام الملفات هي على الترتيب `119,084`, `117,164`, `119,084`, `115,244`, و`122,924` bytes؛ أي `593,500` bytes، نحو `579.6 KiB` إجمالًا. هذه المقاطع تنطق اسم الصلاة فقط، وليست تسجيلات أذان طويلة، ولذلك لا تضخم APK بالحجم الذي كان سيحتاجه أذان كامل لكل صلاة.

ينشئ `MainActivity.kt` قناة `athr/prayer_audio` ويعيد URI من Android runtime بعد استدعاء `getIdentifier("prayer_${name}", "raw", packageName)`. هذا الحل يتجنب افتراض resource ID ثابت أو URI غير صالح من نوع `/raw/name`. في طبقة Dart، يحل `NotificationService` هذه الـURIs عند التهيئة، وينشئ لكل صلاة قناة مستقلة من نمط `prayer_audio_{name}_v2` مع `AudioAttributesUsage.alarm`، ويستخدم `exactAllowWhileIdle` للجدولة المحلية.

يوجد إعداد مستقل بعنوان **«صوت الصلاة المنطوق»**، ويمكن للمستخدم تشغيله أو إيقافه منفصلًا عن تفعيل إشعارات الصلاة. كما توجد أزرار **«اختبار فوري»** و**«اختبار في الخلفية»** في Settings. الصوت الخاص بـ Prayer Audio ليس اختيار تلاوة شيخ؛ هو صوت محلي قصير يذكر اسم الصلاة. أما اختيار القارئ فهو جزء مستقل من Quran Audio streaming، ومفصل في القسم التالي.

### دليل التسليم الفعلي على APK release

| خطوة التحقق | النتيجة | الدليل |
|---|---|---|
| تثبيت APK النهائي | `adb install -r` exit `0` و`Success` | `evidence/final_release_apk_install.txt` |
| تشغيل الاختبار | رسالة «جُدول اختبار الخلفية بعد 15 ثانية؛ اترك التطبيق أو اقفل الشاشة للاستماع.» ظهرت على الشاشة | `evidence/94_final_release_background_schedule_confirmation.png` |
| الخلفية | نُقل التطبيق إلى Home باستخدام زر النظام قبل انقضاء المهلة | `evidence/95_final_release_after_backgrounding.png` |
| التسليم | إشعار بعنوان «اختبار خلفية: حان وقت صلاة الفجر» ظهر بعد أكثر من 15 ثانية | `evidence/final_release_background_delivery_verified.txt` |
| المصدر الصوتي | `mSound=android.resource://com.athr.athr/2131558402` والقناة `prayer_audio_fajr_v2` | الأسطر 54–61 من سجل التسليم |
| نوع الصوت | `AudioAttributes: usage=USAGE_ALARM`، مع `isNoisy=true` و`isInterruptive=true` | الأسطر 36 و54–61 من سجل التسليم |
| أخطاء native | لا `error loading` ولا `No resource` ولا `NotificationPlayer` failure ولا `FATAL EXCEPTION` | `evidence/final_release_background_delivery_verified.log` |

هذا الدليل أقوى من إثبات وجود AlarmManager فقط؛ فهو يثبت أن Android نشر notification record عالي الأهمية بالمورد المحلي الصحيح بعد وضع التطبيق في الخلفية. لا يُقدَّم مع ذلك كضمان مطلق لسلوك كل الشركة المصنّعة أو كل إعدادات DND؛ فهذه قيود نظام التشغيل وتحتاج اختبار أجهزة حقيقية.

## 5. Quran Audio وقائمة القراء الموسعة

يختار المستخدم قارئ القرآن من قائمة مستقلة، ويظل الصوت Streaming من CDN خارجي ولا يدخل كتسجيلات داخل APK. القائمة النهائية تضم عشرة قراء بمعرفات Al Quran Cloud التي يستخدمها التطبيق:

| القارئ | المعرّف | bitrate |
|---|---|---:|
| مشاري العفاسي | `ar.alafasy` | 128 |
| عبد الرحمن السديس | `ar.abdurrahmaansudais` | 192 |
| عبد الباسط عبد الصمد | `ar.abdulbasitmurattal` | 192 |
| محمد صديق المنشاوي | `ar.minshawi` | 128 |
| محمود خليل الحصري | `ar.husary` | 128 |
| ماهر المعيقلي | `ar.mahermuaiqly` | 128 |
| سعود الشريم | `ar.saoodshuraym` | 128 |
| محمد أيوب | `ar.muhammadayyoub` | 128 |
| محمد جبريل | `ar.muhammadjibreel` | 128 |
| أحمد العجمي | `ar.ahmedalajmi` | 128 |

يستمر `QuranAudioRepository` في بناء رابط الآية من `cdn.islamic.network` مع global ayah number، وتُحفظ attribution داخل تجربة المشغل. أظهر اختبار release السابق بدء التلاوة، تغيّر القارئ إلى السديس، وتحديث الآية الجارية والتمييز المرئي. الاعتماد هنا على الشبكة مقصود؛ Quran Audio ليس offline، بينما Prayer Audio المحلي يعمل دون Internet لحظة التنبيه. توثيق API/CDN والمصدر القانوني موضح في [Al Quran Cloud API][2] و[Al Quran Cloud CDN][3] و[شروط المصدر][4].

## 6. Home، المصادر، والـReturn Experience

تتكون Home من Welcome Header هادئ، بطاقة مواقيت الصلاة، Quick Access للقرآن والأذكار والحديث والمفضلة، Continuation Canvas، Source Discovery، وGentle Utility Row. استُبعدت daily task/progress/challenges وبطاقات Daily Companion من مركز التجربة، لكن لم تُحذف المصادر الدينية نفسها. تظهر الخيوط بوصفها مساحات عودة إلى مصدر، لا كسجل إنجاز.

تستخدم CaptureSheet تسمية «من المصدر» وتضع النص الديني في منطقة مستقلة عن context أو private note. ويمكن إنشاء Thread بلا كتابة أي note. عند العودة، يُحل exact source route وتُحفظ ReadingAnchor وReflection وReturnEvent دون تغيير النص الديني. التذكيرات الموجودة مرتبطة بخيط اختاره المستخدم و`ReminderIntent` محددًا؛ لا يوجد تذكير آلي لمجرد الغياب ولا منطق يحاسب المستخدم على عدم العودة.

## 7. التغييرات الرئيسية في المستودع

| المجال | الملفات والمكونات الرئيسية |
|---|---|
| Memory domain | `lib/core/memory/domain/`، `MemoryThread`, `SourceReference`, `UserContext`, `ReflectionEntry`, `ReadingAnchor`, `ReturnEvent`, `ReminderIntent` |
| Drift/persistence | `lib/core/database/app_database.dart`, `app_database.g.dart`, migrations، repositories/providers الخاصة بالـmemory |
| Capture/Return UI | `lib/core/memory/presentation/`، CaptureSheet، Thread Detail، Continuation Canvas، exact return/deep link |
| Home/IA | `lib/features/home/presentation/home_screen.dart`، widgets وproviders المرتبطة بالـCanvas وPrayer Times |
| Prayer | `lib/features/prayer/application/prayer_times.dart`، بطاقة المواقيت، settings وربط الموقع/timezone/AlAdhan |
| Notifications | `lib/core/services/notification_service.dart`، `MainActivity.kt`، Manifest و`res/raw`، scheduled receiver/channel setup |
| Quran Audio | `lib/features/quran/application/quran_audio.dart`، player UI، reciters العشرة، CDN route |
| Quran/Azkar/Hadith | الشاشات والproviders ذات التهيئة الكسولة، و`lib/core/database/seeder/db_seeder.dart` |
| QA | اختبارات `test/memory/` و`test/app_database_test.dart`، وسجلات `athr_final_qa_*.log` وأدلة `evidence/` |

لم تُعدّل النصوص الدينية أو أصولها أثناء جولة Prayer Audio والتوسعة. كما لم تُضف مصادر دينية جديدة غير موثقة أو أي طبقة AI لتفسير أو تغيير المحتوى.

## 8. Final QA الفعلية

شُغّلت الفحوص فعليًا داخل بيئة Flutter، ولم تُعتبر أي نتيجة نجاحًا ضمنيًا. الإصدارات التي كانت حاضرة أثناء الجولة هي Flutter `3.47.0` وDart `3.13.0`.

| الفحص | النتيجة الفعلية | الحكم |
|---|---|---|
| `flutter test` | `33` اختبارًا ناجحًا، `0` فشل، `All tests passed!`, exit `0` | ناجح |
| `flutter analyze` الكامل | exit `1` بسبب `8 info` فقط، دون warning أو error | غير clean، لكنه غير حاجب وفق baseline المعتمد |
| Phase-scoped analyzer | لا مشكلات ضمن نطاق Phase 0–5 السابق | ناجح |
| `git diff --check` | exit `0` بلا output | ناجح |
| `flutter build apk --release` | exit `0`، Gradle `assembleRelease` ناجح | ناجح |
| APK ZIP integrity | `unzip -tqq` exit `0` | ناجح |
| تثبيت APK release | `adb install -r` exit `0`, `Success` | ناجح |
| Prayer Audio background delivery | سجل Android فعلي بالمورد المحلي، القناة alarm، وtitle الاختبار | ناجح على المحاكي |

### الـ8 ملاحظات في analyzer

الملاحظات الثماني كلها `info` وليست warning أو error. توجد ملاحظة `unnecessary_library_name` في page-flip، وأربع ملاحظات مرتبطة بـ`use_super_parameters` أو deprecation داخل page-flip، وثلاث ملاحظات `curly_braces_in_flow_control_structures` في hadith/search. هذه هي نفس legacy baseline الموثق والمعتمد قبل هذه الجولة. لا تؤثر على compilation أو runtime الصحيح لمسار Prayer Audio، ولم تُنتجها تغييرات هذه الجولة. لم تُصلح، ولم تُخفَ، ولم يُعدّل `analysis_options.yaml` لإسكاتها؛ Flutter حدّث الملف تلقائيًا أثناء الفحص والبناء، ثم أُعيد إلى حالته الأصلية بعد كل تشغيل.

## 9. Regression verification والقيود المتبقية

تظل حدود المصدر/المستخدم سليمة في اختبارات persistence وcapture وreturn. لم يظهر في diff النهائي أي مسار لـstreak أو score أو challenge أو guilt أو social engagement أو mood inference. لا يوجد قرآن Audio محلي داخل assets؛ المقاطع المحلية الخمسة تخص فقط نطق أسماء الصلوات القصيرة.

واجهت الجلسات السابقة تأخرًا وANR ظاهريًا في debug على محاكي API 28 بسبب JIT وتهيئة محلية ثقيلة، ثم عولج bootstrap بتأجيل الأعمال الثقيلة. كما ظهر خطأ timezone عند تهيئة التنبيهات كسولًا وخطأ isolate في seed الحديث؛ تم إصلاحهما بدل اعتبارهما نجاحًا ضمنيًا. نسخة release الحالية رسمت Home وSettings واجتازت اختبار الخلفية دون native audio/resource errors.

لا تزال البنود التالية **technical debt أو hardening، وليست blocker لقرار Release Candidate الحالي**: تنظيف ملاحظات analyzer الثماني في دورة مستقلة؛ اختبار GPS permission بالرفض والسماح على جهاز حقيقي؛ اختبار إشعار في وقت صلاة حقيقي؛ اختبار DND وbattery optimization وسلوك OEM؛ اختبار السماع الفعلي لمقاطع Prayer Audio من مكبر جهاز حقيقي؛ اختبار فقد الشبكة أثناء Quran Audio؛ وقياس سرعة seed الأولى على Android حقيقي. كما أن Quran Audio يعتمد على CDN خارجي، لذلك لا ينبغي وصفه بأنه offline.

يحذّر بناء release من أن Gradle `8.14.0` وAGP `8.11.1` وKotlin `2.2.20` ستحتاج إلى ترقية مستقبلية قبل أن تُسقط Flutter دعمها لها. هذه تحذيرات toolchain مستقبلية ظهرت أثناء build، ولم تمنع البناء الحالي.

## 10. APK النهائي

| الحقل | القيمة |
|---|---|
| المسار | `/home/ubuntu/athr/build/app/outputs/flutter-apk/app-release.apk` |
| الحجم | `95,384,508` bytes، وظهر في Flutter كمقاس `95.4 MB` |
| SHA-256 | `383b9be2a426f276fdfa02cc3f3c1c699050bb0ba8cd6a5ca618dc5afa9c88f4` |
| package | `com.athr.athr` |
| version | `versionCode=1`, `targetSdk=36`, `minSdk=24` |
| zip integrity | `unzip -tqq` exit `0` |

## 11. القرار النهائي

**GO — Final Release Candidate.** يمكن تثبيت APK الحالي ومراجعته؛ فمسار Memory Threads، Capture/Return، Continuation Canvas، Prayer infrastructure، Quran Audio، قائمة القراء العشرة، وPrayer Audio المحلي المجدول اجتازت الفحوص الفعلية الأساسية. تمت إضافة الدليل الذي كان ناقصًا: إشعار صلاة مجدول محليًا، نُشر بعد وضع التطبيق في الخلفية، استخدم URI المورد الصوتي المحلي الصحيح و`USAGE_ALARM`، ولم يظهر معه فشل native.

هذا **GO لنسخة Release Candidate وليس ادعاءً بإغلاق اختبار الأجهزة الواقعية**. لا يُنصح بالنشر الواسع قبل تنفيذ hardening الخاص بـGPS، وقت صلاة فعلي، OEM/DND، السماع من مكبر حقيقي، network loss، وزمن seed. لا يوجد مع ذلك blocker correctness أو compile أو test يمنع تسليم النسخة الحالية للمراجعة النهائية.

## References

[1]: https://aladhan.com/prayer-times-api "AlAdhan Prayer Times API"

[2]: https://alquran.cloud/api "Al Quran Cloud API"

[3]: https://alquran.cloud/cdn "Al Quran Cloud CDN"

[4]: https://alquran.cloud/terms-and-conditions "Al Quran Cloud Terms and Conditions"

[5]: https://api-docs.quran.foundation/ "Quran Foundation Developer Portal"

[6]: https://quran.com/en/developers "Quran.com Developers"
