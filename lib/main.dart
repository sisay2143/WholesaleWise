// ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/HomeManager.dart';
import 'package:untitled/Views/RegisterManager.dart';
import 'package:untitled/Views/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'Views/HomeWarehouse.dart';
import 'Views/HomeSales.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
   // Initialize Firebase
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 27, 18, 41)),
        // useMaterial3: true,
      ),
      home: HomePage(),
    ));
  }).catchError((error) {
    print('Error initializing Firebase: $error');
  });
}

//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: 'Flutter Demo',
//     theme: ThemeData(
//       colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromARGB(255, 27, 18, 41)),
//       // useMaterial3: true,
//     ),
//     home: HomePage(),
//   ));
// }

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUserData(), 
      // Call function to fetch user data

      
      builder: (context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Center(child: Text('Error initializing Firebase')),
          );
        } else {
          final userRole = (snapshot.data?.data() as Map<String, dynamic>?)?['role'] as String?;
          
          if (FirebaseAuth.instance.currentUser != null && userRole != null) {
            switch (userRole) {
              case 'manager':
                return HomepageManager();
              case 'wholesale distributor':
                return HomePageWarehouse();
              case 'sales personnel':
                return HomepageSales();
              default:
                return Scaffold(
                  appBar: AppBar(title: Text('Home')),
                  body: Center(child: Text('Unknown role: $userRole')),
                );
            }
          } else {
            return LoginView();
          }
        }
      },
    );
  }

  Future<DocumentSnapshot?> _fetchUserData() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      return userSnapshot;
    } catch (error) {
      // Handle error fetching user data
      return null;
    }
  }
}


// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: FutureBuilder(
//         future: Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform,
//         ),

//         builder:  (context, snapshot) async {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error initializing Firebase'));
//           } else {
//             // Access user role directly from DocumentSnapshot
//             final userSnapshot = await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                 .get();
//                 final userData = userSnapshot.data();
//                 final userRole = userData?['role'] as String?;
           
//               // final userRole = userSnapshot.data()?['role'] as String?;


//             if (FirebaseAuth.instance.currentUser != null && userRole != null) {
//               // Role-based logic
//               switch (userRole) {
//                 case 'manager':
//                   return HomepageManager();
//                 case 'wholesale distributor':
//                   return HomePageWarehouse();
//                 case 'sales personnel':
//                   return HomepageSales();
//                 default:
//                   // For unknown roles, you can handle it accordingly
//                   return Scaffold(
//                     body: Center(
//                       child: Text('Unknown role: $userRole'),
//                     ),
//                   );
//               }
//             } else {
//               // If user is not authenticated or role is not defined, redirect to login
//               return LoginView();
//             }
//           }
      
//         // builder: (context, snapshot) {
//         //   switch (snapshot.connectionState) {
//         //     case ConnectionState.done:
//         //     // Handle when the connection is done.
//         //     // break;
//         //     return Text('done');
//         //     default:
//         //       return Text('Loading...');
//         //     // Handle other connection states.
//         //   }
//         // },
//         }
//       ),
  
//     );
//   }
// }


