// ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/HomeManager.dart';
import 'package:untitled/Views/RegisterManager.dart';
import 'package:untitled/Views/login.dart';
import 'package:untitled/controllers/VerifyEmail.dart';
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
class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, AsyncSnapshot<void> snapshot) {
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
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: AppBar(title: Text('Home')),
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  appBar: AppBar(title: Text('Home')),
                  body: Center(child: Text('Error fetching user')),
                );
              } else {
                final user = snapshot.data;
                if (user != null) {
                  if (user.emailVerified) {
                    return _buildHomePage(user.uid);
                  } else {
                    return VerifyEmailView(); // Show VerifyEmailView if email is not verified
                  }
                } else {
                  return LoginView(); // Show login view if user is not logged in
                }
              }
            },
          );
        }
      },
    );
  }

  Widget _buildHomePage(String userId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Center(child: Text('Error fetching user data')),
          );
        } else {
          final userRole = snapshot.data!.get('role') as String?;
          if (userRole != null) {
            switch (userRole) {
              case 'manager':
                return HomepageManager();
              case 'wholesale distributor':
                return HomePageWarehouse();
              case 'sales personnel':
                return HomepageSales();
              case 'admin':
                return RegisterView();
              default:
                return Scaffold(
                  appBar: AppBar(title: Text('Home')),
                  body: Center(child: Text('Unknown role: $userRole')),
                );
            }
          } else {
            return Scaffold(
              appBar: AppBar(title: Text('Home')),
              body: Center(child: Text('User role not found')),
            );
          }
        }
      },
    );
  }
}


// class HomePage extends StatelessWidget {
//   const HomePage({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _fetchUserData(),
//       builder: (context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             appBar: AppBar(title: Text('Home')),
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else if (snapshot.hasError) {
//           return Scaffold(
//             appBar: AppBar(title: Text('Home')),
//             body: Center(child: Text('Error initializing Firebase')),
//           );
//         } else {
//           final user = FirebaseAuth.instance.currentUser;
//           if (user != null && user.emailVerified) {
//             final userRole = (snapshot.data?.data()
//                 as Map<String, dynamic>?)?['role'] as String?;
//             if (userRole != null) {
//               switch (userRole) {
//                 case 'manager':
//                   return HomepageManager();
//                 case 'wholesale distributor':
//                   return HomePageWarehouse();
//                 case 'sales personnel':
//                   return HomepageSales();
//                 case 'admin':
//                   return RegisterView();
//                 default:
//                   return Scaffold(
//                     appBar: AppBar(title: Text('Home')),
//                     body: Center(child: Text('Unknown role: $userRole')),
//                   );
//               }
//             } else {
//               return LoginView(); // Show login view if user role is not available
//             }
//           } else {
//             // User's email is not verified, navigate to VerifyEmailView
//             WidgetsBinding.instance?.addPostFrameCallback((_) {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => const VerifyEmailView(),
//               ));
//             });
//             // Return an empty container while navigating
//             return Container();
//           }
//         }
//       },
//     );
//   }

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
// }
