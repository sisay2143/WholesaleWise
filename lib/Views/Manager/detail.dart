


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class detailscreen extends StatefulWidget {
  final DocumentSnapshot request;

  const detailscreen({Key? key, required this.request}) : super(key: key);

  @override
  _detailscreenState createState() => _detailscreenState();
}

class _detailscreenState extends State<detailscreen> {
  Future<void> _approveRequest(DocumentSnapshot request) async {
    try {
      // Update Firestore document to mark request as approved
      await request.reference.update({'status': 'approved'});
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

  @override
  Widget build(BuildContext context) {
    // final name = widget.request['name'];
    // final price = widget.request['price'];
    final quantity = widget.request['quantity'];
    // final imageUrl = widget.request['imageUrl'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 20, 20),
                  // child: Image.asset(
                  //   imageUrl,
                  //   width: 150,
                  //   height: 150,
                  //   fit: BoxFit.cover,
                  // ),
                  width: 150,
                  height: 150,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      // Text(
                        // 'Name: $name',
                        // style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      SizedBox(height: 10.0),
                      // Text('Price: $price'),
                      SizedBox(height: 10.0),
                      Text('Quantity: $quantity'),
                      SizedBox(height: 10.0),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ],
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
                    _approveRequest(widget.request); // Call approve function with request
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Reject'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
