import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/core/memory/memory_providers.dart';
import 'package:midrar/core/memory/memory_thread_repository.dart';

class CaptureSource {
  final SourceReference reference;
  final String displayText;

  const CaptureSource({required this.reference, required this.displayText});
}

class CaptureService {
  CaptureService(
    this._repository, {
    DateTime Function()? now,
    String Function(String threadId)? reflectionIdGenerator,
  }) : _now = now ?? DateTime.now,
       _reflectionIdGenerator = reflectionIdGenerator ?? _defaultReflectionId;

  final MemoryThreadRepository _repository;
  final DateTime Function() _now;
  final String Function(String threadId)? _reflectionIdGenerator;

  Future<MemoryThread> capture({
    required CaptureSource source,
    UserContextKind? contextKind,
    String? privateNote,
  }) async {
    final now = _now();
    final thread = await _repository.createThread(
      source: source.reference,
      context: contextKind == null ? null : UserContext(kind: contextKind),
    );

    final note = privateNote?.trim();
    if (note != null && note.isNotEmpty) {
      await _repository.saveReflection(
        ReflectionEntry(
          id: _reflectionIdGenerator!(thread.id),
          threadId: thread.id,
          body: note,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    return thread;
  }
}

String _defaultReflectionId(String threadId) =>
    'reflection-$threadId-${DateTime.now().microsecondsSinceEpoch}';

final captureServiceProvider = Provider<CaptureService>((ref) {
  return CaptureService(ref.watch(memoryThreadRepositoryProvider));
});

Future<MemoryThread?> showCaptureSheet(
  BuildContext context, {
  required CaptureSource source,
}) {
  return showModalBottomSheet<MemoryThread>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => CaptureSheet(source: source),
  );
}

class CaptureSheet extends ConsumerStatefulWidget {
  final CaptureSource source;

  const CaptureSheet({super.key, required this.source});

  @override
  ConsumerState<CaptureSheet> createState() => _CaptureSheetState();
}

class _CaptureSheetState extends ConsumerState<CaptureSheet> {
  final _noteController = TextEditingController();
  UserContextKind? _contextKind;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final thread = await ref
          .read(captureServiceProvider)
          .capture(
            source: widget.source,
            contextKind: _contextKind,
            privateNote: _noteController.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop(thread);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تعذر حفظ الخاطرة: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final reference = widget.source.reference;
    final sourceDetails = [
      reference.sourceBook,
      reference.sourceCitation,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'تدوين خاطر',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'من المصدر',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reference.sourceLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      if (sourceDetails.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          sourceDetails,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.right,
                        ),
                      ],
                      const SizedBox(height: 12),
                      SelectableText(
                        widget.source.displayText,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'سياق العودة (اختياري)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _contextChip(
                      context,
                      UserContextKind.returnTo,
                      'أعود إليه',
                    ),
                    _contextChip(
                      context,
                      UserContextKind.continueLater,
                      'أكمله لاحقًا',
                    ),
                    _contextChip(
                      context,
                      UserContextKind.quietReading,
                      'قراءة هادئة',
                    ),
                    _contextChip(
                      context,
                      UserContextKind.applyLater,
                      'أطبقه لاحقًا',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _noteController,
                  minLines: 2,
                  maxLines: 4,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظة خاصة (اختيارية)',
                    hintText: 'ما الذي تريد أن تتذكره عند العودة؟',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ملاحظتك خاصة بك ولا تصبح جزءًا من المصدر.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _capture,
                  icon: _isSaving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.bookmark_add_outlined),
                  label: Text(_isSaving ? 'جارٍ الحفظ...' : 'حفظ الخاطرة الآن'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contextChip(
    BuildContext context,
    UserContextKind kind,
    String label,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: _contextKind == kind,
      onSelected: _isSaving
          ? null
          : (selected) {
              setState(() => _contextKind = selected ? kind : null);
            },
    );
  }
}
