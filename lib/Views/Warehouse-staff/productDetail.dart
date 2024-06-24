import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart'; // Import for DateFormat
import 'EditScreen.dart';
import 'package:untitled/models/products.dart';
import 'package:untitled/Services/database.dart';
import 'package:untitled/models/products.dart' as pmodel;

class ProductDetailPage extends StatefulWidget {
  final pmodel.Product cuproduct;

  ProductDetailPage(this.cuproduct, {super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late pmodel.Product _product;

  @override
  void initState() {
    _product = widget.cuproduct;
    super.initState();
  }

  Future<void> _navigateToEditScreen() async {
    final existingProduct = _product;
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(existingProduct),
      ),
    );

    if (updatedData != null) {
      setState(() {
        _product = updatedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = [
      charts.Series<StockData, String>(
        id: 'Stock',
        domainFn: (StockData series, _) => series.label,
        measureFn: (StockData series, _) => series.value,
        data: [
          StockData('Stock In', 123, Colors.green),
          StockData('Stock Out', 567, Colors.red),
          StockData('Running Out', 45678, Colors.yellow),
        ],
        colorFn: (StockData series, _) => charts.ColorUtil.fromDartColor(series.color),
        labelAccessorFn: (StockData series, _) => '${series.label}: ${series.value}',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Product Detail'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .9,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Image.network(
                    _product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _product.name,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                IconButton(
                  onPressed: _navigateToEditScreen,
                  icon: Icon(
                    Icons.edit_note,
                    size: 50,
                    color: Color.fromRGBO(107, 59, 225, 1),
                  ),
                  tooltip: "Edit",
                ),
              ],
            ),
            SizedBox(height: 25.0),
            Text(
              'Price: \$ ${_product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(height: 10.0),
            Text(
              'Expiry Date: ${_formatExpiryDate(_product.expiredate)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(height: 10.0),
            Text(
              'Available Units: ${_product.quantity}',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  String _formatExpiryDate(DateTime? expiryDate) {
    if (expiryDate != null) {
      return DateFormat('MMMM d, y').format(expiryDate);
    } else {
      return 'N/A';
    }
  }
}

class StockData {
  final String label;
  final double value;
  final Color color;

  StockData(this.label, this.value, this.color);
}
