import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ordo/common/cubits/theme_mode_cubit.dart';
import 'package:ordo/common/localization/locale_cubit.dart';
import 'package:ordo/common/services/notification_service.dart';
import 'package:ordo/data/database.dart';
import 'package:ordo/features/chat/cubits/chat_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  locator.registerSingleton<SharedPreferences>(prefs);

  // Load saved theme preferences
  final savedThemeMode = prefs.getString('theme_mode') ?? 'system';
  final savedDynamicColor = prefs.getBool('dynamic_color') ?? false;
  final savedAmoledMode = prefs.getBool('amoled_mode') ?? false;
  final savedSpecialTheme = prefs.getBool('special_theme') ?? false;
  final savedSkipWelcome = prefs.getBool('skip_welcome') ?? false;
  final savedNotificationsEnabled =
      prefs.getBool('notifications_enabled') ?? true;
  final savedSendButtonSeparate =
      prefs.getBool('send_button_separate') ?? false;
  final savedSwipeToDelete = prefs.getBool('swipe_to_delete') ?? false;
  final savedCompactMode = prefs.getBool('compact_mode') ?? false;

  final savedLocaleTag = prefs.getString('locale') ?? 'en';
  late final Locale savedLocale;
  if (savedLocaleTag == LocaleCubit.systemTag) {
    savedLocale = LocaleCubit.systemLocale();
  } else {
    final parts = savedLocaleTag.split('-');
    savedLocale = parts.length == 1 ? Locale(parts[0]) : Locale(parts[0], parts[1]);
  }

  final ThemeMode themeMode;
  switch (savedThemeMode) {
    case 'light':
      themeMode = ThemeMode.light;
      break;
    case 'dark':
      themeMode = ThemeMode.dark;
      break;
    default:
      themeMode = ThemeMode.system;
  }

  locator.registerSingleton<ThemeModeCubit>(ThemeModeCubit(prefs, themeMode));
  locator.registerSingleton<DynamicColorCubit>(
    DynamicColorCubit(prefs, savedDynamicColor),
  );
  locator.registerSingleton<AmoledModeCubit>(
    AmoledModeCubit(prefs, savedAmoledMode),
  );
  locator.registerSingleton<SpecialThemeCubit>(
    SpecialThemeCubit(prefs, savedSpecialTheme),
  );
  locator.registerSingleton<SkipWelcomeCubit>(
    SkipWelcomeCubit(prefs, savedSkipWelcome),
  );
  locator.registerSingleton<NotificationsCubit>(
    NotificationsCubit(prefs, savedNotificationsEnabled),
  );
  locator.registerSingleton<SendButtonStyleCubit>(
    SendButtonStyleCubit(prefs, savedSendButtonSeparate),
  );
  locator.registerSingleton<SwipeToDeleteCubit>(
    SwipeToDeleteCubit(prefs, savedSwipeToDelete),
  );
  locator.registerSingleton<CompactModeCubit>(
    CompactModeCubit(prefs, savedCompactMode),
  );
  locator.registerSingleton<LocaleCubit>(
    LocaleCubit(prefs, savedLocale),
  );
  locator.registerSingleton<NotificationService>(NotificationService());
  locator.registerSingleton<AppDatabase>(AppDatabase());
  locator.registerSingleton<ChatCubit>(
    ChatCubit(locator<AppDatabase>(), locator<NotificationService>()),
  );
}
