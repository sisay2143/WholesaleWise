// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/SalesRecords.dart';

import 'package:untitled/Views/login.dart';
import 'package:pie_chart/pie_chart.dart';
import 'CommitSale.dart';
import 'Profile.dart';
import 'QRScanScreen.dart';
import 'Myslider.dart';

class HomepageSales extends StatefulWidget {
  const HomepageSales({Key? key});

  @override
  State<HomepageSales> createState() => _HomepageSalesState();
}

class _HomepageSalesState extends State<HomepageSales> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CommitSale(),
    // Add Sales Records and Profile widgets here
    SalesRecords(),
    Profile(),
  ];

  static List<String> _appBarTitles = [
    'Sales Home',
    'Commit Sales',
    'Sales Records',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Commit Sales',
          ),
          // Add Sales Records and Profile icons here
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Sales Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: true, // Ensure that selected labels are visible
        showUnselectedLabels: true, // Ensure that unselected labels are visible
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black), // Text color
        ),
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
              style: TextStyle(color: Colors.black), // Text color
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Notification()),
              // );
            },
            icon: Icon(Icons.notifications, color: Colors.black), // Icon color
          ),
        ],
      ),
      body: Column(
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
            padding:
                const EdgeInsets.only(bottom: 5, top: 5, right: 15, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SizedBox(width: 10),
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
          // This function will be called when the icon button is pressed
          // You can add your custom logic here
          print('QR code icon pressed!');
          // _scanBarcode();
        },
      ),
    ),
  // }
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          SizedBox(height: 20),
        ],
      ),
       
    );
  }
}


class SalesRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Text('Sales Records Page'),
      ),
    );
  }
}

class IconWithBackground extends StatelessWidget {
  final IconData iconData;

  IconWithBackground(this.iconData);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 50,
        ),
      ),
    );
  }
}

class HeroSec extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeroSec(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}

class CarouselStatus extends StatelessWidget {
  final int itemCount;
  final int currentSlide;

  const CarouselStatus(
      {Key? key, required this.itemCount, required this.currentSlide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int index = 0; index < itemCount; index++)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentSlide == index
                  ? const Color.fromARGB(255, 30, 69, 224)
                  : Colors.white,
            ),
          ),
      ],
    );
  }
}
