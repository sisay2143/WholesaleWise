import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'ProfileWarehouse.dart';
import 'HomeWarehouse.dart';
import 'itemlist.dart';
import 'Requests.dart';
import 'orders_fromSales.dart';

class HomepageWH extends StatefulWidget {
  const HomepageWH({Key? key});

  @override
  State<HomepageWH> createState() => _HomepageWHState();
}

class _HomepageWHState extends State<HomepageWH> {
  int _selectedIndex = 0;
  bool hasNewRequests = false; // Variable to track new requests

  static List<Widget> _widgetOptions = <Widget>[
    HomePageWarehouse(),
    ItemsList(),
    OrderPage(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _checkForNewRequests();
  }

 void _checkForNewRequests() {
  // Implement your logic for checking if there are new requests
  // For demonstration, let's set hasNewRequests to true randomly
  setState(() {
    hasNewRequests = DateTime.now().second % 2 == 0; // Random boolean
  });
}

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
    if (_selectedIndex == 2) {
      // Assume Requests tab is at index 2
      // You need to implement your logic for detecting new requests here
      _checkForNewRequests();
    } else {
      // If another tab is selected, mark requests as seen
      hasNewRequests = false;
    }
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
              color: Colors.grey[300]!,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.view_list,
                size: 30,
              ),
              label: 'itemList',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(
                    Icons.approval_outlined,
                    size: 30,
                  ),
                  if (hasNewRequests)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 3, 94, 147),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
