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

 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

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
               _buildRunningOutProducts(),
                const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTotalCategoryCircularIndicator(),
                  _buildTotalStockCircularIndicator(),
                ],
              ),
              const SizedBox(height: 20.0),
              // _buildRunningoutProducts(),
              _buildSoontoExpire(),
               const SizedBox(height: 20.0),
            _buildBarChartCard(),
            ],
          ),
        ),
      ),
    );
  }




Widget _buildSoontoExpire() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  DateTime currentDate = DateTime.now();

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
            StreamBuilder
              <QuerySnapshot>(
              stream: _firestore
                  // .collection('users')
                  // .doc(user!.uid)
                  .collection('products')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No products found.');
                } else {
                  return SizedBox(
                    height: 140.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data!.docs[index];
                        // Parse the string 'expiredate' to DateTime
                        DateTime expireDate = DateTime.parse(product['expiredate']);
                        int daysLeft = expireDate.difference(currentDate).inDays;
                        
                        // Fetch products expiring within 5 days
                        if (daysLeft < 5) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                    child: Image.network(
                                      product['imageUrl'], // Assuming the image URL is stored in a field called 'image'
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text('$daysLeft : Days Left'),
                              ],
                            ),
                          );
                        } else {
                          // If product is not expiring within 5 days, return an empty container
                          return Container();
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}


  



  Widget _buildRunningOutProducts() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Running Out Products',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: 140.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    // .collection('users')
                    // .doc(user!.uid)
                    .collection('products')
                    .where('quantity', isLessThan: 10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final runningOutProducts = snapshot.data!.docs;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: runningOutProducts.length,
                      itemBuilder: (context, index) {
                        final product = runningOutProducts[index];
                        final productData =
                            product.data() as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  child: Image.network(
                                    productData['imageUrl'] as String,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text('Quantity: ${productData['quantity']}'),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }   
                  
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildTotalCategoryCircularIndicator() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  return Center(
    child: Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.blue, width: 5),
      ),
      child: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              // .collection('users')
              // .doc(user!.uid)
              .collection('products')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data!.docs;
              final categoryCounts = <String, int>{};

              for (final item in items) {
                final categoryName = item['category'] as String;
                categoryCounts[categoryName] =
                    (categoryCounts[categoryName] ?? 0) + 1;
              }

              final totalCategories = categoryCounts.length;

              return Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    totalCategories.toString(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Total Categories",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    ),
  );
}

Widget _buildTotalStockCircularIndicator() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  return Center(
    child: Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.green, width: 5),
      ),
      child: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              // .collection('users')
              // .doc(user!.uid)
              .collection('products')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int totalItems = snapshot.data!.docs.length;

              return Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    totalItems.toString(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Total Items",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    ),
  );
}

}
Widget _buildBarChartCard() {
    // Building the bar chart wrapped inside a Card widget
    return Card(
      child: Container(
        height: 600,
        width: 400, // Adjust the height as needed
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales Overview',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
               SizedBox(
                    height: 55,
                  ),
              _buildBarChart(),
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
        height: 350,
        width: 550,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
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


// Define SalesData class
class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}