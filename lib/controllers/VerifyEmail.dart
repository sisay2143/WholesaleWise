import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/login.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the login screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginView()),
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please verify your email address to continue.',
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Trigger email verification again
                  // This will send another verification email
                  // Make sure user is logged in and FirebaseAuth.instance.currentUser != null
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  // Show message indicating that a new verification email has been sent
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Verification email sent. Please check your inbox.'),
                    ),
                  );
                },
                child: Text('send Verification Email'),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
