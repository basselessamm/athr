import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/library/domain/entities/saved_item_type.dart';
import 'package:athr/features/library/domain/repositories/saved_items_repository.dart';
import 'package:drift/drift.dart';

class SavedItemsRepositoryImpl implements SavedItemsRepository {
  final AppDatabase _db;

  SavedItemsRepositoryImpl(this._db);

  @override
  Stream<List<SavedItem>> watchByType(SavedItemType type) {
    return (_db.select(_db.userFavoriteTable)
          ..where((t) {
            switch (type) {
              case SavedItemType.quran:
                return t.contentType.equals('quran') |
                    t.contentType.equals('verse');
              case SavedItemType.hadith:
                return t.contentType.equals('hadith');
              case SavedItemType.azkar:
                return t.contentType.equals('azkar') |
                    t.contentType.equals('dua');
            }
          })
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((favorites) {
          return favorites.map((f) {
            int referenceId = 0;
            int? secondaryId;
            String? collectionId;

            switch (type) {
              case SavedItemType.quran:
                final parts = f.primaryReference.split(':');
                referenceId = int.tryParse(parts.first) ?? 1;
                secondaryId = parts.length > 1 ? int.tryParse(parts[1]) : null;
                break;
              case SavedItemType.hadith:
                referenceId = int.tryParse(f.primaryReference) ?? 0;
                collectionId = f.secondaryReference;
                break;
              case SavedItemType.azkar:
                referenceId = int.tryParse(f.primaryReference) ?? 0;
                collectionId = f.secondaryReference ?? f.source;
                break;
            }

            return SavedItem(
              id: f.id,
              featureType: type.value,
              referenceId: referenceId,
              secondaryId: secondaryId,
              collectionId: collectionId,
              notes: f.note,
              previewText: f.title.trim().isNotEmpty ? f.title : f.contentText,
              createdAt: f.createdAt,
            );
          }).toList();
        });
  }

  @override
  Future<void> remove(int id) async {
    await (_db.delete(
      _db.userFavoriteTable,
    )..where((t) => t.id.equals(id))).go();
  }
}
