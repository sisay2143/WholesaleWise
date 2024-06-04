import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(buildBarChartCards());
}

class BarChartData {
  final String day;
  final double totalSales;

  BarChartData(this.day, this.totalSales);
}

Widget buildBarChartCards() {
  return FutureBuilder<List<BarChartData>>(
    future: _getChartDataFromFirestore(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        return Container(
          height: 300,
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBarChart(snapshot.data ?? [])
              ],
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
      height: 200,
      width: 650,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: charts.BarChart(
          [
            charts.Series<BarChartData, String>(
              id: 'Sales',
              data: data,
              domainFn: (BarChartData sales, _) => sales.day,
              measureFn: (BarChartData sales, _) => sales.totalSales,
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
      await FirebaseFirestore.instance.collection('sales_transaction').get();

  // Process fetched data
  Map<String, double> daySalesMap = {};
  snapshot.docs.forEach((doc) {
    Timestamp timestamp = doc['timestamp'];
    int quantity = doc['quantity'];
   double sellingPrice;
if (doc['sellingPrice'] is String) {
  sellingPrice = double.tryParse(doc['sellingPrice']) ?? 0.0;
} else {
  sellingPrice = doc['sellingPrice'].toDouble();
}

    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
     String dateString = _formatDate(dateTime); // Format to display only date
    if (daySalesMap.containsKey(dateString)) {
      daySalesMap[dateString] ??= 0;
daySalesMap[dateString] = (daySalesMap[dateString] ?? 0) + sellingPrice * quantity;


    } else {
      daySalesMap[dateString] = sellingPrice * quantity;
    }
  });

  // Convert data to BarChartData objects
  daySalesMap.forEach((day, totalSales) {
    chartData.add(BarChartData(day, totalSales));
  });

  return chartData;
}

String _formatDate(DateTime date) {
  // Format date as "MMM d" (e.g., "Jan 1", "Feb 15")
  return DateFormat.MMMd().format(date);
}










