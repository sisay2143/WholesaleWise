import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart'
    as charts; // Added charts_flutter import
// import 'package:untitled/Views/Manager/itemlist.dart';
// import 'package:untitled/Views/sales/NotificationSales.dart';
// import 'package:untitled/Views/warehouse-staff/HomeWarehouse.dart';
import 'ProfileWarehouse.dart';
import 'HomeWarehouse.dart';
import 'itemlist.dart';
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
    ItemsList(),
    unKnown(),
    // Add Sales Records and Profile widgets here
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
        body: _selectedIndex < _widgetOptions.length
            ? _widgetOptions.elementAt(_selectedIndex)
            : Container(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: Colors.grey[
                      300]!), // Add line at the top of bottom navigation bar
            ),
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SizedBox(
                  width:
                      30, // Adjust the width and height according to your preference
                  height: 30,
                  child: Icon(Icons.home,
                      size: 30), // Adjust the size property of the Icon widget
                ),
                label: 'Home',
              ),

              BottomNavigationBarItem(
                icon: SizedBox(
                  width:
                      30, // Adjust the width and height according to your preference
                  height: 30,
                  child: Icon(Icons.check_circle,
                      size: 30), // Adjust the size property of the Icon widget
                ),
                label: 'itemList',
              ),
              // Add Sales Records and Profile icons here

              BottomNavigationBarItem(
                icon: SizedBox(
                  width:
                      30, // Adjust the width and height according to your preference
                  height: 30,
                  child: Icon(Icons.analytics,
                      size: 30), // Adjust the size property of the Icon widget
                ),
                label: 'unKnown',
              ),

              BottomNavigationBarItem(
                icon: SizedBox(
                  width:
                      30, // Adjust the width and height according to your preference
                  height: 30,
                  child: Icon(Icons.person,
                      size: 30), // Adjust the size property of the Icon widget
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color.fromARGB(255, 3, 94, 147),
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            showSelectedLabels: true, // Ensure that selected labels are visible
            showUnselectedLabels:
                true, // Ensure that unselected labels are visible
          ),
        ));
  }
}


class unKnown extends StatelessWidget {
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
