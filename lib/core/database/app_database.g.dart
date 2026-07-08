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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    note,
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
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
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
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
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
  final String? note;
  const UserFavorite({
    required this.id,
    required this.contentType,
    required this.primaryReference,
    this.secondaryReference,
    required this.title,
    required this.contentText,
    required this.source,
    required this.createdAt,
    this.note,
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
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
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
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
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
      note: serializer.fromJson<String?>(json['note']),
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
      'note': serializer.toJson<String?>(note),
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
    Value<String?> note = const Value.absent(),
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
    note: note.present ? note.value : this.note,
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
      note: data.note.present ? data.note.value : this.note,
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
          ..write('createdAt: $createdAt, ')
          ..write('note: $note')
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
    note,
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
          other.createdAt == this.createdAt &&
          other.note == this.note);
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
  final Value<String?> note;
  const UserFavoriteTableCompanion({
    this.id = const Value.absent(),
    this.contentType = const Value.absent(),
    this.primaryReference = const Value.absent(),
    this.secondaryReference = const Value.absent(),
    this.title = const Value.absent(),
    this.contentText = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
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
    this.note = const Value.absent(),
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
    Expression<String>? note,
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
      if (note != null) 'note': note,
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
    Value<String?>? note,
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
      note: note ?? this.note,
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
    if (note.present) {
      map['note'] = Variable<String>(note.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('note: $note')
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

class $ProgressRecordTableTable extends ProgressRecordTable
    with TableInfo<$ProgressRecordTableTable, ProgressRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressRecordTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pagesReadMeta = const VerificationMeta(
    'pagesRead',
  );
  @override
  late final GeneratedColumn<int> pagesRead = GeneratedColumn<int>(
    'pages_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _readingSecondsMeta = const VerificationMeta(
    'readingSeconds',
  );
  @override
  late final GeneratedColumn<int> readingSeconds = GeneratedColumn<int>(
    'reading_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _azkarCountMeta = const VerificationMeta(
    'azkarCount',
  );
  @override
  late final GeneratedColumn<int> azkarCount = GeneratedColumn<int>(
    'azkar_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hadithCountMeta = const VerificationMeta(
    'hadithCount',
  );
  @override
  late final GeneratedColumn<int> hadithCount = GeneratedColumn<int>(
    'hadith_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isMuhasabaDoneMeta = const VerificationMeta(
    'isMuhasabaDone',
  );
  @override
  late final GeneratedColumn<bool> isMuhasabaDone = GeneratedColumn<bool>(
    'is_muhasaba_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_muhasaba_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    pagesRead,
    readingSeconds,
    azkarCount,
    hadithCount,
    isMuhasabaDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_record_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('pages_read')) {
      context.handle(
        _pagesReadMeta,
        pagesRead.isAcceptableOrUnknown(data['pages_read']!, _pagesReadMeta),
      );
    }
    if (data.containsKey('reading_seconds')) {
      context.handle(
        _readingSecondsMeta,
        readingSeconds.isAcceptableOrUnknown(
          data['reading_seconds']!,
          _readingSecondsMeta,
        ),
      );
    }
    if (data.containsKey('azkar_count')) {
      context.handle(
        _azkarCountMeta,
        azkarCount.isAcceptableOrUnknown(data['azkar_count']!, _azkarCountMeta),
      );
    }
    if (data.containsKey('hadith_count')) {
      context.handle(
        _hadithCountMeta,
        hadithCount.isAcceptableOrUnknown(
          data['hadith_count']!,
          _hadithCountMeta,
        ),
      );
    }
    if (data.containsKey('is_muhasaba_done')) {
      context.handle(
        _isMuhasabaDoneMeta,
        isMuhasabaDone.isAcceptableOrUnknown(
          data['is_muhasaba_done']!,
          _isMuhasabaDoneMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  ProgressRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressRecord(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      pagesRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pages_read'],
      )!,
      readingSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reading_seconds'],
      )!,
      azkarCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}azkar_count'],
      )!,
      hadithCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hadith_count'],
      )!,
      isMuhasabaDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_muhasaba_done'],
      )!,
    );
  }

  @override
  $ProgressRecordTableTable createAlias(String alias) {
    return $ProgressRecordTableTable(attachedDatabase, alias);
  }
}

