// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuranTafseerTableTable extends QuranTafseerTable
    with TableInfo<$QuranTafseerTableTable, QuranTafseer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranTafseerTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tafseerTextMeta = const VerificationMeta(
    'tafseerText',
  );
  @override
  late final GeneratedColumn<String> tafseerText = GeneratedColumn<String>(
    'tafseer_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    ayahNumber,
    tafseerText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran_tafseer_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuranTafseer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('tafseer_text')) {
      context.handle(
        _tafseerTextMeta,
        tafseerText.isAcceptableOrUnknown(
          data['tafseer_text']!,
          _tafseerTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tafseerTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranTafseer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranTafseer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      tafseerText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tafseer_text'],
      )!,
    );
  }

  @override
  $QuranTafseerTableTable createAlias(String alias) {
    return $QuranTafseerTableTable(attachedDatabase, alias);
  }
}

class QuranTafseer extends DataClass implements Insertable<QuranTafseer> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String tafseerText;
  const QuranTafseer({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.tafseerText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['tafseer_text'] = Variable<String>(tafseerText);
    return map;
  }

  QuranTafseerTableCompanion toCompanion(bool nullToAbsent) {
    return QuranTafseerTableCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      tafseerText: Value(tafseerText),
    );
  }

  factory QuranTafseer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranTafseer(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      tafseerText: serializer.fromJson<String>(json['tafseerText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'tafseerText': serializer.toJson<String>(tafseerText),
    };
  }

  QuranTafseer copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    String? tafseerText,
  }) => QuranTafseer(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    tafseerText: tafseerText ?? this.tafseerText,
  );
  QuranTafseer copyWithCompanion(QuranTafseerTableCompanion data) {
    return QuranTafseer(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      tafseerText: data.tafseerText.present
          ? data.tafseerText.value
          : this.tafseerText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuranTafseer(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('tafseerText: $tafseerText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahNumber, ayahNumber, tafseerText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranTafseer &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.tafseerText == this.tafseerText);
}

class QuranTafseerTableCompanion extends UpdateCompanion<QuranTafseer> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> tafseerText;
  const QuranTafseerTableCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.tafseerText = const Value.absent(),
  });
  QuranTafseerTableCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    required String tafseerText,
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       tafseerText = Value(tafseerText);
  static Insertable<QuranTafseer> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? tafseerText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (tafseerText != null) 'tafseer_text': tafseerText,
    });
  }

  QuranTafseerTableCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<String>? tafseerText,
  }) {
    return QuranTafseerTableCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      tafseerText: tafseerText ?? this.tafseerText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (tafseerText.present) {
      map['tafseer_text'] = Variable<String>(tafseerText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranTafseerTableCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('tafseerText: $tafseerText')
          ..write(')'))
        .toString();
  }
}

class $HadithTableTable extends HadithTable
    with TableInfo<$HadithTableTable, Hadith> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HadithTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookNameMeta = const VerificationMeta(
    'bookName',
  );
  @override
  late final GeneratedColumn<String> bookName = GeneratedColumn<String>(
    'book_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterNameMeta = const VerificationMeta(
    'chapterName',
  );
  @override
  late final GeneratedColumn<String> chapterName = GeneratedColumn<String>(
    'chapter_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hadithTextArMeta = const VerificationMeta(
    'hadithTextAr',
  );
  @override
  late final GeneratedColumn<String> hadithTextAr = GeneratedColumn<String>(
    'hadith_text_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hadithTextEnMeta = const VerificationMeta(
    'hadithTextEn',
  );
  @override
  late final GeneratedColumn<String> hadithTextEn = GeneratedColumn<String>(
    'hadith_text_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isBookmarkedMeta = const VerificationMeta(
    'isBookmarked',
  );
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
    'is_bookmarked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bookmarked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookName,
    chapterName,
    reference,
    hadithTextAr,
    hadithTextEn,
    isBookmarked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hadith_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Hadith> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_name')) {
      context.handle(
        _bookNameMeta,
        bookName.isAcceptableOrUnknown(data['book_name']!, _bookNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bookNameMeta);
    }
    if (data.containsKey('chapter_name')) {
      context.handle(
        _chapterNameMeta,
        chapterName.isAcceptableOrUnknown(
          data['chapter_name']!,
          _chapterNameMeta,
        ),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('hadith_text_ar')) {
      context.handle(
        _hadithTextArMeta,
        hadithTextAr.isAcceptableOrUnknown(
          data['hadith_text_ar']!,
          _hadithTextArMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hadithTextArMeta);
    }
    if (data.containsKey('hadith_text_en')) {
      context.handle(
        _hadithTextEnMeta,
        hadithTextEn.isAcceptableOrUnknown(
          data['hadith_text_en']!,
          _hadithTextEnMeta,
        ),
      );
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
        _isBookmarkedMeta,
        isBookmarked.isAcceptableOrUnknown(
          data['is_bookmarked']!,
          _isBookmarkedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hadith map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hadith(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_name'],
      )!,
      chapterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_name'],
      ),
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      hadithTextAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hadith_text_ar'],
      )!,
      hadithTextEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hadith_text_en'],
      ),
      isBookmarked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bookmarked'],
      )!,
    );
  }

  @override
  $HadithTableTable createAlias(String alias) {
    return $HadithTableTable(attachedDatabase, alias);
  }
}

