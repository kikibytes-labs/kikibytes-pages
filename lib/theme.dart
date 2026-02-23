import 'package:flutter/material.dart';

const _kikiOrange = Color(0xFFFF8A00);
const _kikiDeep = Color(0xFF0F1724);

final kikiTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF7F8FA),
  primaryColor: _kikiOrange,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _kikiOrange,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: _kikiDeep),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: _kikiDeep),
    bodyLarge: TextStyle(fontSize: 16, color: _kikiDeep),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _kikiOrange,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 6,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    ),
  ),
);
