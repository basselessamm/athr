import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

import 'package:midrar/core/widgets/midrar_scaffold.dart';
import 'package:midrar/core/widgets/main_navigation_bar.dart';
import 'package:midrar/features/home/presentation/continuation_canvas.dart';
import 'package:midrar/features/prayer/presentation/prayer_times_card.dart';
import 'package:midrar/features/quran/application/quran_audio.dart';
import 'package:midrar/features/quran/providers/bookmark_provider.dart';
import 'package:midrar/features/quran/providers/quran_providers.dart';
import 'package:midrar/core/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return MidrarScaffold(
      title: 'مدرار',
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
            const SizedBox(height: 14),
            const _SmartContinuationCard(),
            const SizedBox(height: 22),
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
            _SituationsDiscoveryCard(
              onOpen: () => context.push('/situations'),
            ),
            const SizedBox(height: 20),
            _DeferredSourceDiscoveryCard(
              onOpen: () => context.push('/quran/67?ayah=3'),
            ),
            const SizedBox(height: 16),
            _GentleUtilityRow(
              onMuhasaba: () => context.push('/muhasaba'),
              onPrayerSettings: () => context.push('/settings'),
              onSituations: () => context.push('/situations'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 0),
    );
  }
}

/// One obvious "continue" action: resumes active listening first, otherwise
/// the last reading position. Hidden entirely for first-run users.
class _SmartContinuationCard extends ConsumerWidget {
  const _SmartContinuationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(quranAudioControllerProvider);
    final lastRead = ref.watch(lastReadProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final bool hasListening = audio.hasSelection;
    final bool hasReading = lastRead != null;
    if (!hasListening && !hasReading) return const SizedBox.shrink();

    final String title;
    final String subtitle;
    final String route;
    if (hasListening) {
      final surahName = Quran.getSurahName(audio.surah!);
      title = 'استئناف الاستماع';
      subtitle =
          'سورة $surahName · الآية ${audio.ayah} · ${audio.reciter.displayName}';
      route = '/quran/${audio.surah}?ayah=${audio.ayah}';
    } else {
      title = 'متابعة القراءة';
      subtitle =
          'سورة ${Quran.getSurahName(lastRead!.surah)} · الآية ${lastRead.ayah}';
      route = '/quran/${lastRead.surah}?ayah=${lastRead.ayah}';
    }

    return Material(
      color: scheme.secondaryContainer.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(AppColors.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Icon(
                hasListening
                    ? Icons.graphic_eq_rounded
                    : Icons.menu_book_outlined,
                color: scheme.onSecondaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSecondaryContainer.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: scheme.onSecondaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'صباحٌ هادئ'
        : hour < 17
        ? 'مساءٌ طيب'
        : 'ليلةٌ مباركة';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusXl),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF1C443B).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            greeting,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 6),
          Text(
            'مكانٌ للقراءة والذكر والعودة إلى ما كان ذا معنى.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
              fontSize: 13,
            ),
            textAlign: TextAlign.right,
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
        Icons.menu_book_rounded,
        onQuran,
      ),
      _QuickAccessItem(
        'الأذكار',
        'وردك بهدوء',
        Icons.spa_rounded,
        onAzkar,
      ),
      _QuickAccessItem(
        'الحديث',
        'مصادر موثقة',
        Icons.import_contacts_rounded,
        onHadith,
      ),
      _QuickAccessItem(
        'المحفوظات',
        'خيوط العودة',
        Icons.bookmark_added_rounded,
        onFavorites,
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.75,
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppColors.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppColors.radiusLg),
            border: Border.all(color: scheme.outline),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : const Color(0xFF1C443B).withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(
                    alpha: isDark ? 0.4 : 0.6,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 20, color: scheme.primary),
              ),
              const SizedBox(width: 10),
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
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
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
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          Icon(Icons.bookmark_border_rounded, color: scheme.primary),
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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusXl),
        border: Border.all(
          color: AppColors.mushafGold.withValues(alpha: isDark ? 0.35 : 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFFC59B3F).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: AppColors.lightGold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'من القرآن الكريم',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
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
              style: GoogleFonts.amiri(
                fontSize: 22,
                height: 1.9,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          const SizedBox(height: 10),
          Text(
            'سورة الملك · الآية ٣',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onOpen,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('فتح موضع القراءة'),
          ),
        ],
      ),
    );
  }
}

class _SituationsDiscoveryCard extends StatelessWidget {
  const _SituationsDiscoveryCard({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusXl),
        border: Border.all(
          color: scheme.outline,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF1C443B).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emotionComfort.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.wb_twilight_outlined,
                  color: AppColors.emotionComfort,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سكينة في مواقف الحياة',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'آيات وأحاديث لما تجده في صدرك من هم أو ضيق أو شكر',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: onOpen,
            icon: const Icon(Icons.explore_outlined, size: 18),
            label: const Text('استعراض المواقف والتأملات'),
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
    required this.onSituations,
  });

  final VoidCallback onMuhasaba;
  final VoidCallback onPrayerSettings;
  final VoidCallback onSituations;

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
          onPressed: onSituations,
          icon: const Icon(Icons.wb_twilight_outlined),
          label: const Text('مواقف وتأملات'),
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
