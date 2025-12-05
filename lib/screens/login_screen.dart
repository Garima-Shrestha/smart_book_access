import 'package:flutter/material.dart';
import 'package:smart_book_access/model/login.dart';
import 'package:smart_book_access/screens/homepage_screen.dart';
import 'package:smart_book_access/screens/registration_screen.dart';
import 'package:smart_book_access/widgets/my_button.dart';
import 'package:smart_book_access/widgets/my_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  List<Login> lstLogin = [];


  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
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
                  // Logo
                  SizedBox(height: 20),
                  Center(child: Image.asset('assets/images/logo.png', height: 237)),

                  // Text
                  Center(child: Text("Sign in your account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),

                  // Email
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: MyTextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Enter your email",
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
                    child: MyTextFormField(
                        controller: _passwordController,
                        isPassword: true,
                        decoration: InputDecoration(
                          labelText: 'Enter password',
                          hintText: "Min 8 characters",
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF00354B)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                  ),


                  // Signin Button
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(left: 90.0, right: 90.0),
                    child: SizedBox(
                      height: 51,
                      child: MyButton(onPressed: (){
                        if(_formkey.currentState!.validate()){
                          Login newLogin = Login(
                              email: _emailController.text,
                              password: _passwordController.text
                          );

                          setState(() {
                            lstLogin.add(newLogin);
                          });

                          _emailController.clear();
                          _passwordController.clear();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomepageScreen()),
                          );
                        }
                      },
                          text: "SIGNIN"),
                    ),
                  ),


                  // SignUp Navigation
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Color(0xFF888888), fontSize: 17)),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                          );
                        },
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
