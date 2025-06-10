import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/localization.dart';
import 'package:ordo/services/notification_service.dart';

/// A screen for adding a new task or editing an existing one.
///
/// This widget is stateful to manage the form's input controllers and state.
class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final int? index;

  const AddTaskScreen({
    Key? key,
    this.task,
    this.index,
  }) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>
    with SingleTickerProviderStateMixin {
  // Global key to uniquely identify the Form widget and allow validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields to manage their content.
  late final TextEditingController _titleController;

  // State variable for the high priority switch.
  late TaskPriority _priority;

  DateTime? _reminderTime;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _reminderTime = widget.task?.reminderTime;

    _controller.forward();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectReminderTime() async {
    if (!mounted) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (!mounted) return;

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (!mounted) return;

      if (time != null) {
        setState(() {
          _reminderTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  /// Validates the form and saves the task.
  /// It either creates a new task or updates an existing one.
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = context.read<TaskProvider>();
      final task = Task(
        id: widget.task?.id,
        title: _titleController.text,
        priority: _priority,
        reminderTime: _reminderTime,
      );

      if (widget.task == null) {
        taskProvider.addTask(task);
        if (_reminderTime != null) {
          NotificationService().showNotification(
            id: task.id.hashCode,
            title: task.title,
            body: Localization.tr('task_reminder'),
            scheduledDate: _reminderTime,
          );
        }
      } else {
        final index = taskProvider.tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          taskProvider.updateTask(index, task);
          if (_reminderTime != null) {
            NotificationService().showNotification(
              id: task.id.hashCode,
              title: task.title,
              body: Localization.tr('task_reminder'),
              scheduledDate: _reminderTime,
            );
          } else {
            NotificationService().cancelNotification(task.id.hashCode);
          }
        }
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF313131),
      appBar: AppBar(
        backgroundColor: const Color(0xFF313131),
        elevation: 0,
        title: Text(
          widget.task != null
              ? Localization.tr('edit_task')
              : Localization.tr('add_task'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SK',
          ),
        ),
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF313131),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF6F6F6F),
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: _titleController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'SK',
                      ),
                      decoration: InputDecoration(
                        hintText: Localization.tr('task_title_hint'),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontFamily: 'SK',
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Localization.tr('task_title_required');
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Localization.tr('priority'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SegmentedButton<TaskPriority>(
                        segments: [
                          ButtonSegment<TaskPriority>(
                            value: TaskPriority.low,
                            label: Text(Localization.tr('low_priority')),
                          ),
                          ButtonSegment<TaskPriority>(
                            value: TaskPriority.medium,
                            label: Text(Localization.tr('normal_priority')),
                          ),
                          ButtonSegment<TaskPriority>(
                            value: TaskPriority.high,
                            label: Text(Localization.tr('high_priority')),
                          ),
                        ],
                        selected: {_priority},
                        onSelectionChanged: (Set<TaskPriority> selected) {
                          setState(() {
                            _priority = selected.first;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color(0xFFB2FF59);
                              }
                              return const Color(0xFF6F6F6F);
                            },
                          ),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return Colors.black;
                              }
                              return Colors.white;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Localization.tr('reminder'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _selectReminderTime,
                        icon: Icon(
                          _reminderTime != null
                              ? FontAwesomeIcons.bell
                              : FontAwesomeIcons.bellSlash,
                          color: _reminderTime != null
                              ? const Color(0xFFB2FF59)
                              : const Color(0xFF6F6F6F),
                        ),
                      ),
                      if (_reminderTime != null)
                        Text(
                          '${_reminderTime!.day}/${_reminderTime!.month}/${_reminderTime!.year} ${_reminderTime!.hour}:${_reminderTime!.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Color(0xFF6F6F6F),
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB2FF59),
                        foregroundColor: const Color(0xFF313131),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        widget.task != null
                            ? Localization.tr('update')
                            : Localization.tr('add'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
