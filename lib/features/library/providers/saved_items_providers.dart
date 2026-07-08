import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/features/library/domain/entities/saved_item_type.dart';
import 'package:athr/features/library/domain/repositories/saved_items_repository.dart';
import 'package:athr/features/library/data/repositories/saved_items_repository_impl.dart';

final savedItemsRepositoryProvider = Provider<SavedItemsRepository>((ref) {
  return SavedItemsRepositoryImpl(ref.watch(appDatabaseProvider));
});

final savedItemsProvider =
    StreamProvider.family<List<SavedItem>, SavedItemType>((ref, type) {
      return ref.watch(savedItemsRepositoryProvider).watchByType(type);
    });
