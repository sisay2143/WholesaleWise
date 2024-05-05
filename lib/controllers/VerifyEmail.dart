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
      body: Builder(
        builder: (BuildContext context) {
          return Center(
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
                    onPressed: () async {
                      // Trigger email verification again
                      if (FirebaseAuth.instance.currentUser != null) {
                        try {
                          await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                          // Show message indicating that a new verification email has been sent
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Verification email sent. Please check your inbox.'),
                            ),
                          );
                        } catch (e) {
                          print('Failed to send verification email: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Failed to send verification email. Please try again later.'),
                            ),
                          );
                        }
                      } else {
                        // Guide the user to log in first
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('User is not logged in.'),
                          ),
                        );
                      }
                    },
                    child: Text('Send Verification Email'),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
