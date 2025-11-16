import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'custom_color_palette.dart';

/// Gerenciador de temas customizáveis seguindo padrão Lello
class ThemeManager {
  /// Criar tema com cores customizadas
  static ThemeData createCustomTheme({
    required Color primary,
    required Color secondary,
    required bool isDark,
  }) {
    final palette = isDark
        ? CustomDarkPalette(primary: primary, secondary: secondary)
        : CustomLightPalette(primary: primary, secondary: secondary);

    return AppTheme.themeWithPalette(
        isDark ? Brightness.dark : Brightness.light, palette);
  }

  /// Cores padrão do TravelSpot
  static const Color defaultPrimary = Color(0xFF0D7377);
  static const Color defaultSecondary = Color(0xFF329D9C);

  /// Temas pré-definidos
  static ThemeData get blueTheme => createCustomTheme(
        primary: const Color(0xFF1976D2),
        secondary: const Color(0xFF42A5F5),
        isDark: false,
      );

  static ThemeData get greenTheme => createCustomTheme(
        primary: const Color(0xFF388E3C),
        secondary: const Color(0xFF66BB6A),
        isDark: false,
      );

  static ThemeData get purpleTheme => createCustomTheme(
        primary: const Color(0xFF7B1FA2),
        secondary: const Color(0xFFAB47BC),
        isDark: false,
      );

  static ThemeData get orangeTheme => createCustomTheme(
        primary: const Color(0xFFF57C00),
        secondary: const Color(0xFFFFB74D),
        isDark: false,
      );

  /// Versões escuras dos temas
  static ThemeData get darkBlueTheme => createCustomTheme(
        primary: const Color(0xFF1976D2),
        secondary: const Color(0xFF42A5F5),
        isDark: true,
      );

  static ThemeData get darkGreenTheme => createCustomTheme(
        primary: const Color(0xFF388E3C),
        secondary: const Color(0xFF66BB6A),
        isDark: true,
      );

  static ThemeData get darkPurpleTheme => createCustomTheme(
        primary: const Color(0xFF7B1FA2),
        secondary: const Color(0xFFAB47BC),
        isDark: true,
      );

  static ThemeData get darkOrangeTheme => createCustomTheme(
        primary: const Color(0xFFF57C00),
        secondary: const Color(0xFFFFB74D),
        isDark: true,
      );
}
