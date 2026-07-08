import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

enum ChallengeType { daily, weekly, monthly }

class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final bool isCompleted;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.isCompleted = false,
  });

  Challenge copyWith({bool? isCompleted}) {
    return Challenge(
      id: id,
      title: title,
      description: description,
      type: type,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

final staticChallenges = <Challenge>[
  const Challenge(
    id: 'c1',
    title: 'قراءة سورة الكهف',
    description: 'قراءة سورة الكهف يوم الجمعة تنير لك ما بين الجمعتين.',
    type: ChallengeType.weekly,
  ),
  const Challenge(
    id: 'c2',
    title: 'صيام الإثنين والخميس',
    description: 'ترفع الأعمال فيها ويحب النبي ﷺ أن يرفع عمله وهو صائم.',
    type: ChallengeType.weekly,
  ),
  const Challenge(
    id: 'c3',
    title: 'صيام الأيام البيض',
    description: 'صيام 13، 14، 15 من كل شهر هجري كصيام الدهر.',
    type: ChallengeType.monthly,
  ),
  const Challenge(
    id: 'c4',
    title: 'أذكار الصباح والمساء',
    description: 'حصن المسلم وراحة قلبه، حافظ عليها كل يوم.',
    type: ChallengeType.daily,
  ),
  const Challenge(
    id: 'c5',
    title: 'ختم القرآن الكريم',
    description: 'تلاوة جزء واحد يومياً لختم القرآن في شهر.',
    type: ChallengeType.monthly,
  ),
  const Challenge(
    id: 'c6',
    title: 'قيام الليل',
    description: 'ركعتان في جوف الليل خير من الدنيا وما فيها.',
    type: ChallengeType.daily,
  ),
];

class ChallengesNotifier extends StateNotifier<List<Challenge>> {
  final SharedPreferences _prefs;

  ChallengesNotifier(this._prefs) : super(_loadChallenges(_prefs));

  static List<Challenge> _loadChallenges(SharedPreferences prefs) {
    return staticChallenges.map((c) {
      final isCompleted = prefs.getBool('challenge_${c.id}') ?? false;
      return c.copyWith(isCompleted: isCompleted);
    }).toList();
  }

  void toggleChallenge(String id) {
    final index = state.indexWhere((c) => c.id == id);
    if (index != -1) {
      final challenge = state[index];
      final newStatus = !challenge.isCompleted;

      _prefs.setBool('challenge_$id', newStatus);

      state = [
        ...state.sublist(0, index),
        challenge.copyWith(isCompleted: newStatus),
        ...state.sublist(index + 1),
      ];
    }
  }
}

final challengesProvider =
    StateNotifierProvider<ChallengesNotifier, List<Challenge>>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return ChallengesNotifier(prefs);
    });
