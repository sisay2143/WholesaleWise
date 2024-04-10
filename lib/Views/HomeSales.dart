import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/login.dart';

class HomepageSales extends StatefulWidget {
  const HomepageSales({super.key});

  @override
  State<HomepageSales> createState() => _HomepageSalesState();
}

class _HomepageSalesState extends State<HomepageSales> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Sales personnel Home'),
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
