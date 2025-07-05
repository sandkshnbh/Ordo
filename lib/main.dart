import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordo/app.dart';
import 'package:ordo/providers/task_provider.dart';
import 'package:ordo/services/task_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ordo/providers/locale_provider.dart';
import 'package:ordo/providers/strike_style_provider.dart';
import 'package:ordo/providers/card_customization_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and Path Provider
  await Hive.initFlutter();

  // The TaskService now handles adapter registration
  final taskService = TaskService();
  await taskService.init();

  // Initialize localization for dates
  await initializeDateFormatting('ar', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider(taskService)),
        ChangeNotifierProvider(create: (_) => StrikeStyleProvider()),
        ChangeNotifierProvider(create: (_) => CardCustomizationProvider()),
      ],
      child: const OrdoApp(),
    ),
  );
}