class Hadith extends DataClass implements Insertable<Hadith> {
  final int id;
  final String bookName;
  final String? chapterName;
  final String? reference;
  final String hadithTextAr;
  final String? hadithTextEn;
  final bool isBookmarked;
  const Hadith({
    required this.id,
    required this.bookName,
    this.chapterName,
    this.reference,
    required this.hadithTextAr,
    this.hadithTextEn,
    required this.isBookmarked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_name'] = Variable<String>(bookName);
    if (!nullToAbsent || chapterName != null) {
      map['chapter_name'] = Variable<String>(chapterName);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['hadith_text_ar'] = Variable<String>(hadithTextAr);
    if (!nullToAbsent || hadithTextEn != null) {
      map['hadith_text_en'] = Variable<String>(hadithTextEn);
    }
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    return map;
  }

  HadithTableCompanion toCompanion(bool nullToAbsent) {
    return HadithTableCompanion(
      id: Value(id),
      bookName: Value(bookName),
      chapterName: chapterName == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterName),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      hadithTextAr: Value(hadithTextAr),
      hadithTextEn: hadithTextEn == null && nullToAbsent
          ? const Value.absent()
          : Value(hadithTextEn),
      isBookmarked: Value(isBookmarked),
    );
  }

  factory Hadith.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hadith(
      id: serializer.fromJson<int>(json['id']),
      bookName: serializer.fromJson<String>(json['bookName']),
      chapterName: serializer.fromJson<String?>(json['chapterName']),
      reference: serializer.fromJson<String?>(json['reference']),
      hadithTextAr: serializer.fromJson<String>(json['hadithTextAr']),
      hadithTextEn: serializer.fromJson<String?>(json['hadithTextEn']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookName': serializer.toJson<String>(bookName),
      'chapterName': serializer.toJson<String?>(chapterName),
      'reference': serializer.toJson<String?>(reference),
      'hadithTextAr': serializer.toJson<String>(hadithTextAr),
      'hadithTextEn': serializer.toJson<String?>(hadithTextEn),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
    };
  }

  Hadith copyWith({
    int? id,
    String? bookName,
    Value<String?> chapterName = const Value.absent(),
    Value<String?> reference = const Value.absent(),
    String? hadithTextAr,
    Value<String?> hadithTextEn = const Value.absent(),
    bool? isBookmarked,
  }) => Hadith(
    id: id ?? this.id,
    bookName: bookName ?? this.bookName,
    chapterName: chapterName.present ? chapterName.value : this.chapterName,
    reference: reference.present ? reference.value : this.reference,
    hadithTextAr: hadithTextAr ?? this.hadithTextAr,
    hadithTextEn: hadithTextEn.present ? hadithTextEn.value : this.hadithTextEn,
    isBookmarked: isBookmarked ?? this.isBookmarked,
  );
  Hadith copyWithCompanion(HadithTableCompanion data) {
    return Hadith(
      id: data.id.present ? data.id.value : this.id,
      bookName: data.bookName.present ? data.bookName.value : this.bookName,
      chapterName: data.chapterName.present
          ? data.chapterName.value
          : this.chapterName,
      reference: data.reference.present ? data.reference.value : this.reference,
      hadithTextAr: data.hadithTextAr.present
          ? data.hadithTextAr.value
          : this.hadithTextAr,
      hadithTextEn: data.hadithTextEn.present
          ? data.hadithTextEn.value
          : this.hadithTextEn,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hadith(')
          ..write('id: $id, ')
          ..write('bookName: $bookName, ')
          ..write('chapterName: $chapterName, ')
          ..write('reference: $reference, ')
          ..write('hadithTextAr: $hadithTextAr, ')
          ..write('hadithTextEn: $hadithTextEn, ')
          ..write('isBookmarked: $isBookmarked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookName,
    chapterName,
    reference,
    hadithTextAr,
    hadithTextEn,
    isBookmarked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hadith &&
          other.id == this.id &&
          other.bookName == this.bookName &&
          other.chapterName == this.chapterName &&
          other.reference == this.reference &&
          other.hadithTextAr == this.hadithTextAr &&
          other.hadithTextEn == this.hadithTextEn &&
          other.isBookmarked == this.isBookmarked);
}

class HadithTableCompanion extends UpdateCompanion<Hadith> {
  final Value<int> id;
  final Value<String> bookName;
  final Value<String?> chapterName;
  final Value<String?> reference;
  final Value<String> hadithTextAr;
  final Value<String?> hadithTextEn;
  final Value<bool> isBookmarked;
  const HadithTableCompanion({
    this.id = const Value.absent(),
    this.bookName = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.reference = const Value.absent(),
    this.hadithTextAr = const Value.absent(),
    this.hadithTextEn = const Value.absent(),
    this.isBookmarked = const Value.absent(),
  });
  HadithTableCompanion.insert({
    this.id = const Value.absent(),
    required String bookName,
    this.chapterName = const Value.absent(),
    this.reference = const Value.absent(),
    required String hadithTextAr,
    this.hadithTextEn = const Value.absent(),
    this.isBookmarked = const Value.absent(),
  }) : bookName = Value(bookName),
       hadithTextAr = Value(hadithTextAr);
  static Insertable<Hadith> custom({
    Expression<int>? id,
    Expression<String>? bookName,
    Expression<String>? chapterName,
    Expression<String>? reference,
    Expression<String>? hadithTextAr,
    Expression<String>? hadithTextEn,
    Expression<bool>? isBookmarked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookName != null) 'book_name': bookName,
      if (chapterName != null) 'chapter_name': chapterName,
      if (reference != null) 'reference': reference,
      if (hadithTextAr != null) 'hadith_text_ar': hadithTextAr,
      if (hadithTextEn != null) 'hadith_text_en': hadithTextEn,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
    });
  }

  HadithTableCompanion copyWith({
    Value<int>? id,
    Value<String>? bookName,
    Value<String?>? chapterName,
    Value<String?>? reference,
    Value<String>? hadithTextAr,
    Value<String?>? hadithTextEn,
    Value<bool>? isBookmarked,
  }) {
    return HadithTableCompanion(
      id: id ?? this.id,
      bookName: bookName ?? this.bookName,
      chapterName: chapterName ?? this.chapterName,
      reference: reference ?? this.reference,
      hadithTextAr: hadithTextAr ?? this.hadithTextAr,
      hadithTextEn: hadithTextEn ?? this.hadithTextEn,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookName.present) {
      map['book_name'] = Variable<String>(bookName.value);
    }
    if (chapterName.present) {
      map['chapter_name'] = Variable<String>(chapterName.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (hadithTextAr.present) {
      map['hadith_text_ar'] = Variable<String>(hadithTextAr.value);
    }
    if (hadithTextEn.present) {
      map['hadith_text_en'] = Variable<String>(hadithTextEn.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HadithTableCompanion(')
          ..write('id: $id, ')
          ..write('bookName: $bookName, ')
          ..write('chapterName: $chapterName, ')
          ..write('reference: $reference, ')
          ..write('hadithTextAr: $hadithTextAr, ')
          ..write('hadithTextEn: $hadithTextEn, ')
          ..write('isBookmarked: $isBookmarked')
          ..write(')'))
        .toString();
  }
}

class $DuaTableTable extends DuaTable with TableInfo<$DuaTableTable, Dua> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duaTextMeta = const VerificationMeta(
    'duaText',
  );
  @override
  late final GeneratedColumn<String> duaText = GeneratedColumn<String>(
    'dua_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isBookmarkedMeta = const VerificationMeta(
    'isBookmarked',
  );
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
    'is_bookmarked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bookmarked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    duaText,
    reference,
    isBookmarked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dua_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dua> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('dua_text')) {
      context.handle(
        _duaTextMeta,
        duaText.isAcceptableOrUnknown(data['dua_text']!, _duaTextMeta),
      );
    } else if (isInserting) {
      context.missing(_duaTextMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
        _isBookmarkedMeta,
        isBookmarked.isAcceptableOrUnknown(
          data['is_bookmarked']!,
          _isBookmarkedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dua map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dua(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      duaText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_text'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      isBookmarked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bookmarked'],
      )!,
    );
  }

  @override
  $DuaTableTable createAlias(String alias) {
    return $DuaTableTable(attachedDatabase, alias);
  }
}

class Dua extends DataClass implements Insertable<Dua> {
  final int id;
  final String category;
  final String duaText;
  final String? reference;
  final bool isBookmarked;
  const Dua({
    required this.id,
    required this.category,
    required this.duaText,
    this.reference,
    required this.isBookmarked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['dua_text'] = Variable<String>(duaText);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    return map;
  }

  DuaTableCompanion toCompanion(bool nullToAbsent) {
    return DuaTableCompanion(
      id: Value(id),
      category: Value(category),
      duaText: Value(duaText),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      isBookmarked: Value(isBookmarked),
    );
  }

  factory Dua.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dua(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      duaText: serializer.fromJson<String>(json['duaText']),
      reference: serializer.fromJson<String?>(json['reference']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'duaText': serializer.toJson<String>(duaText),
      'reference': serializer.toJson<String?>(reference),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
    };
  }

  Dua copyWith({
    int? id,
    String? category,
    String? duaText,
    Value<String?> reference = const Value.absent(),
    bool? isBookmarked,
  }) => Dua(
    id: id ?? this.id,
    category: category ?? this.category,
    duaText: duaText ?? this.duaText,
    reference: reference.present ? reference.value : this.reference,
    isBookmarked: isBookmarked ?? this.isBookmarked,
  );
  Dua copyWithCompanion(DuaTableCompanion data) {
    return Dua(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      duaText: data.duaText.present ? data.duaText.value : this.duaText,
      reference: data.reference.present ? data.reference.value : this.reference,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dua(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('duaText: $duaText, ')
          ..write('reference: $reference, ')
          ..write('isBookmarked: $isBookmarked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, category, duaText, reference, isBookmarked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dua &&
          other.id == this.id &&
          other.category == this.category &&
          other.duaText == this.duaText &&
          other.reference == this.reference &&
          other.isBookmarked == this.isBookmarked);
}

class DuaTableCompanion extends UpdateCompanion<Dua> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> duaText;
  final Value<String?> reference;
  final Value<bool> isBookmarked;
  const DuaTableCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.duaText = const Value.absent(),
    this.reference = const Value.absent(),
    this.isBookmarked = const Value.absent(),
  });
  DuaTableCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String duaText,
    this.reference = const Value.absent(),
    this.isBookmarked = const Value.absent(),
  }) : category = Value(category),
       duaText = Value(duaText);
  static Insertable<Dua> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? duaText,
    Expression<String>? reference,
    Expression<bool>? isBookmarked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (duaText != null) 'dua_text': duaText,
      if (reference != null) 'reference': reference,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
    });
  }

  DuaTableCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? duaText,
    Value<String?>? reference,
    Value<bool>? isBookmarked,
  }) {
    return DuaTableCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      duaText: duaText ?? this.duaText,
      reference: reference ?? this.reference,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (duaText.present) {
      map['dua_text'] = Variable<String>(duaText.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuaTableCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('duaText: $duaText, ')
          ..write('reference: $reference, ')
          ..write('isBookmarked: $isBookmarked')
          ..write(')'))
        .toString();
  }
}

