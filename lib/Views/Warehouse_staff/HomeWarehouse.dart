import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/login.dart';


class HomePageWarehouse extends StatefulWidget {
  const HomePageWarehouse({super.key});

  @override
  State<HomePageWarehouse> createState() => _HomePageWarehouseState();
}

class _HomePageWarehouseState extends State<HomePageWarehouse> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Warehouse staff Home'),
        actions: [
          TextButton(
            onPressed: () {
              // Perform logout operation
              FirebaseAuth.instance.signOut();

              // Navigate back to login view
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}