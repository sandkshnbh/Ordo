// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ordo/app.dart';
import 'package:ordo/providers/task_provider.dart';
import 'package:ordo/services/task_service.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    // We need to use a temporary directory for Hive to store its box during tests.
    final path = Directory.current.path;
    Hive.init(path);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk(); // Clean up the test boxes
  });

  // A helper function to create the app with all its providers
  Widget createTestApp(TaskService taskService) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(taskService),
      child: const OrdoApp(),
    );
  }

  testWidgets('App shows empty task list initially',
      (WidgetTester tester) async {
    final taskService = TaskService();
    await taskService.init(); // This registers adapters and opens the box
    await taskService.clearAllTasks();

    // Build our app and trigger a frame.
    await tester.pumpWidget(createTestApp(taskService));

    // pumpAndSettle waits for all animations and async tasks to complete.
    await tester.pumpAndSettle();

    // Verify that app title is rendered
    expect(find.text('مهامي'), findsOneWidget);

    // Verify that the 'no tasks' message is shown
    expect(find.text('لا توجد مهام حاليًا'), findsOneWidget);

    // Verify there's a floating action button
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Adding a task displays it on the home screen',
      (WidgetTester tester) async {
    final taskService = TaskService();
    await taskService.init();
    await taskService.clearAllTasks();

    // Build our app
    await tester.pumpWidget(createTestApp(taskService));
    await tester.pumpAndSettle();

    // Tap the '+' icon to open the add task sheet
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify the sheet is open
    expect(find.text('إضافة مهمة جديدة'), findsOneWidget);

    // Enter task details
    await tester.enterText(
        find.widgetWithText(TextFormField, 'العنوان'), 'مهمة اختبار');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'الوصف (اختياري)'),
        'وصف مهمة اختبار');

    // Tap the save button
    await tester.tap(find.text('حفظ المهمة'));
    await tester.pumpAndSettle();

    // Verify the sheet is closed
    expect(find.text('إضافة مهمة جديدة'), findsNothing);

    // Verify the new task is displayed
    expect(find.text('مهمة اختبار'), findsOneWidget);
    expect(find.text('وصف مهمة اختبار'), findsOneWidget);
  });
}
