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
  List<Color> defaultColors = [
    Colors.blue,
    Colors.green,
    Color.fromARGB(255, 5, 191, 205),
    Color.fromARGB(255, 1, 92, 149),
    Color.fromARGB(255, 52, 137, 227),
    Color.fromARGB(255, 13, 79, 220),
    Colors.teal,
    Color.fromARGB(255, 16, 133, 229),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final QuerySnapshot salesSnapshot =
        await FirebaseFirestore.instance.collection('sales_transaction').get();

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
    int index = 0;
    colorList = List.generate(
      categories.length,
      (index) {
        // Assign default color if index is within the default color list length
        if (index < defaultColors.length) {
          return defaultColors[index];
        } else {
          // Generate random color if index exceeds default color list length
          final hue = Random().nextInt(360);
          return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.5).toColor();
        }
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




// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pie_chart/pie_chart.dart';

// void main() {
//   runApp(PieChartWidget());
// }

// class PieChartWidget extends StatefulWidget {
//   @override
//   _PieChartWidgetState createState() => _PieChartWidgetState();
// }

// class _PieChartWidgetState extends State<PieChartWidget> {
//   Map<String, double> dataMap = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     final QuerySnapshot salesSnapshot = await FirebaseFirestore.instance.collection('sales_transaction').get();

//     Map<String, double> categoryMap = {};

//     salesSnapshot.docs.forEach((doc) {
//       final String category = doc['category'];
//       final double quantity = doc['quantity'].toDouble();
      
//       if (categoryMap.containsKey(category)) {
//        categoryMap[category] = (categoryMap[category] ?? 0) + quantity;

//       } else {
//         categoryMap[category] = quantity;
//       }
//     });

//     setState(() {
//       dataMap = categoryMap;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Pie Chart Example'),
//       // ),
//       body: Center(
//         child: dataMap.isEmpty
//             ? CircularProgressIndicator()
//             : PieChart(
//                 dataMap: dataMap,
//                 colorList: [
//                   const Color.fromARGB(255, 3, 77, 138),
//                   Color.fromARGB(255, 4, 137, 117),
//                   Color.fromARGB(255, 54, 114, 106),
//                   Color.fromARGB(255, 7, 97, 158),
//                   // Add more colors as needed
//                 ],
//                 chartRadius: MediaQuery.of(context).size.width / 2.0,
//                 chartType: ChartType.disc,
//                 legendOptions: LegendOptions(
//                   showLegends: true,
//                   legendPosition: LegendPosition.right,
//                   legendTextStyle: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 chartValuesOptions: ChartValuesOptions(
//                   showChartValueBackground: true,
//                   showChartValues: true,
//                   showChartValuesInPercentage: true,
//                   showChartValuesOutside: false,
//                   decimalPlaces: 1,
//                 ),
//               ),
//       ),
//     );
//   }
// }
