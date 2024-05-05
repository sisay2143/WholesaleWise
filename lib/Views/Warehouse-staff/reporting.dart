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
    // final User? user = FirebaseAuth.instance.currentUser;

    DateTime currentDate = DateTime.now();

    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
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
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No products found.');
                } else {
                  return SizedBox(
                    height: 160.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data!.docs[index];
                        // Parse the Firestore timestamp to DateTime
                        Timestamp expireDateTimestamp =
                            product['expiredate'] as Timestamp;
                        DateTime expireDate = expireDateTimestamp
                            .toDate(); // Convert timestamp to DateTime
                        int daysLeft =
                            expireDate.difference(currentDate).inDays;

                        // Fetch products expiring within 30 days
                        if (daysLeft < 30) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120.0,
                                  height: 100.0,
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                    child: Image.network(
                                      product[
                                          'imageUrl'], // Assuming the image URL is stored in a field called 'imageUrl'
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    '${product['name']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  '$daysLeft Days Left',
                                ),
// Display product name along with days left
                              ],
                            ),
                          );
                        } else {
                          // If product is not expiring within 30 days, return an empty container
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
              height: 160.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    // .collection('users')
                    // .doc(user!.uid)
                    .collection('products')
                    .where('quantity', isLessThan: 500)
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
                              Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  '${product['name']}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
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

 Widget _buildTotalCategoryCircularIndicator(BuildContext context) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  return GestureDetector(
    onTap: () {
      // Navigate or trigger some action when the circular indicator is pressed
      // For example, you can display a list of total categories
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return 
         AlertDialog(
  title: Text('Total Categories'),
  content: Container(
    width: 300, // Adjust the width as needed
    height: 400, // Adjust the height as needed
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

          return ListView.builder(
            itemCount: categoryCounts.length,
            itemBuilder: (context, index) {
              final category = categoryCounts.keys.elementAt(index);
              final count = categoryCounts[category];
              return ListTile(
                title: Text('$category - $count'),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
  ),
);

        },
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
    ),
  );
}



 Widget _buildTotalStockCircularIndicator(BuildContext context) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('All Items'),
            content: Container(
              width: 300, // Adjust the width as needed
              height: 400, // Adjust the height as needed
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(product['name']),
                          subtitle: Text('Quantity: ${product['quantity']}'),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          );
        },
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
