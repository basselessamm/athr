class SearchResultEntity {
  final int id;
  final String featureType;
  final int referenceId;
  final int? secondaryId;
  final String? title;
  final String content;
  final double rankScore;

  SearchResultEntity({
    required this.id,
    required this.featureType,
    required this.referenceId,
    this.secondaryId,
    this.title,
    required this.content,
    this.rankScore = 0.0,
  });

  SearchResultEntity copyWith({
    int? id,
    String? featureType,
    int? referenceId,
    int? secondaryId,
    String? title,
    String? content,
    double? rankScore,
  }) {
    return SearchResultEntity(
      id: id ?? this.id,
      featureType: featureType ?? this.featureType,
      referenceId: referenceId ?? this.referenceId,
      secondaryId: secondaryId ?? this.secondaryId,
      title: title ?? this.title,
      content: content ?? this.content,
      rankScore: rankScore ?? this.rankScore,
    );
  }
}
