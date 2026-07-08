import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/library/domain/entities/saved_item_type.dart';
import 'package:athr/features/library/domain/repositories/saved_items_repository.dart';
import 'package:drift/drift.dart';

class SavedItemsRepositoryImpl implements SavedItemsRepository {
  final AppDatabase _db;

  SavedItemsRepositoryImpl(this._db);

  @override
  Stream<List<SavedItem>> watchByType(SavedItemType type) {
    return (_db.select(_db.savedItemsTable)
          ..where((t) => t.featureType.equals(type.value))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  @override
  Future<void> remove(int id) async {
    await (_db.delete(_db.savedItemsTable)..where((t) => t.id.equals(id))).go();
  }
}
