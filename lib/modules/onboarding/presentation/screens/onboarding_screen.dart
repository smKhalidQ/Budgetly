import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/user_info/data/data_sources/cache_helper.dart';
import 'package:budget_buddy/modules/onboarding/presentation/screens/setup_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _pageCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await CacheHelper.saveData(key: 'onboarding_seen', value: true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SetupProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    final isLast = _currentPage == _pageCount - 1;

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 20, left: 20),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    t.skip,
                    style: GoogleFonts.cairo(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _SlidePage(
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: AppColor.accentColor,
                    title: t.onboarding1Title,
                    subtitle: t.onboarding1Subtitle,
                  ),
                  _SlidePage(
                    icon: Icons.receipt_long_rounded,
                    iconColor: AppColor.incomeColor,
                    title: t.onboarding2Title,
                    subtitle: t.onboarding2Subtitle,
                  ),
                  _SlidePage(
                    icon: Icons.savings_rounded,
                    iconColor: const Color(0xFFF9A825),
                    title: t.onboarding3Title,
                    subtitle: t.onboarding3Subtitle,
                  ),
                ],
              ),
            ),
            _DotsIndicator(count: _pageCount, current: _currentPage),
            const Gap(32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GestureDetector(
                onTap: _next,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isLast ? t.getStarted : t.next,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _SlidePage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 54, color: iconColor),
              ),
            ),
          ),
          const Gap(48),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}