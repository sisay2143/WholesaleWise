// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// // import 'package:your_app_name/auth_provider.dart';
// import 'AuthProvider.dart'; // Import your AuthProvider class
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// // import '../Views/HomeManager.dart';
// import '../Views//HomeSales.dart';
// import '../Views/HomeWarehouse.dart';
// import '../Views/login.dart';



// class FirebaseInitialization extends StatelessWidget {
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initialization,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // While waiting for Firebase initialization, return a loading indicator
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // If an error occurs during initialization, display an error message
//           return Center(
//             child: Text('Error initializing Firebase'),
//           );
//         } else {
//           // Firebase initialization is complete, return the child widget
//           return Consumer<AuthProvider>(
//             builder: (context, authProvider, _) {
//               final userSnapshot = Provider.of<DocumentSnapshot?>(context);
//               final userRole = userSnapshot?.data() as Map<String, dynamic>? ?? {}['role'];

//               if (authProvider.currentUser != null && userRole != null) {
//                 if (userRole == 'manager') {
//                   // return HomepageManager();
//                 } else if (userRole == 'wholesale distributor') {
//                   return HomePageWarehouse();
//                 } else if (userRole == 'sales personnel') {
//                   return HomepageSales();
//                 } else {
//                   return Scaffold(
//                     body: Center(
//                       child: Text('Unknown role: $userRole'),
//                     ),
//                   );
//                 }
//               } else {
//                 return LoginView();
//               }
//             },
//           );
//         }
//       },
//     );
//   }
// }
