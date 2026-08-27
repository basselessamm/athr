/// Conservative repetition & time-marker parsing for azkar.
///
/// Philosophy (unchanged from v1): the UI must never invent a religious
/// count. Counts are recognised ONLY inside explicit parenthetical
/// annotations present in the source text (e.g. "( ثلاث مرات )",
/// "( مائة مرة إذا أصبح )"). Prose without such annotations yields no
/// prescribed target. Time markers are read only from explicit words in the
/// text itself (أصبح/أمسى/الصباح/المساء...).
///
/// Vendored philosophy kept from the original parser; extended for the
/// per-zikr data model (schema v8).
library;

enum ZikrTimeMarker { morning, evening }

class ZikrRepetition {
  const ZikrRepetition.explicit(
    this.target, {
    this.label,
    this.marker,
  }) : isExplicitInText = true;

  const ZikrRepetition.unspecified({this.label, this.marker})
    : target = 1,
      isExplicitInText = false;

  /// How many times the source prescribes. 1 when no explicit count exists.
  final int target;

  /// True when the count was found in an explicit parenthetical annotation.
  final bool isExplicitInText;

  /// The raw annotation text, shown verbatim in the UI (e.g.
  /// "مائة مرة إذا أصبح") so nothing is paraphrased away.
  final String? label;

  /// Time marker derived from explicit words in the text/annotation.
  final ZikrTimeMarker? marker;
}

final RegExp _parenGroups = RegExp(r'\(([^)]*)\)');

ZikrRepetition parseZikrRepetition(String text) {
  ZikrRepetition? best;
  for (final match in _parenGroups.allMatches(text)) {
    final group = match.group(1)?.trim() ?? '';
    if (group.isEmpty) continue;
    final parsed = _parseGroup(group);
    if (parsed == null) continue;
    // Prefer the first explicit count found in reading order.
    if (best == null || (!best.isExplicitInText && parsed.isExplicitInText)) {
      best = parsed;
    }
  }
  best ??= ZikrRepetition.unspecified(label: null, marker: _bodyMarker(text));
  // A body-level marker still matters when the annotation had none.
  if (best.marker == null) {
    final bodyMarker = _bodyMarker(text);
    if (bodyMarker != null) {
      return best.isExplicitInText
          ? ZikrRepetition.explicit(
              best.target,
              label: best.label,
              marker: bodyMarker,
            )
          : ZikrRepetition.unspecified(label: best.label, marker: bodyMarker);
    }
  }
  return best;
}

ZikrRepetition? _parseGroup(String group) {
  final normalized = _normalize(group);

  // Conservative guard: alternatives like "( أو مرة واحدة عند الكسل )" are
  // not a prescribed count — the source offers an option, not a rule.
  if (normalized.startsWith('او ') || normalized.contains(' او ')) {
    return ZikrRepetition.unspecified(label: group);
  }

  final count = _countFromWords(normalized);
  if (count == null) {
    // Annotation without a count (e.g. "( عند النوم )") — no target, but the
    // group may still carry a time qualifier.
    return ZikrRepetition.unspecified(label: group, marker: _qualifierMarker(normalized));
  }
  return ZikrRepetition.explicit(
    count,
    label: group,
    marker: _qualifierMarker(normalized),
  );
}

int? _countFromWords(String normalized) {
  if (!normalized.contains('مرة') && !normalized.contains('مرات') && !normalized.contains('تسبيحة')) {
    return null;
  }
  if (RegExp(r'مائة|ميئة|100').hasMatch(normalized)) return 100;
  if (RegExp(r'(?<![0-9])عشر|(?<![0-9])10').hasMatch(normalized)) return 10;
  if (RegExp(r'سبع|(?<![0-9])7').hasMatch(normalized)) return 7;
  if (RegExp(r'اربع|أربع|(?<![0-9])4').hasMatch(normalized)) return 4;
  if (RegExp(r'ثلاث|(?<![0-9])3').hasMatch(normalized)) return 3;
  if (RegExp(r'مرة\s+واحدة').hasMatch(normalized)) return 1;
  if (RegExp(r'مرة|مرات').hasMatch(normalized)) return 1;
  return null;
}

ZikrTimeMarker? _qualifierMarker(String normalized) {
  if (RegExp(r'اصبح|أصبح|الصباح|بكرة').hasMatch(normalized)) {
    return ZikrTimeMarker.morning;
  }
  if (RegExp(r'امسى|أمسى|المساء|ليل').hasMatch(normalized)) {
    return ZikrTimeMarker.evening;
  }
  return null;
}

ZikrTimeMarker? _bodyMarker(String text) {
  final hasMorning = RegExp(r'اصبحت|اصبح|أصبحت|أصبح|الصباح|بكرة').hasMatch(text);
  final hasEvening = RegExp(r'امسيت|امسى|أمسيت|أمسى|المساء|ليل').hasMatch(text);
  if (hasMorning && !hasEvening) return ZikrTimeMarker.morning;
  if (hasEvening && !hasMorning) return ZikrTimeMarker.evening;
  return null; // both or neither → valid at both times
}

String _normalize(String value) {
  return value
      .replaceAll(RegExp(r'[أإآ]'), 'ا')
      .replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
