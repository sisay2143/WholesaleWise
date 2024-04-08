// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Views/HomeManager.dart';
import 'package:untitled/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeSales.dart';
import 'HomeWarehouse.dart';


class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  late final TextEditingController _email;
  late final TextEditingController _password;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          // Switch (snapshot.connectionState) {
          //  case ConnectionState.done:

          //  break;
          // }
          return Column(
            children: [
              TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Enter email here')),
              TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: 'Enter password here')),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final UserCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);

                            // Retrieve user role from Firestore
                  final userDoc = await _firestore
                      .collection('users')
                      .doc(UserCredential.user!.uid)
                      .get();
                  final userRole = userDoc['role'];

                   // Navigate to the appropriate homepage based on user role
                  if (userRole == 'manager') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomepageManager()),
                    );
                  } else if (userRole == 'wholesale distributor') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageWarehouse()),
                    );
                  } else if (userRole == 'sales personnel') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomepageSales()),
                    );
                  } else {
                    // Handle unknown role
                    print('Unknown role: $userRole');
                  }
                } catch (e) {
                  print('Error logging in: $e');
                  // Handle login error
                }
              },
               
                   
                child: Text('Login'),
              ),
            ],
          );
          // default: return Text('Loading...');
        },
      ),
    );
  }

  
}
