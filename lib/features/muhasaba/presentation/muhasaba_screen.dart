import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/features/home/providers/home_providers.dart';

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
    final muhasabaAsync = ref.watch(todayMuhasabaProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المحاسبة اليومية')),
        body: muhasabaAsync.when(
          data: (entry) {
            _seedStateFromEntry(entry);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
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
                  title: 'قدمت صدقة أو نفعًا عمليًا',
                  icon: Icons.volunteer_activism_outlined,
                  value: _gaveCharity,
                  onChanged: (value) => setState(() => _gaveCharity = value),
                ),
                _MuhasabaSwitch(
                  title: 'كان لي ورد من القرآن اليوم',
                  icon: Icons.menu_book_rounded,
                  value: _quranRead,
                  onChanged: (value) => setState(() => _quranRead = value),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _noteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظة وتأمل اليوم',
                    hintText: 'ما الذي تحتاج أن تصلحه أو تثبته غدًا؟',
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          setState(() => _isSaving = true);
                          await ref
                              .read(completionActionsProvider)
                              .saveMuhasaba(
                                prayed: _prayed,
                                guardedTongue: _guardedTongue,
                                honoredParents: _honoredParents,
                                avoidedHarm: _avoidedHarm,
                                gaveCharity: _gaveCharity,
                                quranRead: _quranRead,
                                note: _noteController.text,
                              );
                          if (mounted) {
                            setState(() => _isSaving = false);
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('تم حفظ محاسبة اليوم.'),
                              ),
                            );
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
        ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: value
              ? scheme.primaryContainer.withValues(alpha: 0.35)
              : scheme.surface,
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
    );
  }
}
