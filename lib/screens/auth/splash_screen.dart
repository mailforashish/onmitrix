import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/animation_utils.dart';
import '../../utils/session_manager.dart';
import 'login_screen.dart';
import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF2B4380),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final sessionManager = SessionManager();
    await sessionManager.init(); // Initialize SharedPreferences
    final isLoggedIn = await sessionManager.isLoggedIn();

    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? const MainScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B4380), // Exact dark blue from the image
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Money bag logo with scale animation
                  AnimationUtils.fadeInTransition(
                    animation: _fadeAnimation,
                    child: SvgPicture.asset(
                      'assets/images/money_bag.svg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // ONMITRIX text with fade animation
                  AnimationUtils.fadeInTransition(
                    animation: _fadeAnimation,
                    child: const Text(
                      'ONMITRIX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Tagline with fade animation
                  AnimationUtils.fadeInTransition(
                    animation: _fadeAnimation,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'The complete financial management solution trusted by 10,000+ businesses worldwide',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Features list with slide animations
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          'assets/images/shield.svg',
                          '256-bit encryption & SOC 2 compliance',
                          0.2,
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureItem(
                          'assets/images/chart.svg',
                          'AI-powered insights & predictive analytics',
                          0.4,
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureItem(
                          'assets/images/sync.svg',
                          'Seamless integrations & automated reconciliation',
                          0.6,
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureItem(
                          'assets/images/clock.svg',
                          '24/7 expert support & real-time monitoring',
                          0.8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer with fade animation
            AnimationUtils.fadeInTransition(
              animation: _fadeAnimation,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Privacy',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('•', style: TextStyle(color: Colors.white70)),
                      ),
                      Text(
                        'Terms',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('•', style: TextStyle(color: Colors.white70)),
                      ),
                      Text(
                        'Sitemap',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/money_bag_small.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Onmitrix • Complete Financial Management',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String iconPath, String text, double delay) {
    return AnimationUtils.slideTransition(
      animation: _controller,
      direction: SlideDirection.right,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}