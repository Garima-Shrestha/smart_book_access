import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  final Color primaryBlue = const Color(0xFF1E88E5);
  final Color lightBg = const Color(0xFFF7F9FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            "Smart Book access values your privacy. This policy explains how we collect, use, and protect your data when you use our book rental app.",
            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 24),


          Text( "1. Information We Collect",
            style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("We may collect:", style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black87)),
          const SizedBox(height: 8),
          _bulletPoints("Name and email"),
          _bulletPoints("Payment-related details (processed securely by third-party services)"),
          _bulletPoints("Book rental history and reading activity"),
          _bulletPoints("Device and usage data (e.g., IP address, app interactions)"),
          _bulletPoints("Saved notes or quotes (optional)"),

          const SizedBox(height: 24),


          Text( "2. How We Use Your Data",
            style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("We use your information to:", style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black87)),
          const SizedBox(height: 8),
          _bulletPoints("Process book rentals and verify payments"),
          _bulletPoints("Provide access to books during the rental period"),
          _bulletPoints("Manage rental expiration and restrictions"),
          _bulletPoints("Improve app performance and features"),
          _bulletPoints("Send important updates and notifications"),
          _bulletPoints("Keep the platform safe and prevent misuse"),

          const SizedBox(height: 24),


          Text( "3. Sharing Your Data",
            style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("We do not sell your data.\nWe only share:", style: TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 8),
          _bulletPoints("Payment information with secure payment providers"),
          _bulletPoints("Data with services that help us operate the app"),
          _bulletPoints("Information if required by law or for safety purposes"),

          const SizedBox(height: 24),


          Text( "4. Your Rights",
            style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("You can:", style: TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 8),
          _bulletPoints("View or update your profile"),
          _bulletPoints("Request deletion of your account"),
          _bulletPoints("Access your stored data"),
          _bulletPoints("Manage notification settings"),
          _bulletPoints("Contact us with any privacy questions"),

          const SizedBox(height: 24),


          Text( "5. Data Security",
            style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "We use secure systems to protect your data, but no system is completely risk-free. Please keep your account details safe.",
            style: TextStyle(fontSize: 15, height: 1.4),
          ),

          const SizedBox(height: 24),


          Text( "6. Children's Privacy",
            style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Our app is not intended for children under 13. We do not knowingly collect their data.",
            style: TextStyle(fontSize: 15, height: 1.4),
          ),

          const SizedBox(height: 24),


          Text( "7. Policy Updates",
            style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "We may update this policy. If changes are significant, we will notify you via the app.",
            style: TextStyle(fontSize: 15, height: 1.4),
          ),

          const SizedBox(height: 24),


          Text( "8. Contact Us",
            style: TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Have questions? Contact us at:", style: TextStyle(fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("📧 ", style: TextStyle(fontSize: 18)),
              Text(
                "novella@gmail.com",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _bulletPoints(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}