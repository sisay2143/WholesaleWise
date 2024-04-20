// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:untitled/Views/Manager/Notification.dart';
import 'package:untitled/Views/Manager/account.dart';
import 'package:untitled/Views/Manager/itemlist.dart';
import 'Myslider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'profilescreen.dart'; // Import the file where HomeManager is defined
// import 'HomeManager.dart'; // Change 'HomeManager.dart' to the correct file name if necessary
import 'package:camera/camera.dart';
import 'Salesreport.dart';
import 'reporting.dart';
import 'profit.dart';

Map<String, double> dataMap = {
  'Flutter': 3,
  'React': 3,
  'Xamarin': 2,
};

List<Color> colorList = [
  Colors.blue,
  Colors.green,
  Colors.red,
];

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
    Reporting(),
    AccountPage(),
  ];

  // static List<String> _appBarTitles = [
  //   'Manager Home',
  //   'Approval',
  //   'Reporting',
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
      body: _widgetOptions.elementAt(_selectedIndex),
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
              label: 'Approval',
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
              label: 'Reporting',
            ),

            BottomNavigationBarItem(
              icon: SizedBox(
                width:
                    30, // Adjust the width and height according to your preference
                height: 30,
                child: Icon(Icons.person_2_sharp,
                    size: 30), // Adjust the size property of the Icon widget
              ),
              label: 'Accounts',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor:Color.fromARGB(255, 3, 94, 147),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          showSelectedLabels: true, // Ensure that selected labels are visible
          showUnselectedLabels:
              true, // Ensure that unselected labels are visible
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  //  HomeSales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 16), // Add space to align the title to the start
            Text(
              'Home',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            color: Color.fromARGB(255, 3, 94, 147),
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Implement your notification logic here

               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationManager()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 15),
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
                          MaterialPageRoute(
                              builder: (context) => ItemsScreen()),
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
                              builder: (context) => SalesAnalytics()),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 270, // Set the desired height
                    width: 70, // Set the desired width
                    child: Card(
                      elevation: 0, // Add elevation for shadow effect
                      child: Padding(
                        padding: EdgeInsets.all(8.0), // Add padding for spacing
                        child: PieChart(
                          dataMap: dataMap,
                          colorList: colorList,
                          chartRadius: MediaQuery.of(context).size.width / 2.2,
                          chartType: ChartType.disc,
                          legendOptions: LegendOptions(
                            showLegends: true,
                            legendPosition: LegendPosition.right,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

class Approval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Text('approval Records '),
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