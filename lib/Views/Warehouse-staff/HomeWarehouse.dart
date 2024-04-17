import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/login.dart';
import 'FCard.dart';
import 'Myslider.dart';

class HomePageWarehouse extends StatefulWidget {
  const HomePageWarehouse({super.key});

  @override
  State<HomePageWarehouse> createState() => _HomePageWarehouseState();
}

class _HomePageWarehouseState extends State<HomePageWarehouse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              child: Column(
                children: [
                  Stack(
                    children: [
                      MySlider(),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 238, 238, 238),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.qr_code),
                      onPressed: () {
                        print('QR code icon pressed!');
                        // _scanBarcode();
                      },
                    ),
                  ),
                ],
              ),
            ),
            DisplayCard(),
          ],
        ),
      ),
    );
  }
}
