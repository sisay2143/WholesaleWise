import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/firebase_options.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text ('Manager view')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          // Switch (snapshot.connectionState) {
          //  case ConnectionState.done:
          //  break;
          // }
          final user = (FirebaseAuth.instance.currentUser);
          if (user?.emailVerified ?? false) {
            print('You are a verified user');
          } else {
            print('You need to verify your email first');
          }
          return Text('done');
          // default: return Text('Loading...');
        },
      ),
    );
  }
}