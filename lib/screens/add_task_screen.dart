import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ordo/models/task_model.dart';
import 'package:ordo/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:ordo/l10n/app_localizations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddTaskSheet extends StatefulWidget {
  final TaskProvider taskProvider;
  final VoidCallback onClose;
  final Task? editingTask;
  const AddTaskSheet({
    super.key,
    required this.taskProvider,
    required this.onClose,
    this.editingTask,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Priority _selectedPriority = Priority.normal;
  int? _selectedColor;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.editingTask != null) {
      _titleController.text = widget.editingTask!.title;
      _contentController.text = widget.editingTask!.content;
      _selectedPriority = widget.editingTask!.priority;
      _selectedColor = widget.editingTask!.color;
    }
  }

  void _submit() async {
    print('تم الضغط على زر حفظ');
    if (_formKey.currentState?.validate() != true) return;
    final title = _titleController.text;
    final content = _contentController.text;
    final priority = _selectedPriority;
    if (title.isEmpty || priority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.unexpected_error),
        ),
      );
      return;
    }
    if (widget.editingTask != null) {
      // تعديل مهمة موجودة
      await widget.taskProvider.updateTask(
        widget.editingTask!,
        title,
        content,
        priority,
        _selectedColor,
      );
    } else {
      // إضافة مهمة جديدة
      await widget.taskProvider.addTask(title, content, priority, _selectedColor);
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: 24 + keyboardPadding,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Text(
                    widget.editingTask != null
                        ? AppLocalizations.of(context)!.edit_task
                        : AppLocalizations.of(context)!.add_task,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.task_title,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? AppLocalizations.of(context)!.task_title
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.task_description,
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.blur_on),
                              tooltip: AppLocalizations.of(context)!
                                  .blur_selected_text,
                              onPressed: () {
                                final text = _contentController.text;
                                final selection = _contentController.selection;
                                if (selection.isValid &&
                                    selection.start != selection.end) {
                                  final before =
                                      text.substring(0, selection.start);
                                  final selected = text.substring(
                                      selection.start, selection.end);
                                  final after = text.substring(selection.end);
                                  final newText =
                                      '$before[spoiler]$selected[/spoiler]$after';
                                  _contentController.text = newText;
                                  _contentController.selection =
                                      TextSelection.collapsed(
                                          offset: before.length +
                                              '[spoiler]'.length +
                                              selected.length +
                                              '[/spoiler]'.length);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .select_text_first),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPrioritySelector(theme),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text('لون الكرت:', style: TextStyle(color: Colors.white, fontSize: 15)),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () async {
                                Color picked = _selectedColor != null ? Color(_selectedColor!) : Colors.blueAccent;
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.grey[900],
                                    title: const Text('اختر لون الكرت', style: TextStyle(color: Colors.white)),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: picked,
                                        onColorChanged: (color) => picked = color,
                                        enableAlpha: false,
                                        showLabel: false,
                                        pickerAreaHeightPercent: 0.7,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('تم', style: TextStyle(color: Colors.blueAccent)),
                                        onPressed: () {
                                          setState(() {
                                            _selectedColor = picked.value;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _selectedColor != null ? Color(_selectedColor!) : Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                            if (_selectedColor != null)
                              IconButton(
                                icon: Icon(Icons.clear, color: Colors.white70, size: 20),
                                tooltip: 'إزالة اللون',
                                onPressed: () => setState(() => _selectedColor = null),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Text(
                            widget.editingTask != null
                                ? AppLocalizations.of(context)!.edit_task
                                : AppLocalizations.of(context)!.save_task,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
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

  Widget _buildPrioritySelector(ThemeData theme) {
    return DropdownButtonFormField<Priority>(
      value: _selectedPriority,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.priority,
        border: OutlineInputBorder(),
      ),
      items: Priority.values.map((priority) {
        String label;
        switch (priority) {
          case Priority.urgent:
            label = AppLocalizations.of(context)!.urgent;
            break;
          case Priority.important:
            label = AppLocalizations.of(context)!.important;
            break;
          case Priority.normal:
          default:
            label = AppLocalizations.of(context)!.normal;
        }
        return DropdownMenuItem(
          value: priority,
          child: Text(label),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedPriority = value;
          });
        }
      },
    );
  }
}

// Function to be called from home_screen
Future<void> showAddTaskSheet(BuildContext context, TaskProvider provider,
    {Task? editingTask}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => AddTaskSheet(
      taskProvider: provider,
      onClose: () => Navigator.of(context).pop(),
      editingTask: editingTask,
    ),
  );
}
