import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../app_theme.dart';
import 'role_selection_screen.dart';

class _OnboardSlide {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  const _OnboardSlide(this.emoji, this.title, this.subtitle, this.color);
}

const _slides = [
  _OnboardSlide(
    '📍',
    'Find Jobs\nNearby Instantly',
    'Browse 100s of verified part-time jobs within walking distance. Smart AI matches you in seconds.',
    AppColors.saffron,
  ),
  _OnboardSlide(
    '💸',
    'Get Paid\nSame Day',
    'Finish your shift and receive money directly in your Indian Dreams wallet. Zero delays.',
    AppColors.emerald,
  ),
  _OnboardSlide(
    '🛡️',
    'Safe &\nVerified Employers',
    'Every employer is ID-verified with a live trust score. Work with confidence, always.',
    AppColors.sky,
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _slides.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToRoleSelection();
    }
  }

  void _navigateToRoleSelection() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, a, __) => const RoleSelectionScreen(),
        transitionsBuilder: (_, a, __, child) =>
            SlideTransition(position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(a), child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: _navigateToRoleSelection,
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideWidget(slide: _slides[i], index: i),
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageCtrl,
                    count: _slides.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: _slides[_currentPage].color,
                      dotColor: Colors.white.withOpacity(0.3),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_slides[_currentPage].color, _slides[_currentPage].color.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: _slides[_currentPage].color.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _goNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: Text(
                          _currentPage == _slides.length - 1 ? 'Get Started 🚀' : 'Next →',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
}

class _SlideWidget extends StatelessWidget {
  final _OnboardSlide slide;
  final int index;
  const _SlideWidget({required this.slide, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji illustration
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: slide.color.withOpacity(0.12),
              border: Border.all(color: slide.color.withOpacity(0.3), width: 2),
            ),
            child: Center(
              child: Text(slide.emoji, style: const TextStyle(fontSize: 72)),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.65),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
