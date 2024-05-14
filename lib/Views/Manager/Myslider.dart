// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:untitled/Views/HomeManager.dart';
import 'package:untitled/Views/login.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'CommitSale.dart';
import 'package:carousel_slider/carousel_state.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import '../../Backend/slider.dart';

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
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 3, 94, 147),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Yesterday  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${DateFormat.MMMM().format(DateTime.now().subtract(Duration(days: 1)))}', // Display month of yesterday
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5), // Adjust spacing between month and date
                  Text(
                    '${DateFormat.d().format(DateTime.now().subtract(Duration(days: 1)))}', // Display date of yesterday
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Add some spacing below the date
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '320',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white,
                  ),
                  Column(
                    children: const [
                      Text(
                        '160',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Stock in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white,
                  ),
                  Column(
                    children: [
                      Text(
                        '150',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Stock Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 3, 94, 147),
        ),
        child: FutureBuilder(
          future: fetchStockData(), // Function to fetch stock data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:
                    CircularProgressIndicator(), // Placeholder while loading data
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.data == null || (snapshot.data as List).isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            }

            // Your logic to calculate total stock in and stock out goes here
            // Calculate total stock in and stock out for today
            int stockIn = 0;
            int stockOut = 0;
            if (snapshot.data != null) {
              for (var data in snapshot.data as List) {
                if (DateUtils.isToday(data['date'])) {
                  // Accessing isToday method from utility class
                  stockIn += (data['stockIn'] ?? 0)
                      as int; // Convert to int and handle null values
                  stockOut += (data['stockOut'] ?? 0)
                      as int; // Convert to int and handle null values
                }
              }
            }

// Display the stock in and stock out
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Stock In: $stockIn', // Display stock in for today
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Stock Out: $stockOut', // Display stock out for today
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromARGB(255, 3, 94, 147),
        ),
        child: HeroSec("Today", "Aug 22"),
      ),
      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   margin: const EdgeInsets.symmetric(horizontal: 3),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(10)),
      //     color: Color.fromARGB(255, 3, 94, 147),
      //   ),
      //   child: HeroSec("Yesterday", "Aug 21"),
      // ),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
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

class DateUtils {
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
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
