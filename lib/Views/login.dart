import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/Views/HomeManager.dart';
import 'HomeSales.dart';
import 'HomeWarehouse.dart';
import 'package:untitled/firebase_options.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isPasswordVisible = false;
  String? _emailErrorText;
  String? _passwordErrorText;

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
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40.0),
                          Text(
                            '    Hello, Dear',
                            style: TextStyle(
                              fontSize: 29.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: MediaQuery.of(context).size.height * 0.05,
                    child: Image.asset(
                      'lib/assets/login1.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.0),
                    Container(
                      width: double.infinity,
                      child: _buildTextField(
                        controller: _email,
                        labelText: 'Email',
                        icon: Icons.email,
                        errorText: _emailErrorText,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      child: _buildTextField(
                        controller: _password,
                        labelText: 'Password',
                        icon: Icons.lock,
                        isPassword: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        errorText: _passwordErrorText,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Clear previous error messages
                        setState(() {
                          _emailErrorText = null;
                          _passwordErrorText = null;
                        });

                        final email = _email.text.trim();
                        final password = _password.text.trim();

                        // Check for empty fields
                        if (email.isEmpty) {
                          setState(() {
                            _emailErrorText = 'Email is required';
                          });
                          return;
                        }

                        if (password.isEmpty) {
                          setState(() {
                            _passwordErrorText = 'Password is required';
                          });
                          return;
                        }

                        try {
                          final UserCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                          final userDoc = await _firestore
                              .collection('users')
                              .doc(UserCredential.user!.uid)
                              .get();
                          final userRole = userDoc['role'];

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
                            print('Unknown role: $userRole');
                          }
                        } catch (e) {
                          setState(() {
                            _emailErrorText = 'Invalid email or password';
                            _passwordErrorText = 'Invalid email or password';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 120.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        primary: Color.fromARGB(255, 4, 98, 175),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.0),
                    GestureDetector(
                      onTap: () {
                        // Forgot password logic
                      },
                      child: Text(
                        '    Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.black),
        suffixIcon: suffixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        errorText: errorText,
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
