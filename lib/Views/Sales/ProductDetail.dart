// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CommitSale.dart';
import 'package:intl/intl.dart';

class detailss extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String productName;
  final String sellingPrice;
  final Timestamp expireDate; // Change the type to Timestamp
  final Map<String, dynamic>
      additionalFields; // New field to hold additional data
  final String productId;

  detailss({
    required this.imageUrl,
    required this.category,
    required this.productName,
    required this.sellingPrice,
    required this.expireDate,
    required this.additionalFields, // Updated constructor to accept additional fields
    required this.productId, // Add productId to the constructor

  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Detail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductDetailPage(
        imageUrl: imageUrl,
        category: category,
        productName: productName,
        sellingPrice: sellingPrice,
        productId: productId,
        expireDate: expireDate, // Pass the expireDate as a Timestamp
        additionalFields:
            additionalFields, // Pass additional fields to the detail screen
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final String imageUrl;
  final String category;
  final String productName;
  final String sellingPrice;
  final Timestamp expireDate; // Change the type to Timestamp
  final Map<String, dynamic>
      additionalFields; // New field to hold additional data
  final String productId;

  ProductDetailPage({
    required this.imageUrl,
    required this.category,
    required this.productName,
    required this.sellingPrice,
    required this.expireDate,
    required this.additionalFields,
    required this.productId, // Add productId to the constructor
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _quantityController = TextEditingController();
  final _sellerNameController = TextEditingController();
  final _customerNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _quantityController.dispose();
    _sellerNameController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedExpireDate =
        DateFormat('MMMM dd, yyyy').format(widget.expireDate.toDate());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommitSale()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Card(
                  elevation: 4.0,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Selling Price: \$${widget.sellingPrice}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Expire Date: $formattedExpireDate',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      if (widget.additionalFields.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.0),
                            Text(
                              'Quantity: ${widget.additionalFields['quantity']}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Quantity You Want to Sell:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          hintText: 'Enter Quantity',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Sold By:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _sellerNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Name',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Customer Name:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _customerNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Customer Name',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  _commitSale();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 3, 94, 147),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Commit Sale',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
void _commitSale() async {
  String quantity = _quantityController.text.trim();
  String sellerName = _sellerNameController.text.trim();
  String customerName = _customerNameController.text.trim();

  // Get the current quantity from the "products for sale" collection
  DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
      .collection('products for sale')
      .doc(widget.productId)
      .get();
  int availableQuantity = productSnapshot.get('quantity');

  if (int.parse(quantity) <= availableQuantity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Sale'),
          content: Text('Are you sure you want to sell this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performSale(
                    quantity, sellerName, customerName, widget.productId);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  } else {
    // Display an error message if the requested quantity is greater than the available quantity
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insufficient Quantity'),
          content: Text('The  quantity entered is greater than the available quantity.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

  void _performSale(String quantity, String sellerName, String customerName, String productId) {
  if (quantity.isNotEmpty && sellerName.isNotEmpty && customerName.isNotEmpty) {
    CollectionReference salesRef = FirebaseFirestore.instance.collection('sales_transaction');

    // Check if the product already exists in the database
    salesRef.where('productId', isEqualTo: productId).get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Product exists, update the quantity
        DocumentReference productRef = querySnapshot.docs.first.reference;
        int existingQuantity = querySnapshot.docs.first.get('quantity');
        int newQuantity = existingQuantity + int.parse(quantity);
        productRef.update({'quantity': newQuantity}).then((_) {
          print("Quantity updated successfully");
          _quantityController.clear();
          _sellerNameController.clear();
          _customerNameController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have successfully updated the quantity.'),
              backgroundColor: Colors.green, // Success color
            ),
          );
        }).catchError((error) => print("Failed to update quantity: $error"));
      } else {
        // Product does not exist, add a new document
        salesRef.add({
          'productName': widget.productName,
          'imageUrl': widget.imageUrl,
          'category': widget.category,
          'sellingPrice': widget.sellingPrice,
          'quantity': int.parse(quantity),
          'sellerName': sellerName,
          'customerName': customerName,
          'productId': productId, // Add product ID for future reference
          'timestamp': Timestamp.now(),
        }).then((value) {
          print("Sale committed successfully");
          _quantityController.clear();
          _sellerNameController.clear();
          _customerNameController.clear();

          // Update product quantity after sale
        updateProductQuantity(productId, int.parse(quantity));
        

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have successfully sold the product.'),
              backgroundColor: Colors.green, // Success color
            ),
          );
        }).catchError((error) => print("Failed to commit sale: $error"));
      }
    }).catchError((error) => print("Error checking product existence: $error"));

    updateProductQuantity(productId, int.parse(quantity));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please fill all fields.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  void updateProductQuantity(String productId, int soldQuantity) {
    // Get a reference to the product document
    DocumentReference productRef = FirebaseFirestore.instance
        .collection('products for sale')
        .doc(productId);

    // Atomically update the product quantity by subtracting the sold quantity
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot productSnapshot = await transaction.get(productRef);
      if (productSnapshot.exists) {
        Map<String, dynamic>? productData = productSnapshot.data()
            as Map<String, dynamic>?; // Cast to Map<String, dynamic>
        if (productData != null) {
          int currentQuantity = productData['quantity'] ?? 0;
          int newQuantity = currentQuantity - soldQuantity;
          if (newQuantity >= 0) {
            transaction.update(productRef, {'quantity': newQuantity});
            print('Product quantity updated successfully');
          } else {
            print('Error: Sold quantity exceeds available quantity');
          }
        } else {
          print('Error: Product data not found');
        }
      } else {
        print('Error: Product document not found');
      }
    }).catchError((error) {
      print('Failed to update product quantity: $error');
    });
  }
}
