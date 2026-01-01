// import 'package:flutter/material.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 30.0, top: 40.0, bottom: 20.0),
//             child: Text("Profile", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:smart_book_access/models/profile.dart';
// // import 'package:smart_book_access/screens/login_screen.dart';
// // import 'package:smart_book_access/widgets/profile_list_item.dart';
// //
// // class ProfileScreen extends StatefulWidget {
// //   const ProfileScreen({super.key});
// //
// //   @override
// //   State<ProfileScreen> createState() => _ProfileScreenState();
// // }
// //
// // class _ProfileScreenState extends State<ProfileScreen> {
// //   // List of data for profile
// //   final List<ProfileItem> profileItems = [
// //     ProfileItem(
// //         icon: Icons.person_outline,
// //         title: 'Edit Profile',
// //         subtitle: 'Edit your information',
// //         onTap: () {
// //           print('Edit Profile Tapped');
// //         }
// //     ),
// //     ProfileItem(
// //       icon: Icons.description_outlined,
// //       title: 'Activity Overview',
// //       subtitle: 'View your activity',
// //       onTap: () {},
// //     ),
// //     ProfileItem(
// //       icon: Icons.edit_note,
// //       title: 'Account details',
// //       subtitle: 'Manage your account',
// //       onTap: () {},
// //     ),
// //     ProfileItem(
// //       icon: Icons.assignment_outlined,
// //       title: 'Privacy Policy',
// //       subtitle: 'Read our privacy Policy',
// //       onTap: () {},
// //     ),
// //   ];
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       child: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(left: 30.0, top: 40.0, bottom: 20.0),
// //               child: Text("Profile", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
// //             ),
// //
// //             // List of Items
// //             Card(
// //               margin: const EdgeInsets.symmetric(horizontal: 16.0),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(15.0),
// //               ),
// //               color: Colors.white,
// //               elevation: 2,
// //               child: Column(
// //                 children: [
// //                   ListView.builder(
// //                     padding: const EdgeInsets.symmetric(vertical: 8.0),
// //                     shrinkWrap: true,
// //                     itemCount: profileItems.length,
// //                     itemBuilder: (context, index) {
// //                       final item = profileItems[index];
// //                       return ProfileListItem(item: item);
// //                     },
// //                   ),
// //
// //                   // Logout button
// //                   ProfileListItem(
// //                     item: ProfileItem(
// //                       icon: Icons.logout_rounded,
// //                       title: 'Logout',
// //                       subtitle: '',
// //                       onTap: () {
// //                         // Navigate to login screen and remove all previous routes
// //                         Navigator.pushAndRemoveUntil(
// //                           context,
// //                           MaterialPageRoute(builder: (context) => const LoginScreen()),
// //                               (route) => false,  // remove all previous routes
// //                         );
// //                       },
// //                       isLogout: true, // hides arrow icon
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             const SizedBox(height: 16),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }