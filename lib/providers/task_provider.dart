import 'package:flutter/foundation.dart';
import 'package:ordo/models/task_model.dart';
import 'package:ordo/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService;
  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _filter; // e.g., 'completed', 'active'

  TaskProvider(this._taskService) {
    loadTasks();
  }

  List<Task> get tasks {
    if (_filter == 'completed') {
      return _tasks.where((task) => task.isCompleted).toList();
    }
    if (_filter == 'active') {
      return _tasks.where((task) => !task.isCompleted).toList();
    }
    return _tasks;
  }

  List<Task> get activeTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _setLoading(true);
    _tasks = _taskService.getTasks();
    _sortTasks();
    _setLoading(false);
  }

  Future<void> addTask(String title, String content, Priority priority,
      [int? color]) async {
    final newTask = Task.create(
        title: title, content: content, priority: priority, color: color);
    await _taskService.addTask(newTask);
    await loadTasks();
    notifyListeners();
  }

  Future<void> addVoiceTask(
      String title, String audioPath, Priority priority) async {
    final newTask = Task.createVoiceTask(
      title: title,
      audioPath: audioPath,
      priority: priority,
    );
    await _taskService.addTask(newTask);
    await loadTasks();
    notifyListeners();
  }

  Future<void> updateTask(
      Task task, String title, String content, Priority priority,
      [int? color]) async {
    task.title = title;
    task.content = content;
    task.priority = priority;
    if (color != null) task.color = color;
    await _taskService.updateTask(task);
    await loadTasks();
    notifyListeners();
  }

  Future<void> toggleTaskCompleted(String id) async {
    // First, tell the service to update the task in the database.
    await _taskService.toggleTaskCompleted(id);

    // Then, get the freshly sorted list from the service.
    // This ensures the completed task moves to the correct position.
    _tasks = _taskService.getTasks();

    // Finally, notify all listeners to rebuild the UI with the new data.
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void setFilter(String? filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> togglePinTask(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId,
        orElse: () =>
            Task(id: '', title: '', content: '', creationDate: DateTime.now()));
    if (task.id.isNotEmpty) {
      task.isPinned = !task.isPinned;
      await task.save();
      _sortTasks();
      notifyListeners();
    }
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.creationDate.compareTo(a.creationDate);
    });
  }
}
