import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/library/domain/entities/saved_item_type.dart';

abstract class SavedItemsRepository {
  Stream<List<SavedItem>> watchByType(SavedItemType type);
  Future<void> remove(int id);
}
