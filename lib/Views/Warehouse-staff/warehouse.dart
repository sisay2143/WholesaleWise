

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts; // Added charts_flutter import
// import 'package:untitled/Views/sales/NotificationSales.dart';
// import 'package:untitled/Views/warehouse-staff/HomeWarehouse.dart';
import 'ProfileWarehouse.dart';
import 'HomeWarehouse.dart';
// import 'QRScanScreen.dart';


class HomepageWH extends StatefulWidget {
  const HomepageWH({Key? key});

  @override
  State<HomepageWH> createState() => _HomepageWHState();
}

class _HomepageWHState extends State<HomepageWH> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePageWarehouse(),
    CommitSale(),
    // Add Sales Records and Profile widgets here
    SalesRecords(),
    Profile(),
  ];

  // static List<String> _appBarTitles = [
  //   'Sales Home',
  //   'Commit Sales',
  //   'Sales Records',
  //   'Profile',
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex < _widgetOptions.length ? _widgetOptions.elementAt(_selectedIndex) : Container(),

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

class CommitSale extends StatelessWidget {
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