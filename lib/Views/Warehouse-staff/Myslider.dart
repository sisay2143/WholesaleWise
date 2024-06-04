// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
// import '../../Backend/slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Backend/stock_service.dart';


class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
 int _currentSlide = 0;
  int _totalStockInToday = 0;
  int _totalStockOutToday = 0;
  int _totalStockInYesterday = 0;
  int _totalStockOutYesterday = 0;

  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

   Future<void> _fetchStockData() async {
    // Fetch stock data using the stock service
    StockService stockService = StockService();
    Map<String, int> stockData = await stockService.getStockDataForSlider();

    setState(() {
      _totalStockInToday = stockData['totalStockInToday'] ?? 0;
      _totalStockOutToday = stockData['totalStockOutToday'] ?? 0;
      _totalStockInYesterday = stockData['totalStockInYesterday'] ?? 0;
      _totalStockOutYesterday = stockData['totalStockOutYesterday'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [
      // Yesterday's Stock
      // Add your yesterday's stock UI here
      // Yesterday's Stock
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
              ),
            ),
            Text(
              '${DateFormat.MMMM().format(DateTime.now().subtract(Duration(days: 1)))}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
              ),
            ),
            SizedBox(width: 5),
            Text(
              '${DateFormat.d().format(DateTime.now().subtract(Duration(days: 1)))}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      // Stock In Section
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  '$_totalStockInYesterday',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Stock In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.white,
            ),
            // Stock Out Section
            Column(
              children: [
                Text(
                  '$_totalStockOutYesterday',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
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


      // Today's Stock
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
                    'Today  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                    ),
                  ),
                  Text(
                    '${DateFormat.MMMM().format(DateTime.now())}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${DateFormat.d().format(DateTime.now())}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Stock In Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '$_totalStockInToday',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Stock In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white,
                  ),
                  // Stock Out Section
                  Column(
                    children: [
                      Text(
                        '$_totalStockOutToday',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
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
