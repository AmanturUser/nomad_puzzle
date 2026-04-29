import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Brand
  static const Color primary = Color(0xFFE67F37); // warm saffron
  static const Color primaryDeep = Color(0xFFB85818); // rich terracotta
  static const Color primarySoft = Color(0xFFFCE8D5);

  static const Color secondary = Color(0xFF2D6A4F); // pine
  static const Color secondarySoft = Color(0xFFDCEEDF);

  static const Color accent = Color(0xFF3AA9D9); // sky

  // Neutrals — light
  static const Color background = Color(0xFFFFF9F3); // cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFAF5ED);
  static const Color surfaceDim = Color(0xFFF5EEE2);
  static const Color divider = Color(0xFFE8E2D7);
  static const Color outline = Color(0xFFD5CEBF);

  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF6E6E73);
  static const Color textMuted = Color(0xFF9A958C);

  // Neutrals — dark
  static const Color backgroundDark = Color(0xFF0E1220);
  static const Color surfaceDark = Color(0xFF161A2C);
  static const Color surfaceElevatedDark = Color(0xFF1E2238);
  static const Color dividerDark = Color(0xFF2A2F47);
  static const Color textPrimaryDark = Color(0xFFF5F2EC);
  static const Color textSecondaryDark = Color(0xFFA5A3A0);

  // Semantic
  static const Color success = Color(0xFF2D8F4E);
  static const Color successSoft = Color(0xFFDBEFE0);
  static const Color warning = Color(0xFFE5A628);
  static const Color warningSoft = Color(0xFFFBEACD);
  static const Color error = Color(0xFFD94A3A);
  static const Color errorSoft = Color(0xFFFADAD6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE67F37), Color(0xFFDC4D3E)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB473), Color(0xFFE67F37), Color(0xFFB85818)],
  );

  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF3AA9D9), Color(0xFF2D6A4F)],
  );

  static const LinearGradient auroraGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE67F37),
      Color(0xFFDC4D3E),
      Color(0xFF3AA9D9),
    ],
    stops: [0, 0.55, 1],
  );
}
