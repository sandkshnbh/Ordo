import 'package:uuid/uuid.dart';

// Represents a single to-do item.
class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime? reminderTime;

  Task({
    String? id,
    required this.title,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
    this.reminderTime,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? reminderTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  bool get isHighPriority => priority == TaskPriority.high;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'priority': priority.index,
      'createdAt': createdAt.toIso8601String(),
      'reminderTime': reminderTime?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      priority: TaskPriority.values[json['priority'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'] as String)
          : null,
    );
  }
}

enum TaskPriority { low, medium, high }
