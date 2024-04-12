import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pie_chart/pie_chart.dart';
import '../Views/CreateUser.dart';
import '../Views/login.dart';
import 'account.dart'; 
import 'notification.dart';

class HomepageManager extends StatelessWidget {
  const HomepageManager({Key? key});

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      'List of Items': 30,
      'Profit': 40,
      'Sales': 30,
    };

    List<Color> colorList = [
      Colors.blue,
      Colors.green,
      Colors.orange,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 25),
        ),
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   color: Colors.blue,
        //   icon: Icon(Icons.account_circle),
        //   onPressed: () {
        //     // Implement your user profile logic here
        //   },
        // ),
        actions: [
          IconButton(
            color: Colors.blue,
            icon: Icon(Icons.notifications),
            onPressed: () {
               Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()), // Navigate to accounts screen
        );;
              // Implement your notification logic here
            },
          ),
        ],
      ),
      body: Column(
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
            padding: const EdgeInsets.all(20.0),
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
                  child: Icon(Icons.qr_code),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconWithBackground(Icons.list_alt),
              IconWithBackground(Icons.trending_up),
              IconWithBackground(Icons.attach_money),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 200, // Set the desired height
                  width: 70, // Set the desired width
                  child: Card(
                    elevation: 4, // Add elevation for shadow effect
                    child: Padding(
                      padding: EdgeInsets.all(8.0), // Add padding for spacing
                      child: PieChart(
                        dataMap: dataMap,
                        colorList: colorList,
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
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
      bottomNavigationBar: BottomAppBar(
        height: 80,
        shape: CircularNotchedRectangle(), // Make bottom bar curved
        color: Colors.white, // Set background color of BottomAppBar
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.blue, width: 2.0), // Set top border
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    color: Colors.blue,
                    onPressed: () {},
                    icon: Icon(Icons.home, size: 35), // Increase icon size
                  ),
                  Text('Home', style: TextStyle(color: Colors.blue)), // Add text
                ],
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    color: Colors.blue,
                    onPressed: () {},
                    icon: Icon(Icons.approval, size: 35), // Increase icon size
                  ),
                  Text('Approval', style: TextStyle(color: Colors.blue)), // Add text
                ],
              ),
              SizedBox(width: 10), // Adjust spacing between icons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    color: Colors.blue,
                    onPressed: () {},
                    icon: Icon(Icons.analytics, size: 35), // Increase icon size
                  ),
                  Text('Analytics', style: TextStyle(color: Colors.blue)), // Add text
                ],
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    color: Colors.blue,
                    onPressed: () {
                      // Navigate to the CreateUser page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountPage()),
                      );
                    },
                    icon: Icon(Icons.manage_accounts, size: 35), // Increase icon size
                  ),
                  Text('Accounts', style: TextStyle(color: Colors.blue)), // Add text
                ],
              ),
            ],
          ),
        ),
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
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 30,
        ),
      ),
    );
  }
}

class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
        ),
        child: Center(child: Text('Rectangular Box 1')),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Lorem ipsum dolor sit amet.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 10),
              child: Text(
                  "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
        ),
        child: HeroSec("Today", "Aug 22"),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
        ),
        child: HeroSec("Yesterday", "Aug 21"),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                items: carouselItems,
                options: CarouselOptions(
                  autoPlayCurve: Curves.decelerate,
                  autoPlay: true,
                  height: 180,
                  viewportFraction: 1.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSlide = index;
                    });
                  },
                ),
              ),
              Positioned(
                top: 12.0,
                right: 40.0,
                child: CarouselStatus(
                  itemCount: carouselItems.length,
                  currentSlide: _currentSlide,
                ),
              ),
            ],
          ),
        ],
      ),
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