class $DailySunnahTableTable extends DailySunnahTable
    with TableInfo<$DailySunnahTableTable, DailySunnah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySunnahTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _howToApplyMeta = const VerificationMeta(
    'howToApply',
  );
  @override
  late final GeneratedColumn<String> howToApply = GeneratedColumn<String>(
    'how_to_apply',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    howToApply,
    source,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_sunnah_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailySunnah> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('how_to_apply')) {
      context.handle(
        _howToApplyMeta,
        howToApply.isAcceptableOrUnknown(
          data['how_to_apply']!,
          _howToApplyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_howToApplyMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailySunnah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySunnah(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      howToApply: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}how_to_apply'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DailySunnahTableTable createAlias(String alias) {
    return $DailySunnahTableTable(attachedDatabase, alias);
  }
}

class DailySunnah extends DataClass implements Insertable<DailySunnah> {
  final String id;
  final String title;
  final String description;
  final String howToApply;
  final String source;
  final int sortOrder;
  const DailySunnah({
    required this.id,
    required this.title,
    required this.description,
    required this.howToApply,
    required this.source,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['how_to_apply'] = Variable<String>(howToApply);
    map['source'] = Variable<String>(source);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DailySunnahTableCompanion toCompanion(bool nullToAbsent) {
    return DailySunnahTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      howToApply: Value(howToApply),
      source: Value(source),
      sortOrder: Value(sortOrder),
    );
  }

  factory DailySunnah.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySunnah(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      howToApply: serializer.fromJson<String>(json['howToApply']),
      source: serializer.fromJson<String>(json['source']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'howToApply': serializer.toJson<String>(howToApply),
      'source': serializer.toJson<String>(source),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DailySunnah copyWith({
    String? id,
    String? title,
    String? description,
    String? howToApply,
    String? source,
    int? sortOrder,
  }) => DailySunnah(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    howToApply: howToApply ?? this.howToApply,
    source: source ?? this.source,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DailySunnah copyWithCompanion(DailySunnahTableCompanion data) {
    return DailySunnah(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      howToApply: data.howToApply.present
          ? data.howToApply.value
          : this.howToApply,
      source: data.source.present ? data.source.value : this.source,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySunnah(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('howToApply: $howToApply, ')
          ..write('source: $source, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, howToApply, source, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySunnah &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.howToApply == this.howToApply &&
          other.source == this.source &&
          other.sortOrder == this.sortOrder);
}

class DailySunnahTableCompanion extends UpdateCompanion<DailySunnah> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> howToApply;
  final Value<String> source;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DailySunnahTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.howToApply = const Value.absent(),
    this.source = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailySunnahTableCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String howToApply,
    required String source,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       howToApply = Value(howToApply),
       source = Value(source),
       sortOrder = Value(sortOrder);
  static Insertable<DailySunnah> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? howToApply,
    Expression<String>? source,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (howToApply != null) 'how_to_apply': howToApply,
      if (source != null) 'source': source,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailySunnahTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? howToApply,
    Value<String>? source,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DailySunnahTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      howToApply: howToApply ?? this.howToApply,
      source: source ?? this.source,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (howToApply.present) {
      map['how_to_apply'] = Variable<String>(howToApply.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySunnahTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('howToApply: $howToApply, ')
          ..write('source: $source, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyTaskTableTable extends DailyTaskTable
    with TableInfo<$DailyTaskTableTable, DailyTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyTaskTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _impactMeta = const VerificationMeta('impact');
  @override
  late final GeneratedColumn<String> impact = GeneratedColumn<String>(
    'impact',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    impact,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_task_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('impact')) {
      context.handle(
        _impactMeta,
        impact.isAcceptableOrUnknown(data['impact']!, _impactMeta),
      );
    } else if (isInserting) {
      context.missing(_impactMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      impact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}impact'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DailyTaskTableTable createAlias(String alias) {
    return $DailyTaskTableTable(attachedDatabase, alias);
  }
}

class DailyTask extends DataClass implements Insertable<DailyTask> {
  final String id;
  final String title;
  final String description;
  final String impact;
  final int sortOrder;
  const DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.impact,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['impact'] = Variable<String>(impact);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DailyTaskTableCompanion toCompanion(bool nullToAbsent) {
    return DailyTaskTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      impact: Value(impact),
      sortOrder: Value(sortOrder),
    );
  }

  factory DailyTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyTask(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      impact: serializer.fromJson<String>(json['impact']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'impact': serializer.toJson<String>(impact),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DailyTask copyWith({
    String? id,
    String? title,
    String? description,
    String? impact,
    int? sortOrder,
  }) => DailyTask(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    impact: impact ?? this.impact,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DailyTask copyWithCompanion(DailyTaskTableCompanion data) {
    return DailyTask(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      impact: data.impact.present ? data.impact.value : this.impact,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyTask(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('impact: $impact, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, impact, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyTask &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.impact == this.impact &&
          other.sortOrder == this.sortOrder);
}

class DailyTaskTableCompanion extends UpdateCompanion<DailyTask> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> impact;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DailyTaskTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.impact = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyTaskTableCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String impact,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       impact = Value(impact),
       sortOrder = Value(sortOrder);
  static Insertable<DailyTask> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? impact,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (impact != null) 'impact': impact,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyTaskTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? impact,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DailyTaskTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      impact: impact ?? this.impact,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (impact.present) {
      map['impact'] = Variable<String>(impact.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyTaskTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('impact: $impact, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MuhasabaEntryTableTable extends MuhasabaEntryTable
    with TableInfo<$MuhasabaEntryTableTable, MuhasabaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MuhasabaEntryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityDateMeta = const VerificationMeta(
    'activityDate',
  );
  @override
  late final GeneratedColumn<String> activityDate = GeneratedColumn<String>(
    'activity_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prayedMeta = const VerificationMeta('prayed');
  @override
  late final GeneratedColumn<bool> prayed = GeneratedColumn<bool>(
    'prayed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("prayed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _guardedTongueMeta = const VerificationMeta(
    'guardedTongue',
  );
  @override
  late final GeneratedColumn<bool> guardedTongue = GeneratedColumn<bool>(
    'guarded_tongue',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("guarded_tongue" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _honoredParentsMeta = const VerificationMeta(
    'honoredParents',
  );
  @override
  late final GeneratedColumn<bool> honoredParents = GeneratedColumn<bool>(
    'honored_parents',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("honored_parents" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _avoidedHarmMeta = const VerificationMeta(
    'avoidedHarm',
  );
  @override
  late final GeneratedColumn<bool> avoidedHarm = GeneratedColumn<bool>(
    'avoided_harm',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("avoided_harm" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _gaveCharityMeta = const VerificationMeta(
    'gaveCharity',
  );
  @override
  late final GeneratedColumn<bool> gaveCharity = GeneratedColumn<bool>(
    'gave_charity',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gave_charity" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _quranReadMeta = const VerificationMeta(
    'quranRead',
  );
  @override
  late final GeneratedColumn<bool> quranRead = GeneratedColumn<bool>(
    'quran_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("quran_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    activityDate,
    prayed,
    guardedTongue,
    honoredParents,
    avoidedHarm,
    gaveCharity,
    quranRead,
    note,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'muhasaba_entry_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MuhasabaEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_date')) {
      context.handle(
        _activityDateMeta,
        activityDate.isAcceptableOrUnknown(
          data['activity_date']!,
          _activityDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityDateMeta);
    }
    if (data.containsKey('prayed')) {
      context.handle(
        _prayedMeta,
        prayed.isAcceptableOrUnknown(data['prayed']!, _prayedMeta),
      );
    }
    if (data.containsKey('guarded_tongue')) {
      context.handle(
        _guardedTongueMeta,
        guardedTongue.isAcceptableOrUnknown(
          data['guarded_tongue']!,
          _guardedTongueMeta,
        ),
      );
    }
    if (data.containsKey('honored_parents')) {
      context.handle(
        _honoredParentsMeta,
        honoredParents.isAcceptableOrUnknown(
          data['honored_parents']!,
          _honoredParentsMeta,
        ),
      );
    }
    if (data.containsKey('avoided_harm')) {
      context.handle(
        _avoidedHarmMeta,
        avoidedHarm.isAcceptableOrUnknown(
          data['avoided_harm']!,
          _avoidedHarmMeta,
        ),
      );
    }
    if (data.containsKey('gave_charity')) {
      context.handle(
        _gaveCharityMeta,
        gaveCharity.isAcceptableOrUnknown(
          data['gave_charity']!,
          _gaveCharityMeta,
        ),
      );
    }
    if (data.containsKey('quran_read')) {
      context.handle(
        _quranReadMeta,
        quranRead.isAcceptableOrUnknown(data['quran_read']!, _quranReadMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityDate};
  @override
  MuhasabaEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MuhasabaEntry(
      activityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_date'],
      )!,
      prayed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prayed'],
      )!,
      guardedTongue: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}guarded_tongue'],
      )!,
      honoredParents: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}honored_parents'],
      )!,
      avoidedHarm: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}avoided_harm'],
      )!,
      gaveCharity: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gave_charity'],
      )!,
      quranRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}quran_read'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MuhasabaEntryTableTable createAlias(String alias) {
    return $MuhasabaEntryTableTable(attachedDatabase, alias);
  }
}

class MuhasabaEntry extends DataClass implements Insertable<MuhasabaEntry> {
  final String activityDate;
  final bool prayed;
  final bool guardedTongue;
  final bool honoredParents;
  final bool avoidedHarm;
  final bool gaveCharity;
  final bool quranRead;
  final String? note;
  final String updatedAt;
  const MuhasabaEntry({
    required this.activityDate,
    required this.prayed,
    required this.guardedTongue,
    required this.honoredParents,
    required this.avoidedHarm,
    required this.gaveCharity,
    required this.quranRead,
    this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_date'] = Variable<String>(activityDate);
    map['prayed'] = Variable<bool>(prayed);
    map['guarded_tongue'] = Variable<bool>(guardedTongue);
    map['honored_parents'] = Variable<bool>(honoredParents);
    map['avoided_harm'] = Variable<bool>(avoidedHarm);
    map['gave_charity'] = Variable<bool>(gaveCharity);
    map['quran_read'] = Variable<bool>(quranRead);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  MuhasabaEntryTableCompanion toCompanion(bool nullToAbsent) {
    return MuhasabaEntryTableCompanion(
      activityDate: Value(activityDate),
      prayed: Value(prayed),
      guardedTongue: Value(guardedTongue),
      honoredParents: Value(honoredParents),
      avoidedHarm: Value(avoidedHarm),
      gaveCharity: Value(gaveCharity),
      quranRead: Value(quranRead),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory MuhasabaEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MuhasabaEntry(
      activityDate: serializer.fromJson<String>(json['activityDate']),
      prayed: serializer.fromJson<bool>(json['prayed']),
      guardedTongue: serializer.fromJson<bool>(json['guardedTongue']),
      honoredParents: serializer.fromJson<bool>(json['honoredParents']),
      avoidedHarm: serializer.fromJson<bool>(json['avoidedHarm']),
      gaveCharity: serializer.fromJson<bool>(json['gaveCharity']),
      quranRead: serializer.fromJson<bool>(json['quranRead']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityDate': serializer.toJson<String>(activityDate),
      'prayed': serializer.toJson<bool>(prayed),
      'guardedTongue': serializer.toJson<bool>(guardedTongue),
      'honoredParents': serializer.toJson<bool>(honoredParents),
      'avoidedHarm': serializer.toJson<bool>(avoidedHarm),
      'gaveCharity': serializer.toJson<bool>(gaveCharity),
      'quranRead': serializer.toJson<bool>(quranRead),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  MuhasabaEntry copyWith({
    String? activityDate,
    bool? prayed,
    bool? guardedTongue,
    bool? honoredParents,
    bool? avoidedHarm,
    bool? gaveCharity,
    bool? quranRead,
    Value<String?> note = const Value.absent(),
    String? updatedAt,
  }) => MuhasabaEntry(
    activityDate: activityDate ?? this.activityDate,
    prayed: prayed ?? this.prayed,
    guardedTongue: guardedTongue ?? this.guardedTongue,
    honoredParents: honoredParents ?? this.honoredParents,
    avoidedHarm: avoidedHarm ?? this.avoidedHarm,
    gaveCharity: gaveCharity ?? this.gaveCharity,
    quranRead: quranRead ?? this.quranRead,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MuhasabaEntry copyWithCompanion(MuhasabaEntryTableCompanion data) {
    return MuhasabaEntry(
      activityDate: data.activityDate.present
          ? data.activityDate.value
          : this.activityDate,
      prayed: data.prayed.present ? data.prayed.value : this.prayed,
      guardedTongue: data.guardedTongue.present
          ? data.guardedTongue.value
          : this.guardedTongue,
      honoredParents: data.honoredParents.present
          ? data.honoredParents.value
          : this.honoredParents,
      avoidedHarm: data.avoidedHarm.present
          ? data.avoidedHarm.value
          : this.avoidedHarm,
      gaveCharity: data.gaveCharity.present
          ? data.gaveCharity.value
          : this.gaveCharity,
      quranRead: data.quranRead.present ? data.quranRead.value : this.quranRead,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MuhasabaEntry(')
          ..write('activityDate: $activityDate, ')
          ..write('prayed: $prayed, ')
          ..write('guardedTongue: $guardedTongue, ')
          ..write('honoredParents: $honoredParents, ')
          ..write('avoidedHarm: $avoidedHarm, ')
          ..write('gaveCharity: $gaveCharity, ')
          ..write('quranRead: $quranRead, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    activityDate,
    prayed,
    guardedTongue,
    honoredParents,
    avoidedHarm,
    gaveCharity,
    quranRead,
    note,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MuhasabaEntry &&
          other.activityDate == this.activityDate &&
          other.prayed == this.prayed &&
          other.guardedTongue == this.guardedTongue &&
          other.honoredParents == this.honoredParents &&
          other.avoidedHarm == this.avoidedHarm &&
          other.gaveCharity == this.gaveCharity &&
          other.quranRead == this.quranRead &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class MuhasabaEntryTableCompanion extends UpdateCompanion<MuhasabaEntry> {
  final Value<String> activityDate;
  final Value<bool> prayed;
  final Value<bool> guardedTongue;
  final Value<bool> honoredParents;
  final Value<bool> avoidedHarm;
  final Value<bool> gaveCharity;
  final Value<bool> quranRead;
  final Value<String?> note;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const MuhasabaEntryTableCompanion({
    this.activityDate = const Value.absent(),
    this.prayed = const Value.absent(),
    this.guardedTongue = const Value.absent(),
    this.honoredParents = const Value.absent(),
    this.avoidedHarm = const Value.absent(),
    this.gaveCharity = const Value.absent(),
    this.quranRead = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MuhasabaEntryTableCompanion.insert({
    required String activityDate,
    this.prayed = const Value.absent(),
    this.guardedTongue = const Value.absent(),
    this.honoredParents = const Value.absent(),
    this.avoidedHarm = const Value.absent(),
    this.gaveCharity = const Value.absent(),
    this.quranRead = const Value.absent(),
    this.note = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : activityDate = Value(activityDate),
       updatedAt = Value(updatedAt);
  static Insertable<MuhasabaEntry> custom({
    Expression<String>? activityDate,
    Expression<bool>? prayed,
    Expression<bool>? guardedTongue,
    Expression<bool>? honoredParents,
    Expression<bool>? avoidedHarm,
    Expression<bool>? gaveCharity,
    Expression<bool>? quranRead,
    Expression<String>? note,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityDate != null) 'activity_date': activityDate,
      if (prayed != null) 'prayed': prayed,
      if (guardedTongue != null) 'guarded_tongue': guardedTongue,
      if (honoredParents != null) 'honored_parents': honoredParents,
      if (avoidedHarm != null) 'avoided_harm': avoidedHarm,
      if (gaveCharity != null) 'gave_charity': gaveCharity,
      if (quranRead != null) 'quran_read': quranRead,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MuhasabaEntryTableCompanion copyWith({
    Value<String>? activityDate,
    Value<bool>? prayed,
    Value<bool>? guardedTongue,
    Value<bool>? honoredParents,
    Value<bool>? avoidedHarm,
    Value<bool>? gaveCharity,
    Value<bool>? quranRead,
    Value<String?>? note,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return MuhasabaEntryTableCompanion(
      activityDate: activityDate ?? this.activityDate,
      prayed: prayed ?? this.prayed,
      guardedTongue: guardedTongue ?? this.guardedTongue,
      honoredParents: honoredParents ?? this.honoredParents,
      avoidedHarm: avoidedHarm ?? this.avoidedHarm,
      gaveCharity: gaveCharity ?? this.gaveCharity,
      quranRead: quranRead ?? this.quranRead,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityDate.present) {
      map['activity_date'] = Variable<String>(activityDate.value);
    }
    if (prayed.present) {
      map['prayed'] = Variable<bool>(prayed.value);
    }
    if (guardedTongue.present) {
      map['guarded_tongue'] = Variable<bool>(guardedTongue.value);
    }
    if (honoredParents.present) {
      map['honored_parents'] = Variable<bool>(honoredParents.value);
    }
    if (avoidedHarm.present) {
      map['avoided_harm'] = Variable<bool>(avoidedHarm.value);
    }
    if (gaveCharity.present) {
      map['gave_charity'] = Variable<bool>(gaveCharity.value);
    }
    if (quranRead.present) {
      map['quran_read'] = Variable<bool>(quranRead.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MuhasabaEntryTableCompanion(')
          ..write('activityDate: $activityDate, ')
          ..write('prayed: $prayed, ')
          ..write('guardedTongue: $guardedTongue, ')
          ..write('honoredParents: $honoredParents, ')
          ..write('avoidedHarm: $avoidedHarm, ')
          ..write('gaveCharity: $gaveCharity, ')
          ..write('quranRead: $quranRead, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserFavoriteTableTable extends UserFavoriteTable
    with TableInfo<$UserFavoriteTableTable, UserFavorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserFavoriteTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryReferenceMeta = const VerificationMeta(
    'primaryReference',
  );
  @override
  late final GeneratedColumn<String> primaryReference = GeneratedColumn<String>(
    'primary_reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondaryReferenceMeta =
      const VerificationMeta('secondaryReference');
  @override
  late final GeneratedColumn<String> secondaryReference =
      GeneratedColumn<String>(
        'secondary_reference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTextMeta = const VerificationMeta(
    'contentText',
  );
  @override
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
    'content_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    contentType,
    primaryReference,
    secondaryReference,
    title,
    contentText,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_favorite_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserFavorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('primary_reference')) {
      context.handle(
        _primaryReferenceMeta,
        primaryReference.isAcceptableOrUnknown(
          data['primary_reference']!,
          _primaryReferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryReferenceMeta);
    }
    if (data.containsKey('secondary_reference')) {
      context.handle(
        _secondaryReferenceMeta,
        secondaryReference.isAcceptableOrUnknown(
          data['secondary_reference']!,
          _secondaryReferenceMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
        _contentTextMeta,
        contentText.isAcceptableOrUnknown(
          data['content_text']!,
          _contentTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {contentType, primaryReference},
  ];
  @override
  UserFavorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserFavorite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      primaryReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_reference'],
      )!,
      secondaryReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_reference'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      contentText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_text'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserFavoriteTableTable createAlias(String alias) {
    return $UserFavoriteTableTable(attachedDatabase, alias);
  }
}

class UserFavorite extends DataClass implements Insertable<UserFavorite> {
  final int id;
  final String contentType;
  final String primaryReference;
  final String? secondaryReference;
  final String title;
  final String contentText;
  final String source;
  final String createdAt;
  const UserFavorite({
    required this.id,
    required this.contentType,
    required this.primaryReference,
    this.secondaryReference,
    required this.title,
    required this.contentText,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content_type'] = Variable<String>(contentType);
    map['primary_reference'] = Variable<String>(primaryReference);
    if (!nullToAbsent || secondaryReference != null) {
      map['secondary_reference'] = Variable<String>(secondaryReference);
    }
    map['title'] = Variable<String>(title);
    map['content_text'] = Variable<String>(contentText);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  UserFavoriteTableCompanion toCompanion(bool nullToAbsent) {
    return UserFavoriteTableCompanion(
      id: Value(id),
      contentType: Value(contentType),
      primaryReference: Value(primaryReference),
      secondaryReference: secondaryReference == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryReference),
      title: Value(title),
      contentText: Value(contentText),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory UserFavorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserFavorite(
      id: serializer.fromJson<int>(json['id']),
      contentType: serializer.fromJson<String>(json['contentType']),
      primaryReference: serializer.fromJson<String>(json['primaryReference']),
      secondaryReference: serializer.fromJson<String?>(
        json['secondaryReference'],
      ),
      title: serializer.fromJson<String>(json['title']),
      contentText: serializer.fromJson<String>(json['contentText']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contentType': serializer.toJson<String>(contentType),
      'primaryReference': serializer.toJson<String>(primaryReference),
      'secondaryReference': serializer.toJson<String?>(secondaryReference),
      'title': serializer.toJson<String>(title),
      'contentText': serializer.toJson<String>(contentText),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  UserFavorite copyWith({
    int? id,
    String? contentType,
    String? primaryReference,
    Value<String?> secondaryReference = const Value.absent(),
    String? title,
    String? contentText,
    String? source,
    String? createdAt,
  }) => UserFavorite(
    id: id ?? this.id,
    contentType: contentType ?? this.contentType,
    primaryReference: primaryReference ?? this.primaryReference,
    secondaryReference: secondaryReference.present
        ? secondaryReference.value
        : this.secondaryReference,
    title: title ?? this.title,
    contentText: contentText ?? this.contentText,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  UserFavorite copyWithCompanion(UserFavoriteTableCompanion data) {
    return UserFavorite(
      id: data.id.present ? data.id.value : this.id,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      primaryReference: data.primaryReference.present
          ? data.primaryReference.value
          : this.primaryReference,
      secondaryReference: data.secondaryReference.present
          ? data.secondaryReference.value
          : this.secondaryReference,
      title: data.title.present ? data.title.value : this.title,
      contentText: data.contentText.present
          ? data.contentText.value
          : this.contentText,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserFavorite(')
          ..write('id: $id, ')
          ..write('contentType: $contentType, ')
          ..write('primaryReference: $primaryReference, ')
          ..write('secondaryReference: $secondaryReference, ')
          ..write('title: $title, ')
          ..write('contentText: $contentText, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    contentType,
    primaryReference,
    secondaryReference,
    title,
    contentText,
    source,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserFavorite &&
          other.id == this.id &&
          other.contentType == this.contentType &&
          other.primaryReference == this.primaryReference &&
          other.secondaryReference == this.secondaryReference &&
          other.title == this.title &&
          other.contentText == this.contentText &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class UserFavoriteTableCompanion extends UpdateCompanion<UserFavorite> {
  final Value<int> id;
  final Value<String> contentType;
  final Value<String> primaryReference;
  final Value<String?> secondaryReference;
  final Value<String> title;
  final Value<String> contentText;
  final Value<String> source;
  final Value<String> createdAt;
  const UserFavoriteTableCompanion({
    this.id = const Value.absent(),
    this.contentType = const Value.absent(),
    this.primaryReference = const Value.absent(),
    this.secondaryReference = const Value.absent(),
    this.title = const Value.absent(),
    this.contentText = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserFavoriteTableCompanion.insert({
    this.id = const Value.absent(),
    required String contentType,
    required String primaryReference,
    this.secondaryReference = const Value.absent(),
    required String title,
    required String contentText,
    required String source,
    required String createdAt,
  }) : contentType = Value(contentType),
       primaryReference = Value(primaryReference),
       title = Value(title),
       contentText = Value(contentText),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<UserFavorite> custom({
    Expression<int>? id,
    Expression<String>? contentType,
    Expression<String>? primaryReference,
    Expression<String>? secondaryReference,
    Expression<String>? title,
    Expression<String>? contentText,
    Expression<String>? source,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contentType != null) 'content_type': contentType,
      if (primaryReference != null) 'primary_reference': primaryReference,
      if (secondaryReference != null) 'secondary_reference': secondaryReference,
      if (title != null) 'title': title,
      if (contentText != null) 'content_text': contentText,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserFavoriteTableCompanion copyWith({
    Value<int>? id,
    Value<String>? contentType,
    Value<String>? primaryReference,
    Value<String?>? secondaryReference,
    Value<String>? title,
    Value<String>? contentText,
    Value<String>? source,
    Value<String>? createdAt,
  }) {
    return UserFavoriteTableCompanion(
      id: id ?? this.id,
      contentType: contentType ?? this.contentType,
      primaryReference: primaryReference ?? this.primaryReference,
      secondaryReference: secondaryReference ?? this.secondaryReference,
      title: title ?? this.title,
      contentText: contentText ?? this.contentText,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (primaryReference.present) {
      map['primary_reference'] = Variable<String>(primaryReference.value);
    }
    if (secondaryReference.present) {
      map['secondary_reference'] = Variable<String>(secondaryReference.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserFavoriteTableCompanion(')
          ..write('id: $id, ')
          ..write('contentType: $contentType, ')
          ..write('primaryReference: $primaryReference, ')
          ..write('secondaryReference: $secondaryReference, ')
          ..write('title: $title, ')
          ..write('contentText: $contentText, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserDailyActivityTableTable extends UserDailyActivityTable
    with TableInfo<$UserDailyActivityTableTable, UserDailyActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserDailyActivityTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityDateMeta = const VerificationMeta(
    'activityDate',
  );
  @override
  late final GeneratedColumn<String> activityDate = GeneratedColumn<String>(
    'activity_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedTaskIdMeta = const VerificationMeta(
    'completedTaskId',
  );
  @override
  late final GeneratedColumn<String> completedTaskId = GeneratedColumn<String>(
    'completed_task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedSunnahIdMeta = const VerificationMeta(
    'completedSunnahId',
  );
  @override
  late final GeneratedColumn<String> completedSunnahId =
      GeneratedColumn<String>(
        'completed_sunnah_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    activityDate,
    completedTaskId,
    completedSunnahId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_daily_activity_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserDailyActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_date')) {
      context.handle(
        _activityDateMeta,
        activityDate.isAcceptableOrUnknown(
          data['activity_date']!,
          _activityDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityDateMeta);
    }
    if (data.containsKey('completed_task_id')) {
      context.handle(
        _completedTaskIdMeta,
        completedTaskId.isAcceptableOrUnknown(
          data['completed_task_id']!,
          _completedTaskIdMeta,
        ),
      );
    }
    if (data.containsKey('completed_sunnah_id')) {
      context.handle(
        _completedSunnahIdMeta,
        completedSunnahId.isAcceptableOrUnknown(
          data['completed_sunnah_id']!,
          _completedSunnahIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityDate};
  @override
  UserDailyActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserDailyActivity(
      activityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_date'],
      )!,
      completedTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_task_id'],
      ),
      completedSunnahId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_sunnah_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserDailyActivityTableTable createAlias(String alias) {
    return $UserDailyActivityTableTable(attachedDatabase, alias);
  }
}

class UserDailyActivity extends DataClass
    implements Insertable<UserDailyActivity> {
  final String activityDate;
  final String? completedTaskId;
  final String? completedSunnahId;
  final String updatedAt;
  const UserDailyActivity({
    required this.activityDate,
    this.completedTaskId,
    this.completedSunnahId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_date'] = Variable<String>(activityDate);
    if (!nullToAbsent || completedTaskId != null) {
      map['completed_task_id'] = Variable<String>(completedTaskId);
    }
    if (!nullToAbsent || completedSunnahId != null) {
      map['completed_sunnah_id'] = Variable<String>(completedSunnahId);
    }
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  UserDailyActivityTableCompanion toCompanion(bool nullToAbsent) {
    return UserDailyActivityTableCompanion(
      activityDate: Value(activityDate),
      completedTaskId: completedTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(completedTaskId),
      completedSunnahId: completedSunnahId == null && nullToAbsent
          ? const Value.absent()
          : Value(completedSunnahId),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserDailyActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserDailyActivity(
      activityDate: serializer.fromJson<String>(json['activityDate']),
      completedTaskId: serializer.fromJson<String?>(json['completedTaskId']),
      completedSunnahId: serializer.fromJson<String?>(
        json['completedSunnahId'],
      ),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityDate': serializer.toJson<String>(activityDate),
      'completedTaskId': serializer.toJson<String?>(completedTaskId),
      'completedSunnahId': serializer.toJson<String?>(completedSunnahId),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  UserDailyActivity copyWith({
    String? activityDate,
    Value<String?> completedTaskId = const Value.absent(),
    Value<String?> completedSunnahId = const Value.absent(),
    String? updatedAt,
  }) => UserDailyActivity(
    activityDate: activityDate ?? this.activityDate,
    completedTaskId: completedTaskId.present
        ? completedTaskId.value
        : this.completedTaskId,
    completedSunnahId: completedSunnahId.present
        ? completedSunnahId.value
        : this.completedSunnahId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserDailyActivity copyWithCompanion(UserDailyActivityTableCompanion data) {
    return UserDailyActivity(
      activityDate: data.activityDate.present
          ? data.activityDate.value
          : this.activityDate,
      completedTaskId: data.completedTaskId.present
          ? data.completedTaskId.value
          : this.completedTaskId,
      completedSunnahId: data.completedSunnahId.present
          ? data.completedSunnahId.value
          : this.completedSunnahId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserDailyActivity(')
          ..write('activityDate: $activityDate, ')
          ..write('completedTaskId: $completedTaskId, ')
          ..write('completedSunnahId: $completedSunnahId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(activityDate, completedTaskId, completedSunnahId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserDailyActivity &&
          other.activityDate == this.activityDate &&
          other.completedTaskId == this.completedTaskId &&
          other.completedSunnahId == this.completedSunnahId &&
          other.updatedAt == this.updatedAt);
}

class UserDailyActivityTableCompanion
    extends UpdateCompanion<UserDailyActivity> {
  final Value<String> activityDate;
  final Value<String?> completedTaskId;
  final Value<String?> completedSunnahId;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const UserDailyActivityTableCompanion({
    this.activityDate = const Value.absent(),
    this.completedTaskId = const Value.absent(),
    this.completedSunnahId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserDailyActivityTableCompanion.insert({
    required String activityDate,
    this.completedTaskId = const Value.absent(),
    this.completedSunnahId = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : activityDate = Value(activityDate),
       updatedAt = Value(updatedAt);
  static Insertable<UserDailyActivity> custom({
    Expression<String>? activityDate,
    Expression<String>? completedTaskId,
    Expression<String>? completedSunnahId,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityDate != null) 'activity_date': activityDate,
      if (completedTaskId != null) 'completed_task_id': completedTaskId,
      if (completedSunnahId != null) 'completed_sunnah_id': completedSunnahId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserDailyActivityTableCompanion copyWith({
    Value<String>? activityDate,
    Value<String?>? completedTaskId,
    Value<String?>? completedSunnahId,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserDailyActivityTableCompanion(
      activityDate: activityDate ?? this.activityDate,
      completedTaskId: completedTaskId ?? this.completedTaskId,
      completedSunnahId: completedSunnahId ?? this.completedSunnahId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityDate.present) {
      map['activity_date'] = Variable<String>(activityDate.value);
    }
    if (completedTaskId.present) {
      map['completed_task_id'] = Variable<String>(completedTaskId.value);
    }
    if (completedSunnahId.present) {
      map['completed_sunnah_id'] = Variable<String>(completedSunnahId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserDailyActivityTableCompanion(')
          ..write('activityDate: $activityDate, ')
          ..write('completedTaskId: $completedTaskId, ')
          ..write('completedSunnahId: $completedSunnahId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuranTafseerTableTable quranTafseerTable =
      $QuranTafseerTableTable(this);
  late final $HadithTableTable hadithTable = $HadithTableTable(this);
  late final $DuaTableTable duaTable = $DuaTableTable(this);
  late final $DailySunnahTableTable dailySunnahTable = $DailySunnahTableTable(
    this,
  );
  late final $DailyTaskTableTable dailyTaskTable = $DailyTaskTableTable(this);
  late final $MuhasabaEntryTableTable muhasabaEntryTable =
      $MuhasabaEntryTableTable(this);
  late final $UserFavoriteTableTable userFavoriteTable =
      $UserFavoriteTableTable(this);
  late final $UserDailyActivityTableTable userDailyActivityTable =
      $UserDailyActivityTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    quranTafseerTable,
    hadithTable,
    duaTable,
    dailySunnahTable,
    dailyTaskTable,
    muhasabaEntryTable,
    userFavoriteTable,
    userDailyActivityTable,
  ];
}

typedef $$QuranTafseerTableTableCreateCompanionBuilder =
    QuranTafseerTableCompanion Function({
      Value<int> id,
      required int surahNumber,
      required int ayahNumber,
      required String tafseerText,
    });
typedef $$QuranTafseerTableTableUpdateCompanionBuilder =
    QuranTafseerTableCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<String> tafseerText,
    });

class $$QuranTafseerTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $QuranTafseerTableTable> {
  $$QuranTafseerTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get surahNumber => $state.composableBuilder(
    column: $state.table.surahNumber,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get ayahNumber => $state.composableBuilder(
    column: $state.table.ayahNumber,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get tafseerText => $state.composableBuilder(
    column: $state.table.tafseerText,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$QuranTafseerTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $QuranTafseerTableTable> {
  $$QuranTafseerTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get surahNumber => $state.composableBuilder(
    column: $state.table.surahNumber,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get ayahNumber => $state.composableBuilder(
    column: $state.table.ayahNumber,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get tafseerText => $state.composableBuilder(
    column: $state.table.tafseerText,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$QuranTafseerTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuranTafseerTableTable,
          QuranTafseer,
          $$QuranTafseerTableTableFilterComposer,
          $$QuranTafseerTableTableOrderingComposer,
          $$QuranTafseerTableTableCreateCompanionBuilder,
          $$QuranTafseerTableTableUpdateCompanionBuilder,
          (
            QuranTafseer,
            BaseReferences<
              _$AppDatabase,
              $QuranTafseerTableTable,
              QuranTafseer
            >,
          ),
          QuranTafseer,
          PrefetchHooks Function()
        > {
  $$QuranTafseerTableTableTableManager(
    _$AppDatabase db,
    $QuranTafseerTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$QuranTafseerTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$QuranTafseerTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String> tafseerText = const Value.absent(),
              }) => QuranTafseerTableCompanion(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                tafseerText: tafseerText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required int ayahNumber,
                required String tafseerText,
              }) => QuranTafseerTableCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                tafseerText: tafseerText,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuranTafseerTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuranTafseerTableTable,
      QuranTafseer,
      $$QuranTafseerTableTableFilterComposer,
      $$QuranTafseerTableTableOrderingComposer,
      $$QuranTafseerTableTableCreateCompanionBuilder,
      $$QuranTafseerTableTableUpdateCompanionBuilder,
      (
        QuranTafseer,
        BaseReferences<_$AppDatabase, $QuranTafseerTableTable, QuranTafseer>,
      ),
      QuranTafseer,
      PrefetchHooks Function()
    >;
typedef $$HadithTableTableCreateCompanionBuilder =
    HadithTableCompanion Function({
      Value<int> id,
      required String bookName,
      Value<String?> chapterName,
      Value<String?> reference,
      required String hadithTextAr,
      Value<String?> hadithTextEn,
      Value<bool> isBookmarked,
    });
typedef $$HadithTableTableUpdateCompanionBuilder =
    HadithTableCompanion Function({
      Value<int> id,
      Value<String> bookName,
      Value<String?> chapterName,
      Value<String?> reference,
      Value<String> hadithTextAr,
      Value<String?> hadithTextEn,
      Value<bool> isBookmarked,
    });

class $$HadithTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HadithTableTable> {
  $$HadithTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get bookName => $state.composableBuilder(
    column: $state.table.bookName,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get chapterName => $state.composableBuilder(
    column: $state.table.chapterName,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get reference => $state.composableBuilder(
    column: $state.table.reference,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get hadithTextAr => $state.composableBuilder(
    column: $state.table.hadithTextAr,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get hadithTextEn => $state.composableBuilder(
    column: $state.table.hadithTextEn,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get isBookmarked => $state.composableBuilder(
    column: $state.table.isBookmarked,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$HadithTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HadithTableTable> {
  $$HadithTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get bookName => $state.composableBuilder(
    column: $state.table.bookName,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get chapterName => $state.composableBuilder(
    column: $state.table.chapterName,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get reference => $state.composableBuilder(
    column: $state.table.reference,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get hadithTextAr => $state.composableBuilder(
    column: $state.table.hadithTextAr,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get hadithTextEn => $state.composableBuilder(
    column: $state.table.hadithTextEn,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get isBookmarked => $state.composableBuilder(
    column: $state.table.isBookmarked,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$HadithTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HadithTableTable,
          Hadith,
          $$HadithTableTableFilterComposer,
          $$HadithTableTableOrderingComposer,
          $$HadithTableTableCreateCompanionBuilder,
          $$HadithTableTableUpdateCompanionBuilder,
          (Hadith, BaseReferences<_$AppDatabase, $HadithTableTable, Hadith>),
          Hadith,
          PrefetchHooks Function()
        > {
  $$HadithTableTableTableManager(_$AppDatabase db, $HadithTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$HadithTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$HadithTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> bookName = const Value.absent(),
                Value<String?> chapterName = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String> hadithTextAr = const Value.absent(),
                Value<String?> hadithTextEn = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
              }) => HadithTableCompanion(
                id: id,
                bookName: bookName,
                chapterName: chapterName,
                reference: reference,
                hadithTextAr: hadithTextAr,
                hadithTextEn: hadithTextEn,
                isBookmarked: isBookmarked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String bookName,
                Value<String?> chapterName = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                required String hadithTextAr,
                Value<String?> hadithTextEn = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
              }) => HadithTableCompanion.insert(
                id: id,
                bookName: bookName,
                chapterName: chapterName,
                reference: reference,
                hadithTextAr: hadithTextAr,
                hadithTextEn: hadithTextEn,
                isBookmarked: isBookmarked,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HadithTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HadithTableTable,
      Hadith,
      $$HadithTableTableFilterComposer,
      $$HadithTableTableOrderingComposer,
      $$HadithTableTableCreateCompanionBuilder,
      $$HadithTableTableUpdateCompanionBuilder,
      (Hadith, BaseReferences<_$AppDatabase, $HadithTableTable, Hadith>),
      Hadith,
      PrefetchHooks Function()
    >;
typedef $$DuaTableTableCreateCompanionBuilder =
    DuaTableCompanion Function({
      Value<int> id,
      required String category,
      required String duaText,
      Value<String?> reference,
      Value<bool> isBookmarked,
    });
typedef $$DuaTableTableUpdateCompanionBuilder =
    DuaTableCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<String> duaText,
      Value<String?> reference,
      Value<bool> isBookmarked,
    });

class $$DuaTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DuaTableTable> {
  $$DuaTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get category => $state.composableBuilder(
    column: $state.table.category,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get duaText => $state.composableBuilder(
    column: $state.table.duaText,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get reference => $state.composableBuilder(
    column: $state.table.reference,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get isBookmarked => $state.composableBuilder(
    column: $state.table.isBookmarked,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$DuaTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DuaTableTable> {
  $$DuaTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get category => $state.composableBuilder(
    column: $state.table.category,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get duaText => $state.composableBuilder(
    column: $state.table.duaText,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get reference => $state.composableBuilder(
    column: $state.table.reference,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get isBookmarked => $state.composableBuilder(
    column: $state.table.isBookmarked,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$DuaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuaTableTable,
          Dua,
          $$DuaTableTableFilterComposer,
          $$DuaTableTableOrderingComposer,
          $$DuaTableTableCreateCompanionBuilder,
          $$DuaTableTableUpdateCompanionBuilder,
          (Dua, BaseReferences<_$AppDatabase, $DuaTableTable, Dua>),
          Dua,
          PrefetchHooks Function()
        > {
  $$DuaTableTableTableManager(_$AppDatabase db, $DuaTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$DuaTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$DuaTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> duaText = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
              }) => DuaTableCompanion(
                id: id,
                category: category,
                duaText: duaText,
                reference: reference,
                isBookmarked: isBookmarked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required String duaText,
                Value<String?> reference = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
              }) => DuaTableCompanion.insert(
                id: id,
                category: category,
                duaText: duaText,
                reference: reference,
                isBookmarked: isBookmarked,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DuaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuaTableTable,
      Dua,
      $$DuaTableTableFilterComposer,
      $$DuaTableTableOrderingComposer,
      $$DuaTableTableCreateCompanionBuilder,
      $$DuaTableTableUpdateCompanionBuilder,
      (Dua, BaseReferences<_$AppDatabase, $DuaTableTable, Dua>),
      Dua,
      PrefetchHooks Function()
    >;
typedef $$DailySunnahTableTableCreateCompanionBuilder =
    DailySunnahTableCompanion Function({
      required String id,
      required String title,
      required String description,
      required String howToApply,
      required String source,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$DailySunnahTableTableUpdateCompanionBuilder =
    DailySunnahTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> howToApply,
      Value<String> source,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$DailySunnahTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DailySunnahTableTable> {
  $$DailySunnahTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get description => $state.composableBuilder(
    column: $state.table.description,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get howToApply => $state.composableBuilder(
    column: $state.table.howToApply,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get source => $state.composableBuilder(
    column: $state.table.source,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get sortOrder => $state.composableBuilder(
    column: $state.table.sortOrder,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$DailySunnahTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DailySunnahTableTable> {
  $$DailySunnahTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get description => $state.composableBuilder(
    column: $state.table.description,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get howToApply => $state.composableBuilder(
    column: $state.table.howToApply,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get source => $state.composableBuilder(
    column: $state.table.source,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get sortOrder => $state.composableBuilder(
    column: $state.table.sortOrder,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$DailySunnahTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailySunnahTableTable,
          DailySunnah,
          $$DailySunnahTableTableFilterComposer,
          $$DailySunnahTableTableOrderingComposer,
          $$DailySunnahTableTableCreateCompanionBuilder,
          $$DailySunnahTableTableUpdateCompanionBuilder,
          (
            DailySunnah,
            BaseReferences<_$AppDatabase, $DailySunnahTableTable, DailySunnah>,
          ),
          DailySunnah,
          PrefetchHooks Function()
        > {
  $$DailySunnahTableTableTableManager(
    _$AppDatabase db,
    $DailySunnahTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$DailySunnahTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$DailySunnahTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> howToApply = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySunnahTableCompanion(
                id: id,
                title: title,
                description: description,
                howToApply: howToApply,
                source: source,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String howToApply,
                required String source,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => DailySunnahTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                howToApply: howToApply,
                source: source,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailySunnahTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailySunnahTableTable,
      DailySunnah,
      $$DailySunnahTableTableFilterComposer,
      $$DailySunnahTableTableOrderingComposer,
      $$DailySunnahTableTableCreateCompanionBuilder,
      $$DailySunnahTableTableUpdateCompanionBuilder,
      (
        DailySunnah,
        BaseReferences<_$AppDatabase, $DailySunnahTableTable, DailySunnah>,
      ),
      DailySunnah,
      PrefetchHooks Function()
    >;
typedef $$DailyTaskTableTableCreateCompanionBuilder =
    DailyTaskTableCompanion Function({
      required String id,
      required String title,
      required String description,
      required String impact,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$DailyTaskTableTableUpdateCompanionBuilder =
    DailyTaskTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> impact,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$DailyTaskTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DailyTaskTableTable> {
  $$DailyTaskTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get description => $state.composableBuilder(
    column: $state.table.description,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get impact => $state.composableBuilder(
    column: $state.table.impact,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get sortOrder => $state.composableBuilder(
    column: $state.table.sortOrder,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$DailyTaskTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DailyTaskTableTable> {
  $$DailyTaskTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get description => $state.composableBuilder(
    column: $state.table.description,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get impact => $state.composableBuilder(
    column: $state.table.impact,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get sortOrder => $state.composableBuilder(
    column: $state.table.sortOrder,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$DailyTaskTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyTaskTableTable,
          DailyTask,
          $$DailyTaskTableTableFilterComposer,
          $$DailyTaskTableTableOrderingComposer,
          $$DailyTaskTableTableCreateCompanionBuilder,
          $$DailyTaskTableTableUpdateCompanionBuilder,
          (
            DailyTask,
            BaseReferences<_$AppDatabase, $DailyTaskTableTable, DailyTask>,
          ),
          DailyTask,
          PrefetchHooks Function()
        > {
  $$DailyTaskTableTableTableManager(
    _$AppDatabase db,
    $DailyTaskTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$DailyTaskTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$DailyTaskTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> impact = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyTaskTableCompanion(
                id: id,
                title: title,
                description: description,
                impact: impact,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String impact,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => DailyTaskTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                impact: impact,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyTaskTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyTaskTableTable,
      DailyTask,
      $$DailyTaskTableTableFilterComposer,
      $$DailyTaskTableTableOrderingComposer,
      $$DailyTaskTableTableCreateCompanionBuilder,
      $$DailyTaskTableTableUpdateCompanionBuilder,
      (
        DailyTask,
        BaseReferences<_$AppDatabase, $DailyTaskTableTable, DailyTask>,
      ),
      DailyTask,
      PrefetchHooks Function()
    >;
typedef $$MuhasabaEntryTableTableCreateCompanionBuilder =
    MuhasabaEntryTableCompanion Function({
      required String activityDate,
      Value<bool> prayed,
      Value<bool> guardedTongue,
      Value<bool> honoredParents,
      Value<bool> avoidedHarm,
      Value<bool> gaveCharity,
      Value<bool> quranRead,
      Value<String?> note,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$MuhasabaEntryTableTableUpdateCompanionBuilder =
    MuhasabaEntryTableCompanion Function({
      Value<String> activityDate,
      Value<bool> prayed,
      Value<bool> guardedTongue,
      Value<bool> honoredParents,
      Value<bool> avoidedHarm,
      Value<bool> gaveCharity,
      Value<bool> quranRead,
      Value<String?> note,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$MuhasabaEntryTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MuhasabaEntryTableTable> {
  $$MuhasabaEntryTableTableFilterComposer(super.$state);
  ColumnFilters<String> get activityDate => $state.composableBuilder(
    column: $state.table.activityDate,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get prayed => $state.composableBuilder(
    column: $state.table.prayed,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get guardedTongue => $state.composableBuilder(
    column: $state.table.guardedTongue,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get honoredParents => $state.composableBuilder(
    column: $state.table.honoredParents,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get avoidedHarm => $state.composableBuilder(
    column: $state.table.avoidedHarm,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get gaveCharity => $state.composableBuilder(
    column: $state.table.gaveCharity,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get quranRead => $state.composableBuilder(
    column: $state.table.quranRead,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get note => $state.composableBuilder(
    column: $state.table.note,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$MuhasabaEntryTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MuhasabaEntryTableTable> {
  $$MuhasabaEntryTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get activityDate => $state.composableBuilder(
    column: $state.table.activityDate,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get prayed => $state.composableBuilder(
    column: $state.table.prayed,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get guardedTongue => $state.composableBuilder(
    column: $state.table.guardedTongue,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get honoredParents => $state.composableBuilder(
    column: $state.table.honoredParents,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get avoidedHarm => $state.composableBuilder(
    column: $state.table.avoidedHarm,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get gaveCharity => $state.composableBuilder(
    column: $state.table.gaveCharity,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get quranRead => $state.composableBuilder(
    column: $state.table.quranRead,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get note => $state.composableBuilder(
    column: $state.table.note,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$MuhasabaEntryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MuhasabaEntryTableTable,
          MuhasabaEntry,
          $$MuhasabaEntryTableTableFilterComposer,
          $$MuhasabaEntryTableTableOrderingComposer,
          $$MuhasabaEntryTableTableCreateCompanionBuilder,
          $$MuhasabaEntryTableTableUpdateCompanionBuilder,
          (
            MuhasabaEntry,
            BaseReferences<
              _$AppDatabase,
              $MuhasabaEntryTableTable,
              MuhasabaEntry
            >,
          ),
          MuhasabaEntry,
          PrefetchHooks Function()
        > {
  $$MuhasabaEntryTableTableTableManager(
    _$AppDatabase db,
    $MuhasabaEntryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$MuhasabaEntryTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$MuhasabaEntryTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> activityDate = const Value.absent(),
                Value<bool> prayed = const Value.absent(),
                Value<bool> guardedTongue = const Value.absent(),
                Value<bool> honoredParents = const Value.absent(),
                Value<bool> avoidedHarm = const Value.absent(),
                Value<bool> gaveCharity = const Value.absent(),
                Value<bool> quranRead = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MuhasabaEntryTableCompanion(
                activityDate: activityDate,
                prayed: prayed,
                guardedTongue: guardedTongue,
                honoredParents: honoredParents,
                avoidedHarm: avoidedHarm,
                gaveCharity: gaveCharity,
                quranRead: quranRead,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityDate,
                Value<bool> prayed = const Value.absent(),
                Value<bool> guardedTongue = const Value.absent(),
                Value<bool> honoredParents = const Value.absent(),
                Value<bool> avoidedHarm = const Value.absent(),
                Value<bool> gaveCharity = const Value.absent(),
                Value<bool> quranRead = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MuhasabaEntryTableCompanion.insert(
                activityDate: activityDate,
                prayed: prayed,
                guardedTongue: guardedTongue,
                honoredParents: honoredParents,
                avoidedHarm: avoidedHarm,
                gaveCharity: gaveCharity,
                quranRead: quranRead,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MuhasabaEntryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MuhasabaEntryTableTable,
      MuhasabaEntry,
      $$MuhasabaEntryTableTableFilterComposer,
      $$MuhasabaEntryTableTableOrderingComposer,
      $$MuhasabaEntryTableTableCreateCompanionBuilder,
      $$MuhasabaEntryTableTableUpdateCompanionBuilder,
      (
        MuhasabaEntry,
        BaseReferences<_$AppDatabase, $MuhasabaEntryTableTable, MuhasabaEntry>,
      ),
      MuhasabaEntry,
      PrefetchHooks Function()
    >;
typedef $$UserFavoriteTableTableCreateCompanionBuilder =
    UserFavoriteTableCompanion Function({
      Value<int> id,
      required String contentType,
      required String primaryReference,
      Value<String?> secondaryReference,
      required String title,
      required String contentText,
      required String source,
      required String createdAt,
    });
typedef $$UserFavoriteTableTableUpdateCompanionBuilder =
    UserFavoriteTableCompanion Function({
      Value<int> id,
      Value<String> contentType,
      Value<String> primaryReference,
      Value<String?> secondaryReference,
      Value<String> title,
      Value<String> contentText,
      Value<String> source,
      Value<String> createdAt,
    });

class $$UserFavoriteTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UserFavoriteTableTable> {
  $$UserFavoriteTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get contentType => $state.composableBuilder(
    column: $state.table.contentType,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get primaryReference => $state.composableBuilder(
    column: $state.table.primaryReference,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get secondaryReference => $state.composableBuilder(
    column: $state.table.secondaryReference,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get contentText => $state.composableBuilder(
    column: $state.table.contentText,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get source => $state.composableBuilder(
    column: $state.table.source,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get createdAt => $state.composableBuilder(
    column: $state.table.createdAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$UserFavoriteTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UserFavoriteTableTable> {
  $$UserFavoriteTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get contentType => $state.composableBuilder(
    column: $state.table.contentType,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get primaryReference => $state.composableBuilder(
    column: $state.table.primaryReference,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get secondaryReference => $state.composableBuilder(
    column: $state.table.secondaryReference,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get contentText => $state.composableBuilder(
    column: $state.table.contentText,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get source => $state.composableBuilder(
    column: $state.table.source,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
    column: $state.table.createdAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$UserFavoriteTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserFavoriteTableTable,
          UserFavorite,
          $$UserFavoriteTableTableFilterComposer,
          $$UserFavoriteTableTableOrderingComposer,
          $$UserFavoriteTableTableCreateCompanionBuilder,
          $$UserFavoriteTableTableUpdateCompanionBuilder,
          (
            UserFavorite,
            BaseReferences<
              _$AppDatabase,
              $UserFavoriteTableTable,
              UserFavorite
            >,
          ),
          UserFavorite,
          PrefetchHooks Function()
        > {
  $$UserFavoriteTableTableTableManager(
    _$AppDatabase db,
    $UserFavoriteTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$UserFavoriteTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$UserFavoriteTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> primaryReference = const Value.absent(),
                Value<String?> secondaryReference = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> contentText = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => UserFavoriteTableCompanion(
                id: id,
                contentType: contentType,
                primaryReference: primaryReference,
                secondaryReference: secondaryReference,
                title: title,
                contentText: contentText,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String contentType,
                required String primaryReference,
                Value<String?> secondaryReference = const Value.absent(),
                required String title,
                required String contentText,
                required String source,
                required String createdAt,
              }) => UserFavoriteTableCompanion.insert(
                id: id,
                contentType: contentType,
                primaryReference: primaryReference,
                secondaryReference: secondaryReference,
                title: title,
                contentText: contentText,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserFavoriteTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserFavoriteTableTable,
      UserFavorite,
      $$UserFavoriteTableTableFilterComposer,
      $$UserFavoriteTableTableOrderingComposer,
      $$UserFavoriteTableTableCreateCompanionBuilder,
      $$UserFavoriteTableTableUpdateCompanionBuilder,
      (
        UserFavorite,
        BaseReferences<_$AppDatabase, $UserFavoriteTableTable, UserFavorite>,
      ),
      UserFavorite,
      PrefetchHooks Function()
    >;
typedef $$UserDailyActivityTableTableCreateCompanionBuilder =
    UserDailyActivityTableCompanion Function({
      required String activityDate,
      Value<String?> completedTaskId,
      Value<String?> completedSunnahId,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$UserDailyActivityTableTableUpdateCompanionBuilder =
    UserDailyActivityTableCompanion Function({
      Value<String> activityDate,
      Value<String?> completedTaskId,
      Value<String?> completedSunnahId,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$UserDailyActivityTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UserDailyActivityTableTable> {
  $$UserDailyActivityTableTableFilterComposer(super.$state);
  ColumnFilters<String> get activityDate => $state.composableBuilder(
    column: $state.table.activityDate,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get completedTaskId => $state.composableBuilder(
    column: $state.table.completedTaskId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get completedSunnahId => $state.composableBuilder(
    column: $state.table.completedSunnahId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$UserDailyActivityTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UserDailyActivityTableTable> {
  $$UserDailyActivityTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get activityDate => $state.composableBuilder(
    column: $state.table.activityDate,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get completedTaskId => $state.composableBuilder(
    column: $state.table.completedTaskId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get completedSunnahId => $state.composableBuilder(
    column: $state.table.completedSunnahId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$UserDailyActivityTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserDailyActivityTableTable,
          UserDailyActivity,
          $$UserDailyActivityTableTableFilterComposer,
          $$UserDailyActivityTableTableOrderingComposer,
          $$UserDailyActivityTableTableCreateCompanionBuilder,
          $$UserDailyActivityTableTableUpdateCompanionBuilder,
          (
            UserDailyActivity,
            BaseReferences<
              _$AppDatabase,
              $UserDailyActivityTableTable,
              UserDailyActivity
            >,
          ),
          UserDailyActivity,
          PrefetchHooks Function()
        > {
  $$UserDailyActivityTableTableTableManager(
    _$AppDatabase db,
    $UserDailyActivityTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$UserDailyActivityTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$UserDailyActivityTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> activityDate = const Value.absent(),
                Value<String?> completedTaskId = const Value.absent(),
                Value<String?> completedSunnahId = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserDailyActivityTableCompanion(
                activityDate: activityDate,
                completedTaskId: completedTaskId,
                completedSunnahId: completedSunnahId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityDate,
                Value<String?> completedTaskId = const Value.absent(),
                Value<String?> completedSunnahId = const Value.absent(),
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserDailyActivityTableCompanion.insert(
                activityDate: activityDate,
                completedTaskId: completedTaskId,
                completedSunnahId: completedSunnahId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserDailyActivityTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserDailyActivityTableTable,
      UserDailyActivity,
      $$UserDailyActivityTableTableFilterComposer,
      $$UserDailyActivityTableTableOrderingComposer,
      $$UserDailyActivityTableTableCreateCompanionBuilder,
      $$UserDailyActivityTableTableUpdateCompanionBuilder,
      (
        UserDailyActivity,
        BaseReferences<
          _$AppDatabase,
          $UserDailyActivityTableTable,
          UserDailyActivity
        >,
      ),
      UserDailyActivity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuranTafseerTableTableTableManager get quranTafseerTable =>
      $$QuranTafseerTableTableTableManager(_db, _db.quranTafseerTable);
  $$HadithTableTableTableManager get hadithTable =>
      $$HadithTableTableTableManager(_db, _db.hadithTable);
  $$DuaTableTableTableManager get duaTable =>
      $$DuaTableTableTableManager(_db, _db.duaTable);
  $$DailySunnahTableTableTableManager get dailySunnahTable =>
      $$DailySunnahTableTableTableManager(_db, _db.dailySunnahTable);
  $$DailyTaskTableTableTableManager get dailyTaskTable =>
      $$DailyTaskTableTableTableManager(_db, _db.dailyTaskTable);
  $$MuhasabaEntryTableTableTableManager get muhasabaEntryTable =>
      $$MuhasabaEntryTableTableTableManager(_db, _db.muhasabaEntryTable);
  $$UserFavoriteTableTableTableManager get userFavoriteTable =>
      $$UserFavoriteTableTableTableManager(_db, _db.userFavoriteTable);
  $$UserDailyActivityTableTableTableManager get userDailyActivityTable =>
      $$UserDailyActivityTableTableTableManager(
        _db,
        _db.userDailyActivityTable,
      );
}
