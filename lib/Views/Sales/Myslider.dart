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
import 'package:cloud_firestore/cloud_firestore.dart';

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
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
//      Container(
//   width: MediaQuery.of(context).size.width,
//   margin: const EdgeInsets.symmetric(horizontal: 3),
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.all(Radius.circular(15)),
//     color: Color.fromARGB(255, 3, 94, 147),
//   ),
//   child: Column(
//     children: [
//       Padding(
//         padding: const EdgeInsets.only(top: 18.0, left: 12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               'Yesterday  ',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 26.0,
//               ),
//             ),
//             Text(
//               '${DateFormat.MMMM().format(DateTime.now().subtract(Duration(days: 1)))}',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22.0,
//               ),
//             ),
//             SizedBox(width: 5),
//             Text(
//               '${DateFormat.d().format(DateTime.now().subtract(Duration(days: 1)))}',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 20),
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Column(
//               children: [
//                 Text(
//                   'Total',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.0,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Placeholder for displaying total value (if any)
//               ],
//             ),
//             Container(
//               height: 40,
//               width: 1,
//               color: Colors.white,
//             ),
//             Column(
//               children: [
//                 Text(
//                   'Quantity Sold',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.0,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Placeholder for displaying quantity sold (if any)
//                 FutureBuilder(
//                   future: FirebaseFirestore.instance
//                       .collection('sales_transaction')
//                       .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)))) // Query for sales from yesterday onwards
//                       .get(),
//                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator(); // Show loading indicator while fetching data
//                     }
//                     if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     }
//                     // Calculate and display the total quantity sold from yesterday onwards
//                     int totalQuantitySold = 0;
//                     snapshot.data!.docs.forEach((doc) {
//                       totalQuantitySold += doc['quantity'] as int; // Assuming quantity field exists
//                     });
//                     return Text(
//                       '$totalQuantitySold',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18.0,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             Container(
//               height: 40,
//               width: 1,
//               color: Colors.white,
//             ),
//             Column(
//               children: [
//                 Text(
//                   'Total Category Sold',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.0,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Placeholder for displaying total category sold (if any)
//               ],
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),

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
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Placeholder for displaying total value (if any)
              ],
            ),
            Column(
              children: [
                Text(
                  'Quantity Sold',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Placeholder for displaying quantity sold (if any)
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('sales_transaction')
                      .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2))), isLessThan: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)))) // Query for sales from yesterday
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while fetching data
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // Calculate and display the total quantity sold for yesterday
                    int totalQuantitySold = 0;
                    snapshot.data!.docs.forEach((doc) {
                      totalQuantitySold += doc['quantity'] as int; // Assuming quantity field exists
                    });
                    return Text(
                      '$totalQuantitySold',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  'Total Category Sold',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Placeholder for displaying total category sold (if any)
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('sales_transaction')
                      .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2))), isLessThan: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)))) // Query for sales from yesterday
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while fetching data
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // Calculate and display the total categories sold for yesterday
                    Set<String> uniqueCategories = Set<String>(); // Using Set to ensure uniqueness
                    snapshot.data!.docs.forEach((doc) {
                      uniqueCategories.add(doc['category'] as String); // Assuming category field exists
                    });
                    int totalCategoriesSold = uniqueCategories.length;
                    return Text(
                      '$totalCategoriesSold',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    );
                  },
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
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
               
                SizedBox(
                  height: 10,
                ),
                // Placeholder for displaying total value (if any)
              ],
            ),
            Column(
              children: [
                Text(
                  'Quantity Sold',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Placeholder for displaying quantity sold (if any)
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('sales_transaction')
                      .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)))) // Query for sales from today onwards
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while fetching data
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // Calculate and display the total quantity sold for today
                    int totalQuantitySold = 0;
                    snapshot.data!.docs.forEach((doc) {
                      Timestamp timestamp = doc['timestamp'] as Timestamp;
                      if (isSameDay(timestamp.toDate(), DateTime.now())) {
                        totalQuantitySold += doc['quantity'] as int; // Assuming quantity field exists
                      }
                    });
                    return Text(
                      '$totalQuantitySold',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  'Total Category Sold',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Placeholder for displaying total category sold (if any)
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('sales_transaction')
                      .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)))) // Query for sales from today onwards
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while fetching data
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // Calculate and display the total categories sold for today
                    Set<String> uniqueCategories = Set<String>(); // Using Set to ensure uniqueness
                    snapshot.data!.docs.forEach((doc) {
                      Timestamp timestamp = doc['timestamp'] as Timestamp;
                      if (isSameDay(timestamp.toDate(), DateTime.now())) {
                        uniqueCategories.add(doc['category'] as String); // Assuming category field exists
                      }
                    });
                    int totalCategoriesSold = uniqueCategories.length;
                    return Text(
                      '$totalCategoriesSold',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
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
      //   // child: HeroSec("Yesterday", "Aug 21"),
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
