import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/home/presentation/continuation_canvas.dart';
import 'package:athr/features/prayer/presentation/prayer_times_card.dart';
import 'package:athr/features/quran/providers/quran_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AthrScaffold(
      title: 'أَثَر',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'البحث في المصادر',
          onPressed: () => context.push('/search'),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'الإعدادات',
          onPressed: () => context.push('/settings'),
        ),
      ],
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _WelcomeHeader(theme: theme),
            const SizedBox(height: 18),
            const PrayerTimesCard(),
            const SizedBox(height: 26),
            Text(
              'ابدأ من حيث تحب',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),
            _QuickAccessGrid(
              onQuran: () => context.push('/quran'),
              onAzkar: () => context.push('/azkar'),
              onHadith: () => context.push('/hadith'),
              onFavorites: () => context.push('/favorites'),
            ),
            const SizedBox(height: 28),
            const _DeferredContinuationCanvas(),
            const SizedBox(height: 28),
            _DeferredSourceDiscoveryCard(
              onOpen: () => context.push('/quran/67?ayah=3'),
            ),
            const SizedBox(height: 16),
            _GentleUtilityRow(
              onMuhasaba: () => context.push('/muhasaba'),
              onPrayerSettings: () => context.push('/settings'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 0),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'صباحٌ هادئ'
        : hour < 17
        ? 'مساءٌ طيب'
        : 'ليلةٌ مباركة';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface.withValues(alpha: .74),
            ),
            child: Icon(
              Icons.auto_awesome_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 5),
                Text(
                  'مكانٌ للقراءة والذكر والعودة إلى ما كان ذا معنى.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({
    required this.onQuran,
    required this.onAzkar,
    required this.onHadith,
    required this.onFavorites,
  });

  final VoidCallback onQuran;
  final VoidCallback onAzkar;
  final VoidCallback onHadith;
  final VoidCallback onFavorites;

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickAccessItem(
        'القرآن الكريم',
        'اقرأ وتدبّر',
        Icons.menu_book_outlined,
        onQuran,
      ),
      _QuickAccessItem(
        'الأذكار',
        'وردك بهدوء',
        Icons.wb_twilight_outlined,
        onAzkar,
      ),
      _QuickAccessItem(
        'الحديث',
        'مصادر موثقة',
        Icons.library_books_outlined,
        onHadith,
      ),
      _QuickAccessItem(
        'المفضلة',
        'ما حفظته سابقًا',
        Icons.favorite_border,
        onFavorites,
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.72,
      ),
      itemBuilder: (context, index) => _QuickAccessCard(item: items[index]),
    );
  }
}

class _QuickAccessItem {
  const _QuickAccessItem(this.title, this.subtitle, this.icon, this.onTap);

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({required this.item});

  final _QuickAccessItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 19, color: scheme.secondary),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeferredContinuationCanvas extends StatefulWidget {
  const _DeferredContinuationCanvas();

  @override
  State<_DeferredContinuationCanvas> createState() =>
      _DeferredContinuationCanvasState();
}

class _DeferredContinuationCanvasState
    extends State<_DeferredContinuationCanvas> {
  Timer? _timer;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _isReady = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) return const ContinuationCanvas(embedded: true);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_outlined, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'تُجهّز خيوط العودة بهدوء…',
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeferredSourceDiscoveryCard extends StatefulWidget {
  const _DeferredSourceDiscoveryCard({required this.onOpen});

  final VoidCallback onOpen;

  @override
  State<_DeferredSourceDiscoveryCard> createState() =>
      _DeferredSourceDiscoveryCardState();
}

class _DeferredSourceDiscoveryCardState
    extends State<_DeferredSourceDiscoveryCard> {
  Timer? _timer;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 6), () {
      if (mounted) setState(() => _isReady = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) return _SourceDiscoveryCard(onOpen: widget.onOpen);
    return _DiscoveryCardBody(onOpen: widget.onOpen, isLoading: true);
  }
}

class _SourceDiscoveryCard extends ConsumerWidget {
  const _SourceDiscoveryCard({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const surah = 67;
    const ayah = 3;
    final initialization = ref.watch(quranInitializationProvider);

    return initialization.when(
      data: (_) => _DiscoveryCardBody(
        verse: Quran.getVerse(surahNumber: surah, verseNumber: ayah).text,
        onOpen: onOpen,
      ),
      loading: () => _DiscoveryCardBody(onOpen: onOpen, isLoading: true),
      error: (_, _) => _DiscoveryCardBody(onOpen: onOpen, hasError: true),
    );
  }
}

class _DiscoveryCardBody extends StatelessWidget {
  const _DiscoveryCardBody({
    required this.onOpen,
    this.verse,
    this.isLoading = false,
    this.hasError = false,
  });

  final VoidCallback onOpen;
  final String? verse;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_outlined, color: scheme.tertiary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'من القرآن الكريم',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: scheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isLoading)
            const SizedBox(
              height: 54,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (hasError)
            Text(
              'افتح موضع القراءة للعودة إلى الآية من مصدرها.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
            )
          else
            Text(
              verse!,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                height: 1.9,
                fontWeight: FontWeight.w700,
              ),
            ),
          const SizedBox(height: 10),
          Text(
            'سورة الملك · الآية ٣',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onOpen,
            icon: const Icon(Icons.arrow_back),
            label: const Text('فتح موضع القراءة'),
          ),
        ],
      ),
    );
  }
}

class _GentleUtilityRow extends StatelessWidget {
  const _GentleUtilityRow({
    required this.onMuhasaba,
    required this.onPrayerSettings,
  });

  final VoidCallback onMuhasaba;
  final VoidCallback onPrayerSettings;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 10,
      runSpacing: 8,
      children: [
        TextButton.icon(
          onPressed: onMuhasaba,
          icon: const Icon(Icons.edit_note_outlined),
          label: const Text('تأمل شخصي'),
        ),
        TextButton.icon(
          onPressed: onPrayerSettings,
          icon: const Icon(Icons.notifications_none_outlined),
          label: const Text('إعدادات الصلاة'),
        ),
      ],
    );
  }
}
