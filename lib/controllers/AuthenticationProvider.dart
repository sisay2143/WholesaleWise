// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'AuthProvider.dart'; // Import your AuthProvider class
// import 'package:cloud_firestore/cloud_firestore.dart'; 
// import 'FirebaseInitialization.dart';

// class AuthenticationProvider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => AuthProvider()),
//         StreamProvider<DocumentSnapshot?>.value(
//           initialData: null,
//           value: Provider.of<AuthProvider>(context).currentUser != null
//               ? FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(Provider.of<AuthProvider>(context).currentUser?.uid)
//                   .snapshots()
//               : null,
//         ),
//       ],
//       child: FirebaseInitialization(),
//     );
//   }
// }
