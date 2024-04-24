// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:untitled/Services/database.dart';
import 'package:untitled/models/products.dart';
import 'ItemsCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async'; 

class StockOutPage extends StatefulWidget {
  @override
  _StockOutPageState createState() => _StockOutPageState();
}

class _StockOutPageState extends State<StockOutPage> {
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedOption;
  Product? _selectedProduct;
  late Product pro;

  @override
  void dispose() {
    _pidController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _fetchProductByPid(String pidOrName) async {
    try {
      Product? product =
          await _firestoreService.getProductByPidOrName(pidOrName);
      if (product != null) {
        setState(() {
          _selectedProduct = product;
          pro = product;
        });
      } else {
        throw 'Product not found';
      }
    } catch (error) {
      print('Error fetching product: $error');
      _showAlertDialog('Error', 'Product not found');
    }
  }

  void _handleOptionChange(String? option) {
    setState(() {
      _selectedOption = option;
    });
  }

  Future<void> registerTransaction() async {
    print(" ********** transaction update");
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    final transactionsRef = _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('transactions');
    await transactionsRef.add({
      'productId': _selectedProduct!.pid,
      'quantityRemoved': int.parse(_quantityController.text),
      'removedDate': FieldValue.serverTimestamp(),
    });
    // Update product status or other necessary actions
  }



// Modified sendApprovalRequest function
// Completer to wait for approval response
Completer<void>? listenForApprovalResponseCompleter;

// Modified sendApprovalRequest function
Future<void> sendApprovalRequest() async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc('ThMFYek1BJhk1uqYHotsAI2MqC73')
            .get();

    if (userDoc.exists) {
      final String? role = userDoc.data()?['role'];
      if (role == 'manager') {
        final String? managerUid = userDoc.id;
        if (managerUid != null) {
          String productName = _selectedProduct!.name;
          String productId = _selectedProduct!.pid;
          String expiredate = _selectedProduct!.expiredate;
          String imageUrl = _selectedProduct!.imageUrl;
          double price = _selectedProduct!.price;

          // Initialize the Completer
          listenForApprovalResponseCompleter = Completer<void>();

          await FirebaseFirestore.instance
              .collection('approval_requests')
              .add({
            'productName': productName,
            'productId': productId,
            'expiredate': expiredate,
            'imageUrl': imageUrl,
            'quantity': int.parse(_quantityController.text),
            'price': price, // Adding the price field
            'requestedBy': FirebaseAuth.instance.currentUser!.uid,
            'requestedAt': FieldValue.serverTimestamp(),
            'managerUid': managerUid,
            'status': 'pending',
          });

          _showAlertDialog(
            'Request Sent',
            'Approval request for stock-out sent to manager.',
          );

          // Wait for approval response before proceeding
          await listenForApprovalResponse;
        } else {
          throw 'Manager UID not found.';
        }
      } else {
        throw 'User is not a manager.';
      }
    } else {
      throw 'User document does not exist.';
    }
  } catch (error) {
    print('Error sending approval request: $error');
    _showAlertDialog('Error', 'Failed to send approval request.');
  }
}

// Function to listen for approval response
void listenForApprovalResponse() {
  FirebaseFirestore.instance
      .collection('approval_requests')
      .where('productId', isEqualTo: _selectedProduct!.pid)
      .snapshots()
      .listen((snapshot) {
    snapshot.docs.forEach((doc) {
      // Check if the approval is granted
      final status = doc['status'];
      print(status);
      if (status == 'approved') {
         print('almost updating');
        // Update product quantity after approval
        _updateProductQuantity();
        print('product updated');
        // Complete the Completer to signal that the approval response is received
        listenForApprovalResponseCompleter!.complete();
      } else if (status == 'rejected') {
        // Handle rejection if needed
      }
    });
  });
}




  // Update product quantity after approval
  Future<void> _updateProductQuantity() async {
    try {
      final int newQuantity = _selectedProduct!.quantity - int.parse(_quantityController.text);
      await _firestoreService.updateProductQuantity(_selectedProduct!.pid, newQuantity);
      // Show success message or perform any other necessary actions
      print(newQuantity);
      print('quantity updated');
    } catch (error) {
      print('Error updating product quantity: $error');
      _showAlertDialog('Error', 'Failed to update product quantity.');
    }
  }

// Listen for approval response
// void listenForApprovalResponse() {
//   FirebaseFirestore.instance
//       .collection('approval_requests')
//       .where('productId', isEqualTo: _selectedProduct!.pid)
//       .snapshots()
//       .listen((snapshot) {
//     snapshot.docs.forEach((doc) {
//       // Check if the approval is granted
//       final status = doc['status'];
//         print('waiting for approval ');

//       if (status == 'approved') {
//         // Update product quantity after approval
//         _updateProductQuantity();
//         print('product approved');
//         // Show success message or perform any other necessary actions
//       } else if (status == 'rejected') {
//         // Handle rejection if needed
//       }
//     });
//   });
// }





  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Stock Out'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                cursorColor: Color.fromARGB(255, 3, 94, 147),
                controller: _pidController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Enter Product Name or ID',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 3, 94, 147),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 3, 94, 147),
                    )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 3, 94, 147),
                    ))),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _fetchProductByPid(_pidController.text);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0), // Adjust the padding as needed
                  child: Text(
                    'Fetch Product',
                    style: TextStyle(
                        fontSize: 16.0), // Adjust the font size as needed
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 3, 94, 147),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedProduct != null) ...[
                Text(
                  'Selected Product',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ItmeCard(pro),
                Text(
                  'Select Stock Out Option:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Sold Out'),
                  leading: Radio<String>(
                    activeColor: Color.fromARGB(255, 3, 94, 147),
                    value: 'Sold Out',
                    groupValue: _selectedOption,
                    onChanged: _handleOptionChange,
                  ),
                ),
                ListTile(
                  title: Text('Worn Out'),
                  leading: Radio<String>(
                    activeColor: Color.fromARGB(255, 3, 94, 147),
                    value: 'Worn Out',
                    groupValue: _selectedOption,
                    onChanged: _handleOptionChange,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 3, 94, 147),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 3, 94, 147),
                      )),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 3, 94, 147),
                      ))),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: sendApprovalRequest,
                  child: Text('Send Approval Request'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 3, 94, 147),
                  )),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
