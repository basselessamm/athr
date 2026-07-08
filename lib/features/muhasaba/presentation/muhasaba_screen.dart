import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/home/providers/home_providers.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('المحاسبة اليومية')),
      body: muhasabaAsync.when(
        data: (entry) {
          _seedStateFromEntry(entry);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'سجل اليوم كما كان فعلًا، لا كما كنت تتمنى أن يكون. الهدف هو الصدق مع النفس لا المثالية.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.7),
              ),
              const SizedBox(height: 16),
              _MuhasabaSwitch(
                title: 'حافظت على الصلاة في وقتها قدر استطاعتي',
                value: _prayed,
                onChanged: (value) => setState(() => _prayed = value),
              ),
              _MuhasabaSwitch(
                title: 'حفظت لساني من الغيبة والأذى',
                value: _guardedTongue,
                onChanged: (value) => setState(() => _guardedTongue = value),
              ),
              _MuhasabaSwitch(
                title: 'أحسنت إلى والدي أو من له حق قريب',
                value: _honoredParents,
                onChanged: (value) => setState(() => _honoredParents = value),
              ),
              _MuhasabaSwitch(
                title: 'تجنبت ظلم أحد أو أذيته',
                value: _avoidedHarm,
                onChanged: (value) => setState(() => _avoidedHarm = value),
              ),
              _MuhasabaSwitch(
                title: 'قدمت صدقة أو نفعًا عمليًا',
                value: _gaveCharity,
                onChanged: (value) => setState(() => _gaveCharity = value),
              ),
              _MuhasabaSwitch(
                title: 'كان لي ورد من القرآن اليوم',
                value: _quranRead,
                onChanged: (value) => setState(() => _quranRead = value),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'ملاحظة اليوم',
                  hintText: 'ما الذي تحتاج أن تصلحه أو تثبته غدًا؟',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
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
    );
  }
}

class _MuhasabaSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MuhasabaSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
