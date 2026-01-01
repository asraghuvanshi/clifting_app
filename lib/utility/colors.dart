import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Vibrant Brand Colors
  static const Color neonPink = Color(0xFFFF4081);       // Neon Pink (Onboarding 1 & 3)
  static const Color electricGold = Color(0xFFFFEB3B);   // Electric Gold (Onboarding 2)
  static const Color cyberBlue = Color(0xFF00E5FF);      // Cyber Blue (Onboarding 2)

  // Dark Theme Backgrounds
  static const Color spaceBlack = Color(0xFF0A0A15);     // Space Black
  static const Color midnightBlue = Color(0xFF121230);   // Midnight Blue

  static const LinearGradient onboardingGradient1 = LinearGradient(
    colors: [spaceBlack, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient onboardingGradient2 = LinearGradient(
    colors: [midnightBlue, electricGold, cyberBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
