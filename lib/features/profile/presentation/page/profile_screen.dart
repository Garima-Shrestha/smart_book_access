import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/app/routes/app_routes.dart';
import 'package:smart_book_access/features/auth/presentation/page/login_page.dart';
import 'package:smart_book_access/features/auth/presentation/state/auth_state.dart';
import 'package:smart_book_access/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:smart_book_access/features/profile/presentation/page/edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final Color primaryBlue = const Color(0xFF1E88E5);
  final Color avatarBlue = const Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    ImageProvider? getImageProvider() {
      final savedPath = user?.imageUrl;
      if (savedPath == null || savedPath.isEmpty) return null;

      // If the image is NOT on this phone, download it from our Node.js server
      if (savedPath.startsWith('/uploads')) {
        return NetworkImage("http://10.0.2.2:5050$savedPath");
      }

      // Handle local file paths
      if (savedPath.startsWith('/') && !savedPath.startsWith('/uploads')) {
        final localFile = File(savedPath);
        return localFile.existsSync() ? FileImage(localFile) : null;
      }

      // Fallback for standard web URLs
      if (savedPath.startsWith('http')) {
        return NetworkImage(savedPath);
      }
      return null;
    }

    final imageProvider = getImageProvider();

    // Listen for logout state to navigate back to login
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        AppRoutes.pushReplacement(context, const LoginPage());
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 30),

            // Image, Name, Email Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryBlue.withOpacity(0.15), width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 48,
                        // We keep avatarBlue if there  is no image to show the letter clearly
                        backgroundColor: imageProvider == null
                            ? avatarBlue
                            : Colors.transparent,
                        // If imageUrl exists and is valid, use NetworkImage, else null
                          backgroundImage: imageProvider,
                        // If no image, display the 1st letter of username
                        child: imageProvider == null
                            ? Text(
                          (user?.username != null && user!.username.trim().isNotEmpty)
                              ? user.username.trim()[0].toUpperCase()
                              : "U",
                          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: primaryBlue),
                        )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.username ?? "User Name",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? "email@example.com",
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // Menu Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuRow(
                    icon: Icons.account_circle_outlined,
                    iconColor: primaryBlue,
                    title: "Edit Profile",
                    subtitle: "Edit your information",
                    onTap: () => AppRoutes.push(context, const EditProfileScreen()),
                  ),
                  _buildMenuRow(
                    icon: Icons.list_alt_rounded,
                    iconColor: Colors.blueGrey,
                    title: "Activity Overview",
                    subtitle: "View your activity",
                    onTap: () {},
                  ),
                  _buildMenuRow(
                    icon: Icons.edit_note_outlined,
                    iconColor: primaryBlue,
                    title: "Account details",
                    subtitle: "Manage your account",
                    onTap: () {},
                  ),
                  _buildMenuRow(
                    icon: Icons.description_outlined,
                    iconColor: Colors.lightBlue.shade300,
                    title: "Privacy Policy",
                    onTap: () {},
                  ),
                  _buildMenuRow(
                    icon: Icons.logout_rounded,
                    iconColor: Colors.redAccent,
                    title: "Logout",
                    titleColor: Colors.redAccent,
                    onTap: () {
                      ref.read(authViewModelProvider.notifier).logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color titleColor = Colors.black87,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: titleColor),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.black45, fontSize: 13))
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
    );
  }
}