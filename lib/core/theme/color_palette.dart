import 'package:flutter/material.dart';

abstract class ColorPalette {
  // Primary colors
  Color primary();
  Color primaryVariant();
  Color onPrimary();

  // Secondary colors
  Color secondary();
  Color secondaryVariant();
  Color onSecondary();

  // Surface colors
  Color surface();
  Color onSurface();
  Color background();
  Color onBackground();

  // Error colors
  Color error();
  Color onError();

  // Status colors
  Color success();
  Color warning();
  Color info();

  // Text colors
  Color textPrimary();
  Color textSecondary();
  Color textDisabled();

  // Divider and border colors
  Color divider();
  Color border();

  // Card colors
  Color cardBackground();
  Color cardShadow();
}

class LightColorPalette implements ColorPalette {
  @override
  Color primary() => const Color(0xFF0D7377);

  @override
  Color primaryVariant() => const Color(0xFF14A085);

  @override
  Color onPrimary() => Colors.white;

  @override
  Color secondary() => const Color(0xFF329D9C);

  @override
  Color secondaryVariant() => const Color(0xFF7BE495);

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

class DarkColorPalette implements ColorPalette {
  @override
  Color primary() => const Color(0xFF14A085);

  @override
  Color primaryVariant() => const Color(0xFF0D7377);

  @override
  Color onPrimary() => Colors.white;

  @override
  Color secondary() => const Color(0xFF7BE495);

  @override
  Color secondaryVariant() => const Color(0xFF329D9C);

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