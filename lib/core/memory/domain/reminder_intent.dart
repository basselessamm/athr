class ReminderIntent {
  final String id;
  final String threadId;
  final DateTime scheduledAt;
  final bool enabled;

  const ReminderIntent({
    required this.id,
    required this.threadId,
    required this.scheduledAt,
    this.enabled = true,
  }) : assert(id != ''),
       assert(threadId != '');

  ReminderIntent copyWith({DateTime? scheduledAt, bool? enabled}) {
    return ReminderIntent(
      id: id,
      threadId: threadId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      enabled: enabled ?? this.enabled,
    );
  }
}
