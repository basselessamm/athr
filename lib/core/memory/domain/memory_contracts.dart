/// Domain contracts for Athr's local memory model.
///
/// These contracts deliberately keep verified religious source data separate
/// from user-authored memory. A MemoryThread references a SourceReference; it
/// never owns or edits the source text.
library;

enum SourceKind {
  quranVerse('quran_verse'),
  hadith('hadith'),
  dua('dua'),
  azkar('azkar'),
  quranReading('quran_reading'),
  situation('situation');

  const SourceKind(this.storageKey);

  final String storageKey;

  static SourceKind fromStorageKey(String value) {
    for (final kind in SourceKind.values) {
      if (kind.storageKey == value) return kind;
    }
    throw ArgumentError.value(value, 'value', 'Unknown source kind');
  }
}

enum ThreadStatus {
  active('active'),
  archived('archived');

  const ThreadStatus(this.storageKey);

  final String storageKey;

  static ThreadStatus fromStorageKey(String value) {
    for (final status in ThreadStatus.values) {
      if (status.storageKey == value) return status;
    }
    throw ArgumentError.value(value, 'value', 'Unknown thread status');
  }
}

enum ResurfacingPolicy {
  on('on'),
  off('off');

  const ResurfacingPolicy(this.storageKey);

  final String storageKey;

  static ResurfacingPolicy fromStorageKey(String value) {
    for (final policy in ResurfacingPolicy.values) {
      if (policy.storageKey == value) return policy;
    }
    throw ArgumentError.value(value, 'value', 'Unknown resurfacing policy');
  }
}

enum UserContextKind {
  returnTo('return_to'),
  continueLater('continue_later'),
  quietReading('quiet_reading'),
  applyLater('apply_later'),
  custom('custom');

  const UserContextKind(this.storageKey);

  final String storageKey;

  static UserContextKind fromStorageKey(String value) {
    for (final kind in UserContextKind.values) {
      if (kind.storageKey == value) return kind;
    }
    throw ArgumentError.value(value, 'value', 'Unknown user context kind');
  }
}

enum ReturnEventKind {
  opened('opened'),
  resumed('resumed'),
  reflected('reflected'),
  applied('applied'),
  dismissed('dismissed');

  const ReturnEventKind(this.storageKey);

  final String storageKey;

  static ReturnEventKind fromStorageKey(String value) {
    for (final kind in ReturnEventKind.values) {
      if (kind.storageKey == value) return kind;
    }
    throw ArgumentError.value(value, 'value', 'Unknown return event kind');
  }
}

/// A stable, read-only identity for content that comes from an approved
/// bundled source. It contains provenance metadata, never user notes and
/// never editable religious text.
class SourceReference {
  final SourceKind kind;
  final String canonicalId;
  final String sourceLabel;
  final String? sourceBook;
  final String? sourceCitation;
  final String? sourceVersion;
  final String? secondaryReference;

  const SourceReference({
    required this.kind,
    required this.canonicalId,
    required this.sourceLabel,
    this.sourceBook,
    this.sourceCitation,
    this.sourceVersion,
    this.secondaryReference,
  }) : assert(canonicalId != ''),
       assert(sourceLabel != '');

  factory SourceReference.quranVerse({
    required int surahNumber,
    required int ayahNumber,
    required String sourceLabel,
    String? sourceVersion,
  }) {
    _validatePositive(surahNumber, 'surahNumber');
    _validatePositive(ayahNumber, 'ayahNumber');
    return SourceReference(
      kind: SourceKind.quranVerse,
      canonicalId: 'quran:verse:$surahNumber:$ayahNumber',
      sourceLabel: sourceLabel,
      sourceBook: 'القرآن الكريم',
      sourceCitation: '$surahNumber:$ayahNumber',
      sourceVersion: sourceVersion,
    );
  }

  factory SourceReference.hadith({
    required String bookId,
    required String hadithId,
    required String sourceLabel,
    String? sourceBook,
    String? sourceCitation,
    String? sourceVersion,
  }) {
    _validateSegment(bookId, 'bookId');
    _validateSegment(hadithId, 'hadithId');
    return SourceReference(
      kind: SourceKind.hadith,
      canonicalId: 'hadith:$bookId:$hadithId',
      sourceLabel: sourceLabel,
      sourceBook: sourceBook,
      sourceCitation: sourceCitation,
      sourceVersion: sourceVersion,
      secondaryReference: bookId,
    );
  }

  factory SourceReference.dua({
    required String duaId,
    required String category,
    required String sourceLabel,
    String? sourceCitation,
    String? sourceVersion,
  }) {
    _validateSegment(duaId, 'duaId');
    _validateSegment(category, 'category');
    return SourceReference(
      kind: SourceKind.dua,
      canonicalId: 'dua:$duaId',
      sourceLabel: sourceLabel,
      sourceCitation: sourceCitation,
      sourceVersion: sourceVersion,
      secondaryReference: category,
    );
  }

  factory SourceReference.azkar({
    required String itemId,
    required String category,
    required String sourceLabel,
    String? sourceCitation,
    String? sourceVersion,
  }) {
    _validateSegment(itemId, 'itemId');
    _validateSegment(category, 'category');
    return SourceReference(
      kind: SourceKind.azkar,
      canonicalId: 'azkar:$itemId',
      sourceLabel: sourceLabel,
      sourceCitation: sourceCitation,
      sourceVersion: sourceVersion,
      secondaryReference: category,
    );
  }

