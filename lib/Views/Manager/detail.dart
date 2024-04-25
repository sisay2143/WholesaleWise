// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/Views/Manager/approval.dart';

class detailscreen extends StatefulWidget {
  final DocumentSnapshot request;

  const detailscreen({Key? key, required this.request}) : super(key: key);

  @override
  _detailscreenState createState() => _detailscreenState();
}

class _detailscreenState extends State<detailscreen> {
  String _newPrice = ''; // Variable to store the new price entered by the user

  Future<void> _approveRequest(DocumentSnapshot request) async {
    try {
      // Update Firestore document to mark request as approved
      await request.reference.update({'status': 'approved', 'selling price': _newPrice});
      print('Approval request approved.');
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
              _approveRequest(widget.request); // Call approve function with request
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Approval())); // Navigate back to the approval screen
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final name = widget.request['productName'];
    final quantity = widget.request['quantity'];
    final imageUrl = widget.request['imageUrl']; // Fetch imageUrl from Firestore

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
                        SizedBox(height: 10.0),
                        // TextFormField for setting the new price
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
                        _showConfirmationDialog(widget.request); // Show confirmation dialog
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Text('Approve'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _rejectRequest(widget.request); // Call reject function with request
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
