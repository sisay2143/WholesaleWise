import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts; // Added charts_flutter import
import 'package:untitled/Views/Manager/reporting.dart';
import 'package:untitled/Views/Sales/order.dart';
import 'package:untitled/Views/sales/NotificationSales.dart';
import 'CommitSale.dart';
import 'ProfileSales.dart';
import 'salesrecord.dart';

// import 'QRScanScreen.dart';
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
        selectedItemColor: Color.fromARGB(255, 3, 94, 147),
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
         
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSales()),
              );
            },
            icon: Icon(Icons.notifications, color: Color.fromARGB(255, 3, 94, 147),), // Icon color
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
            
             SizedBox(
                      height: 10,
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => ItemsList()),
                        // );
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
                      iconData: Icons.article,
                      backgroundColor: Color.fromARGB(255, 3, 94, 147),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => order()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('order'),
                  ],
                ),
                Column(
                  children: [
                    IconWithBackground(
                      iconData: Icons.analytics,
                      backgroundColor: Color.fromARGB(255, 3, 94, 147),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Reporting()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Reporting'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
      
            // Add the bar graph below
            Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Sales Overview'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 200,
                      child: _buildBarChart(), // Real bar chart
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

  // Function to build the bar chart
  Widget _buildBarChart() {
    // Example data for the bar chart
    final List<SalesData> data = [
      SalesData('Jan', 100),
      SalesData('Feb', 150),
      SalesData('Mar', 200),
      SalesData('Apr', 180),
    ];

    // Creating series for the bar chart
    final List<charts.Series<SalesData, String>> series = [
      charts.Series(
        id: 'Sales',
        data: data,
        domainFn: (SalesData sales, _) => sales.month,
        measureFn: (SalesData sales, _) => sales.sales,
      ),
    ];

    // Building the bar chart
    return charts.BarChart(
      series,
      animate: true,
    );
  }
}



class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
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