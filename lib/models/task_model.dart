import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  normal,

  @HiveField(1)
  important,

  @HiveField(2)
  urgent,
}

extension PriorityExtension on Priority {
  String get name {
    switch (this) {
      case Priority.urgent:
        return 'عاجلة';
      case Priority.important:
        return 'مهمة';
      case Priority.normal:
      default:
        return 'عادية';
    }
  }
}

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime creationDate;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  Priority priority;

  @HiveField(6)
  String? audioPath;

  @HiveField(7)
  bool isVoiceTask;

  @HiveField(8)
  bool isPinned;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    this.isCompleted = false,
    this.priority = Priority.normal,
    this.audioPath,
    this.isVoiceTask = false,
    this.isPinned = false,
  });

  factory Task.create(
      {required String title, required String content, Priority? priority}) {
    return Task(
      id: const Uuid().v4(),
      title: title,
      content: content,
      creationDate: DateTime.now(),
      priority: priority ?? Priority.normal,
      isPinned: false,
    );
  }

  factory Task.createVoiceTask({
    required String title,
    required String audioPath,
    Priority? priority,
  }) {
    return Task(
      id: const Uuid().v4(),
      title: title,
      content: 'مهمة صوتية',
      creationDate: DateTime.now(),
      priority: priority ?? Priority.normal,
      audioPath: audioPath,
      isVoiceTask: true,
      isPinned: false,
    );
  }
}
