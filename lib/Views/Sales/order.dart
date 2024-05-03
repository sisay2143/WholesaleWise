// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';



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
                labelText: 'quantity',
                hintText: 'Enter quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _submitOrderRequest();
              },
              style: ElevatedButton.styleFrom(
               primary: Color.fromARGB(255, 3, 94, 147), // Background color
                onPrimary: Colors.white, // Text color
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 50.0), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Button border radius
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18.0, // Text size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitOrderRequest() {
    String productName = _productNameController.text.trim();
    String quantity = _quantityController.text.trim();

    // Here you can implement the logic to send the order request
    // to the warehouse staff with the entered product name and quantity.
    // You can use APIs, databases, or any other method to communicate
    // the order request to the warehouse.
    // For simplicity, we will just print the order details for now.
    print('Order Request:');
    print('Product Name: $productName');
    print('Quantity: $quantity');

    // Clear the text fields after submitting the order request
    _productNameController.clear();
    _quantityController.clear();

    // Show a confirmation dialog or success message if needed
    // after submitting the order request.

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
              _submitOrder(); // Call the method to submit the order
            },
            child: Text('Yes'),
            
          ),
        ],
      );
    },
  );
  }



Future<void> _submitOrder() async {
  try {
    // Call the cloud function to send email
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'submitOrderEmail',
    );

    await callable.call(<String, dynamic>{
      // Pass any necessary order details to the cloud function
      'orderDetails': {
        'customer': 'John Doe',
        'address': '123 Main St',
        'items': ['Item 1 (Quantity: 2)', 'Item 2 (Quantity: 1)'],
      },
      
    });
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Order request submitted successfully.'),
      backgroundColor: Colors.green, // Success message background color
      
    ),
  );
  } catch (e) {
    print('Error submitting order: $e');
  }
}

Future<void> submitOrderEmail() async {
  final Email email = Email(
    body: 'Order details:\n\nCustomer: John Doe\nAddress: 123 Main St\nItems:\n- Item 1 (Quantity: 2)\n- Item 2 (Quantity: 1)',
    subject: 'New Order',
    recipients: ['sisaybayisa21@example.com'], // Warehouse email address
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
    print('Email sent successfully');
  } catch (error) {
    print('Error sending email: $error');
  }
}


}
