import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:reviseitai/core/theme/app_theme.dart';
import 'package:reviseitai/core/widgets/gradient_button.dart';
import 'package:reviseitai/features/auth/presentation/screens/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final LiquidController _controller = LiquidController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Welcome to Reviseit.ai',
      'subtitle': 'The AI-powered learning revolution',
      'description': 'Reviseit.ai helps you remember concepts using AI-powered spaced repetition, active recall, and automatic mind maps.',
      'gradient': AppTheme.primaryGradient,
      'image': 'assets/animations/onboarding1.json',
    },
    {
      'title': 'AI-Powered Learning',
      'subtitle': 'Smart notes, flashcards & mind maps',
      'description': 'Our AI analyzes your learning materials and creates personalized study resources optimized for your brain.',
      'gradient': AppTheme.secondaryGradient,
      'image': 'assets/animations/onboarding2.json',
    },
    {
      'title': 'Spaced Repetition',
      'subtitle': 'Remember forever, not just for exams',
      'description': 'Reviseit.ai schedules your revisions at scientifically optimal intervals to maximize long-term retention.',
      'gradient': AppTheme.tertiaryGradient,
      'image': 'assets/animations/onboarding3.json',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: _buildPages(),
            liquidController: _controller,
            onPageChangeCallback: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            enableLoop: false,
            waveType: WaveType.liquidReveal,
            enableSideReveal: true,
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicator
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 10,
                      width: _currentPage == index ? 24 : 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                
                // Next/Get Started Button
                GradientButton(
                  text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  width: 150,
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const AuthScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOutCubic;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(position: offsetAnimation, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 800),
                        ),
                      );
                    } else {
                      _controller.animateToPage(
                        page: _currentPage + 1,
                        duration: 700,
                      );
                    }
                  },
                  gradientColors: (_pages[_currentPage]['gradient'] as LinearGradient).colors,
                ),
              ],
            ),
          ),
          
          // Skip Button
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const AuthScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutCubic;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(position: offsetAnimation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildPages() {
    return _pages.map((page) {
      final gradient = page['gradient'] as LinearGradient;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient.colors,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation Placeholder (replace with actual Lottie animation)
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.animation,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            )
            .animate()
            .scale(duration: 600.ms, curve: Curves.easeOutBack),
            
            const SizedBox(height: 40),
            
            // Title
            Text(
              page['title'],
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 16),
            
            // Subtitle
            Text(
              page['subtitle'],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            )
            .animate(delay: 200.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Description
            Text(
              page['description'],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            )
            .animate(delay: 400.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
          ],
        ),
      );
    }).toList();
  }
}