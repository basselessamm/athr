import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/features/home/providers/home_providers.dart';
import 'package:midrar/features/muhasaba/providers/muhasaba_providers.dart';

class MuhasabaScreen extends ConsumerStatefulWidget {
  const MuhasabaScreen({super.key});

  @override
  ConsumerState<MuhasabaScreen> createState() => _MuhasabaScreenState();
}

class _MuhasabaScreenState extends ConsumerState<MuhasabaScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _initialized = false;
  bool _prayed = false;
  bool _guardedTongue = false;
  bool _honoredParents = false;
  bool _avoidedHarm = false;
  bool _gaveCharity = false;
  bool _quranRead = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _seedStateFromEntry(MuhasabaEntry? entry) {
    if (_initialized || entry == null) {
      return;
    }

    _prayed = entry.prayed;
    _guardedTongue = entry.guardedTongue;
    _honoredParents = entry.honoredParents;
    _avoidedHarm = entry.avoidedHarm;
    _gaveCharity = entry.gaveCharity;
    _quranRead = entry.quranRead;
    _noteController.text = entry.note ?? '';
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('المحاسبة اليومية'),
            bottom: TabBar(
              indicatorColor: scheme.primary,
              labelColor: scheme.primary,
              unselectedLabelColor: scheme.onSurfaceVariant,
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  icon: Icon(Icons.edit_note_rounded, size: 20),
                  text: 'محاسبة اليوم',
                ),
                Tab(
                  icon: Icon(Icons.history_rounded, size: 20),
                  text: 'السجل والتدبر',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildTodayView(),
              _buildHistoryView(context, theme, scheme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayView() {
    final muhasabaAsync = ref.watch(todayMuhasabaProvider);

    return muhasabaAsync.when(
      data: (entry) {
        _seedStateFromEntry(entry);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'سجل اليوم كما كان فعلًا، لا كما كنت تتمنى أن يكون. الهدف هو الصدق مع النفس لا المثالية.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.7,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _MuhasabaSwitch(
              title: 'حافظت على الصلاة في وقتها قدر استطاعتي',
              icon: Icons.mosque_outlined,
              value: _prayed,
              onChanged: (value) => setState(() => _prayed = value),
            ),
            _MuhasabaSwitch(
              title: 'حفظت لساني من الغيبة والأذى',
              icon: Icons.record_voice_over_outlined,
              value: _guardedTongue,
              onChanged: (value) => setState(() => _guardedTongue = value),
            ),
            _MuhasabaSwitch(
              title: 'أحسنت إلى والدي أو من له حق قريب',
              icon: Icons.favorite_border_rounded,
              value: _honoredParents,
              onChanged: (value) => setState(() => _honoredParents = value),
            ),
            _MuhasabaSwitch(
              title: 'تجنبت ظلم أحد أو أذيته',
              icon: Icons.shield_outlined,
              value: _avoidedHarm,
              onChanged: (value) => setState(() => _avoidedHarm = value),
            ),
            _MuhasabaSwitch(
              title: 'تصدقت أو فرجت كربة ولو بالقليل',
              icon: Icons.volunteer_activism_outlined,
              value: _gaveCharity,
              onChanged: (value) => setState(() => _gaveCharity = value),
            ),
            _MuhasabaSwitch(
              title: 'قرأت وردي من القرآن الكريم بتدبر',
              icon: Icons.menu_book_outlined,
              value: _quranRead,
              onChanged: (value) => setState(() => _quranRead = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'خاطرة أو توبة أو عهد لنفسك اليوم',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSaving
                  ? null
                  : () async {
                      setState(() => _isSaving = true);
                      try {
                        await ref.read(completionActionsProvider).saveMuhasaba(
                              prayed: _prayed,
                              guardedTongue: _guardedTongue,
                              honoredParents: _honoredParents,
                              avoidedHarm: _avoidedHarm,
                              gaveCharity: _gaveCharity,
                              quranRead: _quranRead,
                              note: _noteController.text,
                            );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم حفظ محاسبة اليوم بنجاح.'),
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _isSaving = false);
                        }
                      }
                    },
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('حفظ المحاسبة'),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('تعذر تحميل المحاسبة: $error')),
    );
  }

  Widget _buildHistoryView(
    BuildContext context,
    ThemeData theme,
    ColorScheme scheme,
    bool isDark,
  ) {
    final allEntriesAsync = ref.watch(allMuhasabaEntriesProvider);

    return allEntriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_edu_rounded,
                    size: 64,
                    color: scheme.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا يوجد سجل سابق بعد',
                    style: GoogleFonts.amiri(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'كل يوم تدوّنه في محاسبة النفس يُحفظ هنا، ليكون لك مرآة صادقة وسندًا على الاستمرار.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final fulfilledCount = [
              entry.prayed,
              entry.guardedTongue,
              entry.honoredParents,
              entry.avoidedHarm,
              entry.gaveCharity,
              entry.quranRead,
            ].where((b) => b).length;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : const Color(0xFF1C443B).withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.primaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                entry.activityDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: fulfilledCount >= 4
                                ? scheme.primary.withValues(alpha: 0.15)
                                : scheme.outline.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$fulfilledCount من 6 خصال',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: fulfilledCount >= 4
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _DeedBadge(
                          title: 'الصلاة',
                          isDone: entry.prayed,
                          icon: Icons.mosque_outlined,
                        ),
                        _DeedBadge(
                          title: 'اللسان',
                          isDone: entry.guardedTongue,
                          icon: Icons.record_voice_over_outlined,
                        ),
                        _DeedBadge(
                          title: 'الوالدان',
                          isDone: entry.honoredParents,
                          icon: Icons.favorite_border_rounded,
                        ),
                        _DeedBadge(
                          title: 'دفع الأذى',
                          isDone: entry.avoidedHarm,
                          icon: Icons.shield_outlined,
                        ),
                        _DeedBadge(
                          title: 'الصدقة',
                          isDone: entry.gaveCharity,
                          icon: Icons.volunteer_activism_outlined,
                        ),
                        _DeedBadge(
                          title: 'القرآن',
                          isDone: entry.quranRead,
                          icon: Icons.menu_book_outlined,
                        ),
                      ],
                    ),
                    if (entry.note != null && entry.note!.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          entry.note!,
                          style: GoogleFonts.amiri(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: scheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('تعذر تحميل السجل: $err')),
    );
  }
}

class _DeedBadge extends StatelessWidget {
  final String title;
  final bool isDone;
  final IconData icon;

  const _DeedBadge({
    required this.title,
    required this.isDone,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDone
            ? scheme.primary.withValues(alpha: 0.1)
            : scheme.outline.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDone
              ? scheme.primary.withValues(alpha: 0.35)
              : scheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: isDone ? scheme.primary : scheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
              color: isDone ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MuhasabaSwitch extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MuhasabaSwitch({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: value
            ? scheme.primaryContainer.withValues(alpha: 0.35)
            : scheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: value
                  ? scheme.primary.withValues(alpha: 0.4)
                  : scheme.outline,
              width: 1.0,
            ),
          ),
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(
              icon,
              color: value ? scheme.primary : scheme.onSurfaceVariant,
              size: 22,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: value ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
                color: scheme.onSurface,
              ),
            ),
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
