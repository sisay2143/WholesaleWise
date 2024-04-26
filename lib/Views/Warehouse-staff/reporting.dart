import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MaterialApp(
    home: Reportings(),
  ));
}

class Reportings extends StatelessWidget {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Inventory report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              _buildRunningoutProducts(),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTotalCategoryCircularIndicator(),
                  _buildTotalItemsCircularIndicator(),
                ],
              ),
              const SizedBox(height: 20.0),
            
              _buildSoontoExpire(),
               const SizedBox(height: 20.0),
               _buildBarChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoontoExpire() {
    return Card(
      child: Container(
        width: 400.0, // Adjust the width to your preference
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Soon to Expire',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              SizedBox(
                height: 140.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              child: Image.asset(
                                'lib/assets/shoe1.jpg', // Change to your product image
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text('Sold: 100'), // Change to your actual quantity
                        ],
                      ),
                    ),
                    // Add more Padding widgets as needed for each product
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              child: Image.asset(
                                'lib/assets/shoe1.jpg', // Change to your product image
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text('Sold: 200'), // Change to your actual quantity
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              child: Image.asset(
                                'lib/assets/shoe1.jpg', // Change to your product image
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text('Sold: 300'), // Change to your actual quantity
                        ],
                      ),
                    ), // Add more Padding widgets as needed for each product
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



Widget _buildBarChart() {
    // Example data for the bar chart
    final List<SalesData> data = [
      SalesData('Jan', 100),
      SalesData('Feb', 150),
      SalesData('Mar', 200),
      SalesData('Apr', 180),
    ];

    // Building the bar chart
    return Card(
      child: Container(
        height: 250,
        width: 400,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: charts.BarChart(
              [
                charts.Series<SalesData, String>(
                  id: 'Sales',
                  data: data,
                  domainFn: (SalesData sales, _) => sales.month,
                  measureFn: (SalesData sales, _) => sales.sales,
                ),
              ],
              animate: true,
            ),
          ),
        ),
      ),
    );
  }
}

// Define SalesData class
class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}




  Widget _buildRunningoutProducts() {
    return Card(
      child: Container(
        width: 400.0, // Adjust the width to your preference
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Running out Products',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              SizedBox(
                height: 140.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              child: Image.asset(
                                'lib/assets/shoe1.jpg', // Change to your product image
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text('Left: 1'), // Change to your actual quantity
                        ],
                      ),
                    ),
                    // Add more Padding widgets as needed for each product
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              child: Image.asset(
                                'lib/assets/shoe1.jpg', // Change to your product image
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text('Left: 10'), // Change to your actual quantity
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              child: Image.asset(
                                'lib/assets/shoe1.jpg', // Change to your product image
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text('Left: 12'), // Change to your actual quantity
                        ],
                      ),
                    ), // Add more Padding widgets as needed for each product
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


Widget _buildTotalCategoryCircularIndicator() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  return Container(
    width: 150.0,
    height: 150.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: Colors.blue, width: 5),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('categories').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Placeholder while loading data
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No data available');
            }
            return Text(
              '${snapshot.data!.docs.length}', // Show the count of categories
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        SizedBox(height: 8.0),
        Text(
          'Total Categories',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTotalItemsCircularIndicator() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  return Container(
    width: 150.0,
    height: 150.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: Colors.green, width: 5),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('items').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Placeholder while loading data
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No data available');
            }
            int totalItems = 0;
            snapshot.data!.docs.forEach((doc) {
              // totalItems += (doc['quantity'] ?? 0).toInt(); // Ensure 'quantity' is not null and cast to int
            });
            return Text(
              '$totalItems', // Show the total count of items
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        SizedBox(height: 8.0),
        Text(
          'Total Items',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
