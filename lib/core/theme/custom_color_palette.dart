import 'package:flutter/material.dart';
import 'color_palette.dart';

/// Paleta de cores customizável para tema claro
/// Permite personalizar cores primária e secundária mantendo o padrão do design system
class CustomLightPalette implements ColorPalette {
  final Color _primary;
  final Color _secondary;

  const CustomLightPalette({
    required Color primary,
    required Color secondary,
  }) : _primary = primary, _secondary = secondary;

  @override
  Color primary() => _primary;

  @override
  Color primaryVariant() => Color.lerp(_primary, Colors.black, 0.2)!;

  @override
  Color onPrimary() => Colors.white;

  @override
  Color secondary() => _secondary;

  @override
  Color secondaryVariant() => Color.lerp(_secondary, Colors.white, 0.2)!;

  @override
  Color onSecondary() => Colors.white;

  @override
  Color surface() => Colors.white;

  @override
  Color onSurface() => const Color(0xFF212121);

  @override
  Color background() => const Color(0xFFF5F5F5);

  @override
  Color onBackground() => const Color(0xFF212121);

  @override
  Color error() => const Color(0xFFE53E3E);

  @override
  Color onError() => Colors.white;

  @override
  Color success() => const Color(0xFF38A169);

  @override
  Color warning() => const Color(0xFFDD6B20);

  @override
  Color info() => const Color(0xFF3182CE);

  @override
  Color textPrimary() => const Color(0xFF212121);

  @override
  Color textSecondary() => const Color(0xFF757575);

  @override
  Color textDisabled() => const Color(0xFFBDBDBD);

  @override
  Color divider() => const Color(0xFFE0E0E0);

  @override
  Color border() => const Color(0xFFE0E0E0);

  @override
  Color cardBackground() => Colors.white;

  @override
  Color cardShadow() => Colors.black.withValues(alpha: 0.1);
}

/// Paleta de cores customizável para tema escuro
/// Permite personalizar cores primária e secundária mantendo o padrão do design system
class CustomDarkPalette implements ColorPalette {
  final Color _primary;
  final Color _secondary;

  const CustomDarkPalette({
    required Color primary,
    required Color secondary,
  }) : _primary = primary, _secondary = secondary;

  @override
  Color primary() => _primary;

  @override
  Color primaryVariant() => Color.lerp(_primary, Colors.white, 0.2)!;

  @override
  Color onPrimary() => Colors.white;

  @override
  Color secondary() => _secondary;

  @override
  Color secondaryVariant() => Color.lerp(_secondary, Colors.black, 0.2)!;

  @override
  Color onSecondary() => Colors.black;

  @override
  Color surface() => const Color(0xFF1E1E1E);

  @override
  Color onSurface() => Colors.white;

  @override
  Color background() => const Color(0xFF121212);

  @override
  Color onBackground() => Colors.white;

  @override
  Color error() => const Color(0xFFFF6B6B);

  @override
  Color onError() => Colors.white;

  @override
  Color success() => const Color(0xFF51CF66);

  @override
  Color warning() => const Color(0xFFFFD43B);

  @override
  Color info() => const Color(0xFF4DABF7);

  @override
  Color textPrimary() => Colors.white;

  @override
  Color textSecondary() => const Color(0xFFB0B0B0);

  @override
  Color textDisabled() => const Color(0xFF616161);

  @override
  Color divider() => const Color(0xFF424242);

  @override
  Color border() => const Color(0xFF424242);

  @override
  Color cardBackground() => const Color(0xFF1E1E1E);

  @override
  Color cardShadow() => Colors.black.withValues(alpha: 0.3);
}