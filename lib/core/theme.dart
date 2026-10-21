import 'package:flutter/material.dart';

/// Rang ka palette (Light + Dark). Har screen `Pal.of(context)` se rang leti hai.
class Pal {
  final Color primary, gold, bg, surface, text, text2, divider;
  const Pal({
    required this.primary,
    required this.gold,
    required this.bg,
    required this.surface,
    required this.text,
    required this.text2,
    required this.divider,
  });

  static const light = Pal(
    primary: Color(0xFF0B6E4F),
    gold: Color(0xFFC9A227),
    bg: Color(0xFFFAF6EA),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF1F2933),
    text2: Color(0xFF5F6B76),
    divider: Color(0xFFE6E0CC),
  );

  static const dark = Pal(
    primary: Color(0xFF3DBE8B),
    gold: Color(0xFFE0B84A),
    bg: Color(0xFF0F1F1A),
    surface: Color(0xFF172A23),
    text: Color(0xFFF2F0E6),
    text2: Color(0xFFB7C2BC),
    divider: Color(0xFF2A3D35),
  );

  static Pal of(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? dark : light;
}

ThemeData buildTheme(Brightness b) {
  final p = b == Brightness.dark ? Pal.dark : Pal.light;
  return ThemeData(
    useMaterial3: true,
    brightness: b,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: p.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Pal.light.primary,
      brightness: b,
    ).copyWith(primary: p.primary, surface: p.surface),
  );
}

TextStyle arabicStyle(double size, {Color? color}) => TextStyle(
      fontFamily: 'AmiriQuran',
      fontSize: size,
      height: 2.0,
      color: color,
    );

TextStyle urduStyle(double size, {Color? color}) => TextStyle(
      fontFamily: 'NotoNastaliq',
      fontSize: size,
      height: 2.1,
      color: color,
    );
