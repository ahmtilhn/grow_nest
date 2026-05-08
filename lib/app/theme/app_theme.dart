import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF5F7FF);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF28758A);
  static const brand = Color(0xFF1FA7E9);
  static const accent = Color(0xFF8ECAE6);
  static const primaryDark = Color(0xFF10233A);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE4EBF5);
  static const softBlue = Color(0xFFEAF3FF);
  static const softPink = Color(0xFFFFEAF4);
  static const softGreen = Color(0xFFE7F3EF);
  static const warning = Color(0xFFFFEFEF);
  static const danger = Color(0xFFE24A46);
}

class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const pill = 999.0;
}

ThemeData buildAppTheme({Brightness brightness = Brightness.light}) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: brightness,
    primary: AppColors.primary,
    surface: isDark ? const Color(0xFF132033) : AppColors.surface,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: isDark
        ? const Color(0xFF0C1524)
        : AppColors.background,
    cardColor: isDark ? const Color(0xFF142238) : AppColors.surface,
    fontFamily: 'Manrope',
    textTheme:
        (isDark ? Typography.whiteMountainView : Typography.blackMountainView)
            .apply(
              bodyColor: isDark
                  ? const Color(0xFFE7EDF7)
                  : AppColors.primaryDark,
              displayColor: isDark
                  ? const Color(0xFFE7EDF7)
                  : AppColors.primaryDark,
              fontFamily: 'Manrope',
            ),
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? const Color(0xFF132033) : AppColors.surface,
      foregroundColor: isDark ? Colors.white : AppColors.primaryDark,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF0E1A2B) : const Color(0xFFF8FAFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: Color(0xFFB8C4D3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: Color(0xFFB8C4D3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: isDark ? const Color(0xFF132033) : Colors.white,
      indicatorColor: AppColors.softBlue,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? AppColors.brand
              : const Color(0xFF94A3B8),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}
