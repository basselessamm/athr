import 'package:drift/drift.dart';

@DataClassName('QuranTafseer')
class QuranTafseerTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  TextColumn get tafseerText => text()();
}
