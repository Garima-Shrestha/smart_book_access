import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/app/routes/app_routes.dart';
import 'package:smart_book_access/features/auth/presentation/page/login_page.dart';
import 'package:smart_book_access/features/auth/presentation/state/auth_state.dart';
import 'package:smart_book_access/features/auth/presentation/view_model/auth_view_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        AppRoutes.pushReplacement(context, const LoginPage());
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(authViewModelProvider.notifier).logout();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
