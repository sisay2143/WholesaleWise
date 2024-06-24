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

  void _clearFields() {
    // Clear the text controllers
    _pidController.clear();
    _quantityController.clear();
    // Reset the selected option to null
    _selectedOption = null;
  }

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
            if (_selectedProduct != null) {
              // Check if product is selected
              if (int.parse(_quantityController.text) >
                  _selectedProduct!.quantity) {
                // Show error message if the entered quantity exceeds available quantity
                _showAlertDialog(
                    'Error', 'Entered quantity exceeds available quantity!');
                return; // Exit function if quantity exceeds
              }
              String productName = _selectedProduct!.name;
              String productId = _selectedProduct!.pid; // Update to productId
              DateTime? expiredate = _selectedProduct!.expiredate;
              String imageUrl = _selectedProduct!.imageUrl;
              double price = _selectedProduct!.price;
              String reason = _selectedOption!; // Get the selected reason
              String category = _selectedProduct!.category;

              await FirebaseFirestore.instance
                  .collection('approval_requests')
                  .add({
                'productName': productName,
                'expiredate': expiredate,
                'imageUrl': imageUrl,
                'quantity': int.parse(_quantityController.text),
                'price': price,
                'requestedBy': FirebaseAuth.instance.currentUser!.uid,
                'requestedAt': FieldValue.serverTimestamp(),
                'managerUid': managerUid,
                'status': 'pending',
                'productId': productId,
                'reason': reason,
                'category': category,
              });
              _clearFields();
              _showAlertDialog(
                'Request Sent',
                'Approval request for stock-out sent to manager.',
              );
            } else {
              throw 'Product not selected.';
            }
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
                  'Select Stock Out reason:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                RadioListTile<String>(
                  title: Text('To be saled'),
                  value: 'To be saled',
                  groupValue: _selectedOption,
                  onChanged: _handleOptionChange,
                  activeColor: Color.fromARGB(255, 3, 94, 147),
                ),
                RadioListTile<String>(
                  title: Text('Worn Out'),
                  value: 'Worn Out',
                  groupValue: _selectedOption,
                  onChanged: _handleOptionChange,
                  activeColor: Color.fromARGB(255, 3, 94, 147),
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 20.0), // Adjust padding as needed
                    child: Text(
                      'Send Approval Request',
                      style: TextStyle(
                          fontSize: 18.0), // Increase font size as needed
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 3, 94, 147),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
