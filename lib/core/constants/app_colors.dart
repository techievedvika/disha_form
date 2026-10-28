import 'package:flutter/material.dart';

class AppColors {
  // Primary Branding Colors
  static const Color primaryIndigo = Colors.indigo;
  static final Color primaryIndigoLight = Colors.indigo.shade400;
  static final Color primaryIndigoDark = Colors.indigo.shade900;
  static final Color primaryBlue = Colors.blue;
  static final Color primaryBlueLight = Colors.blue.shade300;

  // Backgrounds & Gradients
  static const Color scaffoldBackground = Colors.white;
  static final Color surfaceIndigo = Colors.indigo.shade50;

  // Gradient Palettes (as seen in Login and Dialogs)
  static final List<Color> loginGradient = [
    Colors.indigo.shade600,
    Colors.indigo.shade400,
    Colors.blue.shade300,
  ];

  static final List<Color> accentGradient = [
    Colors.indigo.shade400,
    Colors.indigo.shade600,
  ];

  // UI Elements (Borders, Icons, Hints)
  static const Color iconColor = Colors.indigo;
  static final Color borderIndigo = Colors.indigo.shade200;
  static final Color border = Colors.indigo.shade600;
  static final Color shadowColor = const Color(0xFF607D8B).withOpacity(0.2);

  // Feedback Colors
  static final Color error = Colors.red.shade600;
  static final Color errorBorder = Colors.red.shade400;
  static const Color success = Colors.green;
  static final Color textGrey = Colors.grey.shade600;
  static final Color textHint = Colors.grey.shade400;

  // Constants for pure colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static  Color lightRed = Colors.red.shade50;
}