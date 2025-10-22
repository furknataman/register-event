import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Ana renkler
  static const Color primaryBlue = Color(0xFF004B8D);
  static const Color primaryMidBlue = Color(0xFF005A9E);
  static const Color primaryLightBlue = Color(0xFF1AB7EA);

  // Legacy color names (deprecated - use primaryBlue instead)
  static const Color primaryRed = Color(0xFF004B8D); // Now blue

  // Button Colors - Buton renkleri
  static const Color buttonGradientStart = Color(0xFF1AB7EA);
  static const Color buttonGradientEnd = Color(0xFF004B8D);
  static const Color buttonShadow = Color.fromARGB(77, 0, 0, 0); // 0.3 opacity black

  // Background Gradients - Arka plan gradientleri
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryLightBlue, primaryMidBlue, primaryBlue],
    stops: [0.2, 0.5, 1.0],
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [buttonGradientStart, buttonGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text Colors - Metin renkleri
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color.fromARGB(153, 255, 255, 255); // 0.6 opacity white
  
  // Border Colors - Kenar renkleri
  static const Color borderWhite = Colors.white;
  
  // Status Colors - Durum renkleri
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
}

class AppDimensions {
  // Border Radius
  static const double buttonRadius = 27.0;
  static const double cardRadius = 12.0;
  static const double smallRadius = 8.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;
  static const double spacingXXL = 32.0;
  
  // Button Sizes
  static const double buttonHeight = 54.0;
  static const double iconButtonSize = 48.0;
  
  // Form Field
  static const double textFieldHeight = 56.0;
  
  // Margins
  static const EdgeInsets loginFormMargin = EdgeInsets.only(left: 70, right: 70);
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
}

class AppTextStyles {
  // Login Form Text Styles
  static const TextStyle loginButtonText = TextStyle(
    fontSize: 18,
    color: AppColors.textWhite,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  static const TextStyle textFieldLabel = TextStyle(
    color: AppColors.textWhite,
    fontSize: 16,
  );
  
  static const TextStyle textFieldText = TextStyle(
    color: AppColors.textWhite,
    fontSize: 14,
  );
  
  // Title Styles
  static const TextStyle appTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
}