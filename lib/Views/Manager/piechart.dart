import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math';

void main() {
  runApp(PieChartWidget());
}

class PieChartWidget extends StatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  Map<String, double> dataMap = {};
  List<Color> colorList = []; // Updated color list

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final QuerySnapshot salesSnapshot = await FirebaseFirestore.instance.collection('sales_transaction').get();

    Map<String, double> categoryMap = {};

    salesSnapshot.docs.forEach((doc) {
      final String category = doc['category'];
      final double quantity = doc['quantity'].toDouble();

      if (categoryMap.containsKey(category)) {
        categoryMap[category] = (categoryMap[category] ?? 0) + quantity;
      } else {
        categoryMap[category] = quantity;
      }
    });

    setState(() {
      dataMap = categoryMap;
      // Update color list based on categories
      updateColorList();
    });
  }

  // Function to update color list dynamically
  void updateColorList() {
    Set<String> categories = dataMap.keys.toSet();
    colorList = List.generate(
      categories.length,
      (index) {
        final hue = (360 * index / categories.length).round();
        return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.5).toColor();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: dataMap.isEmpty
            ? CircularProgressIndicator()
            : PieChart(
                dataMap: dataMap,
                colorList: colorList,
                chartRadius: MediaQuery.of(context).size.width / 2.0,
                chartType: ChartType.disc,
                legendOptions: LegendOptions(
                  showLegends: true,
                  legendPosition: LegendPosition.right,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
      ),
    );
  }
}
