import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/athr_card.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/azkar/providers/azkar_providers.dart';

class AzkarCategoriesScreen extends ConsumerWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(azkarCategoriesProvider);

    return AthrScaffold(
      title: 'الأذكار',
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('لا توجد تصنيفات للأذكار بعد.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return AthrCard(
                onTap: () {
                  context.pushNamed('azkarReading', pathParameters: {'category': category});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('خطأ: $e')),
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 2),
    );
  }
}
