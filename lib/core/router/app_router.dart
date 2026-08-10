import 'package:slice_pay/modules/home/presentation/screens/home_screen.dart';
import 'package:slice_pay/modules/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:slice_pay/modules/onboarding/presentation/screens/setup_profile_screen.dart';
import 'package:slice_pay/core/utilities/cache_helper.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Widget initialScreen() {
    final onboardingSeen = CacheHelper.getData(key: 'onboarding_seen') as bool? ?? false;
    final setupDone = CacheHelper.getData(key: 'setup_done') as bool? ?? false;

    if (!onboardingSeen) return const OnboardingScreen();
    if (!setupDone) return const SetupProfileScreen();
    return HomeScreen();
  }
}
