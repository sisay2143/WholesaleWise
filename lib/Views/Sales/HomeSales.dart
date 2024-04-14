import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts; // Added charts_flutter import
import 'package:untitled/Views/sales/NotificationSales.dart';
import 'CommitSale.dart';
import 'ProfileSales.dart';

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
         
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSales()),
              );
            },
            icon: Icon(Icons.notifications, color: Colors.black), // Icon color
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
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            SizedBox(height: 20),
      
            // Add the bar graph below
            Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Sales Overview'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 250,
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

// class HeroSec extends StatelessWidget {
//   final String title;
//   final String subtitle;

//   const HeroSec(this.title, this.subtitle);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(color: Colors.white, fontSize: 24),
//         ),
//         SizedBox(height: 10),
//         Text(
//           subtitle,
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         ),
//       ],
//     );
//   }
// }

// class CarouselStatus extends StatelessWidget {
//   final int itemCount;
//   final int currentSlide;

//   const CarouselStatus(
//       {Key? key, required this.itemCount, required this.currentSlide})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         for (int index = 0; index < itemCount; index++)
//           Container(
//             width: 8,
//             height: 8,
//             margin: const EdgeInsets.symmetric(horizontal: 4),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: currentSlide == index
//                   ? const Color.fromARGB(255, 30, 69, 224)
//                   : Colors.white,
//             ),
//           ),
//       ],
//     );
//   }
// }

class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}