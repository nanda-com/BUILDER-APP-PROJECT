import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Palette – Saffron & Deep Blue
  static const Color saffron = Color(0xFFFF6B35);
  static const Color saffronLight = Color(0xFFFF9B6B);
  static const Color saffronDark = Color(0xFFE5501A);

  static const Color navy = Color(0xFF0D1B3E);
  static const Color navyMid = Color(0xFF1A2F5E);
  static const Color navyLight = Color(0xFF243B6E);

  // New UI Primary
  static const Color royalBlue = Color(0xFF1F5DF6);
  static const Color royalBlueLight = Color(0xFF4274F8);
  static const Color royalBlueDark = Color(0xFF0F3DBA);

  // Accent
  static const Color golden = Color(0xFFFFB800);
  static const Color emerald = Color(0xFF00C896);
  static const Color ruby = Color(0xFFE63946);
  static const Color sky = Color(0xFF4CC9F0);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F9FF);
  static const Color grey100 = Color(0xFFF1F3F9);
  static const Color grey300 = Color(0xFFCDD2E1);
  static const Color grey500 = Color(0xFF8892AB);
  static const Color grey700 = Color(0xFF4A5568);
  static const Color dark = Color(0xFF1A1D29);

  // Gradient Presets
  static const LinearGradient saffronGrad = LinearGradient(
    colors: [saffron, saffronDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient navyGrad = LinearGradient(
    colors: [navy, navyMid],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGrad = LinearGradient(
    colors: [Color(0xFF0D1B3E), Color(0xFF1E3A6E), Color(0xFFFF6B35)],
    stops: [0.0, 0.6, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Delivery': Color(0xFF4CC9F0),
    'Cafe': Color(0xFFFFB800),
    'Retail': Color(0xFF7B2FBE),
    'Warehouse': Color(0xFF00C896),
    'Event': Color(0xFFFF6B35),
    'IT Support': Color(0xFF4361EE),
    'Tutoring': Color(0xFFE63946),
    'Security': Color(0xFF2D6A4F),
    'Cleaning': Color(0xFF3A86FF),
    'Cooking': Color(0xFFEF233C),
  };
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.saffron,
        brightness: Brightness.light,
        primary: AppColors.saffron,
        secondary: AppColors.navy,
        surface: AppColors.offWhite,
      ),
      scaffoldBackgroundColor: AppColors.offWhite,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.dark,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.dark,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.dark,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.grey700,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.grey500,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.saffron, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
        ),
        iconTheme: const IconThemeData(color: AppColors.dark),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.saffron,
        labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }
}
