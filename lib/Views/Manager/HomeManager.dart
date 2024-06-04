// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:untitled/Views/Manager/Notification.dart';
import 'package:untitled/Views/Manager/account.dart';
import 'package:untitled/Views/Manager/itemlist.dart';
import 'Myslider.dart';
import 'package:pie_chart/pie_chart.dart'; // Import the file where HomeManager is defined
import 'package:camera/camera.dart';
import 'Salesreport.dart';
import 'reporting.dart';
import 'profit.dart';
import 'approval.dart';
import 'package:badges/badges.dart';
import 'piechart.dart';

// Map<String, double> dataMap = {
//   'Flutter': 3,
//   'React': 3,
//   'Xamarin': 2,
// };

// List<Color> colorList = [
//   const Color.fromARGB(255, 4, 50, 88),
//   Colors.green,
//   Color.fromARGB(255, 33, 86, 87),
// ];

class HomepageManager extends StatefulWidget {
  const HomepageManager({Key? key});

  @override
  State<HomepageManager> createState() => _HomepageManagerState();
}

class _HomepageManagerState extends State<HomepageManager> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // Assuming HomeManager is defined in HomeManager.dart
    Approval(),
    Reportings(),
    AccountPage(),
  ];

  // You can use this boolean to track whether there are new unseen requests
  bool newRequestsAvailable = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        // If "Approval" tab is selected, mark new requests as seen
        newRequestsAvailable = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.check_circle),
                  if (newRequestsAvailable) // Show badge only if there are new requests
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Approval',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Reporting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_sharp),
              label: 'Accounts',
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

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int unreadNotificationCount = 0;
  final List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    // Calculate the count of unread notifications
    unreadNotificationCount = notifications.where((n) => !n.isRead).length;
  }

  void _handleNotificationPageBack(List<NotificationItem> notifications) {
    setState(() {
      unreadNotificationCount = notifications.where((n) => !n.isRead).length;
    });
    print('Received notifications: $notifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('       Home'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(
                        notifications: notifications,
                        onBackButtonPressed: _handleNotificationPageBack,
                        onNotificationUpdated: (count) {
                          setState(() {
                            unreadNotificationCount = count;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              if (unreadNotificationCount > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      unreadNotificationCount.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Your existing body widget code...
         child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
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
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 5, bottom: 15),
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
                  GestureDetector(
                    onTap: () {
                      // Implement the action to open the user's camera here
                      openCamera(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.qr_code),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // IconWithBackground(Icons.list_alt),
                Column(
                  children: [
                    IconWithBackground(
                      iconData: Icons.list_alt,
                      backgroundColor: Color.fromARGB(255, 3, 94, 147),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ItemsList()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('item list'),
                  ],
                ),
                Column(
                  children: [
                    IconWithBackground(
                      iconData: Icons.trending_up,
                      backgroundColor: Color.fromARGB(255, 3, 94, 147),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => salesAnalytics()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('sales analytics'),
                  ],
                ),
                Column(
                  children: [
                    IconWithBackground(
                      iconData: Icons.attach_money,
                      backgroundColor: Color.fromARGB(255, 3, 94, 147),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfitScreen()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('profit analytics'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),



            Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Sales Overview'),
                  ),
                  Container(
                    height: 209,
                    child: PieChartWidget(), // Real bar chart
                  ),
                ],
              ),
            ),


            
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Expanded(
            //       child: SizedBox(
            //         height: 270, // Set the desired height
            //         width: 70, // Set the desired width
            //         child: Card(
            //           elevation: 0, // Add elevation for shadow effect
            //           child: Padding(
            //             padding: EdgeInsets.all(8.0), // Add padding for spacing
            //             child: PieChart(
            //               dataMap: dataMap,
            //               colorList: colorList,
            //               chartRadius: MediaQuery.of(context).size.width / 2.2,
            //               chartType: ChartType.disc,
            //               legendOptions: LegendOptions(
            //                 showLegends: true,
            //                 legendPosition: LegendPosition.right,
            //                 legendTextStyle: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //               chartValuesOptions: ChartValuesOptions(
            //                 showChartValueBackground: true,
            //                 showChartValues: true,
            //                 showChartValuesInPercentage: true,
            //                 showChartValuesOutside: false,
            //                 decimalPlaces: 1,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}


Future<void> openCamera(BuildContext context) async {
  // Initialize the camera
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  // Initialize the camera controller
  final CameraController cameraController = CameraController(
    firstCamera,
    ResolutionPreset.medium,
  );

  // Initialize the camera controller
  await cameraController.initialize();

  // Show the camera preview in a dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: AspectRatio(
          aspectRatio: cameraController.value.aspectRatio,
          child: CameraPreview(cameraController),
        ),
      );
    },
  );
}
// }

class NotificationBadge extends StatelessWidget {
  final int itemCount;
  final Color badgeColor;
  final TextStyle textStyle;

  const NotificationBadge({
    Key? key,
    required this.itemCount,
    this.badgeColor = Colors.red,
    this.textStyle =
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: badgeColor,
      ),
      child: Text(
        itemCount.toString(),
        style: textStyle,
      ),
    );
  }
}

class IconWithBackground extends StatelessWidget {
  final IconData iconData;
  final Color backgroundColor;
  final Function()? onTap;

  IconWithBackground({
    required this.iconData,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Center(
          child: Icon(
            iconData,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
