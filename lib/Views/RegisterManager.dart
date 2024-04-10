import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Views/login.dart';
// import 'package:untitled/Views/login.dart';
import 'package:untitled/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final TextEditingController _name = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Color _passwordBorderColor =
      Colors.grey; // Initial border color for password input field

  String? _errorMessage; // Variable to hold error message
  bool _showErrorMessage = false;

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

  void _checkPasswordStrength(String value) {
    setState(() {
      // Check the strength of the password and update the border color
      if (value.length < 6) {
        // If password is weak, set border color to red
        _passwordBorderColor = Color.fromARGB(255, 255, 17, 0);
      } else {
        // If password is strong, set border color to default
        _passwordBorderColor = Colors.grey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
        actions: [
          TextButton(
            onPressed: () {
              // Perform logout operation
              FirebaseAuth.instance.signOut();

              // Navigate back to login view
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
              children: [
                TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Enter email here')),
                // TextField(
                //     controller: _password,
                //     obscureText: true,
                //     enableSuggestions: false,
                //     autocorrect: false,
                //     keyboardType: TextInputType.text,
                //     decoration: InputDecoration(hintText: 'Enter password here')),
                TextField(
                  controller: _password,
                  onSubmitted: _checkPasswordStrength,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter password here',
                    // Set border color dynamically based on password strength
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: _passwordBorderColor),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _errorMessage = null; // Reset error message
                      _showErrorMessage = false; // Reset flag
                    });
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final UserCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      await _firestore
                          .collection('users')
                          .doc(UserCredential.user!.uid)
                          .set({
                        'name': _name.text,
                        'email': _email.text,
                        'role': 'manager',
                      });
                      print(UserCredential);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        _errorMessage = 'Weak password';
                        print('weak password');
                      } else if (e.code == 'email-already-in-use') {
                        _errorMessage = 'Email is already in use';
                        print('Email is already in use');
                      } else if (e.code == 'invalid-email') {
                        _errorMessage = 'Invalid email entered';
                        print('invalid email entered');
                      } else {
                        _errorMessage = 'An error occurred: ${e.message}';
                      }
                      _showErrorMessage =
                          true; // Set flag to show error message

                      // });
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          _showErrorMessage = false; // Hide error message
                        });
                      });
                      // });
                    }

                    print(UserCredential);
                  },
                  child: Text('Register'),
                ),
                if (_errorMessage != null)
                  Text(
                    _errorMessage ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],)
            );
          }
          // );
  // }
}
