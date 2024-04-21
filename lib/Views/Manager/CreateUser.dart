import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'warehouse staff'; // Default role

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Register New User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: <String>[
                'warehouse staff',
                'sales personnel',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 16.0),
           ElevatedButton(
  onPressed: () async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text,
        'role': _selectedRole,
      });

      // Clear text fields after successful registration
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User registered successfully!'),
        ),
      );
    } catch (e) {
      print('Error registering user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering user'),
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 120.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    primary: Color.fromARGB(255, 4, 98, 175),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Register',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

          ],
        ),
      ),
    );
  }
}


