import 'dart:convert';

class AppEvent {
  final String title;
  final String id;
  final String description;
  final String userId;
  final DateTime dateTime;
  AppEvent({
    this.title,
    this.id,
    this.description,
    this.userId,
    this.dateTime,
  });

  AppEvent copyWith({
    String title,
    String id,
    String description,
    String userId,
    DateTime dateTime,
  }) {
    return AppEvent(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'userId': userId,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory AppEvent.fromMap(Map<String, dynamic> map) {
    return AppEvent(
      title: map['title'],
      id: map['id'],
      description: map['description'],
      userId: map['userId'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }

  factory AppEvent.fromDS(String id, Map<String, dynamic> map) {
    return AppEvent(
      title: map['title'],
      id: id,
      description: map['description'],
      userId: map['userId'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppEvent.fromJson(String source) =>
      AppEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppEvent(title: $title, id: $id, description: $description, userId: $userId, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppEvent &&
        other.title == title &&
        other.id == id &&
        other.description == description &&
        other.userId == userId &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        id.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        dateTime.hashCode;
  }
}
