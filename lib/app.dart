import 'package:flutter/material.dart';
import 'package:ordo/screens/home_screen.dart';
import 'package:ordo/screens/settings_screen.dart';
import 'package:ordo/core/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ordo/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ordo/providers/locale_provider.dart';
import 'dart:ui' as ui;

class OrdoApp extends StatelessWidget {
  const OrdoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    // تهيئة اللغة حسب لغة الجهاز إذا لم يتم تعيينها
    WidgetsBinding.instance.addPostFrameCallback((_) {
      localeProvider.setInitialLocale(
        const [
          Locale('ar'),
          Locale('en'),
          Locale('ko'),
          Locale('zh'),
          Locale('ru'),
          Locale('tr'),
          Locale('es'),
          Locale('pl'),
          Locale('fa'),
        ],
        ui.PlatformDispatcher.instance.locale,
      );
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('ko'),
        Locale('zh'),
        Locale('ru'),
        Locale('tr'),
        Locale('es'),
        Locale('pl'),
        Locale('fa'),
      ],
      builder: (context, child) {
        // تحديد اتجاه النص تلقائياً حسب اللغة
        final locale = Localizations.localeOf(context);
        final rtlLanguages = ['ar', 'he', 'fa', 'ur'];
        final isRtl = rtlLanguages.contains(locale.languageCode);
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}

class MultiScreenApp extends StatefulWidget {
  const MultiScreenApp({super.key});

  @override
  State<MultiScreenApp> createState() => _MultiScreenAppState();
}

class _MultiScreenAppState extends State<MultiScreenApp> {
  final int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SettingsScreen(),
  ];

  void _onFabPressed() {
    // استخدم GlobalKey أو أي منطق لفتح نافذة إضافة المهام من هنا
    // أو يمكنك استخدام showModalBottomSheet أو أي نافذة مناسبة
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const HomeScreen(openAddTask: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// شاشة البداية SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MultiScreenApp()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Ordo',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
