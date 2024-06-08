// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eventhub/screen/signup/signup_screen.dart';
// import 'package:flutter/material.dart';

// class SignUpOption extends StatelessWidget {
//   const SignUpOption({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose Account Type'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SignUp(
//                         accountType: 'Organizer',
//                         firestore: FirebaseFirestore.instance),
//                   ),
//                 );
//               },
//               child: const Text('Sign Up as Organizer'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SignUp(
//                         accountType: 'Participant',
//                         firestore: FirebaseFirestore.instance),
//                   ),
//                 );
//               },
//               child: const Text('Sign Up as Participant'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
