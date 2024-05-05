// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:untitled/Views/RegisterManager.dart';
import 'package:untitled/Views/Warehouse-staff/warehouse.dart';
import 'package:untitled/Views/Sales/HomeSales.dart';
import 'package:untitled/Views/ForgotPassword.dart';
import 'package:untitled/Views/Manager/HomeManager.dart';
import '../Backend/login_auth.dart';
import '../controllers/VerifyEmail.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;
  String? _emailErrorText;
  String? _passwordErrorText;
  bool _isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 3, left: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Dear',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.53,
              child: Stack(
                children: [
                  Positioned.fill(
                    top: MediaQuery.of(context).size.height * 0.1,
                    child: Image.asset(
                      'lib/assets/images/login1.jpeg',
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
                    SizedBox(height: 30.0),
                    Container(
                      width: double.infinity,
                      child: _buildTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        icon: Icons.email,
                        errorText: _emailErrorText,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      child: _buildTextField(
                        controller: _passwordController,
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
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        errorText: _passwordErrorText,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          primary: Color.fromARGB(255, 4, 98, 175),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 14.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
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

  Future<void> _signIn() async {
    setState(() {
      _emailErrorText = null;
      _passwordErrorText = null;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
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
      setState(() {
        _isLoading = true;
      });
      final user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // if (!user.emailVerified) {
          // If email is not verified, navigate to the verify email screen
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => EmailVerification()),
          // );
          // return;
        // }
        final userRole = await _authService.getUserRole(user.uid);
        if (userRole == 'manager') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomepageManager()),
          );
        } else if (userRole == 'warehouse staff') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomepageWH()),
          );
        } else if (userRole == 'sales personnel') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomepageSales()),
          );
        } else if (userRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegisterView()),
          );
        } else {
          print('Unknown role: $userRole');
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      setState(() {
        _emailErrorText = 'Invalid email or password';
        _passwordErrorText = 'Invalid email or password';
      });
      print('Error signing in: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      keyboardType: TextInputType.emailAddress,
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
