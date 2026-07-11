class PrayerLocation {
  final double latitude;
  final double longitude;
  final String timeZoneId;
  final String? label;

  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    required this.timeZoneId,
    this.label,
  });

  PrayerLocation copyWith({
    double? latitude,
    double? longitude,
    String? timeZoneId,
    String? label,
  }) {
    return PrayerLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      label: label ?? this.label,
    );
  }

  String get displayLabel {
    final trimmed = label?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      return trimmed;
    }
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timeZoneId': timeZoneId,
      'label': label,
    };
  }

  factory PrayerLocation.fromMap(Map<String, dynamic> map) {
    return PrayerLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      timeZoneId: map['timeZoneId'] as String,
      label: map['label'] as String?,
    );
  }
}
