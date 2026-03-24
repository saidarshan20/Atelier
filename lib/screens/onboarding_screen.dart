import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.edit_note_outlined,
      title: 'Welcome to Atelier',
      subtitle: 'A mindful space for your tasks.\nCrafted with care, designed for focus.',
      gradient: [Color(0xFF545a94), Color(0xFF484e87)],
    ),
    _OnboardingPage(
      icon: Icons.phone_android_outlined,
      title: 'Fully Local',
      subtitle: 'Your data never leaves your device.\nNo accounts, no cloud, no tracking.',
      gradient: [Color(0xFF545e7e), Color(0xFF3d4a66)],
    ),
    _OnboardingPage(
      icon: Icons.gesture,
      title: 'Swipe to Act',
      subtitle: 'Swipe right to complete tasks.\nSwipe left to postpone to tomorrow.',
      gradient: [Color(0xFF6b5e8a), Color(0xFF545a94)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: widget.onComplete,
                  child: Text('Skip',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      )),
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon in gradient circle
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: page.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Icon(page.icon, size: 48, color: Colors.white),
                        ),
                        SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            letterSpacing: -0.5,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            height: 1.6,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: i == _currentPage ? 24 : 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Next / Get Started
                  FilledButton(
                    onPressed: () {
                      if (isLast) {
                        widget.onComplete();
                      } else {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(
                          horizontal: isLast ? 28 : 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      isLast ? 'Get Started' : 'Next',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
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

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}
