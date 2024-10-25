import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/features.dart';

class VidyooTheme {
  // Colors
  static const Color primary = Color(0xFF5B4DFF);
  static const Color secondary = Color(0xFF00D1FF);

  // Neutral Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FC);
  static const Color textDark = Color(0xFF1A1D1F);
  static const Color textSecondary = Color(0xFF6F767E);

  // Semantic Colors
  static const Color success = Color(0xFF83BF6E);
  static const Color error = Color(0xFFFF6A55);
  static const Color warning = Color(0xFFFFB74A);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Typography - Headings (Plus Jakarta Sans)
  static final TextStyle h1 = GoogleFonts.plusJakartaSans(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: textDark,
    height: 1.2,
  );

  static final TextStyle h2 = GoogleFonts.plusJakartaSans(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    color: textDark,
    height: 1.2,
  );

  static final TextStyle h3 = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: textDark,
    height: 1.3,
  );

  static final TextStyle h4 = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: textDark,
    height: 1.4,
  );

  // Typography - Body (Inter)
  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textDark,
    height: 1.5,
  );

  static final TextStyle bodyDefault = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textDark,
    height: 1.5,
  );

  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textDark,
    height: 1.5,
  );

  // Special Text Styles
  static final TextStyle buttonText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacing2XL = 48.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Shadows
  static final List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}


late UserCredential? userCredential;


