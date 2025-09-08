import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // Error Colors
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  // Warning Colors
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  // Success Colors
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  // Info Colors
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Grey Scale
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Background Colors
  static const Color backgroundLight = grey50;
  static const Color backgroundDark = grey900;
  static const Color surfaceLight = white;
  static const Color surfaceDark = grey800;

  // Text Colors
  static const Color textPrimaryLight = grey900;
  static const Color textPrimaryDark = white;
  static const Color textSecondaryLight = grey600;
  static const Color textSecondaryDark = grey300;
  static const Color textDisabledLight = grey400;
  static const Color textDisabledDark = grey500;

  // Border Colors
  static const Color borderLight = grey200;
  static const Color borderDark = grey700;

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [AppColors.error, AppColors.errorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      AppColors.grey200,
      AppColors.grey100,
      AppColors.grey200,
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
