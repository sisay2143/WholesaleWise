// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

// void main() {
//   runApp(buildLineGraph());
// }

// class buildLineGraph extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sales Line Chart',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sales Line Chart'),
//       ),
//       body: Center(
//         child: _buildLineGraph(),
//       ),
//     );
//   }

//   Widget _buildLineGraph() {
//     return FutureBuilder<List<LinearSales>>(
//       future: _fetchSalesData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError || snapshot.data == null) {
//           print('Error: ${snapshot.error}');
//           return Text('Error: ${snapshot.error}');
//         } else {
//           List<LinearSales> data = snapshot.data!;
//           return charts.LineChart(
//             _createSampleData(data).cast<charts.Series<dynamic, num>>(),
//             animate: true,
//             behaviors: [
//               charts.ChartTitle(
//                 'Date',
//                 behaviorPosition: charts.BehaviorPosition.bottom,
//                 titleOutsideJustification:
//                     charts.OutsideJustification.middleDrawArea,
//               ),
//               charts.ChartTitle(
//                 'Selling Price',
//                 behaviorPosition: charts.BehaviorPosition.start,
//                 titleOutsideJustification:
//                     charts.OutsideJustification.middleDrawArea,
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }

//   List<charts.Series<LinearSales, DateTime>> _createSampleData(List<LinearSales> data) {
//     // Sort the data by timestamp
//     print('Sorting data by timestamp');
//     data.sort((a, b) {
//       print('Comparing timestamps: ${a.timestamp} and ${b.timestamp}');
//       return a.timestamp.compareTo(b.timestamp);
//     });

//     // Aggregate selling price for each date
//     print('Aggregating selling price for each date');
//     Map<DateTime, int> aggregatedData = {};
//     for (var sale in data) {
//       if (aggregatedData.containsKey(sale.timestamp)) {
//         print('Updating aggregated data for ${sale.timestamp}');
//         aggregatedData[sale.timestamp] = aggregatedData[sale.timestamp]! + sale.sellingPrice;
//       } else {
//         print('Adding new entry to aggregated data for ${sale.timestamp}');
//         aggregatedData[sale.timestamp] = sale.sellingPrice;
//       }
//     }

//     // Convert aggregated data to series
//     print('Converting aggregated data to series');
//     print('Data list length: ${data.length}');
//     for (var sale in data) {
//       print('Data point - timestamp: ${sale.timestamp}, selling price: ${sale.sellingPrice}');
//     }
//     List<charts.Series<LinearSales, DateTime>> series = [
//       charts.Series<LinearSales, DateTime>(
//         id: 'Sales',
//         colorFn: (_, __) {
//           print('Coloring data point');
//           return charts.MaterialPalette.blue.shadeDefault;
//         },
//         domainFn: (LinearSales sales, _) {
//           print('Mapping domain: ${sales.timestamp}');
//           return sales.timestamp;
//         },
//         measureFn: (LinearSales sales, _) {
//           final value = aggregatedData[sales.timestamp] ?? 0;
//           print('Mapping measure: ${sales.timestamp} => $value');
//           return value;
//         },
//         data: data,
//       )
//     ];

//     return series;
//   }

//   Future<List<LinearSales>> _fetchSalesData() async {
//     try {
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('sales_transaction')
//           .get();

//       final List<LinearSales> data = [];
//       Map<DateTime, int> salesPerDay = {};

//       snapshot.docs.forEach((doc) {
//         final sellingPrice = int.parse(doc['sellingPrice'] as String);

//         final timestamp = (doc['timestamp'] as Timestamp).toDate();
//         final DateTime day =
//             DateTime(timestamp.year, timestamp.month, timestamp.day);

//         if (salesPerDay.containsKey(day)) {
//           salesPerDay[day] = (salesPerDay[day] ?? 0) + sellingPrice;
//         } else {
//           salesPerDay[day] = sellingPrice;
//         }
//       });

//       salesPerDay.forEach((day, totalSales) {
//         data.add(LinearSales(day, totalSales));
//       });

//       return data;
//     } catch (error) {
//       print('Error: $error');
//       throw error;
//     }
//   }
// }

// class LinearSales {
//   final DateTime timestamp;
//   final int sellingPrice;

//   LinearSales(this.timestamp, this.sellingPrice);
// }
