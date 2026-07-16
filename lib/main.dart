import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ordo/common/common.dart';
import 'package:ordo/app.dart';
import 'package:ordo/common/localization/locale_cubit.dart';
import 'package:ordo/features/chat/cubits/chat_cubit.dart';
import 'package:ordo/features/update/cubits/update_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (details) => FriendlyErrorView(details: details);

  await setupLocator();

  // Initialize notification service
  await locator<NotificationService>().initialize();
  await locator<NotificationService>().requestPermissions();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<ThemeModeCubit>()),
        BlocProvider.value(value: locator<DynamicColorCubit>()),
        BlocProvider.value(value: locator<AmoledModeCubit>()),
        BlocProvider.value(value: locator<SpecialThemeCubit>()),
        BlocProvider.value(value: locator<SkipWelcomeCubit>()),
        BlocProvider.value(value: locator<NotificationsCubit>()),
        BlocProvider.value(value: locator<SendButtonStyleCubit>()),
        BlocProvider.value(value: locator<SwipeToDeleteCubit>()),
        BlocProvider.value(value: locator<CompactModeCubit>()),
        BlocProvider.value(value: locator<LocaleCubit>()),
        BlocProvider.value(value: locator<ChatCubit>()),
        BlocProvider(create: (_) => UpdateCubit()),
      ],
      child: const App(),
    ),
  );
}
