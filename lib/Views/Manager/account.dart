// ignore_for_file: prefer_const_constructors
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CreateUser.dart';
import '../login.dart';
import 'profilescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(
            'Accounts',
            style: TextStyle(
              color: Colors.black, // Set your desired color here
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            PopupMenuButton<String>(
              color: Color.fromARGB(255, 2, 86, 128),
              onSelected: (String result) {
                if (result == 'settings') {
                  // Navigate to settings page
                } else if (result == 'logout') {
                  FirebaseAuth.instance.signOut(); //
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                  // Implement logout functionality
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 171, 126, 123),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.settings, color: Colors.white),
                      title: Text(
                        'Settings',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8), // Adjust padding as needed
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 171, 126, 123),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.white),
                        title: Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color.fromARGB(255, 3, 94, 147),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 140,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 223, 211, 211),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          primary: Color.fromARGB(255, 223, 211, 211),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 17, vertical: 15),
                          child: Text(
                            'Manage My Account',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateUser()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          primary: Color.fromARGB(255, 223, 211, 211),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          child: Text(
                            'Add a User',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    '    Users',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', whereIn: [
                  'warehouse staff',
                  'sales personnel'
                ]).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final users = snapshot.data?.docs ?? [];
                  return Column(
                    children: users.map((userDoc) {
                      final userData = userDoc.data() as Map<String, dynamic>;
                      final String name = userData['name'] ?? 'No Name';
                      final String email = userData['email'] ?? 'No Email';
                      final String role = userData['role'] ?? 'No Role';
                      final String profileImg =
                          userData['profileImg'] ?? ''; // Add imageUrl
                      final String phone = userData['phone'] ?? ''; // Add phone
                      return _buildUserContainer(
                        context,
                        name,
                        email,
                        phone,
                        profileImg,
                        role,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        )
        );
  }
}

Widget _buildUserContainer(
  BuildContext context,
  String name,
  String email,
  String phone,
  String profileImg,
  String role,
) {
  return Container(
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blue, width: 2),
    ),
    child: Row(
      children: [
        profileImg.isNotEmpty
            ? Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(profileImg),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue, // Use same background color as icon
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              role,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              phone,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    ),
  );
}

// void main() {
//   runApp(MaterialApp(
//     home: AccountPage(),
//   ));
// }
