// import 'package:flutter/material.dart';
//
// class MyTextFormField extends StatefulWidget {
//   const MyTextFormField({
//     super.key,
//     this.labelText,
//     this.hintText,
//     required this.controller,
//     this.isPassword = false, // Default to false   [when user type then it text visible nahos bhanna ko lagi we are using isPassword]
//     this.keyboardType = TextInputType.text,  // on-screen keyboard layout that appears for the user
//     this.validator,   // To define the rules for valid input
//     this.decoration,
//   });
//
//   // callback
//   final String? labelText;
//   final String? hintText;
//   final TextEditingController controller;
//   final bool isPassword;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;  //validator is a function. It can contain string but also can be null.
//   final InputDecoration? decoration;  // Optional decoration
//
//
//   @override
//   State<MyTextFormField> createState() => _MyTextFormFieldState();
// }
//
// class _MyTextFormFieldState extends State<MyTextFormField> {
//   bool _obscure = true; // tracks password visibility
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       keyboardType: widget.keyboardType,
//       obscureText: widget.isPassword ? _obscure : false,
//       validator: widget.validator,
//
//       decoration: (widget.decoration ?? InputDecoration()).copyWith(
//         labelText: widget.labelText,
//         hintText: widget.hintText,
//
//         // Password eye
//         suffixIcon: widget.isPassword ? IconButton(
//             icon: Icon(
//                 _obscure ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.grey,
//             ),
//             onPressed: (){
//               setState(() {
//                 _obscure = !_obscure;
//               });
//             },
//         )
//             : null,
//       ),
//     );
//   }
// }
//
//
// /*decoration before ?? => if user give decoration use it,
// if user did not give decoration it will be blank, label and hint are not compulsory  */
//
// // copyWith is always used whether you provide decoration or not.
// // decoration: (decoration ?? InputDecoration()).copyWith => here InputDecoration is empty.
// // Even if the input decoration is blank, we write it so we can call copyWith on some object,
//
// /* lets say decoration is not null. It contains prefix icon, border, labeltext and hintText.
// now with the help of copyWith a new InputDecoration object is created.
// It copies everything from the developer’s decoration like prefix icon, border, labeltext and hinttext.
// Then it overrides labelText and hintText from MyTextFormField widget.
// Basically it means mytextfomfield ko labelText ra hintText ma j xa tei dekhaunxa in output not of screen page.
// But in this code screen ko ra yo page ko values are exactly same you won't see any difference in output.
// For eg, in this page in place of labelText: labelText, if you write labelText: "Hello", no matter what you write in other screens, Hello will be seen in the output.
// */