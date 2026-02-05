import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static const Color background = Color(0xFF1A1F2E);
  static const Color foreground = Color(0xFFF2F2F2);
  static const Color card = Color(0x80222937);
  static const Color cardForeground = Color(0xFFE5E5E5);
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryForeground = Color(0xFF1A1F2E);
  static const Color secondary = Color(0xFF0099E5);
  static const Color secondaryForeground = Color(0xFFF2F2F2);
  static const Color muted = Color(0xFF323749);
  static const Color mutedForeground = Color(0xFFB3B3B3);
  static const Color accent = Color(0xFFFF8C00);
  static const Color accentForeground = Color(0xFF1A1F2E);
  static const Color destructive = Color(0xFFE53E3E);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color border = Color(0x80434959);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: primaryForeground,
      secondary: secondary,
      onSecondary: secondaryForeground,
      tertiary: accent,
      onTertiary: accentForeground,
      surface: background,
      onSurface: foreground,
      surfaceVariant: card,
      onSurfaceVariant: cardForeground,
      outline: border,
      error: destructive,
      onError: destructiveForeground,
      background: background,
      onBackground: foreground,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.orbitron(
        color: foreground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.orbitron(
        color: foreground,
        fontSize: 64,
        fontWeight: FontWeight.w900,
        height: 1.1,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      displayMedium: GoogleFonts.orbitron(
        color: foreground,
        fontSize: 48,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      displaySmall: GoogleFonts.orbitron(
        color: foreground,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      headlineLarge: GoogleFonts.orbitron(
        color: foreground,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      headlineMedium: GoogleFonts.orbitron(
        color: foreground,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      headlineSmall: GoogleFonts.orbitron(
        color: foreground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      titleLarge: GoogleFonts.inter(
        color: foreground,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      titleMedium: GoogleFonts.inter(
        color: foreground,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      titleSmall: GoogleFonts.inter(
        color: foreground,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      bodyLarge: GoogleFonts.inter(
        color: foreground,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      bodyMedium: GoogleFonts.inter(
        color: foreground,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      bodySmall: GoogleFonts.inter(
        color: mutedForeground,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.4,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      labelLarge: GoogleFonts.jetBrainsMono(
        color: foreground,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      labelMedium: GoogleFonts.jetBrainsMono(
        color: foreground,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
      labelSmall: GoogleFonts.jetBrainsMono(
        color: foreground,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ).copyWith(fontFamilyFallback: ['Noto Sans']),
    ),
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primary, secondary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration get glassCard => BoxDecoration(
    color: card.withOpacity(0.8),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: border, width: 1),
    boxShadow: [
      BoxShadow(
        color: primary.withOpacity(0.1),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get androidGlow => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: primary.withOpacity(0.25),
        blurRadius: 10,
        spreadRadius: 2,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: primary.withOpacity(0.15),
        blurRadius: 20,
        spreadRadius: 1,
        offset: const Offset(0, 0),
      ),
    ],
  );
}