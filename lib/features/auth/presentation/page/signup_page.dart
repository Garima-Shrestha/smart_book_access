import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_book_access/app/routes/app_routes.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';
import 'package:smart_book_access/core/widgets/my_button.dart';
import 'package:smart_book_access/features/auth/presentation/page/login_page.dart';
import 'package:smart_book_access/features/auth/presentation/state/auth_state.dart';
import 'package:smart_book_access/features/auth/presentation/view_model/auth_view_model.dart';

class SignupPage extends ConsumerStatefulWidget  {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  final _formkey = GlobalKey<FormState>();


  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedCountryCode = '+977'; // Default Nepal


  // Country codes
  final List<Map<String, String>> _countryCodes = [
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
    {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
  ];


  // // Mock auth data - will come from GET /api/v1/auth
  // List<AuthEntity> lstSignup = [];


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  Future<void> _handleSignup() async {
    if (_formkey.currentState!.validate()) {
      // Call view model register [Yo data lai view model ma pass garnu paryo]
      await ref.read(authViewModelProvider.notifier).register(
          name: _nameController.text,
          email: _emailController.text,
          phone: '$_selectedCountryCode${_phoneNumberController.text}',
          password: _passwordController.text
      );
    }
  }


  void _navigateToLogin() {
    // Navigator.of(context).pop();
    AppRoutes.pushReplacement(context, LoginPage());
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    // listen for auth state changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? 'Signup failed',
        );
      } else if (next.status == AuthStatus.registered) {
        AppRoutes.pushReplacement(context, LoginPage());
        // SnackbarUtils.showSuccess(
        //   context,
        //   next.errorMessage ?? 'Signup Successful',
        // );
      }
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,   // Reducing the height of the AppBar's toolbar. Default ma ~56.0 hunxa. 0.0 le height remove gardinxa.
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                // Logo
                Center(child: Image.asset('assets/images/logo.png', height: 157)),

                // Text
                // SizedBox(height: 30),
                Center(child: Text("Create your account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),

                // Name
                SizedBox(height: 41),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words, // 1st word lai capital banaidinxa
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      hintText: "Example",
                      prefixIcon: Icon(Icons.person, color: Color(0xFF00354B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required.';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                ),

                // Email
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email Address",
                        hintText: "example@gmail.com",
                        prefixIcon: Icon(Icons.email, color: Color(0xFF00354B)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Email is required.';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                ),

                // Phone number with Country Code
                SizedBox(height: 20),
                Row(
                  children: [
                    // Country Code Dropdown
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: SizedBox(
                        width: 120,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCountryCode,
                          decoration: InputDecoration(
                            labelText: 'Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF00354B)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF00354B)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                          items: _countryCodes.map((country) {
                            return DropdownMenuItem<String>(
                              value: country['code'],  // code -> +977
                              child: Row(
                                children: [
                                  Text(
                                    country['flag']!,   // Countries flag
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    country['code']!,  // Text 'Code'
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCountryCode = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Phone Number Field
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                              labelText: "Phone number",
                              hintText: "98000000",
                              prefixIcon: Icon(Icons.phone, color: Color(0xFF00354B)),
                              counterText: '', // hides 0/10
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required.';
                            }
                            if (value.length != 10) {
                              return 'Phone must be 10 digits';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'Only numbers allowed';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Password
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child:  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,  // hides the text
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Min 8 characters",
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF00354B)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||  value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                ),

                // Confirm Password
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,  // hides the text
                    decoration: InputDecoration(
                      labelText: "Confirm password",
                      hintText: "Re-enter password",
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF00354B)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password.';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                ),


                // Signup Button
                SizedBox(height: 55),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0, right: 80.0),
                  child: SizedBox(
                    height: 51,
                    child: MyButton(
                      text: "SIGNUP",
                      onPressed: _handleSignup,
                      isLoading: authState.status == AuthStatus.loading,
                    ),
                  ),
                ),

                  // SignIn Navigation
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account? ", style: TextStyle(color: Color(0xFF888888), fontSize: 17)),

                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        'SIGNIN',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF1A68EE),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60)
              ],
            )
        ),
      ),
    );
  }
}
