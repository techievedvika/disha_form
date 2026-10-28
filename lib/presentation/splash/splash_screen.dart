import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/screens/form_builder_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/my_forms_screen.dart';
import 'get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {


  //check is user is logged in or not
  //if logged in then navigate to home screen
  //if not logged in then navigate to login screen
  // check is user is logged in or not
  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userMail = prefs.getString('user_mail');
    final userId = prefs.getString('user_id');
    final bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    // Wait for splash duration
    await Future.delayed(Duration(milliseconds: 2800));

    if (!mounted) return;

    // Determine target screen
    Widget targetScreen = ( (userMail != null && userMail.isNotEmpty && userId != null) || isFirstLaunch == false)
        ? MyFormsScreen(userId: userId ?? '')
        : GetStartedScreen();

    // Navigate with Fade Animation
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500), // Adjust speed here
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }



  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get the screen size
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;



    // Adjusting logo and text size according to screen size
    final double logoSize = screenWidth * 0.9;
    final double textFontSize = screenWidth * 0.03;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  //Colors.white,
                  Colors.lightBlue.shade200,

                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )
          ),
          Positioned(
            bottom: screenHeight * 0.41,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: Image.asset(
              'assets/animation/splash_final.gif',
            )

          ),


          Positioned(
              bottom: screenHeight * 0.06,
              left: screenWidth * 0.2,
              right: screenWidth * 0.2,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Welcome To ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black26,
                      fontSize: textFontSize,
                    ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Disha",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: textFontSize,
                      ),
                    ),
                  ]
                ),

              ),
          )
        ],
      ),
    );
  }
}
