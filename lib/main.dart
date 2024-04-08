// ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Manager.dart';
import 'package:untitled/Views/Register.dart';
import 'package:untitled/Views/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Views/login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 27, 18, 41)),
      // useMaterial3: true,
    ),
    home:  RegisterView(),
  ));
}

// final dbRef = FirebaseDatabase.instance.reference().child('users');
