// import 'package:flutter/material.dart';
// import 'package:smart_book_access/model/profile.dart';
//
// class ProfileListItem extends StatelessWidget {
//   final ProfileItem item;
//
//   const ProfileListItem({super.key, required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: item.onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Icon
//             Icon(item.icon, color: Color(0xFF1E88E5),
//             size: 30,
//             ),
//
//             const SizedBox(width: 33),
//
//             // Title and Subtitle
//             Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       item.title,   // title
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 2.0),
//                       child: Text(
//                         item.subtitle,  // subtitle
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//             ),
//
//             // Trailing Arrow
//             // Show the arrow for all items except the logout option.
//             if(!item.isLogout)
//               Padding(
//                 padding: const EdgeInsets.only(right: 16.0),
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 20,
//                   color: Colors.grey[600],
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
