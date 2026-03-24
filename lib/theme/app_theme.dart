import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// All design tokens from ink_slate/DESIGN.md
class AtelierColors {
  // Primary
  static const primary = Color(0xFF545a94);
  static const primaryDim = Color(0xFF484e87);
  static const onPrimary = Color(0xFFf9f6ff);
  static const primaryContainer = Color(0xFFdfe0ff);
  static const onPrimaryContainer = Color(0xFF474d86);
  static const primaryFixedDim = Color(0xFFced1ff);

  // Secondary
  static const secondary = Color(0xFF545e7e);
  static const onSecondary = Color(0xFFf9f8ff);
  static const secondaryContainer = Color(0xFFdbe1ff);
  static const onSecondaryContainer = Color(0xFF475170);

  // Surface hierarchy (no explicit borders — use shifts)
  static const surface = Color(0xFFf8f9fa);
  static const surfaceContainerLowest = Color(0xFFffffff);
  static const surfaceContainerLow = Color(0xFFf1f4f6);
  static const surfaceContainer = Color(0xFFeaeff1);
  static const surfaceContainerHigh = Color(0xFFe3e9ec);
  static const surfaceContainerHighest = Color(0xFFdbe4e7);
  static const surfaceDim = Color(0xFFd1dce0);

  // On-surface
  static const onSurface = Color(0xFF2b3437);
  static const onSurfaceVariant = Color(0xFF586064);
  static const inverseSurface = Color(0xFF0c0f10);

  // Outline (use outlineVariant at 15% opacity — never 100%)
  static const outline = Color(0xFF737c7f);
  static const outlineVariant = Color(0xFFabb3b7);

  // Error
  static const error = Color(0xFF9e3f4e);
  static const errorContainer = Color(0xFFff8b9a);

  // Tertiary
  static const tertiary = Color(0xFF535f78);
  static const tertiaryContainer = Color(0xFFd1ddfa);
  static const onTertiaryContainer = Color(0xFF434e66);

  // Priority colours
  static const p1 = Color(0xFF9e3f4e); // Red-ish
  static const p2 = Color(0xFF545a94); // Primary indigo
  static const p3 = Color(0xFF545e7e); // Secondary slate
  static const p4 = Color(0xFF586064); // Surface variant

  static Color forPriority(int p) {
    switch (p) {
      case 1:
        return p1;
      case 2:
        return p2;
      case 3:
        return p3;
      default:
        return p4;
    }
  }
}

class AtelierTheme {
  static Color forPriority(ColorScheme colorScheme, int p) {
    switch (p) {
      case 1:
        return colorScheme.error; // Closest to P1 red
      case 2:
        return colorScheme.primary; // Closest to P2 indigo
      case 3:
        return colorScheme.secondary; // Closest to P3 slate
      default:
        return colorScheme.onSurfaceVariant; // Closest to P4 gray
    }
  }
  static ThemeData light([ColorScheme? dynamicScheme]) {
    final colorScheme = dynamicScheme ?? ColorScheme(
      brightness: Brightness.light,
      primary: AtelierColors.primary,
      onPrimary: AtelierColors.onPrimary,
      primaryContainer: AtelierColors.primaryContainer,
      onPrimaryContainer: AtelierColors.onPrimaryContainer,
      secondary: AtelierColors.secondary,
      onSecondary: AtelierColors.onSecondary,
      secondaryContainer: AtelierColors.secondaryContainer,
      onSecondaryContainer: AtelierColors.onSecondaryContainer,
      error: AtelierColors.error,
      onError: const Color(0xFFfff7f7),
      errorContainer: AtelierColors.errorContainer,
      onErrorContainer: const Color(0xFF782232),
      surface: AtelierColors.surface,
      onSurface: AtelierColors.onSurface,
      surfaceContainerLowest: AtelierColors.surfaceContainerLowest,
      surfaceContainerLow: AtelierColors.surfaceContainerLow,
      surfaceContainer: AtelierColors.surfaceContainer,
      surfaceContainerHigh: AtelierColors.surfaceContainerHigh,
      surfaceContainerHighest: AtelierColors.surfaceContainerHighest,
      onSurfaceVariant: AtelierColors.onSurfaceVariant,
      outline: AtelierColors.outline,
      outlineVariant: AtelierColors.outlineVariant,
      tertiary: AtelierColors.tertiary,
      onTertiary: const Color(0xFFf8f8ff),
      tertiaryContainer: AtelierColors.tertiaryContainer,
      onTertiaryContainer: AtelierColors.onTertiaryContainer,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AtelierColors.surface,
      fontFamily: 'Inter',
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AtelierColors.surface,
        foregroundColor: AtelierColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AtelierColors.primary,
          letterSpacing: -0.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AtelierColors.primary,
        unselectedItemColor: AtelierColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AtelierColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AtelierColors.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: const BorderSide(color: AtelierColors.outline, width: 1.5),
      ),
      cardTheme: CardThemeData(
        color: AtelierColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        filled: false,
      ),
      dividerTheme: const DividerThemeData(color: Colors.transparent),
    );
  }

  static TextTheme _buildTextTheme() {
    final manrope = GoogleFonts.manrope().fontFamily;
    final inter = GoogleFonts.inter().fontFamily;

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: manrope,
        fontWeight: FontWeight.w800,
        fontSize: 44,
        letterSpacing: -1.5,
        color: AtelierColors.onSurface,
      ),
      displayMedium: TextStyle(
        fontFamily: manrope,
        fontWeight: FontWeight.w800,
        fontSize: 36,
        letterSpacing: -1.0,
        color: AtelierColors.onSurface,
      ),
      headlineLarge: TextStyle(
        fontFamily: manrope,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        letterSpacing: -0.5,
        color: AtelierColors.onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: manrope,
        fontWeight: FontWeight.w700,
        fontSize: 22,
        color: AtelierColors.onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: manrope,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AtelierColors.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: inter,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AtelierColors.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: inter,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: AtelierColors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: inter,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AtelierColors.onSurface,
      ),
      bodySmall: TextStyle(
        fontFamily: inter,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AtelierColors.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontFamily: inter,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AtelierColors.primary,
      ),
      labelSmall: TextStyle(
        fontFamily: inter,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.3,
        color: AtelierColors.onSurfaceVariant,
      ),
    );
  }

  static ThemeData dark([ColorScheme? dynamicScheme]) {
    final colorScheme = dynamicScheme ?? ColorScheme.fromSeed(
      seedColor: AtelierColors.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: 'Inter',
      textTheme: _buildTextTheme().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: colorScheme.primary,
          letterSpacing: -0.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: colorScheme.outline, width: 1.5),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
