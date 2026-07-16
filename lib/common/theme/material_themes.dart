import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

const MaterialColor seedColor = MaterialColor(0xffF5A623, {});

const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    .android: FadeForwardsPageTransitionsBuilder(),
    .iOS: FadeForwardsPageTransitionsBuilder(),
  },
);

abstract final class MaterialThemes {
  static ThemeData light({
    bool dynamicColor = false,
    bool specialTheme = false,
  }) => _theme(
    Brightness.light,
    dynamicColor: dynamicColor,
    specialTheme: specialTheme,
  );

  static ThemeData dark({
    bool dynamicColor = false,
    bool amoled = false,
    bool specialTheme = false,
  }) => _theme(
    Brightness.dark,
    dynamicColor: dynamicColor,
    amoled: amoled,
    specialTheme: specialTheme,
  );

  // GoogleFonts.googleSansTextTheme() without a base bakes in light-theme
  // text colors, breaking dark mode; derive it from the brightness-correct
  // base theme instead.
  static ThemeData _theme(
    Brightness brightness, {
    bool dynamicColor = false,
    bool amoled = false,
    bool specialTheme = false,
  }) {
    ThemeData base;

    if (specialTheme) {
      // Special theme with custom colors - improved consistency
      final Color backgroundColor = brightness == Brightness.light
          ? const Color(0xFFF7F5F2)
          : const Color(0xFF1C1C1C);
      final Color textColor = brightness == Brightness.light
          ? const Color(0xFF1C1C1C)
          : const Color(0xFFF7F5F2);
      final Color accentColor = const Color(0xFF0061FE);
      final Color accentLight = brightness == Brightness.light
          ? const Color(0xFF5C95FF)
          : const Color(0xFF0061FE);

      base = ThemeData(
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: accentColor,
          onPrimary: Colors.white,
          primaryContainer: brightness == Brightness.light
              ? const Color(0xFFE3E8FF)
              : const Color(0xFF002F7A),
          onPrimaryContainer: brightness == Brightness.light
              ? const Color(0xFF00194D)
              : const Color(0xFFDDE1FF),
          secondary: accentLight,
          onSecondary: Colors.white,
          secondaryContainer: brightness == Brightness.light
              ? const Color(0xFFE8EDFF)
              : const Color(0xFF0038A0),
          onSecondaryContainer: brightness == Brightness.light
              ? const Color(0xFF001D4D)
              : const Color(0xFFDCE1FF),
          tertiary: brightness == Brightness.light
              ? const Color(0xFF6B5F78)
              : const Color(0xFFC4B8D0),
          onTertiary: brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF2F2739),
          tertiaryContainer: brightness == Brightness.light
              ? const Color(0xFFF2DAFF)
              : const Color(0xFF463E52),
          onTertiaryContainer: brightness == Brightness.light
              ? const Color(0xFF261C33)
              : const Color(0xFFE5D9F6),
          error: brightness == Brightness.light
              ? const Color(0xFFBA1A1A)
              : const Color(0xFFFFB4AB),
          onError: brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF690005),
          errorContainer: brightness == Brightness.light
              ? const Color(0xFFFFDAD6)
              : const Color(0xFF93000A),
          onErrorContainer: brightness == Brightness.light
              ? const Color(0xFF410002)
              : const Color(0xFFFFDAD6),
          surface: backgroundColor,
          onSurface: textColor,
          surfaceContainer: brightness == Brightness.light
              ? const Color(0xFFEBE9E6)
              : const Color(0xFF2A2A2A),
          surfaceContainerLow: brightness == Brightness.light
              ? const Color(0xFFF5F3F0)
              : const Color(0xFF1F1F1F),
          surfaceContainerHigh: brightness == Brightness.light
              ? const Color(0xFFDFDDDA)
              : const Color(0xFF363636),
          surfaceContainerHighest: brightness == Brightness.light
              ? const Color(0xFFD3D1CE)
              : const Color(0xFF424242),
          onSurfaceVariant: textColor.withValues(alpha: 0.75),
          outline: brightness == Brightness.light
              ? textColor.withValues(alpha: 0.25)
              : textColor.withValues(alpha: 0.35),
          outlineVariant: brightness == Brightness.light
              ? textColor.withValues(alpha: 0.12)
              : textColor.withValues(alpha: 0.18),
          shadow: brightness == Brightness.light
              ? Colors.black.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.4),
          scrim: brightness == Brightness.light
              ? Colors.black.withValues(alpha: 0.5)
              : Colors.black.withValues(alpha: 0.8),
          inverseSurface: brightness == Brightness.light
              ? const Color(0xFF313033)
              : const Color(0xFFF4EFF4),
          onInverseSurface: brightness == Brightness.light
              ? const Color(0xFFF4EFF4)
              : const Color(0xFF313033),
          inversePrimary: brightness == Brightness.light
              ? const Color(0xFF5C95FF)
              : const Color(0xFF0061FE),
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          color: brightness == Brightness.light
              ? const Color(0xFFEBE9E6)
              : const Color(0xFF2A2A2A),
          elevation: brightness == Brightness.light ? 1 : 2,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      );
    } else {
      base = ThemeData(
        colorSchemeSeed: Colors.primaries.elementAt(12),
        brightness: brightness,
        useMaterial3: true,
      );
    }

    if (brightness == Brightness.dark && amoled && !specialTheme) {
      final colorScheme = base.colorScheme.copyWith(surface: Colors.black);
      return base.copyWith(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Colors.black,
        pageTransitionsTheme: _pageTransitionsTheme,
      );
    }

    return base.copyWith(pageTransitionsTheme: _pageTransitionsTheme);
  }

  static Widget buildDynamicColorTheme({
    required Widget Function(ColorScheme lightDynamic, ColorScheme darkDynamic)
    builder,
  }) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        if (lightDynamic != null && darkDynamic != null) {
          return builder(lightDynamic, darkDynamic);
        }
        // Fallback to static theme if dynamic colors not available
        return builder(
          ColorScheme.fromSeed(
            seedColor: Colors.primaries.elementAt(12),
            brightness: Brightness.light,
          ),
          ColorScheme.fromSeed(
            seedColor: Colors.primaries.elementAt(12),
            brightness: Brightness.dark,
          ),
        );
      },
    );
  }
}
