import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'presentation/splash/splash_screen.dart';

void main() {
  runApp(const FormBuilderApp());
}

class FormBuilderApp extends StatelessWidget {
  const FormBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
