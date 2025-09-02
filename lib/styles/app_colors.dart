import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand (primary accent used in the app)
  static const Color orange = Color(0xFFFF8A00); // brand orange
  static const Color darkOrange = Color(0xFFE67A00);

  // Material Orange scale
  static const Color orange50 = Color(0xFFFFF3E0);
  static const Color orange200 = Color(0xFFFFCC80);
  static const Color orange400 = Color(0xFFFFA726);
  static const Color orange600 = Color(0xFFFB8C00);
  static const Color orange700 = Color(0xFFF57C00);

  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Neutrals
  static const Color darkGrey = Color(0xFF2E2E2E);
  static const Color grey = Color(0xFF746F6F);
  static const Color lightGrey = Color(0xFF595958);

  // Material greys referenced in code
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);

  // Surfaces & borders
  static const Color surface = Color(0xFFF7F7F7);
  static const Color border = Color(0xFFE6E6E6);
  static const Color successGreen = Color(0xFF2E7D32);
  static Color lightBackground = Color(0xFFF5F5F5);

  // Semantic / overlays
  static const Color errorRed = Color(0xFFF44336);
  static const Color blackAlpha06 = Color(0x11000000);
  static const Color blackAlpha10 = Color(0x1A000000);
}
