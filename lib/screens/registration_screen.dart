import 'package:flutter/material.dart';
import 'package:smart_book_access/model/registration.dart';
import 'package:smart_book_access/screens/login_screen.dart';
import 'package:smart_book_access/widgets/my_button.dart';
import 'package:smart_book_access/widgets/my_text_form_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  // Multiple users lai store garne [<Registration> is a model]
  List<Registration> lstRegistration = [];


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
                  child: MyTextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Enter your name",
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
                      return null;
                    },
                  ),
                ),
        
                // Email
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: MyTextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Enter email",
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
        
                // Phone number
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: MyTextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Enter phone number",
                        hintText: "98000000",
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF00354B)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                        )
                      ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required.';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Phone number must be exactly 10 digits.';
                      }
                      return null;
                    },
                  ),
                ),
                
                // Password
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: MyTextFormField(
                      controller: _passwordController,
                      isPassword: true,
                      decoration: InputDecoration(
                        labelText: "Create password",
                        hintText: "Min 8 characters",
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF00354B)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Password must be at least 8 characters.';
                        }
                        return null;
                      },
                  ),
                ),
        
                // Confirm Password
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: MyTextFormField(
                      controller: _confirmPasswordController,
                      isPassword: true,
                      decoration: InputDecoration(
                        labelText: "Confirm password",
                        hintText: "Re-enter password",
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF00354B)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password.';
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
                    child: MyButton(onPressed: (){
                      if(_formkey.currentState!.validate()){
                        // Object banayeko
                        Registration newRegistration = Registration(
                            name: _nameController.text,
                            email: _emailController.text,
                            phoneNumber: _phoneNumberController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text
                        );
        
                        // Add the new registration to the list
                        setState(() {
                          lstRegistration.add(newRegistration);
                        });
        
                        // Clear the form fields after adding
                        _nameController.clear();
                        _emailController.clear();
                        _phoneNumberController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();

                        // Navigate to LoginScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      }
                    },
                        text: "SIGNUP"
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text('SIGNIN',
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
        ),
      ),
    );
  }
}
