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

class $MemoryThreadTableTable extends MemoryThreadTable
    with TableInfo<$MemoryThreadTableTable, MemoryThreadRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryThreadTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceCanonicalIdMeta = const VerificationMeta(
    'sourceCanonicalId',
  );
  @override
  late final GeneratedColumn<String> sourceCanonicalId =
      GeneratedColumn<String>(
        'source_canonical_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceLabelMeta = const VerificationMeta(
    'sourceLabel',
  );
  @override
  late final GeneratedColumn<String> sourceLabel = GeneratedColumn<String>(
    'source_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceBookMeta = const VerificationMeta(
    'sourceBook',
  );
  @override
  late final GeneratedColumn<String> sourceBook = GeneratedColumn<String>(
    'source_book',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceCitationMeta = const VerificationMeta(
    'sourceCitation',
  );
  @override
  late final GeneratedColumn<String> sourceCitation = GeneratedColumn<String>(
    'source_citation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceVersionMeta = const VerificationMeta(
    'sourceVersion',
  );
  @override
  late final GeneratedColumn<String> sourceVersion = GeneratedColumn<String>(
    'source_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceSecondaryReferenceMeta =
      const VerificationMeta('sourceSecondaryReference');
  @override
  late final GeneratedColumn<String> sourceSecondaryReference =
      GeneratedColumn<String>(
        'source_secondary_reference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _userContextKindMeta = const VerificationMeta(
    'userContextKind',
  );
  @override
  late final GeneratedColumn<String> userContextKind = GeneratedColumn<String>(
    'user_context_kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userContextLabelMeta = const VerificationMeta(
    'userContextLabel',
  );
  @override
  late final GeneratedColumn<String> userContextLabel = GeneratedColumn<String>(
    'user_context_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userLabelMeta = const VerificationMeta(
    'userLabel',
  );
  @override
  late final GeneratedColumn<String> userLabel = GeneratedColumn<String>(
    'user_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _resurfacingMeta = const VerificationMeta(
    'resurfacing',
  );
  @override
  late final GeneratedColumn<String> resurfacing = GeneratedColumn<String>(
    'resurfacing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('on'),
  );
  static const VerificationMeta _legacyKeyMeta = const VerificationMeta(
    'legacyKey',
  );
  @override
  late final GeneratedColumn<String> legacyKey = GeneratedColumn<String>(
    'legacy_key',
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
  static const VerificationMeta _lastReturnedAtMeta = const VerificationMeta(
    'lastReturnedAt',
  );
  @override
  late final GeneratedColumn<String> lastReturnedAt = GeneratedColumn<String>(
    'last_returned_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceKind,
    sourceCanonicalId,
    sourceLabel,
    sourceBook,
    sourceCitation,
    sourceVersion,
    sourceSecondaryReference,
    userContextKind,
    userContextLabel,
    userLabel,
    status,
    resurfacing,
    legacyKey,
    createdAt,
    updatedAt,
    lastReturnedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_thread_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryThreadRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    if (data.containsKey('source_canonical_id')) {
      context.handle(
        _sourceCanonicalIdMeta,
        sourceCanonicalId.isAcceptableOrUnknown(
          data['source_canonical_id']!,
          _sourceCanonicalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceCanonicalIdMeta);
    }
    if (data.containsKey('source_label')) {
      context.handle(
        _sourceLabelMeta,
        sourceLabel.isAcceptableOrUnknown(
          data['source_label']!,
          _sourceLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceLabelMeta);
    }
    if (data.containsKey('source_book')) {
      context.handle(
        _sourceBookMeta,
        sourceBook.isAcceptableOrUnknown(data['source_book']!, _sourceBookMeta),
      );
    }
    if (data.containsKey('source_citation')) {
      context.handle(
        _sourceCitationMeta,
        sourceCitation.isAcceptableOrUnknown(
          data['source_citation']!,
          _sourceCitationMeta,
        ),
      );
    }
    if (data.containsKey('source_version')) {
      context.handle(
        _sourceVersionMeta,
        sourceVersion.isAcceptableOrUnknown(
          data['source_version']!,
          _sourceVersionMeta,
        ),
      );
    }
    if (data.containsKey('source_secondary_reference')) {
      context.handle(
        _sourceSecondaryReferenceMeta,
        sourceSecondaryReference.isAcceptableOrUnknown(
          data['source_secondary_reference']!,
          _sourceSecondaryReferenceMeta,
        ),
      );
    }
    if (data.containsKey('user_context_kind')) {
      context.handle(
        _userContextKindMeta,
        userContextKind.isAcceptableOrUnknown(
          data['user_context_kind']!,
          _userContextKindMeta,
        ),
      );
    }
    if (data.containsKey('user_context_label')) {
      context.handle(
        _userContextLabelMeta,
        userContextLabel.isAcceptableOrUnknown(
          data['user_context_label']!,
          _userContextLabelMeta,
        ),
      );
    }
    if (data.containsKey('user_label')) {
      context.handle(
        _userLabelMeta,
        userLabel.isAcceptableOrUnknown(data['user_label']!, _userLabelMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('resurfacing')) {
      context.handle(
        _resurfacingMeta,
        resurfacing.isAcceptableOrUnknown(
          data['resurfacing']!,
          _resurfacingMeta,
        ),
      );
    }
    if (data.containsKey('legacy_key')) {
      context.handle(
        _legacyKeyMeta,
        legacyKey.isAcceptableOrUnknown(data['legacy_key']!, _legacyKeyMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_returned_at')) {
      context.handle(
        _lastReturnedAtMeta,
        lastReturnedAt.isAcceptableOrUnknown(
          data['last_returned_at']!,
          _lastReturnedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {legacyKey},
  ];
  @override
  MemoryThreadRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryThreadRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
      sourceCanonicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_canonical_id'],
      )!,
      sourceLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_label'],
      )!,
      sourceBook: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_book'],
      ),
      sourceCitation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_citation'],
      ),
      sourceVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_version'],
      ),
      sourceSecondaryReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_secondary_reference'],
      ),
      userContextKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_context_kind'],
      ),
      userContextLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_context_label'],
      ),
      userLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_label'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      resurfacing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resurfacing'],
      )!,
      legacyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legacy_key'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      lastReturnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_returned_at'],
      ),
    );
  }

  @override
  $MemoryThreadTableTable createAlias(String alias) {
    return $MemoryThreadTableTable(attachedDatabase, alias);
  }
}

