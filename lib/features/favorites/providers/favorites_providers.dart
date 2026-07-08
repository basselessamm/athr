import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';

final favoritesProvider = StreamProvider<List<UserFavorite>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchFavorites();
});

final isFavoriteProvider =
    StreamProvider.family<bool, ({String type, String reference})>((ref, args) {
      final db = ref.watch(appDatabaseProvider);
      return db.watchIsFavorite(args.type, args.reference);
    });
