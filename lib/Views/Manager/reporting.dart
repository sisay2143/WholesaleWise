import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'totalcategories.dart';

// void main() {
//   runApp(MaterialApp(
//     home: Reportings(),
//   ));
// }

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
              _buildRunningoutProducts(),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTotalCategoryCircularIndicator(context),
                  _buildTotalStockCircularIndicator(context),
                ],
              ),
              const SizedBox(height: 20.0),
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Filter products expiring within 5 days or already expired
                  List<DocumentSnapshot> expiringProducts = snapshot.data!.docs.where((product) {
                    Timestamp expireDate = product['expiredate'];
                    DateTime expireDateDateTime = expireDate.toDate();
                    int daysLeft = expireDateDateTime.difference(currentDate).inDays;
                    return daysLeft <= 0 || daysLeft < 30;
                  }).toList();

                  if (expiringProducts.isEmpty) {
                    return Column(
                      children: [
                        Text('No products are expiring soon.'),
                        
                      ],
                    );
                  } else {
                    return SizedBox(
                      height: 160.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: expiringProducts.length,
                        itemBuilder: (context, index) {
                          var product = expiringProducts[index];
                          Timestamp expireDate = product['expiredate'];
                          DateTime expireDateDateTime = expireDate.toDate();
                          int daysLeft = expireDateDateTime.difference(currentDate).inDays;

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
                                      product['imageUrl'], // Assuming the image URL is stored in a field called 'imageUrl'
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                if (daysLeft <= 0)
                                  Text('Expired')
                                else
                                  Text('$daysLeft : Days Left'),
                                const SizedBox(height: 4.0),
                               Text(
                                    '${product['name']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ), // Assuming the product text is stored in a field called 'text'
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    ),
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
                .collection('products')
                .where('quantity', isLessThan: 500)
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
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

 Widget _buildTotalCategoryCircularIndicator(BuildContext context) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  return GestureDetector(
    onTap: () {
      // Navigate to a new screen to display the list of total categories
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TotalCategoriesScreen()),
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
            stream: _firestore.collection('products').snapshots(),
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
    ),
  );
}


 Widget _buildTotalStockCircularIndicator(BuildContext context) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  return GestureDetector(
    onTap: () {
      // Navigate to a new screen to display all items
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllItemsScreen()),
      );
    },
    child: Center(
      child: Container(
        width: 150.0,     
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.green, width: 5),
        ),
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('products').snapshots(),
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
    ),
  );
}
}

class BarChartData {
  final String category;
  final int quantity;

  BarChartData(this.category, this.quantity);
}

Widget _buildBarChartCard() {
  return FutureBuilder<List<BarChartData>>(
    future: _getChartDataFromFirestore(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        return Card(
          child: Container(
            height: 600,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category Distribution',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 55),
                  _buildBarChart(snapshot.data ?? [])
                ],
              ),
            ),
          ),
        );
      }
    },
  );
}

Widget _buildBarChart(List<BarChartData> data) {
  return Card(
    child: Container(
      height: 350,
      width: 550,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
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
    ),
  );
}

Future<List<BarChartData>> _getChartDataFromFirestore() async {
  List<BarChartData> chartData = [];

  // Fetch data from Firestore
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('products').get();

  // Process fetched data
  Map<String, int> categoryQuantityMap = {};
  snapshot.docs.forEach((doc) {
    String category = doc['category'];
    int quantity = doc['quantity'];
    if (categoryQuantityMap.containsKey(category)) {
      categoryQuantityMap[category] =
          (categoryQuantityMap[category] ?? 0) + quantity;
    } else {
      categoryQuantityMap[category] = quantity;
    }
  });

  // Convert data to BarChartData objects
  categoryQuantityMap.forEach((category, quantity) {
    chartData.add(BarChartData(category, quantity));
  });

  return chartData;
}
