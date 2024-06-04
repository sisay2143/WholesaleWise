import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(buildBarChartCards());
}

class BarChartData {
  final String category;
  final int quantity;

  BarChartData(this.category, this.quantity);
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
          height: 100,
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
      await FirebaseFirestore.instance.collection('sales_transaction').get();

  // Process fetched data
  Map<String, int> categoryQuantityMap = {};
  snapshot.docs.forEach((doc) {
    Timestamp timestamp = doc['timestamp'];
    int quantity = doc['quantity'];
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
    String dateString = _formatDate(dateTime); // Format date as "Jan 1", "Feb 15", etc.
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

String _formatDate(DateTime date) {
  // Format date as "MMM d" (e.g., "Jan 1", "Feb 15")
  return DateFormat.MMMd().format(date);
}
