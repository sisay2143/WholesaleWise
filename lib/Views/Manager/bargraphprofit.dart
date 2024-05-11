import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(buildBarChartCardsss());
}

class BarChartData {
  final String date;
  final double totalDeductedValue;

  BarChartData(this.date, this.totalDeductedValue);
}

Widget buildBarChartCardsss() {
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
              id: 'DeductedValue',
              data: data,
              domainFn: (BarChartData sales, _) => sales.date,
              measureFn: (BarChartData sales, _) => sales.totalDeductedValue,
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            ),
          ],
          animate: true,
          // Customize the appearance of the chart
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
  QuerySnapshot salesSnapshot =
      await FirebaseFirestore.instance.collection('sales_transaction').get();
  QuerySnapshot productsSnapshot =
      await FirebaseFirestore.instance.collection('products').get();

  // Process fetched data
  Map<String, double> daySalesMap = {};

  // Map product names to their prices
  Map<String, double?> productPrices = {};
  productsSnapshot.docs.forEach((doc) {
   productPrices[doc['name']] = doc['price'];

  });

  salesSnapshot.docs.forEach((doc) {
    Timestamp timestamp = doc['timestamp'];
    int quantity = doc['quantity'];
    String productName = doc['productName'];
    double sellingPrice;
    if (doc['sellingPrice'] is String) {
      sellingPrice = double.tryParse(doc['sellingPrice']) ?? 0.0;
    } else {
      sellingPrice = doc['sellingPrice'].toDouble();
    }

    if (productPrices.containsKey(productName)) {
      double? productPrice = productPrices[productName];
      if (productPrice != null) {
        double deductedValue = (sellingPrice - productPrice) * quantity;

        DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
        String dateString =
            '${dateTime.year}-${dateTime.month}-${dateTime.day}'; // Format to display only date
        daySalesMap[dateString] ??= 0;
        daySalesMap[dateString] = daySalesMap[dateString]! + deductedValue;
      }
    }
  });

  // Convert data to BarChartData objects
  daySalesMap.forEach((date, totalDeductedValue) {
    chartData.add(BarChartData(date, totalDeductedValue ?? 0));
  });

  return chartData;
}
