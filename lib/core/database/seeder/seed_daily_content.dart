class SeedDailySunnah {
  final String id;
  final String title;
  final String description;
  final String howToApply;
  final String source;

  const SeedDailySunnah({
    required this.id,
    required this.title,
    required this.description,
    required this.howToApply,
    required this.source,
  });
}

class SeedDailyTask {
  final String id;
  final String title;
  final String description;
  final String impact;

  const SeedDailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.impact,
  });
}

const seedDailySunnahEntries = <SeedDailySunnah>[
  SeedDailySunnah(
    id: 'right-hand',
    title: 'التيامن في الأمور الطيبة',
    description: 'ابدأ باليمين عند اللبس والأكل وما شابه من الأعمال اليومية.',
    howToApply: 'اختر موقفًا واحدًا اليوم والتزم فيه بالتيامن بوعي.',
    source: 'صحيح البخاري وصحيح مسلم',
  ),
  SeedDailySunnah(
    id: 'smile',
    title: 'البشاشة ولين اللقاء',
    description: 'اجعل أول لقاءاتك اليوم أخف وألطف بالابتسامة وحسن الاستقبال.',
    howToApply: 'ابدأ بها مع أهل البيت أو زميل العمل أو البائع الذي تقابله.',
    source: 'المعنى ثابت في أبواب حسن الخلق وآداب المعاملة',
  ),
  SeedDailySunnah(
    id: 'dua-enter-home',
    title: 'ذكر دخول المنزل',
    description:
        'اربط الرجوع إلى البيت بالسكينة والذكر بدل الدخول على عجلة وغفلة.',
    howToApply: 'اقرأ ذكر الدخول عند أول عودة للمنزل اليوم.',
    source: 'حصن المسلم',
  ),
  SeedDailySunnah(
    id: 'wudu-before-sleep',
    title: 'النوم على طهارة',
    description: 'اجعل ختام اليوم بطهارة وهدوء ونية صالحة قبل النوم.',
    howToApply: 'توضأ قبل النوم الليلة ولو كنت متعبًا.',
    source: 'صحيح البخاري',
  ),
  SeedDailySunnah(
    id: 'dhikr-after-prayer',
    title: 'المداومة على الذكر بعد الصلاة',
    description: 'لا تجعل الصلاة تنتهي عند السلام، بل اربطها بالذكر اللاحق.',
    howToApply: 'اختر صلاة واحدة اليوم واحفظ ما بعدها من أذكار.',
    source: 'حصن المسلم وأبواب الأذكار بعد الصلاة',
  ),
];

const seedDailyTaskEntries = <SeedDailyTask>[
  SeedDailyTask(
    id: 'two-pages-quran',
    title: 'ورد قصير من القرآن',
    description: 'اقرأ صفحتين فقط بتركيز، ولا تحاول تحميل اليوم أكثر من طاقته.',
    impact: 'يبني استمرارية يومية ثابتة بدل الحماس المتقطع.',
  ),
  SeedDailyTask(
    id: 'call-parents',
    title: 'صلة رحم صغيرة',
    description: 'تواصل مع والد أو قريب برسالة أو اتصال قصير بنية البر.',
    impact: 'ينقل التطبيق من قراءة المحتوى إلى أثر عملي مباشر.',
  ),
  SeedDailyTask(
    id: 'charity-small',
    title: 'صدقة يسيرة',
    description: 'خصص مبلغًا بسيطًا أو قدم نفعًا عمليًا لأحد اليوم.',
    impact: 'يدرب النفس على العمل لا على الاكتفاء بالمعرفة.',
  ),
  SeedDailyTask(
    id: 'forgive-someone',
    title: 'إصلاح قلب',
    description: 'اترك خصومة صغيرة أو ادفع عن نفسك رغبة الرد القاسي.',
    impact: 'يرفع جودة اليوم من الداخل حتى لو لم يره أحد.',
  ),
  SeedDailyTask(
    id: 'morning-adhkar',
    title: 'جلسة أذكار كاملة',
    description: 'أكمل تصنيفًا واحدًا من الأذكار بتركيز بدل المرور السريع.',
    impact: 'يحوّل الأذكار من عادة سريعة إلى حضور فعلي.',
  ),
];