class MemoryThreadRow extends DataClass implements Insertable<MemoryThreadRow> {
  final String id;
  final String sourceKind;
  final String sourceCanonicalId;
  final String sourceLabel;
  final String? sourceBook;
  final String? sourceCitation;
  final String? sourceVersion;
  final String? sourceSecondaryReference;
  final String? userContextKind;
  final String? userContextLabel;
  final String? userLabel;
  final String status;
  final String resurfacing;
  final String? legacyKey;
  final String createdAt;
  final String updatedAt;
  final String? lastReturnedAt;
  const MemoryThreadRow({
    required this.id,
    required this.sourceKind,
    required this.sourceCanonicalId,
    required this.sourceLabel,
    this.sourceBook,
    this.sourceCitation,
    this.sourceVersion,
    this.sourceSecondaryReference,
    this.userContextKind,
    this.userContextLabel,
    this.userLabel,
    required this.status,
    required this.resurfacing,
    this.legacyKey,
    required this.createdAt,
    required this.updatedAt,
    this.lastReturnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_kind'] = Variable<String>(sourceKind);
    map['source_canonical_id'] = Variable<String>(sourceCanonicalId);
    map['source_label'] = Variable<String>(sourceLabel);
    if (!nullToAbsent || sourceBook != null) {
      map['source_book'] = Variable<String>(sourceBook);
    }
    if (!nullToAbsent || sourceCitation != null) {
      map['source_citation'] = Variable<String>(sourceCitation);
    }
    if (!nullToAbsent || sourceVersion != null) {
      map['source_version'] = Variable<String>(sourceVersion);
    }
    if (!nullToAbsent || sourceSecondaryReference != null) {
      map['source_secondary_reference'] = Variable<String>(
        sourceSecondaryReference,
      );
    }
    if (!nullToAbsent || userContextKind != null) {
      map['user_context_kind'] = Variable<String>(userContextKind);
    }
    if (!nullToAbsent || userContextLabel != null) {
      map['user_context_label'] = Variable<String>(userContextLabel);
    }
    if (!nullToAbsent || userLabel != null) {
      map['user_label'] = Variable<String>(userLabel);
    }
    map['status'] = Variable<String>(status);
    map['resurfacing'] = Variable<String>(resurfacing);
    if (!nullToAbsent || legacyKey != null) {
      map['legacy_key'] = Variable<String>(legacyKey);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || lastReturnedAt != null) {
      map['last_returned_at'] = Variable<String>(lastReturnedAt);
    }
    return map;
  }

  MemoryThreadTableCompanion toCompanion(bool nullToAbsent) {
    return MemoryThreadTableCompanion(
      id: Value(id),
      sourceKind: Value(sourceKind),
      sourceCanonicalId: Value(sourceCanonicalId),
      sourceLabel: Value(sourceLabel),
      sourceBook: sourceBook == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceBook),
      sourceCitation: sourceCitation == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceCitation),
      sourceVersion: sourceVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceVersion),
      sourceSecondaryReference: sourceSecondaryReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceSecondaryReference),
      userContextKind: userContextKind == null && nullToAbsent
          ? const Value.absent()
          : Value(userContextKind),
      userContextLabel: userContextLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(userContextLabel),
      userLabel: userLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(userLabel),
      status: Value(status),
      resurfacing: Value(resurfacing),
      legacyKey: legacyKey == null && nullToAbsent
          ? const Value.absent()
          : Value(legacyKey),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastReturnedAt: lastReturnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReturnedAt),
    );
  }

  factory MemoryThreadRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryThreadRow(
      id: serializer.fromJson<String>(json['id']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
      sourceCanonicalId: serializer.fromJson<String>(json['sourceCanonicalId']),
      sourceLabel: serializer.fromJson<String>(json['sourceLabel']),
      sourceBook: serializer.fromJson<String?>(json['sourceBook']),
      sourceCitation: serializer.fromJson<String?>(json['sourceCitation']),
      sourceVersion: serializer.fromJson<String?>(json['sourceVersion']),
      sourceSecondaryReference: serializer.fromJson<String?>(
        json['sourceSecondaryReference'],
      ),
      userContextKind: serializer.fromJson<String?>(json['userContextKind']),
      userContextLabel: serializer.fromJson<String?>(json['userContextLabel']),
      userLabel: serializer.fromJson<String?>(json['userLabel']),
      status: serializer.fromJson<String>(json['status']),
      resurfacing: serializer.fromJson<String>(json['resurfacing']),
      legacyKey: serializer.fromJson<String?>(json['legacyKey']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      lastReturnedAt: serializer.fromJson<String?>(json['lastReturnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceKind': serializer.toJson<String>(sourceKind),
      'sourceCanonicalId': serializer.toJson<String>(sourceCanonicalId),
      'sourceLabel': serializer.toJson<String>(sourceLabel),
      'sourceBook': serializer.toJson<String?>(sourceBook),
      'sourceCitation': serializer.toJson<String?>(sourceCitation),
      'sourceVersion': serializer.toJson<String?>(sourceVersion),
      'sourceSecondaryReference': serializer.toJson<String?>(
        sourceSecondaryReference,
      ),
      'userContextKind': serializer.toJson<String?>(userContextKind),
      'userContextLabel': serializer.toJson<String?>(userContextLabel),
      'userLabel': serializer.toJson<String?>(userLabel),
      'status': serializer.toJson<String>(status),
      'resurfacing': serializer.toJson<String>(resurfacing),
      'legacyKey': serializer.toJson<String?>(legacyKey),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'lastReturnedAt': serializer.toJson<String?>(lastReturnedAt),
    };
  }

  MemoryThreadRow copyWith({
    String? id,
    String? sourceKind,
    String? sourceCanonicalId,
    String? sourceLabel,
    Value<String?> sourceBook = const Value.absent(),
    Value<String?> sourceCitation = const Value.absent(),
    Value<String?> sourceVersion = const Value.absent(),
    Value<String?> sourceSecondaryReference = const Value.absent(),
    Value<String?> userContextKind = const Value.absent(),
    Value<String?> userContextLabel = const Value.absent(),
    Value<String?> userLabel = const Value.absent(),
    String? status,
    String? resurfacing,
    Value<String?> legacyKey = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    Value<String?> lastReturnedAt = const Value.absent(),
  }) => MemoryThreadRow(
    id: id ?? this.id,
    sourceKind: sourceKind ?? this.sourceKind,
    sourceCanonicalId: sourceCanonicalId ?? this.sourceCanonicalId,
    sourceLabel: sourceLabel ?? this.sourceLabel,
    sourceBook: sourceBook.present ? sourceBook.value : this.sourceBook,
    sourceCitation: sourceCitation.present
        ? sourceCitation.value
        : this.sourceCitation,
    sourceVersion: sourceVersion.present
        ? sourceVersion.value
        : this.sourceVersion,
    sourceSecondaryReference: sourceSecondaryReference.present
        ? sourceSecondaryReference.value
        : this.sourceSecondaryReference,
    userContextKind: userContextKind.present
        ? userContextKind.value
        : this.userContextKind,
    userContextLabel: userContextLabel.present
        ? userContextLabel.value
        : this.userContextLabel,
    userLabel: userLabel.present ? userLabel.value : this.userLabel,
    status: status ?? this.status,
    resurfacing: resurfacing ?? this.resurfacing,
    legacyKey: legacyKey.present ? legacyKey.value : this.legacyKey,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastReturnedAt: lastReturnedAt.present
        ? lastReturnedAt.value
        : this.lastReturnedAt,
  );
  MemoryThreadRow copyWithCompanion(MemoryThreadTableCompanion data) {
    return MemoryThreadRow(
      id: data.id.present ? data.id.value : this.id,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      sourceCanonicalId: data.sourceCanonicalId.present
          ? data.sourceCanonicalId.value
          : this.sourceCanonicalId,
      sourceLabel: data.sourceLabel.present
          ? data.sourceLabel.value
          : this.sourceLabel,
      sourceBook: data.sourceBook.present
          ? data.sourceBook.value
          : this.sourceBook,
      sourceCitation: data.sourceCitation.present
          ? data.sourceCitation.value
          : this.sourceCitation,
      sourceVersion: data.sourceVersion.present
          ? data.sourceVersion.value
          : this.sourceVersion,
      sourceSecondaryReference: data.sourceSecondaryReference.present
          ? data.sourceSecondaryReference.value
          : this.sourceSecondaryReference,
      userContextKind: data.userContextKind.present
          ? data.userContextKind.value
          : this.userContextKind,
      userContextLabel: data.userContextLabel.present
          ? data.userContextLabel.value
          : this.userContextLabel,
      userLabel: data.userLabel.present ? data.userLabel.value : this.userLabel,
      status: data.status.present ? data.status.value : this.status,
      resurfacing: data.resurfacing.present
          ? data.resurfacing.value
          : this.resurfacing,
      legacyKey: data.legacyKey.present ? data.legacyKey.value : this.legacyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastReturnedAt: data.lastReturnedAt.present
          ? data.lastReturnedAt.value
          : this.lastReturnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryThreadRow(')
          ..write('id: $id, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceCanonicalId: $sourceCanonicalId, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('sourceBook: $sourceBook, ')
          ..write('sourceCitation: $sourceCitation, ')
          ..write('sourceVersion: $sourceVersion, ')
          ..write('sourceSecondaryReference: $sourceSecondaryReference, ')
          ..write('userContextKind: $userContextKind, ')
          ..write('userContextLabel: $userContextLabel, ')
          ..write('userLabel: $userLabel, ')
          ..write('status: $status, ')
          ..write('resurfacing: $resurfacing, ')
          ..write('legacyKey: $legacyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReturnedAt: $lastReturnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceKind,
    sourceCanonicalId,
    sourceLabel,
    sourceBook,
    sourceCitation,
    sourceVersion,
    sourceSecondaryReference,
    userContextKind,
    userContextLabel,
    userLabel,
    status,
    resurfacing,
    legacyKey,
    createdAt,
    updatedAt,
    lastReturnedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryThreadRow &&
          other.id == this.id &&
          other.sourceKind == this.sourceKind &&
          other.sourceCanonicalId == this.sourceCanonicalId &&
          other.sourceLabel == this.sourceLabel &&
          other.sourceBook == this.sourceBook &&
          other.sourceCitation == this.sourceCitation &&
          other.sourceVersion == this.sourceVersion &&
          other.sourceSecondaryReference == this.sourceSecondaryReference &&
          other.userContextKind == this.userContextKind &&
          other.userContextLabel == this.userContextLabel &&
          other.userLabel == this.userLabel &&
          other.status == this.status &&
          other.resurfacing == this.resurfacing &&
          other.legacyKey == this.legacyKey &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastReturnedAt == this.lastReturnedAt);
}

class MemoryThreadTableCompanion extends UpdateCompanion<MemoryThreadRow> {
  final Value<String> id;
  final Value<String> sourceKind;
  final Value<String> sourceCanonicalId;
  final Value<String> sourceLabel;
  final Value<String?> sourceBook;
  final Value<String?> sourceCitation;
  final Value<String?> sourceVersion;
  final Value<String?> sourceSecondaryReference;
  final Value<String?> userContextKind;
  final Value<String?> userContextLabel;
  final Value<String?> userLabel;
  final Value<String> status;
  final Value<String> resurfacing;
  final Value<String?> legacyKey;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> lastReturnedAt;
  final Value<int> rowid;
  const MemoryThreadTableCompanion({
    this.id = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.sourceCanonicalId = const Value.absent(),
    this.sourceLabel = const Value.absent(),
    this.sourceBook = const Value.absent(),
    this.sourceCitation = const Value.absent(),
    this.sourceVersion = const Value.absent(),
    this.sourceSecondaryReference = const Value.absent(),
    this.userContextKind = const Value.absent(),
    this.userContextLabel = const Value.absent(),
    this.userLabel = const Value.absent(),
    this.status = const Value.absent(),
    this.resurfacing = const Value.absent(),
    this.legacyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReturnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryThreadTableCompanion.insert({
    required String id,
    required String sourceKind,
    required String sourceCanonicalId,
    required String sourceLabel,
    this.sourceBook = const Value.absent(),
    this.sourceCitation = const Value.absent(),
    this.sourceVersion = const Value.absent(),
    this.sourceSecondaryReference = const Value.absent(),
    this.userContextKind = const Value.absent(),
    this.userContextLabel = const Value.absent(),
    this.userLabel = const Value.absent(),
    this.status = const Value.absent(),
    this.resurfacing = const Value.absent(),
    this.legacyKey = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.lastReturnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceKind = Value(sourceKind),
       sourceCanonicalId = Value(sourceCanonicalId),
       sourceLabel = Value(sourceLabel),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MemoryThreadRow> custom({
    Expression<String>? id,
    Expression<String>? sourceKind,
    Expression<String>? sourceCanonicalId,
    Expression<String>? sourceLabel,
    Expression<String>? sourceBook,
    Expression<String>? sourceCitation,
    Expression<String>? sourceVersion,
    Expression<String>? sourceSecondaryReference,
    Expression<String>? userContextKind,
    Expression<String>? userContextLabel,
    Expression<String>? userLabel,
    Expression<String>? status,
    Expression<String>? resurfacing,
    Expression<String>? legacyKey,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? lastReturnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (sourceCanonicalId != null) 'source_canonical_id': sourceCanonicalId,
      if (sourceLabel != null) 'source_label': sourceLabel,
      if (sourceBook != null) 'source_book': sourceBook,
      if (sourceCitation != null) 'source_citation': sourceCitation,
      if (sourceVersion != null) 'source_version': sourceVersion,
      if (sourceSecondaryReference != null)
        'source_secondary_reference': sourceSecondaryReference,
      if (userContextKind != null) 'user_context_kind': userContextKind,
      if (userContextLabel != null) 'user_context_label': userContextLabel,
      if (userLabel != null) 'user_label': userLabel,
      if (status != null) 'status': status,
      if (resurfacing != null) 'resurfacing': resurfacing,
      if (legacyKey != null) 'legacy_key': legacyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastReturnedAt != null) 'last_returned_at': lastReturnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryThreadTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceKind,
    Value<String>? sourceCanonicalId,
    Value<String>? sourceLabel,
    Value<String?>? sourceBook,
    Value<String?>? sourceCitation,
    Value<String?>? sourceVersion,
    Value<String?>? sourceSecondaryReference,
    Value<String?>? userContextKind,
    Value<String?>? userContextLabel,
    Value<String?>? userLabel,
    Value<String>? status,
    Value<String>? resurfacing,
    Value<String?>? legacyKey,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? lastReturnedAt,
    Value<int>? rowid,
  }) {
    return MemoryThreadTableCompanion(
      id: id ?? this.id,
      sourceKind: sourceKind ?? this.sourceKind,
      sourceCanonicalId: sourceCanonicalId ?? this.sourceCanonicalId,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      sourceBook: sourceBook ?? this.sourceBook,
      sourceCitation: sourceCitation ?? this.sourceCitation,
      sourceVersion: sourceVersion ?? this.sourceVersion,
      sourceSecondaryReference:
          sourceSecondaryReference ?? this.sourceSecondaryReference,
      userContextKind: userContextKind ?? this.userContextKind,
      userContextLabel: userContextLabel ?? this.userContextLabel,
      userLabel: userLabel ?? this.userLabel,
      status: status ?? this.status,
      resurfacing: resurfacing ?? this.resurfacing,
      legacyKey: legacyKey ?? this.legacyKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReturnedAt: lastReturnedAt ?? this.lastReturnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    if (sourceCanonicalId.present) {
      map['source_canonical_id'] = Variable<String>(sourceCanonicalId.value);
    }
    if (sourceLabel.present) {
      map['source_label'] = Variable<String>(sourceLabel.value);
    }
    if (sourceBook.present) {
      map['source_book'] = Variable<String>(sourceBook.value);
    }
    if (sourceCitation.present) {
      map['source_citation'] = Variable<String>(sourceCitation.value);
    }
    if (sourceVersion.present) {
      map['source_version'] = Variable<String>(sourceVersion.value);
    }
    if (sourceSecondaryReference.present) {
      map['source_secondary_reference'] = Variable<String>(
        sourceSecondaryReference.value,
      );
    }
    if (userContextKind.present) {
      map['user_context_kind'] = Variable<String>(userContextKind.value);
    }
    if (userContextLabel.present) {
      map['user_context_label'] = Variable<String>(userContextLabel.value);
    }
    if (userLabel.present) {
      map['user_label'] = Variable<String>(userLabel.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (resurfacing.present) {
      map['resurfacing'] = Variable<String>(resurfacing.value);
    }
    if (legacyKey.present) {
      map['legacy_key'] = Variable<String>(legacyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (lastReturnedAt.present) {
      map['last_returned_at'] = Variable<String>(lastReturnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryThreadTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceCanonicalId: $sourceCanonicalId, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('sourceBook: $sourceBook, ')
          ..write('sourceCitation: $sourceCitation, ')
          ..write('sourceVersion: $sourceVersion, ')
          ..write('sourceSecondaryReference: $sourceSecondaryReference, ')
          ..write('userContextKind: $userContextKind, ')
          ..write('userContextLabel: $userContextLabel, ')
          ..write('userLabel: $userLabel, ')
          ..write('status: $status, ')
          ..write('resurfacing: $resurfacing, ')
          ..write('legacyKey: $legacyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReturnedAt: $lastReturnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReflectionEntryTableTable extends ReflectionEntryTable
    with TableInfo<$ReflectionEntryTableTable, ReflectionEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReflectionEntryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    threadId,
    body,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reflection_entry_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReflectionEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {threadId, createdAt},
  ];
  @override
  ReflectionEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReflectionEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ReflectionEntryTableTable createAlias(String alias) {
    return $ReflectionEntryTableTable(attachedDatabase, alias);
  }
}

class ReflectionEntryRow extends DataClass
    implements Insertable<ReflectionEntryRow> {
  final String id;
  final String threadId;
  final String body;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const ReflectionEntryRow({
    required this.id,
    required this.threadId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<String>(threadId);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  ReflectionEntryTableCompanion toCompanion(bool nullToAbsent) {
    return ReflectionEntryTableCompanion(
      id: Value(id),
      threadId: Value(threadId),
      body: Value(body),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ReflectionEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReflectionEntryRow(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String>(json['threadId']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String>(threadId),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  ReflectionEntryRow copyWith({
    String? id,
    String? threadId,
    String? body,
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
  }) => ReflectionEntryRow(
    id: id ?? this.id,
    threadId: threadId ?? this.threadId,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ReflectionEntryRow copyWithCompanion(ReflectionEntryTableCompanion data) {
    return ReflectionEntryRow(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionEntryRow(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, threadId, body, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReflectionEntryRow &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ReflectionEntryTableCompanion
    extends UpdateCompanion<ReflectionEntryRow> {
  final Value<String> id;
  final Value<String> threadId;
  final Value<String> body;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const ReflectionEntryTableCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReflectionEntryTableCompanion.insert({
    required String id,
    required String threadId,
    required String body,
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       threadId = Value(threadId),
       body = Value(body),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReflectionEntryRow> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? body,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReflectionEntryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? threadId,
    Value<String>? body,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ReflectionEntryTableCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionEntryTableCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingAnchorTableTable extends ReadingAnchorTable
    with TableInfo<$ReadingAnchorTableTable, ReadingAnchorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingAnchorTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceCanonicalIdMeta = const VerificationMeta(
    'sourceCanonicalId',
  );
  @override
  late final GeneratedColumn<String> sourceCanonicalId =
      GeneratedColumn<String>(
        'source_canonical_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
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
  static const VerificationMeta _itemIndexMeta = const VerificationMeta(
    'itemIndex',
  );
  @override
  late final GeneratedColumn<int> itemIndex = GeneratedColumn<int>(
    'item_index',
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
    threadId,
    sourceCanonicalId,
    surahNumber,
    ayahNumber,
    pageNumber,
    itemIndex,
    scrollOffset,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_anchor_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingAnchorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    }
    if (data.containsKey('source_canonical_id')) {
      context.handle(
        _sourceCanonicalIdMeta,
        sourceCanonicalId.isAcceptableOrUnknown(
          data['source_canonical_id']!,
          _sourceCanonicalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceCanonicalIdMeta);
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    }
    if (data.containsKey('item_index')) {
      context.handle(
        _itemIndexMeta,
        itemIndex.isAcceptableOrUnknown(data['item_index']!, _itemIndexMeta),
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {threadId},
  ];
  @override
  ReadingAnchorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingAnchorRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      ),
      sourceCanonicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_canonical_id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      ),
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      ),
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      ),
      itemIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_index'],
      ),
      scrollOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_offset'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingAnchorTableTable createAlias(String alias) {
    return $ReadingAnchorTableTable(attachedDatabase, alias);
  }
}

class ReadingAnchorRow extends DataClass
    implements Insertable<ReadingAnchorRow> {
  final String id;
  final String? threadId;
  final String sourceCanonicalId;
  final int? surahNumber;
  final int? ayahNumber;
  final int? pageNumber;
  final int? itemIndex;
  final double? scrollOffset;
  final String updatedAt;
  const ReadingAnchorRow({
    required this.id,
    this.threadId,
    required this.sourceCanonicalId,
    this.surahNumber,
    this.ayahNumber,
    this.pageNumber,
    this.itemIndex,
    this.scrollOffset,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || threadId != null) {
      map['thread_id'] = Variable<String>(threadId);
    }
    map['source_canonical_id'] = Variable<String>(sourceCanonicalId);
    if (!nullToAbsent || surahNumber != null) {
      map['surah_number'] = Variable<int>(surahNumber);
    }
    if (!nullToAbsent || ayahNumber != null) {
      map['ayah_number'] = Variable<int>(ayahNumber);
    }
    if (!nullToAbsent || pageNumber != null) {
      map['page_number'] = Variable<int>(pageNumber);
    }
    if (!nullToAbsent || itemIndex != null) {
      map['item_index'] = Variable<int>(itemIndex);
    }
    if (!nullToAbsent || scrollOffset != null) {
      map['scroll_offset'] = Variable<double>(scrollOffset);
    }
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ReadingAnchorTableCompanion toCompanion(bool nullToAbsent) {
    return ReadingAnchorTableCompanion(
      id: Value(id),
      threadId: threadId == null && nullToAbsent
          ? const Value.absent()
          : Value(threadId),
      sourceCanonicalId: Value(sourceCanonicalId),
      surahNumber: surahNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(surahNumber),
      ayahNumber: ayahNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(ayahNumber),
      pageNumber: pageNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNumber),
      itemIndex: itemIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(itemIndex),
      scrollOffset: scrollOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(scrollOffset),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingAnchorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingAnchorRow(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String?>(json['threadId']),
      sourceCanonicalId: serializer.fromJson<String>(json['sourceCanonicalId']),
      surahNumber: serializer.fromJson<int?>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int?>(json['ayahNumber']),
      pageNumber: serializer.fromJson<int?>(json['pageNumber']),
      itemIndex: serializer.fromJson<int?>(json['itemIndex']),
      scrollOffset: serializer.fromJson<double?>(json['scrollOffset']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String?>(threadId),
      'sourceCanonicalId': serializer.toJson<String>(sourceCanonicalId),
      'surahNumber': serializer.toJson<int?>(surahNumber),
      'ayahNumber': serializer.toJson<int?>(ayahNumber),
      'pageNumber': serializer.toJson<int?>(pageNumber),
      'itemIndex': serializer.toJson<int?>(itemIndex),
      'scrollOffset': serializer.toJson<double?>(scrollOffset),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ReadingAnchorRow copyWith({
    String? id,
    Value<String?> threadId = const Value.absent(),
    String? sourceCanonicalId,
    Value<int?> surahNumber = const Value.absent(),
    Value<int?> ayahNumber = const Value.absent(),
    Value<int?> pageNumber = const Value.absent(),
    Value<int?> itemIndex = const Value.absent(),
    Value<double?> scrollOffset = const Value.absent(),
    String? updatedAt,
  }) => ReadingAnchorRow(
    id: id ?? this.id,
    threadId: threadId.present ? threadId.value : this.threadId,
    sourceCanonicalId: sourceCanonicalId ?? this.sourceCanonicalId,
    surahNumber: surahNumber.present ? surahNumber.value : this.surahNumber,
    ayahNumber: ayahNumber.present ? ayahNumber.value : this.ayahNumber,
    pageNumber: pageNumber.present ? pageNumber.value : this.pageNumber,
    itemIndex: itemIndex.present ? itemIndex.value : this.itemIndex,
    scrollOffset: scrollOffset.present ? scrollOffset.value : this.scrollOffset,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingAnchorRow copyWithCompanion(ReadingAnchorTableCompanion data) {
    return ReadingAnchorRow(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      sourceCanonicalId: data.sourceCanonicalId.present
          ? data.sourceCanonicalId.value
          : this.sourceCanonicalId,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      itemIndex: data.itemIndex.present ? data.itemIndex.value : this.itemIndex,
      scrollOffset: data.scrollOffset.present
          ? data.scrollOffset.value
          : this.scrollOffset,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingAnchorRow(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('sourceCanonicalId: $sourceCanonicalId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('itemIndex: $itemIndex, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    threadId,
    sourceCanonicalId,
    surahNumber,
    ayahNumber,
    pageNumber,
    itemIndex,
    scrollOffset,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingAnchorRow &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.sourceCanonicalId == this.sourceCanonicalId &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.pageNumber == this.pageNumber &&
          other.itemIndex == this.itemIndex &&
          other.scrollOffset == this.scrollOffset &&
          other.updatedAt == this.updatedAt);
}

class ReadingAnchorTableCompanion extends UpdateCompanion<ReadingAnchorRow> {
  final Value<String> id;
  final Value<String?> threadId;
  final Value<String> sourceCanonicalId;
  final Value<int?> surahNumber;
  final Value<int?> ayahNumber;
  final Value<int?> pageNumber;
  final Value<int?> itemIndex;
  final Value<double?> scrollOffset;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const ReadingAnchorTableCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.sourceCanonicalId = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.itemIndex = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingAnchorTableCompanion.insert({
    required String id,
    this.threadId = const Value.absent(),
    required String sourceCanonicalId,
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.itemIndex = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceCanonicalId = Value(sourceCanonicalId),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingAnchorRow> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? sourceCanonicalId,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<int>? pageNumber,
    Expression<int>? itemIndex,
    Expression<double>? scrollOffset,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (sourceCanonicalId != null) 'source_canonical_id': sourceCanonicalId,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (pageNumber != null) 'page_number': pageNumber,
      if (itemIndex != null) 'item_index': itemIndex,
      if (scrollOffset != null) 'scroll_offset': scrollOffset,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingAnchorTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? threadId,
    Value<String>? sourceCanonicalId,
    Value<int?>? surahNumber,
    Value<int?>? ayahNumber,
    Value<int?>? pageNumber,
    Value<int?>? itemIndex,
    Value<double?>? scrollOffset,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReadingAnchorTableCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      sourceCanonicalId: sourceCanonicalId ?? this.sourceCanonicalId,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      itemIndex: itemIndex ?? this.itemIndex,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (sourceCanonicalId.present) {
      map['source_canonical_id'] = Variable<String>(sourceCanonicalId.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (itemIndex.present) {
      map['item_index'] = Variable<int>(itemIndex.value);
    }
    if (scrollOffset.present) {
      map['scroll_offset'] = Variable<double>(scrollOffset.value);
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
    return (StringBuffer('ReadingAnchorTableCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('sourceCanonicalId: $sourceCanonicalId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('itemIndex: $itemIndex, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnEventTableTable extends ReturnEventTable
    with TableInfo<$ReturnEventTableTable, ReturnEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnEventTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<String> occurredAt = GeneratedColumn<String>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reflectionIdMeta = const VerificationMeta(
    'reflectionId',
  );
  @override
  late final GeneratedColumn<String> reflectionId = GeneratedColumn<String>(
    'reflection_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    threadId,
    kind,
    occurredAt,
    durationSeconds,
    reflectionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_event_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReturnEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('reflection_id')) {
      context.handle(
        _reflectionIdMeta,
        reflectionId.isAcceptableOrUnknown(
          data['reflection_id']!,
          _reflectionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurred_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      reflectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection_id'],
      ),
    );
  }

  @override
  $ReturnEventTableTable createAlias(String alias) {
    return $ReturnEventTableTable(attachedDatabase, alias);
  }
}

class ReturnEventRow extends DataClass implements Insertable<ReturnEventRow> {
  final String id;
  final String threadId;
  final String kind;
  final String occurredAt;
  final int? durationSeconds;
  final String? reflectionId;
  const ReturnEventRow({
    required this.id,
    required this.threadId,
    required this.kind,
    required this.occurredAt,
    this.durationSeconds,
    this.reflectionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<String>(threadId);
    map['kind'] = Variable<String>(kind);
    map['occurred_at'] = Variable<String>(occurredAt);
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || reflectionId != null) {
      map['reflection_id'] = Variable<String>(reflectionId);
    }
    return map;
  }

  ReturnEventTableCompanion toCompanion(bool nullToAbsent) {
    return ReturnEventTableCompanion(
      id: Value(id),
      threadId: Value(threadId),
      kind: Value(kind),
      occurredAt: Value(occurredAt),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      reflectionId: reflectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(reflectionId),
    );
  }

  factory ReturnEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnEventRow(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String>(json['threadId']),
      kind: serializer.fromJson<String>(json['kind']),
      occurredAt: serializer.fromJson<String>(json['occurredAt']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      reflectionId: serializer.fromJson<String?>(json['reflectionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String>(threadId),
      'kind': serializer.toJson<String>(kind),
      'occurredAt': serializer.toJson<String>(occurredAt),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'reflectionId': serializer.toJson<String?>(reflectionId),
    };
  }

  ReturnEventRow copyWith({
    String? id,
    String? threadId,
    String? kind,
    String? occurredAt,
    Value<int?> durationSeconds = const Value.absent(),
    Value<String?> reflectionId = const Value.absent(),
  }) => ReturnEventRow(
    id: id ?? this.id,
    threadId: threadId ?? this.threadId,
    kind: kind ?? this.kind,
    occurredAt: occurredAt ?? this.occurredAt,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    reflectionId: reflectionId.present ? reflectionId.value : this.reflectionId,
  );
  ReturnEventRow copyWithCompanion(ReturnEventTableCompanion data) {
    return ReturnEventRow(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      kind: data.kind.present ? data.kind.value : this.kind,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      reflectionId: data.reflectionId.present
          ? data.reflectionId.value
          : this.reflectionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnEventRow(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('kind: $kind, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('reflectionId: $reflectionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    threadId,
    kind,
    occurredAt,
    durationSeconds,
    reflectionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnEventRow &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.kind == this.kind &&
          other.occurredAt == this.occurredAt &&
          other.durationSeconds == this.durationSeconds &&
          other.reflectionId == this.reflectionId);
}

class ReturnEventTableCompanion extends UpdateCompanion<ReturnEventRow> {
  final Value<String> id;
  final Value<String> threadId;
  final Value<String> kind;
  final Value<String> occurredAt;
  final Value<int?> durationSeconds;
  final Value<String?> reflectionId;
  final Value<int> rowid;
  const ReturnEventTableCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.kind = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.reflectionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnEventTableCompanion.insert({
    required String id,
    required String threadId,
    required String kind,
    required String occurredAt,
    this.durationSeconds = const Value.absent(),
    this.reflectionId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       threadId = Value(threadId),
       kind = Value(kind),
       occurredAt = Value(occurredAt);
  static Insertable<ReturnEventRow> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? kind,
    Expression<String>? occurredAt,
    Expression<int>? durationSeconds,
    Expression<String>? reflectionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (kind != null) 'kind': kind,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (reflectionId != null) 'reflection_id': reflectionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnEventTableCompanion copyWith({
    Value<String>? id,
    Value<String>? threadId,
    Value<String>? kind,
    Value<String>? occurredAt,
    Value<int?>? durationSeconds,
    Value<String?>? reflectionId,
    Value<int>? rowid,
  }) {
    return ReturnEventTableCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      kind: kind ?? this.kind,
      occurredAt: occurredAt ?? this.occurredAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      reflectionId: reflectionId ?? this.reflectionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<String>(occurredAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (reflectionId.present) {
      map['reflection_id'] = Variable<String>(reflectionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnEventTableCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('kind: $kind, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('reflectionId: $reflectionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderIntentTableTable extends ReminderIntentTable
    with TableInfo<$ReminderIntentTableTable, ReminderIntentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderIntentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<String> scheduledAt = GeneratedColumn<String>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, threadId, scheduledAt, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_intent_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderIntentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {threadId},
  ];
  @override
  ReminderIntentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderIntentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_at'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $ReminderIntentTableTable createAlias(String alias) {
    return $ReminderIntentTableTable(attachedDatabase, alias);
  }
}

class ReminderIntentRow extends DataClass
    implements Insertable<ReminderIntentRow> {
  final String id;
  final String threadId;
  final String scheduledAt;
  final bool enabled;
  const ReminderIntentRow({
    required this.id,
    required this.threadId,
    required this.scheduledAt,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<String>(threadId);
    map['scheduled_at'] = Variable<String>(scheduledAt);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  ReminderIntentTableCompanion toCompanion(bool nullToAbsent) {
    return ReminderIntentTableCompanion(
      id: Value(id),
      threadId: Value(threadId),
      scheduledAt: Value(scheduledAt),
      enabled: Value(enabled),
    );
  }

  factory ReminderIntentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderIntentRow(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String>(json['threadId']),
      scheduledAt: serializer.fromJson<String>(json['scheduledAt']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String>(threadId),
      'scheduledAt': serializer.toJson<String>(scheduledAt),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  ReminderIntentRow copyWith({
    String? id,
    String? threadId,
    String? scheduledAt,
    bool? enabled,
  }) => ReminderIntentRow(
    id: id ?? this.id,
    threadId: threadId ?? this.threadId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    enabled: enabled ?? this.enabled,
  );
  ReminderIntentRow copyWithCompanion(ReminderIntentTableCompanion data) {
    return ReminderIntentRow(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderIntentRow(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, threadId, scheduledAt, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderIntentRow &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.scheduledAt == this.scheduledAt &&
          other.enabled == this.enabled);
}

class ReminderIntentTableCompanion extends UpdateCompanion<ReminderIntentRow> {
  final Value<String> id;
  final Value<String> threadId;
  final Value<String> scheduledAt;
  final Value<bool> enabled;
  final Value<int> rowid;
  const ReminderIntentTableCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderIntentTableCompanion.insert({
    required String id,
    required String threadId,
    required String scheduledAt,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       threadId = Value(threadId),
       scheduledAt = Value(scheduledAt);
  static Insertable<ReminderIntentRow> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? scheduledAt,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderIntentTableCompanion copyWith({
    Value<String>? id,
    Value<String>? threadId,
    Value<String>? scheduledAt,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return ReminderIntentTableCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<String>(scheduledAt.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderIntentTableCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('enabled: $enabled, ')
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
  late final $MemoryThreadTableTable memoryThreadTable =
      $MemoryThreadTableTable(this);
  late final $ReflectionEntryTableTable reflectionEntryTable =
      $ReflectionEntryTableTable(this);
  late final $ReadingAnchorTableTable readingAnchorTable =
      $ReadingAnchorTableTable(this);
  late final $ReturnEventTableTable returnEventTable = $ReturnEventTableTable(
    this,
  );
  late final $ReminderIntentTableTable reminderIntentTable =
      $ReminderIntentTableTable(this);
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
    memoryThreadTable,
    reflectionEntryTable,
    readingAnchorTable,
    returnEventTable,
    reminderIntentTable,
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
typedef $$MemoryThreadTableTableCreateCompanionBuilder =
    MemoryThreadTableCompanion Function({
      required String id,
      required String sourceKind,
      required String sourceCanonicalId,
      required String sourceLabel,
      Value<String?> sourceBook,
      Value<String?> sourceCitation,
      Value<String?> sourceVersion,
      Value<String?> sourceSecondaryReference,
      Value<String?> userContextKind,
      Value<String?> userContextLabel,
      Value<String?> userLabel,
      Value<String> status,
      Value<String> resurfacing,
      Value<String?> legacyKey,
      required String createdAt,
      required String updatedAt,
      Value<String?> lastReturnedAt,
      Value<int> rowid,
    });
typedef $$MemoryThreadTableTableUpdateCompanionBuilder =
    MemoryThreadTableCompanion Function({
      Value<String> id,
      Value<String> sourceKind,
      Value<String> sourceCanonicalId,
      Value<String> sourceLabel,
      Value<String?> sourceBook,
      Value<String?> sourceCitation,
      Value<String?> sourceVersion,
      Value<String?> sourceSecondaryReference,
      Value<String?> userContextKind,
      Value<String?> userContextLabel,
      Value<String?> userLabel,
      Value<String> status,
      Value<String> resurfacing,
      Value<String?> legacyKey,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> lastReturnedAt,
      Value<int> rowid,
    });

class $$MemoryThreadTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MemoryThreadTableTable> {
  $$MemoryThreadTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get sourceKind => $state.composableBuilder(
    column: $state.table.sourceKind,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get sourceCanonicalId => $state.composableBuilder(
    column: $state.table.sourceCanonicalId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get sourceLabel => $state.composableBuilder(
    column: $state.table.sourceLabel,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get sourceBook => $state.composableBuilder(
    column: $state.table.sourceBook,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get sourceCitation => $state.composableBuilder(
    column: $state.table.sourceCitation,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get sourceVersion => $state.composableBuilder(
    column: $state.table.sourceVersion,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get sourceSecondaryReference =>
      $state.composableBuilder(
        column: $state.table.sourceSecondaryReference,
        builder: (column, joinBuilders) =>
            ColumnFilters(column, joinBuilders: joinBuilders),
      );

  ColumnFilters<String> get userContextKind => $state.composableBuilder(
    column: $state.table.userContextKind,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get userContextLabel => $state.composableBuilder(
    column: $state.table.userContextLabel,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get userLabel => $state.composableBuilder(
    column: $state.table.userLabel,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get status => $state.composableBuilder(
    column: $state.table.status,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get resurfacing => $state.composableBuilder(
    column: $state.table.resurfacing,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get legacyKey => $state.composableBuilder(
    column: $state.table.legacyKey,
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

  ColumnFilters<String> get lastReturnedAt => $state.composableBuilder(
    column: $state.table.lastReturnedAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$MemoryThreadTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MemoryThreadTableTable> {
  $$MemoryThreadTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get sourceKind => $state.composableBuilder(
    column: $state.table.sourceKind,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get sourceCanonicalId => $state.composableBuilder(
    column: $state.table.sourceCanonicalId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get sourceLabel => $state.composableBuilder(
    column: $state.table.sourceLabel,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get sourceBook => $state.composableBuilder(
    column: $state.table.sourceBook,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get sourceCitation => $state.composableBuilder(
    column: $state.table.sourceCitation,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get sourceVersion => $state.composableBuilder(
    column: $state.table.sourceVersion,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get sourceSecondaryReference =>
      $state.composableBuilder(
        column: $state.table.sourceSecondaryReference,
        builder: (column, joinBuilders) =>
            ColumnOrderings(column, joinBuilders: joinBuilders),
      );

  ColumnOrderings<String> get userContextKind => $state.composableBuilder(
    column: $state.table.userContextKind,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get userContextLabel => $state.composableBuilder(
    column: $state.table.userContextLabel,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get userLabel => $state.composableBuilder(
    column: $state.table.userLabel,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get status => $state.composableBuilder(
    column: $state.table.status,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get resurfacing => $state.composableBuilder(
    column: $state.table.resurfacing,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get legacyKey => $state.composableBuilder(
    column: $state.table.legacyKey,
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

  ColumnOrderings<String> get lastReturnedAt => $state.composableBuilder(
    column: $state.table.lastReturnedAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$MemoryThreadTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryThreadTableTable,
          MemoryThreadRow,
          $$MemoryThreadTableTableFilterComposer,
          $$MemoryThreadTableTableOrderingComposer,
          $$MemoryThreadTableTableCreateCompanionBuilder,
          $$MemoryThreadTableTableUpdateCompanionBuilder,
          (
            MemoryThreadRow,
            BaseReferences<
              _$AppDatabase,
              $MemoryThreadTableTable,
              MemoryThreadRow
            >,
          ),
          MemoryThreadRow,
          PrefetchHooks Function()
        > {
  $$MemoryThreadTableTableTableManager(
    _$AppDatabase db,
    $MemoryThreadTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$MemoryThreadTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$MemoryThreadTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
                Value<String> sourceCanonicalId = const Value.absent(),
                Value<String> sourceLabel = const Value.absent(),
                Value<String?> sourceBook = const Value.absent(),
                Value<String?> sourceCitation = const Value.absent(),
                Value<String?> sourceVersion = const Value.absent(),
                Value<String?> sourceSecondaryReference = const Value.absent(),
                Value<String?> userContextKind = const Value.absent(),
                Value<String?> userContextLabel = const Value.absent(),
                Value<String?> userLabel = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> resurfacing = const Value.absent(),
                Value<String?> legacyKey = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> lastReturnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryThreadTableCompanion(
                id: id,
                sourceKind: sourceKind,
                sourceCanonicalId: sourceCanonicalId,
                sourceLabel: sourceLabel,
                sourceBook: sourceBook,
                sourceCitation: sourceCitation,
                sourceVersion: sourceVersion,
                sourceSecondaryReference: sourceSecondaryReference,
                userContextKind: userContextKind,
                userContextLabel: userContextLabel,
                userLabel: userLabel,
                status: status,
                resurfacing: resurfacing,
                legacyKey: legacyKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastReturnedAt: lastReturnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceKind,
                required String sourceCanonicalId,
                required String sourceLabel,
                Value<String?> sourceBook = const Value.absent(),
                Value<String?> sourceCitation = const Value.absent(),
                Value<String?> sourceVersion = const Value.absent(),
                Value<String?> sourceSecondaryReference = const Value.absent(),
                Value<String?> userContextKind = const Value.absent(),
                Value<String?> userContextLabel = const Value.absent(),
                Value<String?> userLabel = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> resurfacing = const Value.absent(),
                Value<String?> legacyKey = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> lastReturnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryThreadTableCompanion.insert(
                id: id,
                sourceKind: sourceKind,
                sourceCanonicalId: sourceCanonicalId,
                sourceLabel: sourceLabel,
                sourceBook: sourceBook,
                sourceCitation: sourceCitation,
                sourceVersion: sourceVersion,
                sourceSecondaryReference: sourceSecondaryReference,
                userContextKind: userContextKind,
                userContextLabel: userContextLabel,
                userLabel: userLabel,
                status: status,
                resurfacing: resurfacing,
                legacyKey: legacyKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastReturnedAt: lastReturnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemoryThreadTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryThreadTableTable,
      MemoryThreadRow,
      $$MemoryThreadTableTableFilterComposer,
      $$MemoryThreadTableTableOrderingComposer,
      $$MemoryThreadTableTableCreateCompanionBuilder,
      $$MemoryThreadTableTableUpdateCompanionBuilder,
      (
        MemoryThreadRow,
        BaseReferences<_$AppDatabase, $MemoryThreadTableTable, MemoryThreadRow>,
      ),
      MemoryThreadRow,
      PrefetchHooks Function()
    >;
typedef $$ReflectionEntryTableTableCreateCompanionBuilder =
    ReflectionEntryTableCompanion Function({
      required String id,
      required String threadId,
      required String body,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<int> rowid,
    });
typedef $$ReflectionEntryTableTableUpdateCompanionBuilder =
    ReflectionEntryTableCompanion Function({
      Value<String> id,
      Value<String> threadId,
      Value<String> body,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<int> rowid,
    });

class $$ReflectionEntryTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ReflectionEntryTableTable> {
  $$ReflectionEntryTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get threadId => $state.composableBuilder(
    column: $state.table.threadId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get body => $state.composableBuilder(
    column: $state.table.body,
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

  ColumnFilters<String> get deletedAt => $state.composableBuilder(
    column: $state.table.deletedAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$ReflectionEntryTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ReflectionEntryTableTable> {
  $$ReflectionEntryTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get threadId => $state.composableBuilder(
    column: $state.table.threadId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get body => $state.composableBuilder(
    column: $state.table.body,
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

  ColumnOrderings<String> get deletedAt => $state.composableBuilder(
    column: $state.table.deletedAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$ReflectionEntryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReflectionEntryTableTable,
          ReflectionEntryRow,
          $$ReflectionEntryTableTableFilterComposer,
          $$ReflectionEntryTableTableOrderingComposer,
          $$ReflectionEntryTableTableCreateCompanionBuilder,
          $$ReflectionEntryTableTableUpdateCompanionBuilder,
          (
            ReflectionEntryRow,
            BaseReferences<
              _$AppDatabase,
              $ReflectionEntryTableTable,
              ReflectionEntryRow
            >,
          ),
          ReflectionEntryRow,
          PrefetchHooks Function()
        > {
  $$ReflectionEntryTableTableTableManager(
    _$AppDatabase db,
    $ReflectionEntryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ReflectionEntryTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$ReflectionEntryTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> threadId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReflectionEntryTableCompanion(
                id: id,
                threadId: threadId,
                body: body,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String threadId,
                required String body,
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReflectionEntryTableCompanion.insert(
                id: id,
                threadId: threadId,
                body: body,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReflectionEntryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReflectionEntryTableTable,
      ReflectionEntryRow,
      $$ReflectionEntryTableTableFilterComposer,
      $$ReflectionEntryTableTableOrderingComposer,
      $$ReflectionEntryTableTableCreateCompanionBuilder,
      $$ReflectionEntryTableTableUpdateCompanionBuilder,
      (
        ReflectionEntryRow,
        BaseReferences<
          _$AppDatabase,
          $ReflectionEntryTableTable,
          ReflectionEntryRow
        >,
      ),
      ReflectionEntryRow,
      PrefetchHooks Function()
    >;
typedef $$ReadingAnchorTableTableCreateCompanionBuilder =
    ReadingAnchorTableCompanion Function({
      required String id,
      Value<String?> threadId,
      required String sourceCanonicalId,
      Value<int?> surahNumber,
      Value<int?> ayahNumber,
      Value<int?> pageNumber,
      Value<int?> itemIndex,
      Value<double?> scrollOffset,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$ReadingAnchorTableTableUpdateCompanionBuilder =
    ReadingAnchorTableCompanion Function({
      Value<String> id,
      Value<String?> threadId,
      Value<String> sourceCanonicalId,
      Value<int?> surahNumber,
      Value<int?> ayahNumber,
      Value<int?> pageNumber,
      Value<int?> itemIndex,
      Value<double?> scrollOffset,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$ReadingAnchorTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ReadingAnchorTableTable> {
  $$ReadingAnchorTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get threadId => $state.composableBuilder(
    column: $state.table.threadId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get sourceCanonicalId => $state.composableBuilder(
    column: $state.table.sourceCanonicalId,
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

  ColumnFilters<int> get pageNumber => $state.composableBuilder(
    column: $state.table.pageNumber,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get itemIndex => $state.composableBuilder(
    column: $state.table.itemIndex,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<double> get scrollOffset => $state.composableBuilder(
    column: $state.table.scrollOffset,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$ReadingAnchorTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ReadingAnchorTableTable> {
  $$ReadingAnchorTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get threadId => $state.composableBuilder(
    column: $state.table.threadId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get sourceCanonicalId => $state.composableBuilder(
    column: $state.table.sourceCanonicalId,
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

  ColumnOrderings<int> get pageNumber => $state.composableBuilder(
    column: $state.table.pageNumber,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get itemIndex => $state.composableBuilder(
    column: $state.table.itemIndex,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<double> get scrollOffset => $state.composableBuilder(
    column: $state.table.scrollOffset,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
    column: $state.table.updatedAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$ReadingAnchorTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingAnchorTableTable,
          ReadingAnchorRow,
          $$ReadingAnchorTableTableFilterComposer,
          $$ReadingAnchorTableTableOrderingComposer,
          $$ReadingAnchorTableTableCreateCompanionBuilder,
          $$ReadingAnchorTableTableUpdateCompanionBuilder,
          (
            ReadingAnchorRow,
            BaseReferences<
              _$AppDatabase,
              $ReadingAnchorTableTable,
              ReadingAnchorRow
            >,
          ),
          ReadingAnchorRow,
          PrefetchHooks Function()
        > {
  $$ReadingAnchorTableTableTableManager(
    _$AppDatabase db,
    $ReadingAnchorTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ReadingAnchorTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$ReadingAnchorTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> threadId = const Value.absent(),
                Value<String> sourceCanonicalId = const Value.absent(),
                Value<int?> surahNumber = const Value.absent(),
                Value<int?> ayahNumber = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<int?> itemIndex = const Value.absent(),
                Value<double?> scrollOffset = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingAnchorTableCompanion(
                id: id,
                threadId: threadId,
                sourceCanonicalId: sourceCanonicalId,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                pageNumber: pageNumber,
                itemIndex: itemIndex,
                scrollOffset: scrollOffset,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> threadId = const Value.absent(),
                required String sourceCanonicalId,
                Value<int?> surahNumber = const Value.absent(),
                Value<int?> ayahNumber = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<int?> itemIndex = const Value.absent(),
                Value<double?> scrollOffset = const Value.absent(),
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReadingAnchorTableCompanion.insert(
                id: id,
                threadId: threadId,
                sourceCanonicalId: sourceCanonicalId,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                pageNumber: pageNumber,
                itemIndex: itemIndex,
                scrollOffset: scrollOffset,
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

typedef $$ReadingAnchorTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingAnchorTableTable,
      ReadingAnchorRow,
      $$ReadingAnchorTableTableFilterComposer,
      $$ReadingAnchorTableTableOrderingComposer,
      $$ReadingAnchorTableTableCreateCompanionBuilder,
      $$ReadingAnchorTableTableUpdateCompanionBuilder,
      (
        ReadingAnchorRow,
        BaseReferences<
          _$AppDatabase,
          $ReadingAnchorTableTable,
          ReadingAnchorRow
        >,
      ),
      ReadingAnchorRow,
      PrefetchHooks Function()
    >;
typedef $$ReturnEventTableTableCreateCompanionBuilder =
    ReturnEventTableCompanion Function({
      required String id,
      required String threadId,
      required String kind,
      required String occurredAt,
      Value<int?> durationSeconds,
      Value<String?> reflectionId,
      Value<int> rowid,
    });
typedef $$ReturnEventTableTableUpdateCompanionBuilder =
    ReturnEventTableCompanion Function({
      Value<String> id,
      Value<String> threadId,
      Value<String> kind,
      Value<String> occurredAt,
      Value<int?> durationSeconds,
      Value<String?> reflectionId,
      Value<int> rowid,
    });

class $$ReturnEventTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ReturnEventTableTable> {
  $$ReturnEventTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get threadId => $state.composableBuilder(
    column: $state.table.threadId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get kind => $state.composableBuilder(
    column: $state.table.kind,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get occurredAt => $state.composableBuilder(
    column: $state.table.occurredAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<int> get durationSeconds => $state.composableBuilder(
    column: $state.table.durationSeconds,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get reflectionId => $state.composableBuilder(
    column: $state.table.reflectionId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$ReturnEventTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ReturnEventTableTable> {
  $$ReturnEventTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get threadId => $state.composableBuilder(
    column: $state.table.threadId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get kind => $state.composableBuilder(
    column: $state.table.kind,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get occurredAt => $state.composableBuilder(
    column: $state.table.occurredAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<int> get durationSeconds => $state.composableBuilder(
    column: $state.table.durationSeconds,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get reflectionId => $state.composableBuilder(
    column: $state.table.reflectionId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$ReturnEventTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReturnEventTableTable,
          ReturnEventRow,
          $$ReturnEventTableTableFilterComposer,
          $$ReturnEventTableTableOrderingComposer,
          $$ReturnEventTableTableCreateCompanionBuilder,
          $$ReturnEventTableTableUpdateCompanionBuilder,
          (
            ReturnEventRow,
            BaseReferences<
              _$AppDatabase,
              $ReturnEventTableTable,
              ReturnEventRow
            >,
          ),
          ReturnEventRow,
          PrefetchHooks Function()
        > {
  $$ReturnEventTableTableTableManager(
    _$AppDatabase db,
    $ReturnEventTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ReturnEventTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$ReturnEventTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> threadId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> occurredAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> reflectionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnEventTableCompanion(
                id: id,
                threadId: threadId,
                kind: kind,
                occurredAt: occurredAt,
                durationSeconds: durationSeconds,
                reflectionId: reflectionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String threadId,
                required String kind,
                required String occurredAt,
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> reflectionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnEventTableCompanion.insert(
                id: id,
                threadId: threadId,
                kind: kind,
                occurredAt: occurredAt,
                durationSeconds: durationSeconds,
                reflectionId: reflectionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReturnEventTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReturnEventTableTable,
      ReturnEventRow,
      $$ReturnEventTableTableFilterComposer,
      $$ReturnEventTableTableOrderingComposer,
      $$ReturnEventTableTableCreateCompanionBuilder,
      $$ReturnEventTableTableUpdateCompanionBuilder,
      (
        ReturnEventRow,
        BaseReferences<_$AppDatabase, $ReturnEventTableTable, ReturnEventRow>,
      ),
      ReturnEventRow,
      PrefetchHooks Function()
    >;
typedef $$ReminderIntentTableTableCreateCompanionBuilder =
    ReminderIntentTableCompanion Function({
      required String id,
      required String threadId,
      required String scheduledAt,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$ReminderIntentTableTableUpdateCompanionBuilder =
    ReminderIntentTableCompanion Function({
      Value<String> id,
      Value<String> threadId,
      Value<String> scheduledAt,
      Value<bool> enabled,
      Value<int> rowid,
    });

class $$ReminderIntentTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ReminderIntentTableTable> {
  $$ReminderIntentTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get threadId => $state.composableBuilder(
    column: $state.table.threadId,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<String> get scheduledAt => $state.composableBuilder(
    column: $state.table.scheduledAt,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );

  ColumnFilters<bool> get enabled => $state.composableBuilder(
    column: $state.table.enabled,
    builder: (column, joinBuilders) =>
        ColumnFilters(column, joinBuilders: joinBuilders),
  );
}

class $$ReminderIntentTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ReminderIntentTableTable> {
  $$ReminderIntentTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
    column: $state.table.id,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get threadId => $state.composableBuilder(
    column: $state.table.threadId,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<String> get scheduledAt => $state.composableBuilder(
    column: $state.table.scheduledAt,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );

  ColumnOrderings<bool> get enabled => $state.composableBuilder(
    column: $state.table.enabled,
    builder: (column, joinBuilders) =>
        ColumnOrderings(column, joinBuilders: joinBuilders),
  );
}

class $$ReminderIntentTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderIntentTableTable,
          ReminderIntentRow,
          $$ReminderIntentTableTableFilterComposer,
          $$ReminderIntentTableTableOrderingComposer,
          $$ReminderIntentTableTableCreateCompanionBuilder,
          $$ReminderIntentTableTableUpdateCompanionBuilder,
          (
            ReminderIntentRow,
            BaseReferences<
              _$AppDatabase,
              $ReminderIntentTableTable,
              ReminderIntentRow
            >,
          ),
          ReminderIntentRow,
          PrefetchHooks Function()
        > {
  $$ReminderIntentTableTableTableManager(
    _$AppDatabase db,
    $ReminderIntentTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ReminderIntentTableTableFilterComposer(
            ComposerState(db, table),
          ),
          orderingComposer: $$ReminderIntentTableTableOrderingComposer(
            ComposerState(db, table),
          ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> threadId = const Value.absent(),
                Value<String> scheduledAt = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderIntentTableCompanion(
                id: id,
                threadId: threadId,
                scheduledAt: scheduledAt,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String threadId,
                required String scheduledAt,
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderIntentTableCompanion.insert(
                id: id,
                threadId: threadId,
                scheduledAt: scheduledAt,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderIntentTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderIntentTableTable,
      ReminderIntentRow,
      $$ReminderIntentTableTableFilterComposer,
      $$ReminderIntentTableTableOrderingComposer,
      $$ReminderIntentTableTableCreateCompanionBuilder,
      $$ReminderIntentTableTableUpdateCompanionBuilder,
      (
        ReminderIntentRow,
        BaseReferences<
          _$AppDatabase,
          $ReminderIntentTableTable,
          ReminderIntentRow
        >,
      ),
      ReminderIntentRow,
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
  $$MemoryThreadTableTableTableManager get memoryThreadTable =>
      $$MemoryThreadTableTableTableManager(_db, _db.memoryThreadTable);
  $$ReflectionEntryTableTableTableManager get reflectionEntryTable =>
      $$ReflectionEntryTableTableTableManager(_db, _db.reflectionEntryTable);
  $$ReadingAnchorTableTableTableManager get readingAnchorTable =>
      $$ReadingAnchorTableTableTableManager(_db, _db.readingAnchorTable);
  $$ReturnEventTableTableTableManager get returnEventTable =>
      $$ReturnEventTableTableTableManager(_db, _db.returnEventTable);
  $$ReminderIntentTableTableTableManager get reminderIntentTable =>
      $$ReminderIntentTableTableTableManager(_db, _db.reminderIntentTable);
}
