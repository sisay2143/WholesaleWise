import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Views/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key});
  

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
         backgroundColor: Color.fromARGB(255, 3, 94, 147),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _password,
              obscureText: true,
              onChanged: _checkPasswordStrength,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password here',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: _passwordBorderColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
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
                    final errorMessage = e.message ?? 'An error occurred';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Register', style: TextStyle(fontSize: 18.0)),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    
                  ),
                     primary: Color.fromARGB(255, 4, 98, 175),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