  factory SourceReference.quranReading({
    required int surahNumber,
    required String sourceLabel,
    String? sourceVersion,
  }) {
    _validatePositive(surahNumber, 'surahNumber');
    return SourceReference(
      kind: SourceKind.quranReading,
      canonicalId: 'quran:surah:$surahNumber',
      sourceLabel: sourceLabel,
      sourceBook: 'القرآن الكريم',
      sourceCitation: 'surah:$surahNumber',
      sourceVersion: sourceVersion,
    );
  }

  factory SourceReference.situation({
    required String situationId,
    required String sourceLabel,
    String? sourceVersion,
  }) {
    _validateSegment(situationId, 'situationId');
    return SourceReference(
      kind: SourceKind.situation,
      canonicalId: 'situation:$situationId',
      sourceLabel: sourceLabel,
      sourceVersion: sourceVersion,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SourceReference &&
        other.kind == kind &&
        other.canonicalId == canonicalId &&
        other.sourceLabel == sourceLabel &&
        other.sourceBook == sourceBook &&
        other.sourceCitation == sourceCitation &&
        other.sourceVersion == sourceVersion &&
        other.secondaryReference == secondaryReference;
  }

  @override
  int get hashCode => Object.hash(
    kind,
    canonicalId,
    sourceLabel,
    sourceBook,
    sourceCitation,
    sourceVersion,
    secondaryReference,
  );
}

/// A user-selected, non-religious label for why a source should remain easy
/// to revisit. It is never presented as part of the source.
class UserContext {
  final UserContextKind kind;
  final String? customLabel;

  const UserContext({required this.kind, this.customLabel})
    : assert(kind != UserContextKind.custom || customLabel != null),
      assert(customLabel == null || customLabel != '');

  String get displayLabel {
    if (kind == UserContextKind.custom) return customLabel!;
    return kind.storageKey;
  }

  @override
  bool operator ==(Object other) {
    return other is UserContext &&
        other.kind == kind &&
        other.customLabel == customLabel;
  }

  @override
  int get hashCode => Object.hash(kind, customLabel);
}

/// The user's private words. This is intentionally a separate entity from a
/// source and from the thread metadata.
class ReflectionEntry {
  final String id;
  final String threadId;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  ReflectionEntry({
    required this.id,
    required this.threadId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  }) {
    _validateSegment(id, 'id');
    _validateSegment(threadId, 'threadId');
    _validateSegment(body, 'body');
  }
}

/// A position within a source reader. It does not contain source text and can
/// be used independently of a thread for the user's last reading position.
class ReadingAnchor {
  final String sourceCanonicalId;
  final int? surahNumber;
  final int? ayahNumber;
  final int? pageNumber;
  final int? itemIndex;
  final double? scrollOffset;
  final DateTime updatedAt;

  ReadingAnchor({
    required this.sourceCanonicalId,
    this.surahNumber,
    this.ayahNumber,
    this.pageNumber,
    this.itemIndex,
    this.scrollOffset,
    required this.updatedAt,
  }) {
    if (sourceCanonicalId.trim().isEmpty) {
      throw ArgumentError.value(sourceCanonicalId, 'sourceCanonicalId');
    }
    if (surahNumber == null &&
        ayahNumber == null &&
        pageNumber == null &&
        itemIndex == null &&
        scrollOffset == null) {
      throw ArgumentError('ReadingAnchor requires at least one position value');
    }
    if (scrollOffset != null && scrollOffset! < 0) {
      throw ArgumentError.value(scrollOffset, 'scrollOffset');
    }
  }
}

class MemoryThread {
  final String id;
  final SourceReference source;
  final UserContext? context;
  final String? userLabel;
  final ThreadStatus status;
  final ResurfacingPolicy resurfacing;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastReturnedAt;

  MemoryThread({
    required this.id,
    required this.source,
    this.context,
    this.userLabel,
    this.status = ThreadStatus.active,
    this.resurfacing = ResurfacingPolicy.on,
    required this.createdAt,
    required this.updatedAt,
    this.lastReturnedAt,
  }) {
    _validateSegment(id, 'id');
    if (userLabel != null && userLabel!.trim().isEmpty) {
      throw ArgumentError.value(userLabel, 'userLabel');
    }
  }

  MemoryThread copyWith({
    SourceReference? source,
    UserContext? context,
    bool clearContext = false,
    String? userLabel,
    bool clearUserLabel = false,
    ThreadStatus? status,
    ResurfacingPolicy? resurfacing,
    DateTime? updatedAt,
    DateTime? lastReturnedAt,
  }) {
    return MemoryThread(
      id: id,
      source: source ?? this.source,
      context: clearContext ? null : (context ?? this.context),
      userLabel: clearUserLabel ? null : (userLabel ?? this.userLabel),
      status: status ?? this.status,
      resurfacing: resurfacing ?? this.resurfacing,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReturnedAt: lastReturnedAt ?? this.lastReturnedAt,
    );
  }
}

class ReturnEvent {
  final String id;
  final String threadId;
  final ReturnEventKind kind;
  final DateTime occurredAt;
  final int? durationSeconds;
  final String? reflectionId;

  ReturnEvent({
    required this.id,
    required this.threadId,
    required this.kind,
    required this.occurredAt,
    this.durationSeconds,
    this.reflectionId,
  }) {
    _validateSegment(id, 'id');
    _validateSegment(threadId, 'threadId');
    if (durationSeconds != null && durationSeconds! < 0) {
      throw ArgumentError.value(durationSeconds, 'durationSeconds');
    }
  }
}

void _validatePositive(int value, String name) {
  if (value <= 0) throw ArgumentError.value(value, name);
}

void _validateSegment(String value, String name) {
  if (value.trim().isEmpty || value.contains(':')) {
    throw ArgumentError.value(value, name, 'Must be a non-empty segment');
  }
}