class ProgressRecord extends DataClass implements Insertable<ProgressRecord> {
  final String date;
  final int pagesRead;
  final int readingSeconds;
  final int azkarCount;
  final int hadithCount;
  final bool isMuhasabaDone;
  const ProgressRecord({
    required this.date,
    required this.pagesRead,
    required this.readingSeconds,
    required this.azkarCount,
    required this.hadithCount,
    required this.isMuhasabaDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['pages_read'] = Variable<int>(pagesRead);
    map['reading_seconds'] = Variable<int>(readingSeconds);
    map['azkar_count'] = Variable<int>(azkarCount);
    map['hadith_count'] = Variable<int>(hadithCount);
    map['is_muhasaba_done'] = Variable<bool>(isMuhasabaDone);
    return map;
  }

  ProgressRecordTableCompanion toCompanion(bool nullToAbsent) {
    return ProgressRecordTableCompanion(
      date: Value(date),
      pagesRead: Value(pagesRead),
      readingSeconds: Value(readingSeconds),
      azkarCount: Value(azkarCount),
      hadithCount: Value(hadithCount),
      isMuhasabaDone: Value(isMuhasabaDone),
    );
  }

  factory ProgressRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressRecord(
      date: serializer.fromJson<String>(json['date']),
      pagesRead: serializer.fromJson<int>(json['pagesRead']),
      readingSeconds: serializer.fromJson<int>(json['readingSeconds']),
      azkarCount: serializer.fromJson<int>(json['azkarCount']),
      hadithCount: serializer.fromJson<int>(json['hadithCount']),
      isMuhasabaDone: serializer.fromJson<bool>(json['isMuhasabaDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'pagesRead': serializer.toJson<int>(pagesRead),
      'readingSeconds': serializer.toJson<int>(readingSeconds),
      'azkarCount': serializer.toJson<int>(azkarCount),
      'hadithCount': serializer.toJson<int>(hadithCount),
      'isMuhasabaDone': serializer.toJson<bool>(isMuhasabaDone),
    };
  }

  ProgressRecord copyWith({
    String? date,
    int? pagesRead,
    int? readingSeconds,
    int? azkarCount,
    int? hadithCount,
    bool? isMuhasabaDone,
  }) => ProgressRecord(
    date: date ?? this.date,
    pagesRead: pagesRead ?? this.pagesRead,
    readingSeconds: readingSeconds ?? this.readingSeconds,
    azkarCount: azkarCount ?? this.azkarCount,
    hadithCount: hadithCount ?? this.hadithCount,
    isMuhasabaDone: isMuhasabaDone ?? this.isMuhasabaDone,
  );
  ProgressRecord copyWithCompanion(ProgressRecordTableCompanion data) {
    return ProgressRecord(
      date: data.date.present ? data.date.value : this.date,
      pagesRead: data.pagesRead.present ? data.pagesRead.value : this.pagesRead,
      readingSeconds: data.readingSeconds.present
          ? data.readingSeconds.value
          : this.readingSeconds,
      azkarCount: data.azkarCount.present
          ? data.azkarCount.value
          : this.azkarCount,
      hadithCount: data.hadithCount.present
          ? data.hadithCount.value
          : this.hadithCount,
      isMuhasabaDone: data.isMuhasabaDone.present
          ? data.isMuhasabaDone.value
          : this.isMuhasabaDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressRecord(')
          ..write('date: $date, ')
          ..write('pagesRead: $pagesRead, ')
          ..write('readingSeconds: $readingSeconds, ')
          ..write('azkarCount: $azkarCount, ')
          ..write('hadithCount: $hadithCount, ')
          ..write('isMuhasabaDone: $isMuhasabaDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    pagesRead,
    readingSeconds,
    azkarCount,
    hadithCount,
    isMuhasabaDone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressRecord &&
          other.date == this.date &&
          other.pagesRead == this.pagesRead &&
          other.readingSeconds == this.readingSeconds &&
          other.azkarCount == this.azkarCount &&
          other.hadithCount == this.hadithCount &&
          other.isMuhasabaDone == this.isMuhasabaDone);
}

class ProgressRecordTableCompanion extends UpdateCompanion<ProgressRecord> {
  final Value<String> date;
  final Value<int> pagesRead;
  final Value<int> readingSeconds;
  final Value<int> azkarCount;
  final Value<int> hadithCount;
  final Value<bool> isMuhasabaDone;
  final Value<int> rowid;
  const ProgressRecordTableCompanion({
    this.date = const Value.absent(),
    this.pagesRead = const Value.absent(),
    this.readingSeconds = const Value.absent(),
    this.azkarCount = const Value.absent(),
    this.hadithCount = const Value.absent(),
    this.isMuhasabaDone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressRecordTableCompanion.insert({
    required String date,
    this.pagesRead = const Value.absent(),
    this.readingSeconds = const Value.absent(),
    this.azkarCount = const Value.absent(),
    this.hadithCount = const Value.absent(),
    this.isMuhasabaDone = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<ProgressRecord> custom({
    Expression<String>? date,
    Expression<int>? pagesRead,
    Expression<int>? readingSeconds,
    Expression<int>? azkarCount,
    Expression<int>? hadithCount,
    Expression<bool>? isMuhasabaDone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (pagesRead != null) 'pages_read': pagesRead,
      if (readingSeconds != null) 'reading_seconds': readingSeconds,
      if (azkarCount != null) 'azkar_count': azkarCount,
      if (hadithCount != null) 'hadith_count': hadithCount,
      if (isMuhasabaDone != null) 'is_muhasaba_done': isMuhasabaDone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressRecordTableCompanion copyWith({
    Value<String>? date,
    Value<int>? pagesRead,
    Value<int>? readingSeconds,
    Value<int>? azkarCount,
    Value<int>? hadithCount,
    Value<bool>? isMuhasabaDone,
    Value<int>? rowid,
  }) {
    return ProgressRecordTableCompanion(
      date: date ?? this.date,
      pagesRead: pagesRead ?? this.pagesRead,
      readingSeconds: readingSeconds ?? this.readingSeconds,
      azkarCount: azkarCount ?? this.azkarCount,
      hadithCount: hadithCount ?? this.hadithCount,
      isMuhasabaDone: isMuhasabaDone ?? this.isMuhasabaDone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (pagesRead.present) {
      map['pages_read'] = Variable<int>(pagesRead.value);
    }
    if (readingSeconds.present) {
      map['reading_seconds'] = Variable<int>(readingSeconds.value);
    }
    if (azkarCount.present) {
      map['azkar_count'] = Variable<int>(azkarCount.value);
    }
    if (hadithCount.present) {
      map['hadith_count'] = Variable<int>(hadithCount.value);
    }
    if (isMuhasabaDone.present) {
      map['is_muhasaba_done'] = Variable<bool>(isMuhasabaDone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressRecordTableCompanion(')
          ..write('date: $date, ')
          ..write('pagesRead: $pagesRead, ')
          ..write('readingSeconds: $readingSeconds, ')
          ..write('azkarCount: $azkarCount, ')
          ..write('hadithCount: $hadithCount, ')
          ..write('isMuhasabaDone: $isMuhasabaDone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentActivityTableTable extends RecentActivityTable
    with TableInfo<$RecentActivityTableTable, RecentActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentActivityTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
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
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _routePathMeta = const VerificationMeta(
    'routePath',
  );
  @override
  late final GeneratedColumn<String> routePath = GeneratedColumn<String>(
    'route_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    subtitle,
    routePath,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_activity_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('route_path')) {
      context.handle(
        _routePathMeta,
        routePath.isAcceptableOrUnknown(data['route_path']!, _routePathMeta),
      );
    } else if (isInserting) {
      context.missing(_routePathMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentActivity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      routePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_path'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $RecentActivityTableTable createAlias(String alias) {
    return $RecentActivityTableTable(attachedDatabase, alias);
  }
}

class RecentActivity extends DataClass implements Insertable<RecentActivity> {
  final String id;
  final String type;
  final String title;
  final String? subtitle;
  final String routePath;
  final DateTime timestamp;
  const RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.routePath,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    map['route_path'] = Variable<String>(routePath);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  RecentActivityTableCompanion toCompanion(bool nullToAbsent) {
    return RecentActivityTableCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      routePath: Value(routePath),
      timestamp: Value(timestamp),
    );
  }

  factory RecentActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentActivity(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      routePath: serializer.fromJson<String>(json['routePath']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'routePath': serializer.toJson<String>(routePath),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  RecentActivity copyWith({
    String? id,
    String? type,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    String? routePath,
    DateTime? timestamp,
  }) => RecentActivity(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    routePath: routePath ?? this.routePath,
    timestamp: timestamp ?? this.timestamp,
  );
  RecentActivity copyWithCompanion(RecentActivityTableCompanion data) {
    return RecentActivity(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      routePath: data.routePath.present ? data.routePath.value : this.routePath,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentActivity(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('routePath: $routePath, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, title, subtitle, routePath, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentActivity &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.routePath == this.routePath &&
          other.timestamp == this.timestamp);
}

class RecentActivityTableCompanion extends UpdateCompanion<RecentActivity> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String> routePath;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const RecentActivityTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.routePath = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentActivityTableCompanion.insert({
    required String id,
    required String type,
    required String title,
    this.subtitle = const Value.absent(),
    required String routePath,
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       title = Value(title),
       routePath = Value(routePath),
       timestamp = Value(timestamp);
  static Insertable<RecentActivity> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? routePath,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (routePath != null) 'route_path': routePath,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentActivityTableCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String>? routePath,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return RecentActivityTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      routePath: routePath ?? this.routePath,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (routePath.present) {
      map['route_path'] = Variable<String>(routePath.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentActivityTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('routePath: $routePath, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserGoalsTableTable extends UserGoalsTable
    with TableInfo<$UserGoalsTableTable, UserGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGoalsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('quran_pages'),
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
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<int> targetValue = GeneratedColumn<int>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resetPolicyMeta = const VerificationMeta(
    'resetPolicy',
  );
  @override
  late final GeneratedColumn<String> resetPolicy = GeneratedColumn<String>(
    'reset_policy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily'),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
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
    id,
    goalType,
    metric,
    title,
    icon,
    targetValue,
    resetPolicy,
    metadata,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_goals_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
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
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('reset_policy')) {
      context.handle(
        _resetPolicyMeta,
        resetPolicy.isAcceptableOrUnknown(
          data['reset_policy']!,
          _resetPolicyMeta,
        ),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      metric: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_value'],
      )!,
      resetPolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reset_policy'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserGoalsTableTable createAlias(String alias) {
    return $UserGoalsTableTable(attachedDatabase, alias);
  }
}

class UserGoal extends DataClass implements Insertable<UserGoal> {
  final int id;
  final String goalType;
  final String metric;
  final String title;
  final String icon;
  final int targetValue;
  final String resetPolicy;
  final String? metadata;
  final String updatedAt;
  const UserGoal({
    required this.id,
    required this.goalType,
    required this.metric,
    required this.title,
    required this.icon,
    required this.targetValue,
    required this.resetPolicy,
    this.metadata,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_type'] = Variable<String>(goalType);
    map['metric'] = Variable<String>(metric);
    map['title'] = Variable<String>(title);
    map['icon'] = Variable<String>(icon);
    map['target_value'] = Variable<int>(targetValue);
    map['reset_policy'] = Variable<String>(resetPolicy);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  UserGoalsTableCompanion toCompanion(bool nullToAbsent) {
    return UserGoalsTableCompanion(
      id: Value(id),
      goalType: Value(goalType),
      metric: Value(metric),
      title: Value(title),
      icon: Value(icon),
      targetValue: Value(targetValue),
      resetPolicy: Value(resetPolicy),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGoal(
      id: serializer.fromJson<int>(json['id']),
      goalType: serializer.fromJson<String>(json['goalType']),
      metric: serializer.fromJson<String>(json['metric']),
      title: serializer.fromJson<String>(json['title']),
      icon: serializer.fromJson<String>(json['icon']),
      targetValue: serializer.fromJson<int>(json['targetValue']),
      resetPolicy: serializer.fromJson<String>(json['resetPolicy']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalType': serializer.toJson<String>(goalType),
      'metric': serializer.toJson<String>(metric),
      'title': serializer.toJson<String>(title),
      'icon': serializer.toJson<String>(icon),
      'targetValue': serializer.toJson<int>(targetValue),
      'resetPolicy': serializer.toJson<String>(resetPolicy),
      'metadata': serializer.toJson<String?>(metadata),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  UserGoal copyWith({
    int? id,
    String? goalType,
    String? metric,
    String? title,
    String? icon,
    int? targetValue,
    String? resetPolicy,
    Value<String?> metadata = const Value.absent(),
    String? updatedAt,
  }) => UserGoal(
    id: id ?? this.id,
    goalType: goalType ?? this.goalType,
    metric: metric ?? this.metric,
    title: title ?? this.title,
    icon: icon ?? this.icon,
    targetValue: targetValue ?? this.targetValue,
    resetPolicy: resetPolicy ?? this.resetPolicy,
    metadata: metadata.present ? metadata.value : this.metadata,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserGoal copyWithCompanion(UserGoalsTableCompanion data) {
    return UserGoal(
      id: data.id.present ? data.id.value : this.id,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      metric: data.metric.present ? data.metric.value : this.metric,
      title: data.title.present ? data.title.value : this.title,
      icon: data.icon.present ? data.icon.value : this.icon,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      resetPolicy: data.resetPolicy.present
          ? data.resetPolicy.value
          : this.resetPolicy,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserGoal(')
          ..write('id: $id, ')
          ..write('goalType: $goalType, ')
          ..write('metric: $metric, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('targetValue: $targetValue, ')
          ..write('resetPolicy: $resetPolicy, ')
          ..write('metadata: $metadata, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalType,
    metric,
    title,
    icon,
    targetValue,
    resetPolicy,
    metadata,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGoal &&
          other.id == this.id &&
          other.goalType == this.goalType &&
          other.metric == this.metric &&
          other.title == this.title &&
          other.icon == this.icon &&
          other.targetValue == this.targetValue &&
          other.resetPolicy == this.resetPolicy &&
          other.metadata == this.metadata &&
          other.updatedAt == this.updatedAt);
}

class UserGoalsTableCompanion extends UpdateCompanion<UserGoal> {
  final Value<int> id;
  final Value<String> goalType;
  final Value<String> metric;
  final Value<String> title;
  final Value<String> icon;
  final Value<int> targetValue;
  final Value<String> resetPolicy;
  final Value<String?> metadata;
  final Value<String> updatedAt;
  const UserGoalsTableCompanion({
    this.id = const Value.absent(),
    this.goalType = const Value.absent(),
    this.metric = const Value.absent(),
    this.title = const Value.absent(),
    this.icon = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.resetPolicy = const Value.absent(),
    this.metadata = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserGoalsTableCompanion.insert({
    this.id = const Value.absent(),
    required String goalType,
    this.metric = const Value.absent(),
    required String title,
    required String icon,
    required int targetValue,
    this.resetPolicy = const Value.absent(),
    this.metadata = const Value.absent(),
    required String updatedAt,
  }) : goalType = Value(goalType),
       title = Value(title),
       icon = Value(icon),
       targetValue = Value(targetValue),
       updatedAt = Value(updatedAt);
  static Insertable<UserGoal> custom({
    Expression<int>? id,
    Expression<String>? goalType,
    Expression<String>? metric,
    Expression<String>? title,
    Expression<String>? icon,
    Expression<int>? targetValue,
    Expression<String>? resetPolicy,
    Expression<String>? metadata,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalType != null) 'goal_type': goalType,
      if (metric != null) 'metric': metric,
      if (title != null) 'title': title,
      if (icon != null) 'icon': icon,
      if (targetValue != null) 'target_value': targetValue,
      if (resetPolicy != null) 'reset_policy': resetPolicy,
      if (metadata != null) 'metadata': metadata,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserGoalsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? goalType,
    Value<String>? metric,
    Value<String>? title,
    Value<String>? icon,
    Value<int>? targetValue,
    Value<String>? resetPolicy,
    Value<String?>? metadata,
    Value<String>? updatedAt,
  }) {
    return UserGoalsTableCompanion(
      id: id ?? this.id,
      goalType: goalType ?? this.goalType,
      metric: metric ?? this.metric,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      targetValue: targetValue ?? this.targetValue,
      resetPolicy: resetPolicy ?? this.resetPolicy,
      metadata: metadata ?? this.metadata,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<int>(targetValue.value);
    }
    if (resetPolicy.present) {
      map['reset_policy'] = Variable<String>(resetPolicy.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('goalType: $goalType, ')
          ..write('metric: $metric, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('targetValue: $targetValue, ')
          ..write('resetPolicy: $resetPolicy, ')
          ..write('metadata: $metadata, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReadingSessionTableTable extends ReadingSessionTable
    with TableInfo<$ReadingSessionTableTable, ReadingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSessionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _featureTypeMeta = const VerificationMeta(
    'featureType',
  );
  @override
  late final GeneratedColumn<String> featureType = GeneratedColumn<String>(
    'feature_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('quran'),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surahIdMeta = const VerificationMeta(
    'surahId',
  );
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
    'surah_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verseNumberMeta = const VerificationMeta(
    'verseNumber',
  );
  @override
  late final GeneratedColumn<int> verseNumber = GeneratedColumn<int>(
    'verse_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scrollOffsetMeta = const VerificationMeta(
    'scrollOffset',
  );
  @override
  late final GeneratedColumn<double> scrollOffset = GeneratedColumn<double>(
    'scroll_offset',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _themeIdMeta = const VerificationMeta(
    'themeId',
  );
  @override
  late final GeneratedColumn<String> themeId = GeneratedColumn<String>(
    'theme_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
    'font_size',
    aliasedName,
    true,
    type: DriftSqlType.double,
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
    id,
    featureType,
    bookId,
    surahId,
    pageNumber,
    verseNumber,
    scrollOffset,
    themeId,
    fontSize,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_session_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feature_type')) {
      context.handle(
        _featureTypeMeta,
        featureType.isAcceptableOrUnknown(
          data['feature_type']!,
          _featureTypeMeta,
        ),
      );
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    }
    if (data.containsKey('surah_id')) {
      context.handle(
        _surahIdMeta,
        surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta),
      );
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    }
    if (data.containsKey('verse_number')) {
      context.handle(
        _verseNumberMeta,
        verseNumber.isAcceptableOrUnknown(
          data['verse_number']!,
          _verseNumberMeta,
        ),
      );
    }
    if (data.containsKey('scroll_offset')) {
      context.handle(
        _scrollOffsetMeta,
        scrollOffset.isAcceptableOrUnknown(
          data['scroll_offset']!,
          _scrollOffsetMeta,
        ),
      );
    }
    if (data.containsKey('theme_id')) {
      context.handle(
        _themeIdMeta,
        themeId.isAcceptableOrUnknown(data['theme_id']!, _themeIdMeta),
      );
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      featureType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_type'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      ),
      surahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_id'],
      ),
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      ),
      verseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_number'],
      ),
      scrollOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_offset'],
      )!,
      themeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_id'],
      ),
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_size'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingSessionTableTable createAlias(String alias) {
    return $ReadingSessionTableTable(attachedDatabase, alias);
  }
}

class ReadingSession extends DataClass implements Insertable<ReadingSession> {
  final int id;
  final String featureType;
  final int? bookId;
  final int? surahId;
  final int? pageNumber;
  final int? verseNumber;
  final double scrollOffset;
  final String? themeId;
  final double? fontSize;
  final String updatedAt;
  const ReadingSession({
    required this.id,
    required this.featureType,
    this.bookId,
    this.surahId,
    this.pageNumber,
    this.verseNumber,
    required this.scrollOffset,
    this.themeId,
    this.fontSize,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feature_type'] = Variable<String>(featureType);
    if (!nullToAbsent || bookId != null) {
      map['book_id'] = Variable<int>(bookId);
    }
    if (!nullToAbsent || surahId != null) {
      map['surah_id'] = Variable<int>(surahId);
    }
    if (!nullToAbsent || pageNumber != null) {
      map['page_number'] = Variable<int>(pageNumber);
    }
    if (!nullToAbsent || verseNumber != null) {
      map['verse_number'] = Variable<int>(verseNumber);
    }
    map['scroll_offset'] = Variable<double>(scrollOffset);
    if (!nullToAbsent || themeId != null) {
      map['theme_id'] = Variable<String>(themeId);
    }
    if (!nullToAbsent || fontSize != null) {
      map['font_size'] = Variable<double>(fontSize);
    }
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ReadingSessionTableCompanion toCompanion(bool nullToAbsent) {
    return ReadingSessionTableCompanion(
      id: Value(id),
      featureType: Value(featureType),
      bookId: bookId == null && nullToAbsent
          ? const Value.absent()
          : Value(bookId),
      surahId: surahId == null && nullToAbsent
          ? const Value.absent()
          : Value(surahId),
      pageNumber: pageNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNumber),
      verseNumber: verseNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(verseNumber),
      scrollOffset: Value(scrollOffset),
      themeId: themeId == null && nullToAbsent
          ? const Value.absent()
          : Value(themeId),
      fontSize: fontSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fontSize),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSession(
      id: serializer.fromJson<int>(json['id']),
      featureType: serializer.fromJson<String>(json['featureType']),
      bookId: serializer.fromJson<int?>(json['bookId']),
      surahId: serializer.fromJson<int?>(json['surahId']),
      pageNumber: serializer.fromJson<int?>(json['pageNumber']),
      verseNumber: serializer.fromJson<int?>(json['verseNumber']),
      scrollOffset: serializer.fromJson<double>(json['scrollOffset']),
      themeId: serializer.fromJson<String?>(json['themeId']),
      fontSize: serializer.fromJson<double?>(json['fontSize']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'featureType': serializer.toJson<String>(featureType),
      'bookId': serializer.toJson<int?>(bookId),
      'surahId': serializer.toJson<int?>(surahId),
      'pageNumber': serializer.toJson<int?>(pageNumber),
      'verseNumber': serializer.toJson<int?>(verseNumber),
      'scrollOffset': serializer.toJson<double>(scrollOffset),
      'themeId': serializer.toJson<String?>(themeId),
      'fontSize': serializer.toJson<double?>(fontSize),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ReadingSession copyWith({
    int? id,
    String? featureType,
    Value<int?> bookId = const Value.absent(),
    Value<int?> surahId = const Value.absent(),
    Value<int?> pageNumber = const Value.absent(),
    Value<int?> verseNumber = const Value.absent(),
    double? scrollOffset,
    Value<String?> themeId = const Value.absent(),
    Value<double?> fontSize = const Value.absent(),
    String? updatedAt,
  }) => ReadingSession(
    id: id ?? this.id,
    featureType: featureType ?? this.featureType,
    bookId: bookId.present ? bookId.value : this.bookId,
    surahId: surahId.present ? surahId.value : this.surahId,
    pageNumber: pageNumber.present ? pageNumber.value : this.pageNumber,
    verseNumber: verseNumber.present ? verseNumber.value : this.verseNumber,
    scrollOffset: scrollOffset ?? this.scrollOffset,
    themeId: themeId.present ? themeId.value : this.themeId,
    fontSize: fontSize.present ? fontSize.value : this.fontSize,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingSession copyWithCompanion(ReadingSessionTableCompanion data) {
    return ReadingSession(
      id: data.id.present ? data.id.value : this.id,
      featureType: data.featureType.present
          ? data.featureType.value
          : this.featureType,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      verseNumber: data.verseNumber.present
          ? data.verseNumber.value
          : this.verseNumber,
      scrollOffset: data.scrollOffset.present
          ? data.scrollOffset.value
          : this.scrollOffset,
      themeId: data.themeId.present ? data.themeId.value : this.themeId,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSession(')
          ..write('id: $id, ')
          ..write('featureType: $featureType, ')
          ..write('bookId: $bookId, ')
          ..write('surahId: $surahId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('themeId: $themeId, ')
          ..write('fontSize: $fontSize, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    featureType,
    bookId,
    surahId,
    pageNumber,
    verseNumber,
    scrollOffset,
    themeId,
    fontSize,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSession &&
          other.id == this.id &&
          other.featureType == this.featureType &&
          other.bookId == this.bookId &&
          other.surahId == this.surahId &&
          other.pageNumber == this.pageNumber &&
          other.verseNumber == this.verseNumber &&
          other.scrollOffset == this.scrollOffset &&
          other.themeId == this.themeId &&
          other.fontSize == this.fontSize &&
          other.updatedAt == this.updatedAt);
}

class ReadingSessionTableCompanion extends UpdateCompanion<ReadingSession> {
  final Value<int> id;
  final Value<String> featureType;
  final Value<int?> bookId;
  final Value<int?> surahId;
  final Value<int?> pageNumber;
  final Value<int?> verseNumber;
  final Value<double> scrollOffset;
  final Value<String?> themeId;
  final Value<double?> fontSize;
  final Value<String> updatedAt;
  const ReadingSessionTableCompanion({
    this.id = const Value.absent(),
    this.featureType = const Value.absent(),
    this.bookId = const Value.absent(),
    this.surahId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.themeId = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReadingSessionTableCompanion.insert({
    this.id = const Value.absent(),
    this.featureType = const Value.absent(),
    this.bookId = const Value.absent(),
    this.surahId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.themeId = const Value.absent(),
    this.fontSize = const Value.absent(),
    required String updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<ReadingSession> custom({
    Expression<int>? id,
    Expression<String>? featureType,
    Expression<int>? bookId,
    Expression<int>? surahId,
    Expression<int>? pageNumber,
    Expression<int>? verseNumber,
    Expression<double>? scrollOffset,
    Expression<String>? themeId,
    Expression<double>? fontSize,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (featureType != null) 'feature_type': featureType,
      if (bookId != null) 'book_id': bookId,
      if (surahId != null) 'surah_id': surahId,
      if (pageNumber != null) 'page_number': pageNumber,
      if (verseNumber != null) 'verse_number': verseNumber,
      if (scrollOffset != null) 'scroll_offset': scrollOffset,
      if (themeId != null) 'theme_id': themeId,
      if (fontSize != null) 'font_size': fontSize,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReadingSessionTableCompanion copyWith({
    Value<int>? id,
    Value<String>? featureType,
    Value<int?>? bookId,
    Value<int?>? surahId,
    Value<int?>? pageNumber,
    Value<int?>? verseNumber,
    Value<double>? scrollOffset,
    Value<String?>? themeId,
    Value<double?>? fontSize,
    Value<String>? updatedAt,
  }) {
    return ReadingSessionTableCompanion(
      id: id ?? this.id,
      featureType: featureType ?? this.featureType,
      bookId: bookId ?? this.bookId,
      surahId: surahId ?? this.surahId,
      pageNumber: pageNumber ?? this.pageNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      themeId: themeId ?? this.themeId,
      fontSize: fontSize ?? this.fontSize,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (featureType.present) {
      map['feature_type'] = Variable<String>(featureType.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (verseNumber.present) {
      map['verse_number'] = Variable<int>(verseNumber.value);
    }
    if (scrollOffset.present) {
      map['scroll_offset'] = Variable<double>(scrollOffset.value);
    }
    if (themeId.present) {
      map['theme_id'] = Variable<String>(themeId.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionTableCompanion(')
          ..write('id: $id, ')
          ..write('featureType: $featureType, ')
          ..write('bookId: $bookId, ')
          ..write('surahId: $surahId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('themeId: $themeId, ')
          ..write('fontSize: $fontSize, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SavedItemsTableTable extends SavedItemsTable
    with TableInfo<$SavedItemsTableTable, SavedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedItemsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _featureTypeMeta = const VerificationMeta(
    'featureType',
  );
  @override
  late final GeneratedColumn<String> featureType = GeneratedColumn<String>(
    'feature_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<int> referenceId = GeneratedColumn<int>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondaryIdMeta = const VerificationMeta(
    'secondaryId',
  );
  @override
  late final GeneratedColumn<int> secondaryId = GeneratedColumn<int>(
    'secondary_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
    'collection_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previewTextMeta = const VerificationMeta(
    'previewText',
  );
  @override
  late final GeneratedColumn<String> previewText = GeneratedColumn<String>(
    'preview_text',
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
    featureType,
    referenceId,
    secondaryId,
    collectionId,
    notes,
    previewText,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feature_type')) {
      context.handle(
        _featureTypeMeta,
        featureType.isAcceptableOrUnknown(
          data['feature_type']!,
          _featureTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_featureTypeMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
    }
    if (data.containsKey('secondary_id')) {
      context.handle(
        _secondaryIdMeta,
        secondaryId.isAcceptableOrUnknown(
          data['secondary_id']!,
          _secondaryIdMeta,
        ),
      );
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('preview_text')) {
      context.handle(
        _previewTextMeta,
        previewText.isAcceptableOrUnknown(
          data['preview_text']!,
          _previewTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previewTextMeta);
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
  SavedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      featureType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_type'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reference_id'],
      )!,
      secondaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}secondary_id'],
      ),
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      previewText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preview_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavedItemsTableTable createAlias(String alias) {
    return $SavedItemsTableTable(attachedDatabase, alias);
  }
}

class SavedItem extends DataClass implements Insertable<SavedItem> {
  final int id;
  final String featureType;
  final int referenceId;
  final int? secondaryId;
  final String? collectionId;
  final String? notes;
  final String previewText;
  final String createdAt;
  const SavedItem({
    required this.id,
    required this.featureType,
    required this.referenceId,
    this.secondaryId,
    this.collectionId,
    this.notes,
    required this.previewText,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feature_type'] = Variable<String>(featureType);
    map['reference_id'] = Variable<int>(referenceId);
    if (!nullToAbsent || secondaryId != null) {
      map['secondary_id'] = Variable<int>(secondaryId);
    }
    if (!nullToAbsent || collectionId != null) {
      map['collection_id'] = Variable<String>(collectionId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['preview_text'] = Variable<String>(previewText);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  SavedItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SavedItemsTableCompanion(
      id: Value(id),
      featureType: Value(featureType),
      referenceId: Value(referenceId),
      secondaryId: secondaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryId),
      collectionId: collectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(collectionId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      previewText: Value(previewText),
      createdAt: Value(createdAt),
    );
  }

  factory SavedItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedItem(
      id: serializer.fromJson<int>(json['id']),
      featureType: serializer.fromJson<String>(json['featureType']),
      referenceId: serializer.fromJson<int>(json['referenceId']),
      secondaryId: serializer.fromJson<int?>(json['secondaryId']),
      collectionId: serializer.fromJson<String?>(json['collectionId']),
      notes: serializer.fromJson<String?>(json['notes']),
      previewText: serializer.fromJson<String>(json['previewText']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'featureType': serializer.toJson<String>(featureType),
      'referenceId': serializer.toJson<int>(referenceId),
      'secondaryId': serializer.toJson<int?>(secondaryId),
      'collectionId': serializer.toJson<String?>(collectionId),
      'notes': serializer.toJson<String?>(notes),
      'previewText': serializer.toJson<String>(previewText),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  SavedItem copyWith({
    int? id,
    String? featureType,
    int? referenceId,
    Value<int?> secondaryId = const Value.absent(),
    Value<String?> collectionId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? previewText,
    String? createdAt,
  }) => SavedItem(
    id: id ?? this.id,
    featureType: featureType ?? this.featureType,
    referenceId: referenceId ?? this.referenceId,
    secondaryId: secondaryId.present ? secondaryId.value : this.secondaryId,
    collectionId: collectionId.present ? collectionId.value : this.collectionId,
    notes: notes.present ? notes.value : this.notes,
    previewText: previewText ?? this.previewText,
    createdAt: createdAt ?? this.createdAt,
  );
  SavedItem copyWithCompanion(SavedItemsTableCompanion data) {
    return SavedItem(
      id: data.id.present ? data.id.value : this.id,
      featureType: data.featureType.present
          ? data.featureType.value
          : this.featureType,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      secondaryId: data.secondaryId.present
          ? data.secondaryId.value
          : this.secondaryId,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      notes: data.notes.present ? data.notes.value : this.notes,
      previewText: data.previewText.present
          ? data.previewText.value
          : this.previewText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedItem(')
          ..write('id: $id, ')
          ..write('featureType: $featureType, ')
          ..write('referenceId: $referenceId, ')
          ..write('secondaryId: $secondaryId, ')
          ..write('collectionId: $collectionId, ')
          ..write('notes: $notes, ')
          ..write('previewText: $previewText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    featureType,
    referenceId,
    secondaryId,
    collectionId,
    notes,
    previewText,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedItem &&
          other.id == this.id &&
          other.featureType == this.featureType &&
          other.referenceId == this.referenceId &&
          other.secondaryId == this.secondaryId &&
          other.collectionId == this.collectionId &&
          other.notes == this.notes &&
          other.previewText == this.previewText &&
          other.createdAt == this.createdAt);
}

class SavedItemsTableCompanion extends UpdateCompanion<SavedItem> {
  final Value<int> id;
  final Value<String> featureType;
  final Value<int> referenceId;
  final Value<int?> secondaryId;
  final Value<String?> collectionId;
  final Value<String?> notes;
  final Value<String> previewText;
  final Value<String> createdAt;
  const SavedItemsTableCompanion({
    this.id = const Value.absent(),
    this.featureType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.secondaryId = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.notes = const Value.absent(),
    this.previewText = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavedItemsTableCompanion.insert({
    this.id = const Value.absent(),
    required String featureType,
    required int referenceId,
    this.secondaryId = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.notes = const Value.absent(),
    required String previewText,
    required String createdAt,
  }) : featureType = Value(featureType),
       referenceId = Value(referenceId),
       previewText = Value(previewText),
       createdAt = Value(createdAt);
  static Insertable<SavedItem> custom({
    Expression<int>? id,
    Expression<String>? featureType,
    Expression<int>? referenceId,
    Expression<int>? secondaryId,
    Expression<String>? collectionId,
    Expression<String>? notes,
    Expression<String>? previewText,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (featureType != null) 'feature_type': featureType,
      if (referenceId != null) 'reference_id': referenceId,
      if (secondaryId != null) 'secondary_id': secondaryId,
      if (collectionId != null) 'collection_id': collectionId,
      if (notes != null) 'notes': notes,
      if (previewText != null) 'preview_text': previewText,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavedItemsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? featureType,
    Value<int>? referenceId,
    Value<int?>? secondaryId,
    Value<String?>? collectionId,
    Value<String?>? notes,
    Value<String>? previewText,
    Value<String>? createdAt,
  }) {
    return SavedItemsTableCompanion(
      id: id ?? this.id,
      featureType: featureType ?? this.featureType,
      referenceId: referenceId ?? this.referenceId,
      secondaryId: secondaryId ?? this.secondaryId,
      collectionId: collectionId ?? this.collectionId,
      notes: notes ?? this.notes,
      previewText: previewText ?? this.previewText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (featureType.present) {
      map['feature_type'] = Variable<String>(featureType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<int>(referenceId.value);
    }
    if (secondaryId.present) {
      map['secondary_id'] = Variable<int>(secondaryId.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (previewText.present) {
      map['preview_text'] = Variable<String>(previewText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('featureType: $featureType, ')
          ..write('referenceId: $referenceId, ')
          ..write('secondaryId: $secondaryId, ')
          ..write('collectionId: $collectionId, ')
          ..write('notes: $notes, ')
          ..write('previewText: $previewText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTableTable extends CollectionsTable
    with TableInfo<$CollectionsTableTable, LibraryCollection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  List<GeneratedColumn> get $columns => [id, name, icon, colorHex, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryCollection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
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
  LibraryCollection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryCollection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CollectionsTableTable createAlias(String alias) {
    return $CollectionsTableTable(attachedDatabase, alias);
  }
}

class LibraryCollection extends DataClass
    implements Insertable<LibraryCollection> {
  final String id;
  final String name;
  final String? icon;
  final String? colorHex;
  final String createdAt;
  const LibraryCollection({
    required this.id,
    required this.name,
    this.icon,
    this.colorHex,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  CollectionsTableCompanion toCompanion(bool nullToAbsent) {
    return CollectionsTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      createdAt: Value(createdAt),
    );
  }

  factory LibraryCollection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryCollection(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'colorHex': serializer.toJson<String?>(colorHex),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  LibraryCollection copyWith({
    String? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    Value<String?> colorHex = const Value.absent(),
    String? createdAt,
  }) => LibraryCollection(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    createdAt: createdAt ?? this.createdAt,
  );
  LibraryCollection copyWithCompanion(CollectionsTableCompanion data) {
    return LibraryCollection(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryCollection(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, colorHex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryCollection &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorHex == this.colorHex &&
          other.createdAt == this.createdAt);
}

class CollectionsTableCompanion extends UpdateCompanion<LibraryCollection> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String?> colorHex;
  final Value<String> createdAt;
  final Value<int> rowid;
  const CollectionsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionsTableCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<LibraryCollection> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? colorHex,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorHex != null) 'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<String?>? colorHex,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return CollectionsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTableTable extends NotesTable
    with TableInfo<$NotesTableTable, UserNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _featureTypeMeta = const VerificationMeta(
    'featureType',
  );
  @override
  late final GeneratedColumn<String> featureType = GeneratedColumn<String>(
    'feature_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<int> referenceId = GeneratedColumn<int>(
    'reference_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _secondaryIdMeta = const VerificationMeta(
    'secondaryId',
  );
  @override
  late final GeneratedColumn<int> secondaryId = GeneratedColumn<int>(
    'secondary_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
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
    id,
    featureType,
    referenceId,
    secondaryId,
    content,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feature_type')) {
      context.handle(
        _featureTypeMeta,
        featureType.isAcceptableOrUnknown(
          data['feature_type']!,
          _featureTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_featureTypeMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('secondary_id')) {
      context.handle(
        _secondaryIdMeta,
        secondaryId.isAcceptableOrUnknown(
          data['secondary_id']!,
          _secondaryIdMeta,
        ),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      featureType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_type'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reference_id'],
      ),
      secondaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}secondary_id'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTableTable createAlias(String alias) {
    return $NotesTableTable(attachedDatabase, alias);
  }
}

class UserNote extends DataClass implements Insertable<UserNote> {
  final int id;
  final String featureType;
  final int? referenceId;
  final int? secondaryId;
  final String content;
  final String createdAt;
  final String updatedAt;
  const UserNote({
    required this.id,
    required this.featureType,
    this.referenceId,
    this.secondaryId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feature_type'] = Variable<String>(featureType);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<int>(referenceId);
    }
    if (!nullToAbsent || secondaryId != null) {
      map['secondary_id'] = Variable<int>(secondaryId);
    }
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  NotesTableCompanion toCompanion(bool nullToAbsent) {
    return NotesTableCompanion(
      id: Value(id),
      featureType: Value(featureType),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      secondaryId: secondaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryId),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserNote(
      id: serializer.fromJson<int>(json['id']),
      featureType: serializer.fromJson<String>(json['featureType']),
      referenceId: serializer.fromJson<int?>(json['referenceId']),
      secondaryId: serializer.fromJson<int?>(json['secondaryId']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'featureType': serializer.toJson<String>(featureType),
      'referenceId': serializer.toJson<int?>(referenceId),
      'secondaryId': serializer.toJson<int?>(secondaryId),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  UserNote copyWith({
    int? id,
    String? featureType,
    Value<int?> referenceId = const Value.absent(),
    Value<int?> secondaryId = const Value.absent(),
    String? content,
    String? createdAt,
    String? updatedAt,
  }) => UserNote(
    id: id ?? this.id,
    featureType: featureType ?? this.featureType,
    referenceId: referenceId.present ? referenceId.value : this.referenceId,
    secondaryId: secondaryId.present ? secondaryId.value : this.secondaryId,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserNote copyWithCompanion(NotesTableCompanion data) {
    return UserNote(
      id: data.id.present ? data.id.value : this.id,
      featureType: data.featureType.present
          ? data.featureType.value
          : this.featureType,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      secondaryId: data.secondaryId.present
          ? data.secondaryId.value
          : this.secondaryId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserNote(')
          ..write('id: $id, ')
          ..write('featureType: $featureType, ')
          ..write('referenceId: $referenceId, ')
          ..write('secondaryId: $secondaryId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    featureType,
    referenceId,
    secondaryId,
    content,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserNote &&
          other.id == this.id &&
          other.featureType == this.featureType &&
          other.referenceId == this.referenceId &&
          other.secondaryId == this.secondaryId &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesTableCompanion extends UpdateCompanion<UserNote> {
  final Value<int> id;
  final Value<String> featureType;
  final Value<int?> referenceId;
  final Value<int?> secondaryId;
  final Value<String> content;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const NotesTableCompanion({
    this.id = const Value.absent(),
    this.featureType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.secondaryId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotesTableCompanion.insert({
    this.id = const Value.absent(),
    required String featureType,
    this.referenceId = const Value.absent(),
    this.secondaryId = const Value.absent(),
    required String content,
    required String createdAt,
    required String updatedAt,
  }) : featureType = Value(featureType),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserNote> custom({
    Expression<int>? id,
    Expression<String>? featureType,
    Expression<int>? referenceId,
    Expression<int>? secondaryId,
    Expression<String>? content,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (featureType != null) 'feature_type': featureType,
      if (referenceId != null) 'reference_id': referenceId,
      if (secondaryId != null) 'secondary_id': secondaryId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? featureType,
    Value<int?>? referenceId,
    Value<int?>? secondaryId,
    Value<String>? content,
    Value<String>? createdAt,
    Value<String>? updatedAt,
  }) {
    return NotesTableCompanion(
      id: id ?? this.id,
      featureType: featureType ?? this.featureType,
      referenceId: referenceId ?? this.referenceId,
      secondaryId: secondaryId ?? this.secondaryId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (featureType.present) {
      map['feature_type'] = Variable<String>(featureType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<int>(referenceId.value);
    }
    if (secondaryId.present) {
      map['secondary_id'] = Variable<int>(secondaryId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableCompanion(')
          ..write('id: $id, ')
          ..write('featureType: $featureType, ')
          ..write('referenceId: $referenceId, ')
          ..write('secondaryId: $secondaryId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SearchableItemsTableTable extends SearchableItemsTable
    with TableInfo<$SearchableItemsTableTable, SearchableItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchableItemsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _featureTypeMeta = const VerificationMeta(
    'featureType',
  );
  @override
  late final GeneratedColumn<String> featureType = GeneratedColumn<String>(
    'feature_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<int> referenceId = GeneratedColumn<int>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondaryIdMeta = const VerificationMeta(
    'secondaryId',
  );
  @override
  late final GeneratedColumn<int> secondaryId = GeneratedColumn<int>(
    'secondary_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedContentMeta = const VerificationMeta(
    'normalizedContent',
  );
  @override
  late final GeneratedColumn<String> normalizedContent =
      GeneratedColumn<String>(
        'normalized_content',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    featureType,
    referenceId,
    secondaryId,
    title,
    content,
    normalizedContent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'searchable_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SearchableItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feature_type')) {
      context.handle(
        _featureTypeMeta,
        featureType.isAcceptableOrUnknown(
          data['feature_type']!,
          _featureTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_featureTypeMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
    }
    if (data.containsKey('secondary_id')) {
      context.handle(
        _secondaryIdMeta,
        secondaryId.isAcceptableOrUnknown(
          data['secondary_id']!,
          _secondaryIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('normalized_content')) {
      context.handle(
        _normalizedContentMeta,
        normalizedContent.isAcceptableOrUnknown(
          data['normalized_content']!,
          _normalizedContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedContentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchableItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchableItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      featureType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_type'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reference_id'],
      )!,
      secondaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}secondary_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      normalizedContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_content'],
      )!,
    );
  }

  @override
  $SearchableItemsTableTable createAlias(String alias) {
    return $SearchableItemsTableTable(attachedDatabase, alias);
  }
}

class SearchableItem extends DataClass implements Insertable<SearchableItem> {
  final int id;
  final String featureType;
  final int referenceId;
  final int? secondaryId;
  final String? title;
  final String content;
  final String normalizedContent;
  const SearchableItem({
    required this.id,
    required this.featureType,
    required this.referenceId,
    this.secondaryId,
    this.title,
    required this.content,
    required this.normalizedContent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feature_type'] = Variable<String>(featureType);
    map['reference_id'] = Variable<int>(referenceId);
    if (!nullToAbsent || secondaryId != null) {
      map['secondary_id'] = Variable<int>(secondaryId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['content'] = Variable<String>(content);
    map['normalized_content'] = Variable<String>(normalizedContent);
    return map;
  }

  SearchableItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SearchableItemsTableCompanion(
      id: Value(id),
      featureType: Value(featureType),
      referenceId: Value(referenceId),
      secondaryId: secondaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      content: Value(content),
      normalizedContent: Value(normalizedContent),
    );
  }

  factory SearchableItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchableItem(
      id: serializer.fromJson<int>(json['id']),
      featureType: serializer.fromJson<String>(json['featureType']),
      referenceId: serializer.fromJson<int>(json['referenceId']),
      secondaryId: serializer.fromJson<int?>(json['secondaryId']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      normalizedContent: serializer.fromJson<String>(json['normalizedContent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'featureType': serializer.toJson<String>(featureType),
      'referenceId': serializer.toJson<int>(referenceId),
      'secondaryId': serializer.toJson<int?>(secondaryId),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String>(content),
      'normalizedContent': serializer.toJson<String>(normalizedContent),
    };
  }

  SearchableItem copyWith({
    int? id,
    String? featureType,
    int? referenceId,
    Value<int?> secondaryId = const Value.absent(),
    Value<String?> title = const Value.absent(),
    String? content,
    String? normalizedContent,
  }) => SearchableItem(
    id: id ?? this.id,
    featureType: featureType ?? this.featureType,
    referenceId: referenceId ?? this.referenceId,
    secondaryId: secondaryId.present ? secondaryId.value : this.secondaryId,
    title: title.present ? title.value : this.title,
    content: content ?? this.content,
    normalizedContent: normalizedContent ?? this.normalizedContent,
  );
  SearchableItem copyWithCompanion(SearchableItemsTableCompanion data) {
    return SearchableItem(
      id: data.id.present ? data.id.value : this.id,
      featureType: data.featureType.present
          ? data.featureType.value
          : this.featureType,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      secondaryId: data.secondaryId.present
          ? data.secondaryId.value
          : this.secondaryId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      normalizedContent: data.normalizedContent.present
          ? data.normalizedContent.value
          : this.normalizedContent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchableItem(')
          ..write('id: $id, ')
          ..write('featureType: $featureType, ')
          ..write('referenceId: $referenceId, ')
          ..write('secondaryId: $secondaryId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('normalizedContent: $normalizedContent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    featureType,
    referenceId,
    secondaryId,
    title,
    content,
    normalizedContent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchableItem &&
          other.id == this.id &&
          other.featureType == this.featureType &&
          other.referenceId == this.referenceId &&
          other.secondaryId == this.secondaryId &&
          other.title == this.title &&
          other.content == this.content &&
          other.normalizedContent == this.normalizedContent);
}

class SearchableItemsTableCompanion extends UpdateCompanion<SearchableItem> {
  final Value<int> id;
  final Value<String> featureType;
  final Value<int> referenceId;
  final Value<int?> secondaryId;
  final Value<String?> title;
  final Value<String> content;
  final Value<String> normalizedContent;
  const SearchableItemsTableCompanion({
    this.id = const Value.absent(),
    this.featureType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.secondaryId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.normalizedContent = const Value.absent(),
  });
  SearchableItemsTableCompanion.insert({
    this.id = const Value.absent(),
    required String featureType,
    required int referenceId,
    this.secondaryId = const Value.absent(),
    this.title = const Value.absent(),
    required String content,
    required String normalizedContent,
  }) : featureType = Value(featureType),
       referenceId = Value(referenceId),
       content = Value(content),
       normalizedContent = Value(normalizedContent);
  static Insertable<SearchableItem> custom({
    Expression<int>? id,
    Expression<String>? featureType,
    Expression<int>? referenceId,
    Expression<int>? secondaryId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? normalizedContent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (featureType != null) 'feature_type': featureType,
      if (referenceId != null) 'reference_id': referenceId,
      if (secondaryId != null) 'secondary_id': secondaryId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (normalizedContent != null) 'normalized_content': normalizedContent,
    });
  }

  SearchableItemsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? featureType,
    Value<int>? referenceId,
    Value<int?>? secondaryId,
    Value<String?>? title,
    Value<String>? content,
    Value<String>? normalizedContent,
  }) {
    return SearchableItemsTableCompanion(
      id: id ?? this.id,
      featureType: featureType ?? this.featureType,
      referenceId: referenceId ?? this.referenceId,
      secondaryId: secondaryId ?? this.secondaryId,
      title: title ?? this.title,
      content: content ?? this.content,
      normalizedContent: normalizedContent ?? this.normalizedContent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (featureType.present) {
      map['feature_type'] = Variable<String>(featureType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<int>(referenceId.value);
    }
    if (secondaryId.present) {
      map['secondary_id'] = Variable<int>(secondaryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (normalizedContent.present) {
      map['normalized_content'] = Variable<String>(normalizedContent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchableItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('featureType: $featureType, ')
          ..write('referenceId: $referenceId, ')
          ..write('secondaryId: $secondaryId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('normalizedContent: $normalizedContent')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTableTable extends SearchHistoryTable
    with TableInfo<$SearchHistoryTableTable, SearchHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, query, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SearchHistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('query')) {
      context.handle(
        _queryMeta,
        query.isAcceptableOrUnknown(data['query']!, _queryMeta),
      );
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {query},
  ];
  @override
  SearchHistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      query: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $SearchHistoryTableTable createAlias(String alias) {
    return $SearchHistoryTableTable(attachedDatabase, alias);
  }
}

class SearchHistoryTableData extends DataClass
    implements Insertable<SearchHistoryTableData> {
  final int id;
  final String query;
  final DateTime timestamp;
  const SearchHistoryTableData({
    required this.id,
    required this.query,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['query'] = Variable<String>(query);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  SearchHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryTableCompanion(
      id: Value(id),
      query: Value(query),
      timestamp: Value(timestamp),
    );
  }

  factory SearchHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryTableData(
      id: serializer.fromJson<int>(json['id']),
      query: serializer.fromJson<String>(json['query']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'query': serializer.toJson<String>(query),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  SearchHistoryTableData copyWith({
    int? id,
    String? query,
    DateTime? timestamp,
  }) => SearchHistoryTableData(
    id: id ?? this.id,
    query: query ?? this.query,
    timestamp: timestamp ?? this.timestamp,
  );
  SearchHistoryTableData copyWithCompanion(SearchHistoryTableCompanion data) {
    return SearchHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      query: data.query.present ? data.query.value : this.query,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryTableData(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, query, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryTableData &&
          other.id == this.id &&
          other.query == this.query &&
          other.timestamp == this.timestamp);
}

class SearchHistoryTableCompanion
    extends UpdateCompanion<SearchHistoryTableData> {
  final Value<int> id;
  final Value<String> query;
  final Value<DateTime> timestamp;
  const SearchHistoryTableCompanion({
    this.id = const Value.absent(),
    this.query = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  SearchHistoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String query,
    required DateTime timestamp,
  }) : query = Value(query),
       timestamp = Value(timestamp);
  static Insertable<SearchHistoryTableData> custom({
    Expression<int>? id,
    Expression<String>? query,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (query != null) 'query': query,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  SearchHistoryTableCompanion copyWith({
    Value<int>? id,
    Value<String>? query,
    Value<DateTime>? timestamp,
  }) {
    return SearchHistoryTableCompanion(
      id: id ?? this.id,
      query: query ?? this.query,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('timestamp: $timestamp')
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
  late final $UserFavoriteTableTable userFavoriteTable =
      $UserFavoriteTableTable(this);
  late final $UserDailyActivityTableTable userDailyActivityTable =
      $UserDailyActivityTableTable(this);
  late final $DailySunnahTableTable dailySunnahTable = $DailySunnahTableTable(
    this,
  );
  late final $DailyTaskTableTable dailyTaskTable = $DailyTaskTableTable(this);
  late final $MuhasabaEntryTableTable muhasabaEntryTable =
      $MuhasabaEntryTableTable(this);
  late final $ProgressRecordTableTable progressRecordTable =
      $ProgressRecordTableTable(this);
  late final $RecentActivityTableTable recentActivityTable =
      $RecentActivityTableTable(this);
  late final $UserGoalsTableTable userGoalsTable = $UserGoalsTableTable(this);
  late final $ReadingSessionTableTable readingSessionTable =
      $ReadingSessionTableTable(this);
  late final $SavedItemsTableTable savedItemsTable = $SavedItemsTableTable(
    this,
  );
  late final $CollectionsTableTable collectionsTable = $CollectionsTableTable(
    this,
  );
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final $SearchableItemsTableTable searchableItemsTable =
      $SearchableItemsTableTable(this);
  late final $SearchHistoryTableTable searchHistoryTable =
      $SearchHistoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    quranTafseerTable,
    hadithTable,
    duaTable,
    userFavoriteTable,
    userDailyActivityTable,
    dailySunnahTable,
    dailyTaskTable,
    muhasabaEntryTable,
    progressRecordTable,
    recentActivityTable,
    userGoalsTable,
    readingSessionTable,
    savedItemsTable,
    collectionsTable,
    notesTable,
    searchableItemsTable,
    searchHistoryTable,
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
      Value<String?> note,
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
      Value<String?> note,
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

  ColumnFilters<String> get note => $state.composableBuilder(
    column: $state.table.note,
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

  ColumnOrderings<String> get note => $state.composableBuilder(
    column: $state.table.note,
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
                Value<String?> note = const Value.absent(),
              }) => UserFavoriteTableCompanion(
                id: id,
                contentType: contentType,
                primaryReference: primaryReference,
                secondaryReference: secondaryReference,
                title: title,
                contentText: contentText,
                source: source,
                createdAt: createdAt,
                note: note,
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
                Value<String?> note = const Value.absent(),
              }) => UserFavoriteTableCompanion.insert(
                id: id,
                contentType: contentType,
                primaryReference: primaryReference,
                secondaryReference: secondaryReference,
                title: title,
                contentText: contentText,
                source: source,
                createdAt: createdAt,
                note: note,
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
typedef $$ProgressRecordTableTableCreateCompanionBuilder =
    ProgressRecordTableCompanion Function({
      required String date,
      Value<int> pagesRead,
      Value<int> readingSeconds,
      Value<int> azkarCount,
      Value<int> hadithCount,
      Value<bool> isMuhasabaDone,
      Value<int> rowid,
    });
typedef $$ProgressRecordTableTableUpdateCompanionBuilder =
    ProgressRecordTableCompanion Function({
      Value<String> date,
      Value<int> pagesRead,
      Value<int> readingSeconds,
      Value<int> azkarCount,
      Value<int> hadithCount,
      Value<bool> isMuhasabaDone,
      Value<int> rowid,
    });

class $$ProgressRecordTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProgressRecordTableTable> {
  $$ProgressRecordTableTableFilterComposer(super.$state);
  ColumnFilters<String> get date => $state.composableBuilder(
    column: $state.table.date,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get pagesRead => $state.composableBuilder(
    column: $state.table.pagesRead,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get readingSeconds => $state.composableBuilder(
    column: $state.table.readingSeconds,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get azkarCount => $state.composableBuilder(
    column: $state.table.azkarCount,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get hadithCount => $state.composableBuilder(
    column: $state.table.hadithCount,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get isMuhasabaDone => $state.composableBuilder(
    column: $state.table.isMuhasabaDone,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$ProgressRecordTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProgressRecordTableTable> {
  $$ProgressRecordTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get date => $state.composableBuilder(
    column: $state.table.date,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get pagesRead => $state.composableBuilder(
    column: $state.table.pagesRead,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get readingSeconds => $state.composableBuilder(
    column: $state.table.readingSeconds,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get azkarCount => $state.composableBuilder(
    column: $state.table.azkarCount,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get hadithCount => $state.composableBuilder(
    column: $state.table.hadithCount,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get isMuhasabaDone => $state.composableBuilder(
    column: $state.table.isMuhasabaDone,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$ProgressRecordTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressRecordTableTable,
          ProgressRecord,
          $$ProgressRecordTableTableFilterComposer,
          $$ProgressRecordTableTableOrderingComposer,
          $$ProgressRecordTableTableCreateCompanionBuilder,
          $$ProgressRecordTableTableUpdateCompanionBuilder,
          (
            ProgressRecord,
            BaseReferences<
              _$AppDatabase,
              $ProgressRecordTableTable,
              ProgressRecord
            >,
          ),
          ProgressRecord,
          PrefetchHooks Function()
        > {
  $$ProgressRecordTableTableTableManager(
    _$AppDatabase db,
    $ProgressRecordTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ProgressRecordTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$ProgressRecordTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> pagesRead = const Value.absent(),
                Value<int> readingSeconds = const Value.absent(),
                Value<int> azkarCount = const Value.absent(),
                Value<int> hadithCount = const Value.absent(),
                Value<bool> isMuhasabaDone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressRecordTableCompanion(
                date: date,
                pagesRead: pagesRead,
                readingSeconds: readingSeconds,
                azkarCount: azkarCount,
                hadithCount: hadithCount,
                isMuhasabaDone: isMuhasabaDone,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int> pagesRead = const Value.absent(),
                Value<int> readingSeconds = const Value.absent(),
                Value<int> azkarCount = const Value.absent(),
                Value<int> hadithCount = const Value.absent(),
                Value<bool> isMuhasabaDone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressRecordTableCompanion.insert(
                date: date,
                pagesRead: pagesRead,
                readingSeconds: readingSeconds,
                azkarCount: azkarCount,
                hadithCount: hadithCount,
                isMuhasabaDone: isMuhasabaDone,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressRecordTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressRecordTableTable,
      ProgressRecord,
      $$ProgressRecordTableTableFilterComposer,
      $$ProgressRecordTableTableOrderingComposer,
      $$ProgressRecordTableTableCreateCompanionBuilder,
      $$ProgressRecordTableTableUpdateCompanionBuilder,
      (
        ProgressRecord,
        BaseReferences<
          _$AppDatabase,
          $ProgressRecordTableTable,
          ProgressRecord
        >,
      ),
      ProgressRecord,
      PrefetchHooks Function()
    >;
typedef $$RecentActivityTableTableCreateCompanionBuilder =
    RecentActivityTableCompanion Function({
      required String id,
      required String type,
      required String title,
      Value<String?> subtitle,
      required String routePath,
      required DateTime timestamp,
      Value<int> rowid,
    });
typedef $$RecentActivityTableTableUpdateCompanionBuilder =
    RecentActivityTableCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> title,
      Value<String?> subtitle,
      Value<String> routePath,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

class $$RecentActivityTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $RecentActivityTableTable> {
  $$RecentActivityTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get type => $state.composableBuilder(
    column: $state.table.type,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get subtitle => $state.composableBuilder(
    column: $state.table.subtitle,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get routePath => $state.composableBuilder(
    column: $state.table.routePath,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
    column: $state.table.timestamp,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$RecentActivityTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $RecentActivityTableTable> {
  $$RecentActivityTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get type => $state.composableBuilder(
    column: $state.table.type,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get subtitle => $state.composableBuilder(
    column: $state.table.subtitle,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get routePath => $state.composableBuilder(
    column: $state.table.routePath,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
    column: $state.table.timestamp,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$RecentActivityTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentActivityTableTable,
          RecentActivity,
          $$RecentActivityTableTableFilterComposer,
          $$RecentActivityTableTableOrderingComposer,
          $$RecentActivityTableTableCreateCompanionBuilder,
          $$RecentActivityTableTableUpdateCompanionBuilder,
          (
            RecentActivity,
            BaseReferences<
              _$AppDatabase,
              $RecentActivityTableTable,
              RecentActivity
            >,
          ),
          RecentActivity,
          PrefetchHooks Function()
        > {
  $$RecentActivityTableTableTableManager(
    _$AppDatabase db,
    $RecentActivityTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$RecentActivityTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$RecentActivityTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String> routePath = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentActivityTableCompanion(
                id: id,
                type: type,
                title: title,
                subtitle: subtitle,
                routePath: routePath,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String title,
                Value<String?> subtitle = const Value.absent(),
                required String routePath,
                required DateTime timestamp,
                Value<int> rowid = const Value.absent(),
              }) => RecentActivityTableCompanion.insert(
                id: id,
                type: type,
                title: title,
                subtitle: subtitle,
                routePath: routePath,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentActivityTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentActivityTableTable,
      RecentActivity,
      $$RecentActivityTableTableFilterComposer,
      $$RecentActivityTableTableOrderingComposer,
      $$RecentActivityTableTableCreateCompanionBuilder,
      $$RecentActivityTableTableUpdateCompanionBuilder,
      (
        RecentActivity,
        BaseReferences<
          _$AppDatabase,
          $RecentActivityTableTable,
          RecentActivity
        >,
      ),
      RecentActivity,
      PrefetchHooks Function()
    >;
typedef $$UserGoalsTableTableCreateCompanionBuilder =
    UserGoalsTableCompanion Function({
      Value<int> id,
      required String goalType,
      Value<String> metric,
      required String title,
      required String icon,
      required int targetValue,
      Value<String> resetPolicy,
      Value<String?> metadata,
      required String updatedAt,
    });
typedef $$UserGoalsTableTableUpdateCompanionBuilder =
    UserGoalsTableCompanion Function({
      Value<int> id,
      Value<String> goalType,
      Value<String> metric,
      Value<String> title,
      Value<String> icon,
      Value<int> targetValue,
      Value<String> resetPolicy,
      Value<String?> metadata,
      Value<String> updatedAt,
    });

class $$UserGoalsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UserGoalsTableTable> {
  $$UserGoalsTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get goalType => $state.composableBuilder(
    column: $state.table.goalType,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get metric => $state.composableBuilder(
    column: $state.table.metric,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get icon => $state.composableBuilder(
    column: $state.table.icon,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get targetValue => $state.composableBuilder(
    column: $state.table.targetValue,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get resetPolicy => $state.composableBuilder(
    column: $state.table.resetPolicy,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get metadata => $state.composableBuilder(
    column: $state.table.metadata,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$UserGoalsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UserGoalsTableTable> {
  $$UserGoalsTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get goalType => $state.composableBuilder(
    column: $state.table.goalType,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get metric => $state.composableBuilder(
    column: $state.table.metric,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get icon => $state.composableBuilder(
    column: $state.table.icon,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get targetValue => $state.composableBuilder(
    column: $state.table.targetValue,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get resetPolicy => $state.composableBuilder(
    column: $state.table.resetPolicy,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get metadata => $state.composableBuilder(
    column: $state.table.metadata,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$UserGoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserGoalsTableTable,
          UserGoal,
          $$UserGoalsTableTableFilterComposer,
          $$UserGoalsTableTableOrderingComposer,
          $$UserGoalsTableTableCreateCompanionBuilder,
          $$UserGoalsTableTableUpdateCompanionBuilder,
          (
            UserGoal,
            BaseReferences<_$AppDatabase, $UserGoalsTableTable, UserGoal>,
          ),
          UserGoal,
          PrefetchHooks Function()
        > {
  $$UserGoalsTableTableTableManager(
    _$AppDatabase db,
    $UserGoalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$UserGoalsTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$UserGoalsTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> targetValue = const Value.absent(),
                Value<String> resetPolicy = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => UserGoalsTableCompanion(
                id: id,
                goalType: goalType,
                metric: metric,
                title: title,
                icon: icon,
                targetValue: targetValue,
                resetPolicy: resetPolicy,
                metadata: metadata,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String goalType,
                Value<String> metric = const Value.absent(),
                required String title,
                required String icon,
                required int targetValue,
                Value<String> resetPolicy = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                required String updatedAt,
              }) => UserGoalsTableCompanion.insert(
                id: id,
                goalType: goalType,
                metric: metric,
                title: title,
                icon: icon,
                targetValue: targetValue,
                resetPolicy: resetPolicy,
                metadata: metadata,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserGoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserGoalsTableTable,
      UserGoal,
      $$UserGoalsTableTableFilterComposer,
      $$UserGoalsTableTableOrderingComposer,
      $$UserGoalsTableTableCreateCompanionBuilder,
      $$UserGoalsTableTableUpdateCompanionBuilder,
      (UserGoal, BaseReferences<_$AppDatabase, $UserGoalsTableTable, UserGoal>),
      UserGoal,
      PrefetchHooks Function()
    >;
typedef $$ReadingSessionTableTableCreateCompanionBuilder =
    ReadingSessionTableCompanion Function({
      Value<int> id,
      Value<String> featureType,
      Value<int?> bookId,
      Value<int?> surahId,
      Value<int?> pageNumber,
      Value<int?> verseNumber,
      Value<double> scrollOffset,
      Value<String?> themeId,
      Value<double?> fontSize,
      required String updatedAt,
    });
typedef $$ReadingSessionTableTableUpdateCompanionBuilder =
    ReadingSessionTableCompanion Function({
      Value<int> id,
      Value<String> featureType,
      Value<int?> bookId,
      Value<int?> surahId,
      Value<int?> pageNumber,
      Value<int?> verseNumber,
      Value<double> scrollOffset,
      Value<String?> themeId,
      Value<double?> fontSize,
      Value<String> updatedAt,
    });

class $$ReadingSessionTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ReadingSessionTableTable> {
  $$ReadingSessionTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get featureType => $state.composableBuilder(
    column: $state.table.featureType,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get bookId => $state.composableBuilder(
    column: $state.table.bookId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get surahId => $state.composableBuilder(
    column: $state.table.surahId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get pageNumber => $state.composableBuilder(
    column: $state.table.pageNumber,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get verseNumber => $state.composableBuilder(
    column: $state.table.verseNumber,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<double> get scrollOffset => $state.composableBuilder(
    column: $state.table.scrollOffset,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get themeId => $state.composableBuilder(
    column: $state.table.themeId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<double> get fontSize => $state.composableBuilder(
    column: $state.table.fontSize,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$ReadingSessionTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ReadingSessionTableTable> {
  $$ReadingSessionTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get featureType => $state.composableBuilder(
    column: $state.table.featureType,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get bookId => $state.composableBuilder(
    column: $state.table.bookId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get surahId => $state.composableBuilder(
    column: $state.table.surahId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get pageNumber => $state.composableBuilder(
    column: $state.table.pageNumber,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get verseNumber => $state.composableBuilder(
    column: $state.table.verseNumber,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<double> get scrollOffset => $state.composableBuilder(
    column: $state.table.scrollOffset,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get themeId => $state.composableBuilder(
    column: $state.table.themeId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<double> get fontSize => $state.composableBuilder(
    column: $state.table.fontSize,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$ReadingSessionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingSessionTableTable,
          ReadingSession,
          $$ReadingSessionTableTableFilterComposer,
          $$ReadingSessionTableTableOrderingComposer,
          $$ReadingSessionTableTableCreateCompanionBuilder,
          $$ReadingSessionTableTableUpdateCompanionBuilder,
          (
            ReadingSession,
            BaseReferences<
              _$AppDatabase,
              $ReadingSessionTableTable,
              ReadingSession
            >,
          ),
          ReadingSession,
          PrefetchHooks Function()
        > {
  $$ReadingSessionTableTableTableManager(
    _$AppDatabase db,
    $ReadingSessionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ReadingSessionTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$ReadingSessionTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> featureType = const Value.absent(),
                Value<int?> bookId = const Value.absent(),
                Value<int?> surahId = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<int?> verseNumber = const Value.absent(),
                Value<double> scrollOffset = const Value.absent(),
                Value<String?> themeId = const Value.absent(),
                Value<double?> fontSize = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => ReadingSessionTableCompanion(
                id: id,
                featureType: featureType,
                bookId: bookId,
                surahId: surahId,
                pageNumber: pageNumber,
                verseNumber: verseNumber,
                scrollOffset: scrollOffset,
                themeId: themeId,
                fontSize: fontSize,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> featureType = const Value.absent(),
                Value<int?> bookId = const Value.absent(),
                Value<int?> surahId = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<int?> verseNumber = const Value.absent(),
                Value<double> scrollOffset = const Value.absent(),
                Value<String?> themeId = const Value.absent(),
                Value<double?> fontSize = const Value.absent(),
                required String updatedAt,
              }) => ReadingSessionTableCompanion.insert(
                id: id,
                featureType: featureType,
                bookId: bookId,
                surahId: surahId,
                pageNumber: pageNumber,
                verseNumber: verseNumber,
                scrollOffset: scrollOffset,
                themeId: themeId,
                fontSize: fontSize,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingSessionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingSessionTableTable,
      ReadingSession,
      $$ReadingSessionTableTableFilterComposer,
      $$ReadingSessionTableTableOrderingComposer,
      $$ReadingSessionTableTableCreateCompanionBuilder,
      $$ReadingSessionTableTableUpdateCompanionBuilder,
      (
        ReadingSession,
        BaseReferences<
          _$AppDatabase,
          $ReadingSessionTableTable,
          ReadingSession
        >,
      ),
      ReadingSession,
      PrefetchHooks Function()
    >;
typedef $$SavedItemsTableTableCreateCompanionBuilder =
    SavedItemsTableCompanion Function({
      Value<int> id,
      required String featureType,
      required int referenceId,
      Value<int?> secondaryId,
      Value<String?> collectionId,
      Value<String?> notes,
      required String previewText,
      required String createdAt,
    });
typedef $$SavedItemsTableTableUpdateCompanionBuilder =
    SavedItemsTableCompanion Function({
      Value<int> id,
      Value<String> featureType,
      Value<int> referenceId,
      Value<int?> secondaryId,
      Value<String?> collectionId,
      Value<String?> notes,
      Value<String> previewText,
      Value<String> createdAt,
    });

class $$SavedItemsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SavedItemsTableTable> {
  $$SavedItemsTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get featureType => $state.composableBuilder(
    column: $state.table.featureType,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get referenceId => $state.composableBuilder(
    column: $state.table.referenceId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get secondaryId => $state.composableBuilder(
    column: $state.table.secondaryId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get collectionId => $state.composableBuilder(
    column: $state.table.collectionId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get notes => $state.composableBuilder(
    column: $state.table.notes,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get previewText => $state.composableBuilder(
    column: $state.table.previewText,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get createdAt => $state.composableBuilder(
    column: $state.table.createdAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$SavedItemsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SavedItemsTableTable> {
  $$SavedItemsTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get featureType => $state.composableBuilder(
    column: $state.table.featureType,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get referenceId => $state.composableBuilder(
    column: $state.table.referenceId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get secondaryId => $state.composableBuilder(
    column: $state.table.secondaryId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get collectionId => $state.composableBuilder(
    column: $state.table.collectionId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get notes => $state.composableBuilder(
    column: $state.table.notes,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get previewText => $state.composableBuilder(
    column: $state.table.previewText,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
    column: $state.table.createdAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$SavedItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedItemsTableTable,
          SavedItem,
          $$SavedItemsTableTableFilterComposer,
          $$SavedItemsTableTableOrderingComposer,
          $$SavedItemsTableTableCreateCompanionBuilder,
          $$SavedItemsTableTableUpdateCompanionBuilder,
          (
            SavedItem,
            BaseReferences<_$AppDatabase, $SavedItemsTableTable, SavedItem>,
          ),
          SavedItem,
          PrefetchHooks Function()
        > {
  $$SavedItemsTableTableTableManager(
    _$AppDatabase db,
    $SavedItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$SavedItemsTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$SavedItemsTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> featureType = const Value.absent(),
                Value<int> referenceId = const Value.absent(),
                Value<int?> secondaryId = const Value.absent(),
                Value<String?> collectionId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> previewText = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => SavedItemsTableCompanion(
                id: id,
                featureType: featureType,
                referenceId: referenceId,
                secondaryId: secondaryId,
                collectionId: collectionId,
                notes: notes,
                previewText: previewText,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String featureType,
                required int referenceId,
                Value<int?> secondaryId = const Value.absent(),
                Value<String?> collectionId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String previewText,
                required String createdAt,
              }) => SavedItemsTableCompanion.insert(
                id: id,
                featureType: featureType,
                referenceId: referenceId,
                secondaryId: secondaryId,
                collectionId: collectionId,
                notes: notes,
                previewText: previewText,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedItemsTableTable,
      SavedItem,
      $$SavedItemsTableTableFilterComposer,
      $$SavedItemsTableTableOrderingComposer,
      $$SavedItemsTableTableCreateCompanionBuilder,
      $$SavedItemsTableTableUpdateCompanionBuilder,
      (
        SavedItem,
        BaseReferences<_$AppDatabase, $SavedItemsTableTable, SavedItem>,
      ),
      SavedItem,
      PrefetchHooks Function()
    >;
typedef $$CollectionsTableTableCreateCompanionBuilder =
    CollectionsTableCompanion Function({
      required String id,
      required String name,
      Value<String?> icon,
      Value<String?> colorHex,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$CollectionsTableTableUpdateCompanionBuilder =
    CollectionsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> icon,
      Value<String?> colorHex,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$CollectionsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CollectionsTableTable> {
  $$CollectionsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get name => $state.composableBuilder(
    column: $state.table.name,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get icon => $state.composableBuilder(
    column: $state.table.icon,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get colorHex => $state.composableBuilder(
    column: $state.table.colorHex,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get createdAt => $state.composableBuilder(
    column: $state.table.createdAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$CollectionsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CollectionsTableTable> {
  $$CollectionsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get name => $state.composableBuilder(
    column: $state.table.name,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get icon => $state.composableBuilder(
    column: $state.table.icon,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get colorHex => $state.composableBuilder(
    column: $state.table.colorHex,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
    column: $state.table.createdAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$CollectionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTableTable,
          LibraryCollection,
          $$CollectionsTableTableFilterComposer,
          $$CollectionsTableTableOrderingComposer,
          $$CollectionsTableTableCreateCompanionBuilder,
          $$CollectionsTableTableUpdateCompanionBuilder,
          (
            LibraryCollection,
            BaseReferences<
              _$AppDatabase,
              $CollectionsTableTable,
              LibraryCollection
            >,
          ),
          LibraryCollection,
          PrefetchHooks Function()
        > {
  $$CollectionsTableTableTableManager(
    _$AppDatabase db,
    $CollectionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$CollectionsTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$CollectionsTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollectionsTableCompanion(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CollectionsTableCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CollectionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTableTable,
      LibraryCollection,
      $$CollectionsTableTableFilterComposer,
      $$CollectionsTableTableOrderingComposer,
      $$CollectionsTableTableCreateCompanionBuilder,
      $$CollectionsTableTableUpdateCompanionBuilder,
      (
        LibraryCollection,
        BaseReferences<
          _$AppDatabase,
          $CollectionsTableTable,
          LibraryCollection
        >,
      ),
      LibraryCollection,
      PrefetchHooks Function()
    >;
typedef $$NotesTableTableCreateCompanionBuilder =
    NotesTableCompanion Function({
      Value<int> id,
      required String featureType,
      Value<int?> referenceId,
      Value<int?> secondaryId,
      required String content,
      required String createdAt,
      required String updatedAt,
    });
typedef $$NotesTableTableUpdateCompanionBuilder =
    NotesTableCompanion Function({
      Value<int> id,
      Value<String> featureType,
      Value<int?> referenceId,
      Value<int?> secondaryId,
      Value<String> content,
      Value<String> createdAt,
      Value<String> updatedAt,
    });

class $$NotesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get featureType => $state.composableBuilder(
    column: $state.table.featureType,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get referenceId => $state.composableBuilder(
    column: $state.table.referenceId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get secondaryId => $state.composableBuilder(
    column: $state.table.secondaryId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get content => $state.composableBuilder(
    column: $state.table.content,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get createdAt => $state.composableBuilder(
    column: $state.table.createdAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$NotesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get featureType => $state.composableBuilder(
    column: $state.table.featureType,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get referenceId => $state.composableBuilder(
    column: $state.table.referenceId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get secondaryId => $state.composableBuilder(
    column: $state.table.secondaryId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get content => $state.composableBuilder(
    column: $state.table.content,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
    column: $state.table.createdAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$NotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTableTable,
          UserNote,
          $$NotesTableTableFilterComposer,
          $$NotesTableTableOrderingComposer,
          $$NotesTableTableCreateCompanionBuilder,
          $$NotesTableTableUpdateCompanionBuilder,
          (UserNote, BaseReferences<_$AppDatabase, $NotesTableTable, UserNote>),
          UserNote,
          PrefetchHooks Function()
        > {
  $$NotesTableTableTableManager(_$AppDatabase db, $NotesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$NotesTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$NotesTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> featureType = const Value.absent(),
                Value<int?> referenceId = const Value.absent(),
                Value<int?> secondaryId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => NotesTableCompanion(
                id: id,
                featureType: featureType,
                referenceId: referenceId,
                secondaryId: secondaryId,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String featureType,
                Value<int?> referenceId = const Value.absent(),
                Value<int?> secondaryId = const Value.absent(),
                required String content,
                required String createdAt,
                required String updatedAt,
              }) => NotesTableCompanion.insert(
                id: id,
                featureType: featureType,
                referenceId: referenceId,
                secondaryId: secondaryId,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTableTable,
      UserNote,
      $$NotesTableTableFilterComposer,
      $$NotesTableTableOrderingComposer,
      $$NotesTableTableCreateCompanionBuilder,
      $$NotesTableTableUpdateCompanionBuilder,
      (UserNote, BaseReferences<_$AppDatabase, $NotesTableTable, UserNote>),
      UserNote,
      PrefetchHooks Function()
    >;
typedef $$SearchableItemsTableTableCreateCompanionBuilder =
    SearchableItemsTableCompanion Function({
      Value<int> id,
      required String featureType,
      required int referenceId,
      Value<int?> secondaryId,
      Value<String?> title,
      required String content,
      required String normalizedContent,
    });
typedef $$SearchableItemsTableTableUpdateCompanionBuilder =
    SearchableItemsTableCompanion Function({
      Value<int> id,
      Value<String> featureType,
      Value<int> referenceId,
      Value<int?> secondaryId,
      Value<String?> title,
      Value<String> content,
      Value<String> normalizedContent,
    });

class $$SearchableItemsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SearchableItemsTableTable> {
  $$SearchableItemsTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get featureType => $state.composableBuilder(
    column: $state.table.featureType,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get referenceId => $state.composableBuilder(
    column: $state.table.referenceId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get secondaryId => $state.composableBuilder(
    column: $state.table.secondaryId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get content => $state.composableBuilder(
    column: $state.table.content,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get normalizedContent => $state.composableBuilder(
    column: $state.table.normalizedContent,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$SearchableItemsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SearchableItemsTableTable> {
  $$SearchableItemsTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get featureType => $state.composableBuilder(
    column: $state.table.featureType,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get referenceId => $state.composableBuilder(
    column: $state.table.referenceId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get secondaryId => $state.composableBuilder(
    column: $state.table.secondaryId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get title => $state.composableBuilder(
    column: $state.table.title,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get content => $state.composableBuilder(
    column: $state.table.content,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get normalizedContent => $state.composableBuilder(
    column: $state.table.normalizedContent,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$SearchableItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchableItemsTableTable,
          SearchableItem,
          $$SearchableItemsTableTableFilterComposer,
          $$SearchableItemsTableTableOrderingComposer,
          $$SearchableItemsTableTableCreateCompanionBuilder,
          $$SearchableItemsTableTableUpdateCompanionBuilder,
          (
            SearchableItem,
            BaseReferences<
              _$AppDatabase,
              $SearchableItemsTableTable,
              SearchableItem
            >,
          ),
          SearchableItem,
          PrefetchHooks Function()
        > {
  $$SearchableItemsTableTableTableManager(
    _$AppDatabase db,
    $SearchableItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$SearchableItemsTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$SearchableItemsTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> featureType = const Value.absent(),
                Value<int> referenceId = const Value.absent(),
                Value<int?> secondaryId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> normalizedContent = const Value.absent(),
              }) => SearchableItemsTableCompanion(
                id: id,
                featureType: featureType,
                referenceId: referenceId,
                secondaryId: secondaryId,
                title: title,
                content: content,
                normalizedContent: normalizedContent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String featureType,
                required int referenceId,
                Value<int?> secondaryId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required String content,
                required String normalizedContent,
              }) => SearchableItemsTableCompanion.insert(
                id: id,
                featureType: featureType,
                referenceId: referenceId,
                secondaryId: secondaryId,
                title: title,
                content: content,
                normalizedContent: normalizedContent,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchableItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchableItemsTableTable,
      SearchableItem,
      $$SearchableItemsTableTableFilterComposer,
      $$SearchableItemsTableTableOrderingComposer,
      $$SearchableItemsTableTableCreateCompanionBuilder,
      $$SearchableItemsTableTableUpdateCompanionBuilder,
      (
        SearchableItem,
        BaseReferences<
          _$AppDatabase,
          $SearchableItemsTableTable,
          SearchableItem
        >,
      ),
      SearchableItem,
      PrefetchHooks Function()
    >;
typedef $$SearchHistoryTableTableCreateCompanionBuilder =
    SearchHistoryTableCompanion Function({
      Value<int> id,
      required String query,
      required DateTime timestamp,
    });
typedef $$SearchHistoryTableTableUpdateCompanionBuilder =
    SearchHistoryTableCompanion Function({
      Value<int> id,
      Value<String> query,
      Value<DateTime> timestamp,
    });

class $$SearchHistoryTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get query => $state.composableBuilder(
    column: $state.table.query,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
    column: $state.table.timestamp,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$SearchHistoryTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get query => $state.composableBuilder(
    column: $state.table.query,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
    column: $state.table.timestamp,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$SearchHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchHistoryTableTable,
          SearchHistoryTableData,
          $$SearchHistoryTableTableFilterComposer,
          $$SearchHistoryTableTableOrderingComposer,
          $$SearchHistoryTableTableCreateCompanionBuilder,
          $$SearchHistoryTableTableUpdateCompanionBuilder,
          (
            SearchHistoryTableData,
            BaseReferences<
              _$AppDatabase,
              $SearchHistoryTableTable,
              SearchHistoryTableData
            >,
          ),
          SearchHistoryTableData,
          PrefetchHooks Function()
        > {
  $$SearchHistoryTableTableTableManager(
    _$AppDatabase db,
    $SearchHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$SearchHistoryTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$SearchHistoryTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> query = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => SearchHistoryTableCompanion(
                id: id,
                query: query,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String query,
                required DateTime timestamp,
              }) => SearchHistoryTableCompanion.insert(
                id: id,
                query: query,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchHistoryTableTable,
      SearchHistoryTableData,
      $$SearchHistoryTableTableFilterComposer,
      $$SearchHistoryTableTableOrderingComposer,
      $$SearchHistoryTableTableCreateCompanionBuilder,
      $$SearchHistoryTableTableUpdateCompanionBuilder,
      (
        SearchHistoryTableData,
        BaseReferences<
          _$AppDatabase,
          $SearchHistoryTableTable,
          SearchHistoryTableData
        >,
      ),
      SearchHistoryTableData,
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
  $$UserFavoriteTableTableTableManager get userFavoriteTable =>
      $$UserFavoriteTableTableTableManager(_db, _db.userFavoriteTable);
  $$UserDailyActivityTableTableTableManager get userDailyActivityTable =>
      $$UserDailyActivityTableTableTableManager(
        _db,
        _db.userDailyActivityTable,
      );
  $$DailySunnahTableTableTableManager get dailySunnahTable =>
      $$DailySunnahTableTableTableManager(_db, _db.dailySunnahTable);
  $$DailyTaskTableTableTableManager get dailyTaskTable =>
      $$DailyTaskTableTableTableManager(_db, _db.dailyTaskTable);
  $$MuhasabaEntryTableTableTableManager get muhasabaEntryTable =>
      $$MuhasabaEntryTableTableTableManager(_db, _db.muhasabaEntryTable);
  $$ProgressRecordTableTableTableManager get progressRecordTable =>
      $$ProgressRecordTableTableTableManager(_db, _db.progressRecordTable);
  $$RecentActivityTableTableTableManager get recentActivityTable =>
      $$RecentActivityTableTableTableManager(_db, _db.recentActivityTable);
  $$UserGoalsTableTableTableManager get userGoalsTable =>
      $$UserGoalsTableTableTableManager(_db, _db.userGoalsTable);
  $$ReadingSessionTableTableTableManager get readingSessionTable =>
      $$ReadingSessionTableTableTableManager(_db, _db.readingSessionTable);
  $$SavedItemsTableTableTableManager get savedItemsTable =>
      $$SavedItemsTableTableTableManager(_db, _db.savedItemsTable);
  $$CollectionsTableTableTableManager get collectionsTable =>
      $$CollectionsTableTableTableManager(_db, _db.collectionsTable);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);
  $$SearchableItemsTableTableTableManager get searchableItemsTable =>
      $$SearchableItemsTableTableTableManager(_db, _db.searchableItemsTable);
  $$SearchHistoryTableTableTableManager get searchHistoryTable =>
      $$SearchHistoryTableTableTableManager(_db, _db.searchHistoryTable);
}
