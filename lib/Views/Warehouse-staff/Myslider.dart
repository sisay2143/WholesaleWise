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
import 'package:cloud_firestore/cloud_firestore.dart';

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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('timestamp',
                      isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()
                          .subtract(Duration(
                              days:
                                  2)))) // Filtering documents with timestamp within the day before yesterday
                  .where('timestamp',
                      isLessThan: Timestamp.fromDate(DateTime.now().subtract(
                          Duration(
                              days:
                                  1)))) // Filtering documents with timestamp before yesterday
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while fetching data
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                var data = snapshot.data!.docs;
                var total = 0;
                var stockIn = 0;
                for (var doc in data) {
                  var quantity = doc['quantity'] as int?;
                  var stockInValue = doc['stockIn'] as int?;
                  if (quantity != null) {
                    total += quantity;
                  }
                  if (stockInValue != null) {
                    stockIn += stockInValue;
                  }
                }
                var stockOut = total -
                    stockIn; // Calculate stock out by subtracting stock in from total quantity
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$total',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
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
                            '$stockIn',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
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
                            '$stockOut',
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
                );
              },
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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('timestamp',
                      isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()
                          .subtract(Duration(
                              days:
                                  1)))) // Filtering documents with timestamp within the last 24 hours
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while fetching data
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                var data = snapshot.data!.docs;
                var totalQuantity = 0;
                var totalQuantityAdded = 0;
                var currentDate =
                    DateFormat('yyyy-MM-dd').format(DateTime.now());

                for (var doc in data) {
                  var quantity = doc['quantity'] as int?;
                  if (quantity != null) {
                    totalQuantity += quantity;
                  }
                  var quantityAddedByDate =
                      doc['quantityAddedByDate'] as Map<dynamic, dynamic>?;
                  if (quantityAddedByDate != null &&
                      quantityAddedByDate.containsKey(currentDate)) {
                    var addedQuantity = quantityAddedByDate[currentDate];
                    if (addedQuantity is int) {
                      totalQuantityAdded += addedQuantity;
                    } else if (addedQuantity is String) {
                      var parsedQuantity = int.tryParse(addedQuantity);
                      if (parsedQuantity != null) {
                        totalQuantityAdded += parsedQuantity;
                      }
                    }
                  }
                }
                bool isSameDay(DateTime date1, DateTime date2) {
                  return date1.year == date2.year &&
                      date1.month == date2.month &&
                      date1.day == date2.day;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Text(
                          '$totalQuantity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
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
                          ),
                        ),
                      ]),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            '$totalQuantityAdded',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'stock in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.white,
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('approval_requests')
                            .where('status',
                                isEqualTo:
                                    'approved') // Listen for approved requests
                            .where('timestamp',
                                isGreaterThanOrEqualTo: Timestamp.fromDate(
                                    DateTime.now().subtract(Duration(
                                        days:
                                            1)))) // Filter by timestamp within the last 24 hours
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show loading indicator while fetching data
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          var approvedRequests = snapshot.data!.docs;
                          var totalStockOut = 0;
                          var currentDate =
                              DateFormat('yyyy-MM-dd').format(DateTime.now());
                          for (var request in approvedRequests) {
                            // Process each approved request
                            var requestTimestamp =
                                (request['timestamp'] as Timestamp).toDate();
                            if (isSameDay(requestTimestamp, DateTime.now())) {
                              var quantity = request['quantity'] as int?;
                              if (quantity != null) {
                                totalStockOut += quantity;
                              }
                            }
                          }
                          return Column(
                            children: [
                              Text(
                                '$totalStockOut',
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
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   margin: const EdgeInsets.symmetric(horizontal: 3),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(10)),
      //     color: Color.fromARGB(255, 3, 94, 147),
      //   ),
      //   child: HeroSec("gfg", "Aug 22"),
      // ),
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
