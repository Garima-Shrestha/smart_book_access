import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/app/routes/app_routes.dart';
import 'package:lost_n_found/features/dashboard/presentation/page/dashboard_page.dart';
import 'package:lost_n_found/features/onboarding/presentation/page/onboarding_page.dart';
import 'package:lost_n_found/features/splash/presentation/view_model/splash_view_model.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () async {
      await ref.read(splashViewModelProvider.notifier).checkInitialPage();
      final state = ref.read(splashViewModelProvider);

      if (state.isLoggedIn == true) {
        AppRoutes.pushReplacement(context, const DashboardPage());
      } else {
        AppRoutes.pushReplacement(context, const OnboardingPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBFD6FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
          ],
        ),
      ),
    );
  }
}