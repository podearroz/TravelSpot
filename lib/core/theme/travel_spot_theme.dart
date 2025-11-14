import 'package:flutter/material.dart';
import 'color_palette.dart';

class TravelSpotTheme {
  static final _lightColorPalette = LightColorPalette();
  static final _darkColorPalette = DarkColorPalette();

  /// Obter a paleta de cores baseada no tema atual
  static ColorPalette paletteOf(ThemeData theme) {
    return theme.brightness == Brightness.light
        ? _lightColorPalette
        : _darkColorPalette;
  }

  /// Criar tema customizado com cores específicas
  static ThemeData themeWithPalette(
      Brightness brightness, ColorPalette palette) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: isLight
          ? ColorScheme.light(
              primary: palette.primary(),
              onPrimary: palette.onPrimary(),
              secondary: palette.secondary(),
              onSecondary: palette.onSecondary(),
              surface: palette.surface(),
              onSurface: palette.onSurface(),
              background: palette.background(),
              onBackground: palette.onBackground(),
              error: palette.error(),
              onError: palette.onError(),
            )
          : ColorScheme.dark(
              primary: palette.primary(),
              onPrimary: palette.onPrimary(),
              secondary: palette.secondary(),
              onSecondary: palette.onSecondary(),
              surface: palette.surface(),
              onSurface: palette.onSurface(),
              background: palette.background(),
              onBackground: palette.onBackground(),
              error: palette.error(),
              onError: palette.onError(),
            ),
      appBarTheme: AppBarTheme(
        backgroundColor: isLight ? palette.primary() : palette.surface(),
        foregroundColor: isLight ? palette.onPrimary() : palette.onSurface(),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: isLight ? palette.onPrimary() : palette.onSurface(),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary(),
          foregroundColor: palette.onPrimary(),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary(),
          side: BorderSide(color: palette.primary()),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border()),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border()),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.primary()),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.error()),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      cardTheme: CardTheme(
        color: palette.cardBackground(),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: palette.cardShadow(),
      ),
      dividerTheme: DividerThemeData(
        color: palette.divider(),
        thickness: 1,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: palette.textPrimary(),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: palette.textPrimary(),
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: palette.textPrimary(),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: palette.textPrimary(),
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: palette.textPrimary(),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: palette.textPrimary(),
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: palette.textSecondary(),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: palette.textSecondary(),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  /// Tema padrão claro
  static ThemeData get lightTheme =>
      themeWithPalette(Brightness.light, _lightColorPalette);

  /// Tema padrão escuro
  static ThemeData get darkTheme =>
      themeWithPalette(Brightness.dark, _darkColorPalette);
}
