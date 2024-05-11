import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'totalrevenue.dart';
import 'totalwarehousing.dart';
import 'totalprofit.dart';

void main() {
  runApp(MaterialApp(
    home: ProfitScreen(),
  ));
}

class ProfitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Profit analytics'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),


Container(
  height: 170, // Adjust the height as needed
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    color: Color.fromARGB(255, 3, 94, 147),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(
                      0, 3), // changes position of shadow
                    ),
                  ],
                ),
                // SizedBox(height: 20.0),
                child: TextButton(
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Totalwarehousing()),
                    );
                    // Add your action here
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 109, 163, 206), // Set background color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      'Show More',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Warehousing',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('products').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    double totalWarehousing = 0.0;
                    if (snapshot.hasData) {
                      snapshot.data?.docs.forEach((doc) {
                        final price = doc['price'] as num?;
                        final quantity = doc['quantity'] as num?;
                        if (price != null && quantity != null) {
                          totalWarehousing += price.toDouble() * quantity.toDouble();
                        }
                      });
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        '$totalWarehousing birr',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),




              SizedBox(height: 20.0),

Container(
  height: 170, // Adjust the height as needed
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    color: Color.fromARGB(255, 3, 94, 147),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(
                      0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => totalrevenue()),
                    );
                    // Add your action here
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 109, 163, 206), // Set background color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      'show more',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // SizedBox(height: 5),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Revenue',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sales_transaction')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  double totalRevenue = 0.0;
                  if (snapshot.hasData) {
                    snapshot.data?.docs.forEach((doc) {
                      final sellingPrice = double.tryParse((doc.data() as Map<String, dynamic>?)?['sellingPrice'] ?? '0');
                      final quantity = (doc.data() as Map<String, dynamic>?)?['quantity'];
                      if (sellingPrice != null && quantity is num) {
                        totalRevenue += (sellingPrice * quantity);
                      }
                    });
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '$totalRevenue\ birr',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  ),
),

              const SizedBox(height: 20.0),

              
             Container(
  height: 170,
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    color: Color.fromARGB(255, 3, 94, 147),
    // margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(
                      0, 3), // changes position of shadow
                    ),
                  ],
                ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => totalprofit()),
                  );
                  // Add your action here
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                    255, 109, 163, 206), // Set background color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      'show more',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Profit',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  
                ),
              ),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('products').snapshots(),
  builder: (context, productsSnapshot) {
    if (productsSnapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    Map<String, double> itemProfits = {};

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('sales_transaction').snapshots(),
      builder: (context, salesSnapshot) {
        if (salesSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (salesSnapshot.hasData && productsSnapshot.hasData) {
          final salesDocs = salesSnapshot.data!.docs;
          final productDocs = productsSnapshot.data!.docs;

          // Iterate through products to calculate profits
          for (var productDoc in productDocs) {
            final productName = (productDoc.data() as Map<String, dynamic>)['name'] as String?;
            final productPrice = (productDoc.data() as Map<String, dynamic>)['price'] as num?;
            if (productName != null && productPrice != null) {
              itemProfits[productName] = 0.0; // Initialize profit for each product
            }
          }

          // Iterate through sales transactions to calculate profits
          for (var saleDoc in salesDocs) {
            final productName = (saleDoc.data() as Map<String, dynamic>)['productName'] as String?;
            final sellingPrice = double.tryParse((saleDoc.data() as Map<String, dynamic>)['sellingPrice'] as String? ?? '') ?? 0.0;
            final saleQuantity = (saleDoc.data() as Map<String, dynamic>)['quantity'] as num?;
            if (productName != null && itemProfits.containsKey(productName) && saleQuantity != null) {
              final productPrice = (productsSnapshot.data!.docs.firstWhere((doc) => doc['name'] == productName)['price']) as num?;
              if (productPrice != null) {
                itemProfits[productName] = itemProfits[productName]! + ((sellingPrice - productPrice) * saleQuantity.toDouble());
              }
            }
          }
        }

        double totalProfit = 0.0;
        itemProfits.forEach((key, value) {
          totalProfit += value;
        });

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '$totalProfit\ birr',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
                fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  },
),

            ],
          ),
        ],
      ),
    ),
  ),
),



// Container(
//                 height: 170, // Adjust the height as needed
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   color: Color.fromARGB(255, 3, 94, 147),
//                   // margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Stack(
//                       children: [
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   spreadRadius: 2,
//                                   blurRadius: 5,
//                                   offset: Offset(
//                                       0, 3), // changes position of shadow
//                                 ),
//                               ],
//                             ),
//                             child: TextButton(
//                               onPressed: () {
//                                 // Add your action here
//                               },
//                               style: TextButton.styleFrom(
//                                 backgroundColor: Color.fromARGB(
//                                     255, 109, 163, 206), // Set background color
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15.0, vertical: 15.0),
//                                 child: Text(
//                                   'show more',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Total expenditure',
//                               style: TextStyle(
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 10),
//                               child: Text(
//                                 '\$1000',
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),



//               const SizedBox(height: 10.0),
//               _buildBarChart(),
//               _buildPlaceholderTableCard(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildBarChartCard() {
//   // Building the bar chart wrapped inside a Card widget
//   return Card(
//     child: Container(
//       height: 300, // Adjust the height as needed
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Sales Overview',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             _buildBarChart(),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildBarChart() {
//   // Example data for the bar chart
//   final List<SalesData> data = [
//     SalesData('Jan', 100),
//     SalesData('Feb', 150),
//     SalesData('Mar', 200),
//     SalesData('Apr', 180),
//   ];

//   // Building the bar chart
//   return Card(
//     child: Container(
//       height: 250,
//       width: 400,
//       child: Expanded(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: charts.BarChart(
//             [
//               charts.Series<SalesData, String>(
//                 id: 'Sales',
//                 data: data,
//                 domainFn: (SalesData sales, _) => sales.month,
//                 measureFn: (SalesData sales, _) => sales.sales,
//               ),
//             ],
//             animate: true,
//           ),
//         ),
//       ),
//     ),
//   );
// }

// // Define SalesData class
// class SalesData {
//   final String month;
//   final int sales;

//   SalesData(this.month, this.sales);
// }

// Widget _buildPlaceholderTableCard() {
//   return Card(
//     child: Container(
//       padding: EdgeInsets.all(15.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Placeholder table content goes here
//           Text(
//             'Transactions',
//             style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8.0),
//           // Add your placeholder table widget here
//           // For example:
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columnSpacing: 30.0, // Adjust spacing between columns
//               columns: [
//                 DataColumn(label: Text('Column 1')),
//                 DataColumn(label: Text('Column 2')),
//                 DataColumn(label: Text('Column 3')),
//               ],
//               rows: [
//                 DataRow(cells: [
//                   DataCell(Text('Data 1')),
//                   DataCell(Text('Data 2')),
//                   DataCell(Text('Data 3')),
//                 ]),
//                 // Add more rows as needed
//               ],
//             ),
//           ),
//           SizedBox(height: 8.0),
//           // "More" button
//           TextButton(
//             onPressed: () {
//               // Handle "More" button press
//             },
//             child: Text('More'),
//           ),
        ],
      ),
    ),
      )
  );
  }
  }