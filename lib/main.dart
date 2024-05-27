
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/RegisterManager.dart';
import 'package:untitled/Views/Warehouse-staff/warehouse.dart';
import 'package:untitled/Views/login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Views/warehouse-staff/HomeWarehouse.dart';
import 'Views/Manager/HomeManager.dart';

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

