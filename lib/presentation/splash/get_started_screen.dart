import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/login_screen.dart';
import '../../data/models/image_info_model.dart';
import '../screens/form_builder_screen.dart';
import '../widgets/normal_widgets/hero_layout_widget.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> with TickerProviderStateMixin {
  double _scale = 1.0;
  late final CarouselController _carouselController;
  late final Timer _autoScrollTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;

  final List<ImageInfoModel> heroImages = [
    ImageInfoModel(
      image: 'assets/images/carousall_1.png',
      title: 'Welcome',
      subtitle: 'Explore new features',
    ),
    ImageInfoModel(
      image: 'assets/images/carousall_2.png',
      title: 'Offline Mode',
      subtitle: 'Works without internet',
    ),
    ImageInfoModel(
      image: 'assets/images/carousall_3.png',
      title: 'Fast Sync',
      subtitle: 'Upload data instantly',
    ),
    ImageInfoModel(
      image: 'assets/images/carousall_4.png',
      title: 'Fast Sync',
      subtitle: 'Upload data instantly',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _carouselController = CarouselController();

    // Fade animation for initial load
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _autoScrollTimer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) {
        if (!mounted) return;

        setState(() {
          if (_currentIndex < heroImages.length - 1) {
            _currentIndex++;
          } else {
            _currentIndex = 0;
          }
        });

        _carouselController.animateToItem(
          _currentIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userMail = prefs.getString('user_mail');

    // Wait for splash duration
    await Future.delayed(Duration(milliseconds: 2800));

    if (!mounted) return;

    // Determine target screen
    Widget targetScreen = (userMail != null && userMail.isNotEmpty)
        ? FormBuilderScreen()
        : LoginScreen();

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
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _tap() async {
    setState(() => _scale = 0.92);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo.shade50,
              Colors.white,
              Colors.blue.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Logo and header section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigo.shade400,
                                Colors.indigo.shade600,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.rocket_launch_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Get Started',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Swipe to explore features',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  // Carousel section with enhanced styling
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Carousel
                        CarouselView.weighted(
                          enableSplash: true,
                          controller: _carouselController,
                          itemSnapping: true,
                          onTap: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          flexWeights: const [1],
                          children: heroImages.asMap().entries.map((entry) {
                            int index = entry.key;
                            ImageInfoModel imageInfo = entry.value;

                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(
                                horizontal: _currentIndex == index ? 8 : 16,
                                vertical: _currentIndex == index ? 0 : 20,
                              ),
                              child: ClipRRect(
                                //borderRadius: BorderRadius.circular(24),

                                child: HeroLayoutItem(imageInfo: imageInfo),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      heroImages.length,
                          (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentIndex == index ? 26 : 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: _currentIndex == index
                              ? LinearGradient(
                            colors: [
                              Colors.indigo.shade600,
                              Colors.indigo.shade600,
                            ],
                          )
                              : null,
                          color: _currentIndex == index
                              ? null
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Get Started button with enhanced design
                  AnimatedScale(
                    scale: _scale,
                    duration: const Duration(milliseconds: 120),
                    child: Container(
                      width: screenWidth * 0.85,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.shade500,
                            Colors.indigo.shade700,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.4),
                            blurRadius: 16,
                            spreadRadius: 1,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _tap,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Get Started",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}