import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';
import 'package:ordo/common/localization/locale_cubit.dart';
import 'package:ordo/features/home/home_page.dart';
import 'package:ordo/features/welcome/pages/welcome_page.dart';
import 'package:ordo/features/update/widgets/update_dialog.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state;

    return BlocBuilder<ThemeModeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<DynamicColorCubit, bool>(
          builder: (context, dynamicColorEnabled) {
            return BlocBuilder<AmoledModeCubit, bool>(
              builder: (context, amoled) {
                return BlocBuilder<SpecialThemeCubit, bool>(
                  builder: (context, specialTheme) {
                    return BlocBuilder<SkipWelcomeCubit, bool>(
                      builder: (context, skipWelcome) {
                        if (dynamicColorEnabled && !specialTheme) {
                          return MaterialThemes.buildDynamicColorTheme(
                            builder: (lightDynamic, darkDynamic) {
                              return MaterialApp(
                                title: AppValues.title,
                                locale: locale,
                                localizationsDelegates: const [
                                  AppLocalizationsDelegate(),
                                  GlobalMaterialLocalizations.delegate,
                                  GlobalWidgetsLocalizations.delegate,
                                  GlobalCupertinoLocalizations.delegate,
                                ],
                                supportedLocales: const [
                                  Locale('en'),
                                  Locale('ar'),
                                  Locale('ru'),
                                  Locale('ko'),
                                  Locale('fa'),
                                  Locale('es'),
                                  Locale('id'),
                                  Locale('vi'),
                                  Locale('zh'),
                                  Locale('es', 'MX'),
                                  Locale('pt', 'BR'),
                                  Locale('fil'),
                                  Locale('ur'),
                                  Locale('si'),
                                  Locale('pl'),
                                ],
                                debugShowCheckedModeBanner: false,
                                themeMode: themeMode,
                                theme: ThemeData(
                                  colorScheme: lightDynamic,
                                  useMaterial3: true,
                                  textTheme: ThemeData(
                                    brightness: Brightness.light,
                                  ).textTheme,
                                  pageTransitionsTheme:
                                      const PageTransitionsTheme(
                                    builders: {
                                      .android:
                                          FadeForwardsPageTransitionsBuilder(),
                                      .iOS:
                                          FadeForwardsPageTransitionsBuilder(),
                                    },
                                  ),
                                ),
                                darkTheme: ThemeData(
                                  colorScheme: amoled
                                      ? darkDynamic.copyWith(
                                          surface: Colors.black,
                                        )
                                      : darkDynamic,
                                  scaffoldBackgroundColor: amoled
                                      ? Colors.black
                                      : null,
                                  useMaterial3: true,
                                  textTheme: ThemeData.dark().textTheme,
                                  pageTransitionsTheme:
                                      const PageTransitionsTheme(
                                    builders: {
                                      .android:
                                          FadeForwardsPageTransitionsBuilder(),
                                      .iOS:
                                          FadeForwardsPageTransitionsBuilder(),
                                    },
                                  ),
                                ),
                                builder: _mediaQueryBuilder,
                                home: skipWelcome
                                    ? const UpdateDialog(child: HomePage())
                                    : const UpdateDialog(child: WelcomePage()),
                              );
                            },
                          );
                        }

                        return MaterialApp(
                          title: AppValues.title,
                          locale: locale,
                          localizationsDelegates: const [
                            AppLocalizationsDelegate(),
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                          ],
                          supportedLocales: const [
                            Locale('en'),
                            Locale('ar'),
                            Locale('ru'),
                            Locale('ko'),
                            Locale('fa'),
                            Locale('es'),
                            Locale('id'),
                            Locale('vi'),
                            Locale('zh'),
                            Locale('es', 'MX'),
                            Locale('pt', 'BR'),
                            Locale('fil'),
                            Locale('ur'),
                            Locale('si'),
                            Locale('pl'),
                          ],
                          debugShowCheckedModeBanner: false,
                          themeMode: themeMode,
                          theme: MaterialThemes.light(
                            dynamicColor: false,
                            specialTheme: specialTheme,
                          ),
                          darkTheme: MaterialThemes.dark(
                            dynamicColor: false,
                            amoled: amoled,
                            specialTheme: specialTheme,
                          ),
                          builder: _mediaQueryBuilder,
                          home: skipWelcome
                              ? const UpdateDialog(child: HomePage())
                              : const UpdateDialog(child: WelcomePage()),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

Widget _mediaQueryBuilder(BuildContext context, Widget? child) {
  final MediaQueryData mediaQueryData = MediaQuery.of(context);
  return MediaQuery(
    data: mediaQueryData.copyWith(
      textScaler: mediaQueryData.textScaler.clamp(maxScaleFactor: 1.1),
    ),
    child: child!,
  );
}
