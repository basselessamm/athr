import 'package:drift/drift.dart';

/// One individual zikr row — the per-item data model (schema v8) that
/// replaces the category-merged text blobs. Each row carries its own parsed
/// repetition (only when explicitly annotated in the source) and an optional
/// time marker read from explicit words in the text.
@DataClassName('Zikr')
class ZikrTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  IntColumn get zikrIndex => integer()(); // 1-based order within category
  TextColumn get zikrText => text()();
  TextColumn get textNorm => text().withDefault(const Constant(''))();
  IntColumn get repetitionCount => integer().nullable()();
  TextColumn get repetitionLabel => text().nullable()();
  TextColumn get timeMarker => text().nullable()(); // 'morning' | 'evening'
}
