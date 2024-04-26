import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/Views/login.dart';
// import '../login.dart';

class AccountViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  Stream<QuerySnapshot> getUsers() {
    return _firestore
        .collection('users')
        .where('role', whereIn: ['warehouse staff', 'sales personnel'])
        .snapshots();
  }
}
