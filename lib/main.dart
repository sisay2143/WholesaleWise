// ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/HomeManager.dart';
import 'package:untitled/Views/RegisterManager.dart';
import 'package:untitled/Views/login.dart';
import 'package:untitled/controllers/VerifyEmail.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Views/HomeWarehouse.dart';
import 'Views/HomeSales.dart';

void main() {
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
    home:  LoginView(),
  ));
}

// final dbRef = FirebaseDatabase.instance.reference().child('users');
