class SituationVerseReference {
  final int surahNumber;
  final int ayahNumber;
  final String sourceLabel;

  const SituationVerseReference({
    required this.surahNumber,
    required this.ayahNumber,
    required this.sourceLabel,
  });
}

class SituationHadithReference {
  final String bookName;
  final String chapterKeyword;
  final String sourceLabel;

  const SituationHadithReference({
    required this.bookName,
    required this.chapterKeyword,
    required this.sourceLabel,
  });
}

class SituationContentBlock {
  final String intro;
  final List<String> actionSteps;
  final List<SituationVerseReference> verses;
  final List<SituationHadithReference> hadiths;

  const SituationContentBlock({
    required this.intro,
    required this.actionSteps,
    required this.verses,
    required this.hadiths,
  });
}

const situationsContent = <String, SituationContentBlock>{
  '1': SituationContentBlock(
    intro: 'هذه المساحة تجمع لك ما يخفف الحزن ويعيدك إلى الذكر والعمل الهادئ.',
    actionSteps: [
      'ابدأ بدعاء واحد تقرؤه بتمهل ثلاث مرات.',
      'اقرأ آية واحدة بصوت منخفض ثم اجلس دقيقة صامتًا.',
      'اختر شخصًا تثق به ولا تحمل همك وحدك طوال اليوم.',
    ],
    verses: [
      SituationVerseReference(
        surahNumber: 13,
        ayahNumber: 28,
        sourceLabel: 'سورة الرعد 28',
      ),
      SituationVerseReference(
        surahNumber: 94,
        ayahNumber: 5,
        sourceLabel: 'سورة الشرح 5',
      ),
    ],
    hadiths: [
      SituationHadithReference(
        bookName: 'صحيح مسلم',
        chapterKeyword: 'الذكر',
        sourceLabel: 'صحيح مسلم - أبواب الذكر',
      ),
    ],
  ),
  '2': SituationContentBlock(
    intro:
        'في الكرب، المطلوب أولًا تهدئة النفس، ثم دعاء واضح، ثم خطوة عملية صغيرة.',
    actionSteps: [
      'لا تتخذ قرارًا كبيرًا وأنت في ذروة الضيق.',
      'حوّل الدعاء إلى عادة قصيرة متكررة خلال اليوم.',
      'قسّم المشكلة إلى أصغر خطوة قابلة للتنفيذ الآن.',
    ],
    verses: [
      SituationVerseReference(
        surahNumber: 2,
        ayahNumber: 286,
        sourceLabel: 'سورة البقرة 286',
      ),
      SituationVerseReference(
        surahNumber: 65,
        ayahNumber: 3,
        sourceLabel: 'سورة الطلاق 3',
      ),
    ],
    hadiths: [
      SituationHadithReference(
        bookName: 'صحيح البخاري',
        chapterKeyword: 'الدعوات',
        sourceLabel: 'صحيح البخاري - كتاب الدعوات',
      ),
    ],
  ),
  '3': SituationContentBlock(
    intro:
        'عند تعسر الأمور، اجمع بين الاستعانة بالله والتنفيذ الهادئ دون استعجال.',
    actionSteps: [
      'اكتب ما الذي تعطل بالضبط بدل الشعور العام بالانسداد.',
      'اطلب التيسير ثم راجع أول خطوة عملية لا تزال ممكنة.',
      'كرر المحاولة بعد ترتيب الأولويات لا بعد زيادة التوتر.',
    ],
    verses: [
      SituationVerseReference(
        surahNumber: 94,
        ayahNumber: 6,
        sourceLabel: 'سورة الشرح 6',
      ),
      SituationVerseReference(
        surahNumber: 8,
        ayahNumber: 2,
        sourceLabel: 'سورة الأنفال 2',
      ),
    ],
    hadiths: [
      SituationHadithReference(
        bookName: 'صحيح مسلم',
        chapterKeyword: 'القدر',
        sourceLabel: 'صحيح مسلم - كتاب القدر',
      ),
    ],
  ),
  '4': SituationContentBlock(
    intro:
        'القلق يحتاج إيقاعًا أبطأ، وذكرًا قصيرًا، ومخرجًا من الدوران الذهني المستمر.',
    actionSteps: [
      'ابتعد عن المثير القريب للقلق لدقائق قليلة.',
      'اقرأ ما تيسر من الذكر ثم خفف المؤثرات حولك.',
      'نم مبكرًا إن كان القلق متصلًا بالإرهاق وتشتت اليوم.',
    ],
    verses: [
      SituationVerseReference(
        surahNumber: 21,
        ayahNumber: 83,
        sourceLabel: 'سورة الأنبياء 83',
      ),
      SituationVerseReference(
        surahNumber: 9,
        ayahNumber: 51,
        sourceLabel: 'سورة التوبة 51',
      ),
    ],
    hadiths: [
      SituationHadithReference(
        bookName: 'صحيح البخاري',
        chapterKeyword: 'الرقاق',
        sourceLabel: 'صحيح البخاري - كتاب الرقاق',
      ),
    ],
  ),
  '5': SituationContentBlock(
    intro:
        'بعد الذنب، الأهم هو سرعة الرجوع لا طول التردد، وترك باب القنوط مغلقًا.',
    actionSteps: [
      'أوقف الذنب فورًا إذا كان مستمرًا.',
      'استغفر مباشرة ثم اتبع ذلك بعمل صالح صغير.',
      'أبعد نفسك عن السبب الذي يعيدك لنفس الزلة اليوم.',
    ],
    verses: [
      SituationVerseReference(
        surahNumber: 39,
        ayahNumber: 53,
        sourceLabel: 'سورة الزمر 53',
      ),
      SituationVerseReference(
        surahNumber: 3,
        ayahNumber: 135,
        sourceLabel: 'سورة آل عمران 135',
      ),
    ],
    hadiths: [
      SituationHadithReference(
        bookName: 'صحيح مسلم',
        chapterKeyword: 'التوبة',
        sourceLabel: 'صحيح مسلم - كتاب التوبة',
      ),
    ],
  ),
  '6': SituationContentBlock(
    intro:
        'مع الشكوك والوساوس، لا توسع الحوار الداخلي؛ ارجع إلى الذكر وقطع الاسترسال.',
    actionSteps: [
      'لا تدخل في جدال ذهني طويل مع الوسواس.',
      'اقطع الاسترسال بذكر قصير واشتغال مباشر بعمل نافع.',
      'إن تكرر الأمر كثيرًا فخفف العزلة والإرهاق الذهني.',
    ],
    verses: [
      SituationVerseReference(
        surahNumber: 2,
        ayahNumber: 285,
        sourceLabel: 'سورة البقرة 285',
      ),
      SituationVerseReference(
        surahNumber: 41,
        ayahNumber: 36,
        sourceLabel: 'سورة فصلت 36',
      ),
    ],
    hadiths: [
      SituationHadithReference(
        bookName: 'صحيح مسلم',
        chapterKeyword: 'الإيمان',
        sourceLabel: 'صحيح مسلم - كتاب الإيمان',
      ),
    ],
  ),
  '7': SituationContentBlock(
    intro:
        'ضيق الدين يحتاج دعاءً صادقًا مع مراجعة عملية للالتزامات وترتيب الأولويات.',
    actionSteps: [
      'اكتب ما عليك وما يمكنك سداده هذا الأسبوع فقط.',
      'تجنب الإنفاق العاطفي حتى تهدأ الأزمة.',
      'اسأل أهل الثقة عن خطة سداد واقعية بدل التأجيل المفتوح.',
    ],
    verses: [
      SituationVerseReference(
        surahNumber: 2,
        ayahNumber: 280,
        sourceLabel: 'سورة البقرة 280',
      ),
      SituationVerseReference(
        surahNumber: 65,
        ayahNumber: 2,
        sourceLabel: 'سورة الطلاق 2',
      ),
    ],
    hadiths: [
      SituationHadithReference(
        bookName: 'صحيح البخاري',
        chapterKeyword: 'الاستقراض',
        sourceLabel: 'صحيح البخاري - كتاب الاستقراض',
      ),
    ],
  ),
  '8': SituationContentBlock(
    intro:
        'الغضب يعالج أولًا بقطع الاندفاع، ثم تغيير الحالة، ثم الرجوع للكلام المتزن.',
    actionSteps: [
      'توقف عن الرد الفوري إذا ارتفع صوتك أو تسارع نفسُك.',
      'غيّر وضعك الجسدي أو اترك المكان لدقائق.',
      'لا ترسل رسالة وأنت غاضب؛ اكتبها ثم امسحها.',
    ],
    verses: [
      SituationVerseReference(
        surahNumber: 3,
        ayahNumber: 134,
        sourceLabel: 'سورة آل عمران 134',
      ),
      SituationVerseReference(
        surahNumber: 42,
        ayahNumber: 37,
        sourceLabel: 'سورة الشورى 37',
      ),
    ],
    hadiths: [
      SituationHadithReference(
        bookName: 'صحيح البخاري',
        chapterKeyword: 'الأدب',
        sourceLabel: 'صحيح البخاري - كتاب الأدب',
      ),
    ],
  ),
};
