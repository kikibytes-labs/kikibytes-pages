import 'package:flutter/material.dart';

const kikiOrange = Color(0xFFFF8A00);
const kikiDeep = Color(0xFF0F1724);
const _kikiBackground = Color(0xFFF7F8FA);
const _kikiSurface = Color(0xFFFFFFFF);
const _kikiInputFill = Color(0xFFF1F3F5);

final kikiTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: _kikiBackground,
  primaryColor: kikiOrange,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kikiOrange,
    brightness: Brightness.light,
    surface: _kikiSurface,
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: kikiDeep, height: 1.2),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: kikiDeep, height: 1.3),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kikiDeep),
    bodyLarge: TextStyle(fontSize: 16, color: kikiDeep, height: 1.6),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5),
    bodySmall: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kikiOrange,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3),
    ).copyWith(
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) return 2;
        return 0;
      }),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _kikiInputFill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kikiOrange, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFEF4444)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF6B7280)),
    floatingLabelStyle: const TextStyle(color: kikiOrange, fontWeight: FontWeight.w500),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    color: _kikiSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    margin: EdgeInsets.zero,
  ),

  dividerTheme: const DividerThemeData(
    color: Color(0xFFE5E7EB),
    thickness: 1,
    indent: 0,
    endIndent: 0,
  ),
);
