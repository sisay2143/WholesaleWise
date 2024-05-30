import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../Backend/sales_analytics_backend.dart';
import 'detailCategory.dart';
import 'barchartanalytics.dart';
import 'tablesales.dart';

class salesAnalytics extends StatelessWidget {
  final SalesService salesService = SalesService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Sales analytics'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSellingProducts(),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTotalCategoryCircularIndicator(context),
                  _buildTotalItemsCircularIndicator(context),
                ],
              ),
              const SizedBox(height: 10.0),
              _buildRunningoutProducts(),
              Card(
                elevation: 3,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Sales Overview'),
                    ),
                    Container(
                      height: 220,
                      child: buildBarChartCards(), // Real bar chart
                    ),
                  ],
                ),
              ),
              _buildPlaceholderTableCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSellingProducts() {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: salesService.fetchTopSellingProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No data available');
        } else {
          return Card(
            child: Container(
              width: 400.0, // Adjust the width to your preference
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top selling Products',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    SizedBox(
                      height: 160.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot productSnapshot =
                              snapshot.data![index];
                          Map<String, dynamic> productData =
                              productSnapshot.data() as Map<String, dynamic>;

                          // Handle null values gracefully
                          String imageUrl = productData['imageUrl'] ??
                              ''; // Provide a default value
                          int quantity = productData['quantity'] ??
                              0; // Provide a default value
                          String productName = productData['productName'] ??
                              ''; // Provide a default value

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
                                      imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Product Name: $productName',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'quantity: $quantity',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildRunningoutProducts() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Running Out Products',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  // .collection('users')
                  // .doc(user!.uid)
                  .collection('products for sale')
                  .where('quantity', isLessThan: 50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final runningOutProducts = snapshot.data!.docs;
                  if (runningOutProducts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 100, 20),
                      child: Text('No products are running out.'),
                    );
                  } else {
                    return SizedBox(
                      height: 160.0,
                      child: ListView.builder(
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
                                Text(
                                  '${product['name']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text('Quantity: ${productData['quantity']}'),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartCard() {
    return Card(
      child: Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales Overview',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: FutureBuilder<List<BarChartData>>(
                  future: _getChartDataFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return _buildBarChart(snapshot.data ?? []);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<BarChartData> data) {
    return Container(
      height: 250,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: charts.BarChart(
          [
            charts.Series<BarChartData, String>(
              id: 'Sales',
              data: data,
              domainFn: (BarChartData sales, _) => sales.category,
              measureFn: (BarChartData sales, _) => sales.quantity,
            ),
          ],
          animate: true,
          domainAxis: charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
              labelRotation: 45, // Rotate labels by 45 degrees
            ),
          ),
        ),
      ),
    );
  }

  Future<List<BarChartData>> _getChartDataFromFirestore() async {
    List<BarChartData> chartData = [];

    // Fetch data from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('sales_transaction').get();

    // Process fetched data
    Map<String, int> categoryQuantityMap = {};
    snapshot.docs.forEach((doc) {
      Timestamp timestamp = doc['timestamp'];

      int quantity = doc['quantity'];
      DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
      String dateString =
          '${dateTime.year}-${dateTime.month}-${dateTime.day}'; // Format to display only date
      if (categoryQuantityMap.containsKey(dateString)) {
        categoryQuantityMap[dateString] =
            (categoryQuantityMap[dateString] ?? 0) + quantity;
      } else {
        categoryQuantityMap[dateString] = quantity;
      }
    });

    // Convert data to BarChartData objects
    categoryQuantityMap.forEach((category, quantity) {
      chartData.add(BarChartData(category, quantity));
    });

    return chartData;
  }

  Widget _buildPlaceholderTableCard() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder table content goes here
            Text(
              'Transactions',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // Add your placeholder table widget here
            // For example:
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30.0, // Adjust spacing between columns
                columns: [
                  DataColumn(label: Text('Pname')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Date')),
                ],
                rows: [
                  // DataRow(cells: [
                  //   DataCell(Text('Data 1')),
                  //   DataCell(Text('Data 2')),
                  //   DataCell(Text('Data 3')),
                  // ]),
                  // Add more rows as needed
                ],
              ),
            ),
            SizedBox(height: 8.0),
            // "More" button
            Builder(
              builder: (BuildContext context) {
                return TextButton(
                  onPressed: () {
                    // Navigate to the new screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionTableWidget()),
                    );
                  },
                  child: Text('More'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCategoryCircularIndicator(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // User? user = FirebaseAuth.instance.currentUser;
    return GestureDetector(
      onTap: () {
        // Navigate to a new screen to display the list of total categories
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => detaiCategory()),
        );
      },
      child: Center(
        child: Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.blue, width: 5),
          ),
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('sales_transaction').snapshots(),
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
                        "Total Categories sold",
                        style: TextStyle(fontSize: 14),
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
      ),
    );
  }

  Widget _buildTotalItemsCircularIndicator(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllItemsScreen()),
        );
      },
      child: Container(
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
              stream: _firestore.collection('sales_transaction').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  totalItems += (doc['quantity'] ?? 0)
                      as int; // Ensure 'quantity' is not null and add to total
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
              'Total products sold',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
