class Reminder {
  final int id;
  final String title;
  final String description;
  final String priority;
  final DateTime dateTime;
  final bool isSwitchOn;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    required this.isSwitchOn,
  });

  Reminder copyWith({
    int? id,
    String? title,
    String? description,
    String? priority,
    DateTime? dateTime,
    bool? isSwitchOn,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dateTime: dateTime ?? this.dateTime,
      isSwitchOn: isSwitchOn ?? this.isSwitchOn,
    );
  }
}
