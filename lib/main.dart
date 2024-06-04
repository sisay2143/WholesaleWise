
import 'package:flutter/material.dart';
import 'package:untitled/Views/login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wholesale wise',
      home: LoginView(),
    ));
  }).catchError((error) {
    print('Error initializing Firebase: $error');
  });
}

