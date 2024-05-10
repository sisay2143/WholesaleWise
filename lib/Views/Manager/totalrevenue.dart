import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'linegraph.dart';


void main() {
  runApp(MaterialApp(
    home: totalrevenue(),
  ));
}

class totalrevenue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Total Revenue'),
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
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Text(
                                'Your Total Revenue is',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('sales_transaction')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                double totalRevenue = 0.0;
                                if (snapshot.hasData) {
                                  snapshot.data?.docs.forEach((doc) {
                                    final sellingPrice =
                                        (doc.data() as Map<String, dynamic>?)?[
                                            'sellingPrice'];
                                    if (sellingPrice is String) {
                                      totalRevenue +=
                                          double.tryParse(sellingPrice) ?? 0.0;
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
              // SizedBox(height: 16),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.0),
              //   child: SizedBox(
              //     height: 300,
              //     width: 700,
                  
              //     child: Card(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5.0),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(1.0),
              //         child: buildLineGraph(),
              //       ),
              //     ),
              //   ),
              // ),
               Card(
                  margin: EdgeInsets.only(top: 30),
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Placeholder for transaction table columns
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  'Pname',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'sold at',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(), // Horizontal line between header and rows
                        SizedBox(height: 10),
                        // Placeholder for transaction table rows
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('sales_transaction').snapshots(),
                          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Placeholder while loading data
                            }
                            final documents = snapshot.data!.docs;
                            return Column(
                              children: [
                                for (int i = 0; i < documents.length; i++)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Text(documents[i]['productName']),
                                          ),
                                          Expanded(
                                            child: Text('${documents[i]['sellingPrice']}'),
                                          ),
                                          Expanded(
                                            child: Text('${documents[i]['quantity']}'),
                                          ),
                                          Expanded(
                                            child: Text(documents[i]['timestamp'].toDate().toString()),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10), // Spacing between rows
                                      Divider(), // Horizontal line between rows
                                      SizedBox(height: 10), // Spacing between rows
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//   Widget _buildLineGraph() {
//   return charts.LineChart(
//     _createSampleData(),
//     animate: true,
//     behaviors: [
//       charts.ChartTitle(
//         'X Axis Title',
//         behaviorPosition: charts.BehaviorPosition.bottom,
//         titleOutsideJustification:
//             charts.OutsideJustification.middleDrawArea,
//       ),
//       charts.ChartTitle(
//         'Y Axis Title',
//         behaviorPosition: charts.BehaviorPosition.start,
//         titleOutsideJustification:
//             charts.OutsideJustification.middleDrawArea,
//       ),
//     ],
//   );
// }

// List<charts.Series<LinearSales, int>> _createSampleData() {
//   final List<LinearSales> data = [];

//   // Fetch data from Firestore and populate the data list
//   _fetchSalesData().then((salesData) {
//     data.addAll(salesData);

//     // Update the chart with the new data
//     setState(() {});
//   });

//   return [
//     charts.Series<LinearSales, int>(
//       id: 'Sales',
//       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//       domainFn: (LinearSales sales, _) => sales.timestamp.day,
//       measureFn: (LinearSales sales, _) => sales.sellingPrice,
//       data: data,
//     )
//   ];
// }

// Future<List<LinearSales>> _fetchSalesData() async {
//   final QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('sales_transaction')
//       .get();

//   final List<LinearSales> data = [];
//   int totalSalesForDay = 0;
//   DateTime currentDay;

//   snapshot.docs.forEach((doc) {
//     final sellingPrice = doc['sellingPrice'] as int;
//     final timestamp = (doc['timestamp'] as Timestamp).toDate();

//     if (currentDay == null || !_isSameDay(currentDay, timestamp)) {
//       if (currentDay != null) {
//         data.add(LinearSales(currentDay, totalSalesForDay));
//       }

//       currentDay = timestamp;
//       totalSalesForDay = 0;
//     }

//     totalSalesForDay += sellingPrice;
//   });

//   if (currentDay != null) {
//     data.add(LinearSales(currentDay, totalSalesForDay));
//   }

//   return data;
// }

// bool _isSameDay(DateTime date1, DateTime date2) {
//   return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
// }

// class LinearSales {
//   final DateTime timestamp;
//   final int sellingPrice;

//   LinearSales(this.timestamp, this.sellingPrice);
// }
// }