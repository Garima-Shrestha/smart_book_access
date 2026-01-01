import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/app/routes/app_routes.dart';
import 'package:lost_n_found/app/theme/app_colors.dart';
import 'package:lost_n_found/core/utils/snackbar_utils.dart';
import 'package:lost_n_found/features/auth/presentation/page/signup_page.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:lost_n_found/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:lost_n_found/core/widgets/my_button.dart';
import 'package:lost_n_found/features/dashboard/presentation/page/dashboard_page.dart';

class LoginPage extends ConsumerStatefulWidget  {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formkey.currentState!.validate()) {
      await ref.read(authViewModelProvider.notifier)
          .login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
      );
    }
  }

  void _navigateToSignup() {
    AppRoutes.push(context, const SignupPage());
  }

  // void _handleForgotPassword() {
  //   // TODO: Implement forgot password
  //   SnackbarUtils.showInfo(context, 'Forgot password feature coming soon');
  // }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next){
      if(next.status == AuthStatus.authenticated) {
        AppRoutes.pushReplacement(context, DashboardPage());
      } else if (next.status == AuthStatus.error && next.errorMessage != null){
        SnackbarUtils.showError(
          context, next.errorMessage!);
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
                  // Logo
                  SizedBox(height: 20),
                  Center(child: Image.asset('assets/images/logo.png', height: 237)),

                  // Text
                  Center(child: Text("Sign in your account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),

                  // Email
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "example@gmail.com",
                          prefixIcon: Icon(Icons.email, color: Color(0xFF00354B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if(!emailRegex.hasMatch(value)){
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Password
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Forgot Password
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0, top: 6.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        // onPressed: _handleForgotPassword,
                        onPressed: (){},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF1A68EE),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),


                  // Signin Button
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 90.0, right: 90.0),
                    child: SizedBox(
                      height: 51,
                      child: MyButton(
                        text: "SIGNIN",
                        onPressed: _handleLogin,
                        isLoading: authState.status == AuthStatus.loading,
                      ),
                    ),
                  ),


                  // SignUp Navigation
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Color(0xFF888888), fontSize: 17)),

                      GestureDetector(
                        onTap: _navigateToSignup,
                        child: Text('SIGNUP',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1A68EE),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
          )
      ),
    );
  }
}