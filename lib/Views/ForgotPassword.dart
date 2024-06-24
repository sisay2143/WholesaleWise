import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Backend/forgot_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.resetPassword(_emailController.text);
      _showSnackBar('Password reset email sent successfully check your email!');
    } catch (error) {
      _showSnackBar('Failed to reset password: $error');
      print('Failed to reset password: $error');
    }

    setState(() {
      _isLoading = false;
    });

     // Clear the email text field
  _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Forgot Password'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true || !value!.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double
                          .infinity, // Sets the width to match the parent width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 3, 94, 147),
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _resetPassword();
                          }
                        },
                        child: Text(
                          'Reset Password',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
