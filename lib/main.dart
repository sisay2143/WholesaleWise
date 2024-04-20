
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/RegisterManager.dart';
import 'package:untitled/Views/Warehouse-staff/warehouse.dart';
import 'package:untitled/Views/login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'Views/warehouse-staff/HomeWarehouse.dart';
import 'Views/Manager/HomeManager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginView(),
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
            // appBar: AppBar(title: Text('Home')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            // appBar: AppBar(title: Text('Home')),
            body: Center(child: Text('Error initializing Firebase')),
          );
        } else {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  // appBar: AppBar(title: Text('Home')),
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  // appBar: AppBar(title: Text('Home')),
                  body: Center(child: Text('Error fetching user')),
                );
              } else {
                final user = snapshot.data;
                if (user != null) {
                  if (user.emailVerified) {
                    // Navigate to the home page if the user is logged in and email is verified
                    return _buildHomePage(user.uid);
                  } else {
                    // Show the email verification view if the user's email is not verified
                    return _buildHomePage(user.uid);;
                  }
                } else {
                  // Show the login view if the user is not logged in
                  return LoginView();
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
            // appBar: AppBar(title: Text('Home')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            // appBar: AppBar(title: Text('Home')),
            body: Center(child: Text('Error fetching user data')),
          );
        } else {
          final userRole = snapshot.data!.get('role') as String?;
          if (userRole != null) {
            switch (userRole) {
              case 'manager':
                return HomepageManager();
              case 'warehouse staff':
                return HomepageWH();
              case 'sales personnel':
                // return HomepageSales();
              case 'admin':
                return RegisterView();
              default:
                return Scaffold(
                  // appBar: AppBar(title: Text('Home')),
                  body: Center(child: Text('Unknown role: $userRole')),
                );
            }
          } else {
            return Scaffold(
              // appBar: AppBar(title: Text('Home')),
              body: Center(child: Text('User role not found')),
            );
          }
        }
      },
    );
  }
}
