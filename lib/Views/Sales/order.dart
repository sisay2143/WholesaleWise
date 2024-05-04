import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class order extends StatefulWidget {
  const order({Key? key}) : super(key: key);

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Order Request'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Name:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter product name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Quantity:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _submitOrderRequest(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 3, 94, 147),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitOrderRequest(BuildContext context) {
  String productName = _productNameController.text.trim();
  String quantity = _quantityController.text.trim();

  if (productName.isNotEmpty && quantity.isNotEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to submit this order request?'),
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
                _submitOrder(productName, int.parse(quantity), context); // Call the method to submit the order
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please enter product name and quantity.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  Future<void> _submitOrder(String productName, int quantity, BuildContext context) async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Define the order data
      Map<String, dynamic> orderData = {
        'productName': productName,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(), // Timestamp of the order submission
      };

      // Add the order data to Firestore
      await firestore.collection('orders').add(orderData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order request submitted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit order request. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error submitting order: $e');
    }
  }
}
