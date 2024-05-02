// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/Views/Manager/approval.dart';
import 'package:untitled/Services/database.dart';
import 'package:untitled/models/products.dart';

class detailscreen extends StatefulWidget {
  final DocumentSnapshot request;

  const detailscreen({Key? key, required this.request}) : super(key: key);

  @override
  _detailscreenState createState() => _detailscreenState();
}

class _detailscreenState extends State<detailscreen> {
  String _newPrice = ''; // Variable to store the new price entered by the user
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedOption;
  Product? _selectedProduct;
  late Product pro;
  String reason = '';

  Future<void> _fetchProductByPid(String pidOrName) async {
    try {
      Product? product =
          await _firestoreService.getProductByPidOrName(pidOrName);
      if (product != null) {
        setState(() {
          _selectedProduct = product;
          pro = product;
        });
        // Fetch the reason for stock out from Firestore
        await FirebaseFirestore.instance
            .collection('approval_requests')
            .where('productId', isEqualTo: product.pid)
            .where('status', isEqualTo: 'pending')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              reason = doc['reason'];
            });
          });
        });
      } else {
        throw 'Product not found';
      }
    } catch (error) {
      print('Error fetching product: $error');
    }
  }

  Future<void> _approveRequest(DocumentSnapshot request) async {
    try {
      // Get the document ID of the approval request
      String requestId = request.id;
      print('Request ID: $requestId');

      // Get a reference to the approval request document
      DocumentReference approvalRequestRef = FirebaseFirestore.instance
          .collection('approval_requests')
          .doc(requestId);
      print('Approval Request Reference: $approvalRequestRef');

      // Fetch the approval request document
      DocumentSnapshot approvalRequestSnapshot = await approvalRequestRef.get();
      print('Approval Request Snapshot: $approvalRequestSnapshot');

      // Get the requested quantity and product name from the approval request
      int requestedQuantity = approvalRequestSnapshot['quantity'];
      String productName = approvalRequestSnapshot['productName'];
      String reason = approvalRequestSnapshot['reason'];
      print('Requested Quantity: $requestedQuantity');
      print('Product Name: $productName');

      // Get a reference to the product document
      QuerySnapshot productQuerySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isEqualTo: productName)
          .get();
      if (productQuerySnapshot.docs.isNotEmpty) {
        DocumentSnapshot productSnapshot = productQuerySnapshot.docs.first;
        print('Product Snapshot: $productSnapshot');
        int currentQuantity = productSnapshot['quantity'];
        print('Current Quantity: $currentQuantity');

        // Ensure the current quantity is greater than or equal to the requested quantity
        if (currentQuantity >= requestedQuantity) {
          // Calculate the updated quantity after deducting the requested quantity
          int updatedQuantity = currentQuantity - requestedQuantity;
          print('Updated Quantity: $updatedQuantity');

          // Update the quantity field in the product document
          await productSnapshot.reference.update({'quantity': updatedQuantity});
          print('Quantity Updated Successfully.');

          // Update Firestore document to mark request as approved
          await approvalRequestRef
              .update({'status': 'approved', 'selling price': _newPrice});

          // Add the approved product to the "products for sale" collection
          await FirebaseFirestore.instance
              .collection('products for sale')
              .doc(productSnapshot.id)
              .set({
            'name': productName,
            'quantity': requestedQuantity,
            'imageUrl': productSnapshot['imageUrl'],
            'pid': productSnapshot['pid'],
            'price': productSnapshot['price'],
            'category': 'Default Category',
            'expiredate':
                Timestamp.fromDate(DateTime.parse('2024-05-30 00:00:00')),
            'selling price':
                _newPrice, // Assuming _newPrice is the selling price entered by the user
            'productId': productSnapshot
                .id, // Assuming this is the product ID in the "approval_requests" collection
          });

          print(
              'Approval request approved. Requested quantity deducted from the product.');
        } else {
          print('Error: Insufficient quantity available.');
          // Handle error appropriately, e.g., show an error message to the user
        }
      } else {
        print('Error: Product not found.');
        // Handle error appropriately, e.g., show an error message to the user
      }
    } catch (error) {
      print('Error approving request: $error');
      // Handle error appropriately
    }
  }

  Future<void> _rejectRequest(DocumentSnapshot request) async {
    // Implement rejection logic here
    await request.reference.update({'status': 'rejected'});

    print('Request Rejected');
  }

  Future<void> _updateProductQuantity() async {
    // Ensure necessary fields are selected and available
    if (_selectedProduct == null) {
      print('_selectedProduct is null');
      return;
    }

    FirebaseFirestore.instance
        .collection('approval_requests')
        .where('productId', isEqualTo: _selectedProduct!.pid)
        .snapshots()
        .listen((snapshot) async {
      print('Snapshot received');
      for (var doc in snapshot.docs) {
        var status = doc['status'];
        print('Status: $status');
        if (status == 'approved') {
          // Retrieve the quantity from the approved request
          final int approvedQuantity = int.parse(doc['quantity']);
          print('Approved Quantity: $approvedQuantity');
          int newQuantity = _selectedProduct!.quantity - approvedQuantity;
          print('New Quantity: $newQuantity');
          if (newQuantity <= 0) {
            // If the new quantity is 0 or negative, delete the product
            await _firestoreService.deleteProduct(_selectedProduct!.pid);
          } else {
            // Otherwise, update the product quantity
            await _firestoreService.updateProduct(_selectedProduct!.pid, {
              'quantity': newQuantity,
            });
          }

          // Show a dialog to inform the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('Product quantity updated successfully.'),
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
      }
    });
  }

  Future<void> _showConfirmationDialog(DocumentSnapshot request) async {
    if (_newPrice.isEmpty) {
      // Show a snackbar to inform the user to fill in the selling price first
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in the selling price first.'),
      ));
      return;
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Approval'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to approve this request?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                _approveRequest(
                    widget.request); // Call approve function with request
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Approval())); // Navigate back to the approval screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final name = widget.request['productName'];
    final quantity = widget.request['quantity'];
    final reason = widget.request['reason'];
    final imageUrl =
        widget.request['imageUrl']; // Fetch imageUrl from Firestore

    // Define a variable to determine whether to show the price field
    bool showPriceField = reason != 'Worn Out';

    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Product Details'),
            backgroundColor: Color.fromARGB(255, 3, 94, 147),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          imageUrl, // Use Image.network to load imageUrl from Firestore
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Name: $name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Text('Quantity: $quantity'),
                        Text('Reason: $reason'),
                        SizedBox(height: 10.0),
                        // Conditionally show the TextFormField based on the reason
                        if (showPriceField)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Set Price',
                              hintText: 'Enter the selling price',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _newPrice = value;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(
                            widget.request); // Show confirmation dialog
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Text('Approve'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _rejectRequest(widget
                            .request); // Call reject function with request
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Text('Reject'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
