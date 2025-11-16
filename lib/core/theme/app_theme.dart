import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'travel_spot_theme.dart';

class AppTheme {
  /// Obter a paleta de cores baseada no tema atual (seguindo padrão Lello)
  static ColorPalette paletteOf(ThemeData theme) {
    return TravelSpotTheme.paletteOf(theme);
  }

  /// Tema padrão claro
  static ThemeData get lightTheme => TravelSpotTheme.lightTheme;

  /// Tema padrão escuro  
  static ThemeData get darkTheme => TravelSpotTheme.darkTheme;

  /// Criar tema customizado com cores específicas
  static ThemeData themeWithPalette(Brightness brightness, ColorPalette palette) {
    return TravelSpotTheme.themeWithPalette(brightness, palette);
  }

  /// Método de compatibilidade (seguindo padrão Lello)
  static ColorPalette colorPalette(BuildContext context) {
    return paletteOf(Theme.of(context));
  }
}