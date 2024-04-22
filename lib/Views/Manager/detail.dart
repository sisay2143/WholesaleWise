// import 'package:flutter/material.dart';

// void main() {
//   runApp(detailscreen());
// }

// class detailscreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Rectangular Box with Image',
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color.fromARGB(255, 3, 94, 147),
//           title: Center(child: Text('Detail')),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               child: Container(
//                 margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                 width: 200, // Width of the box
//                 height: 200, // Height of the box
//                 decoration: BoxDecoration(
//                     // border: Border.all(color: Color.fromARGB(255, 4, 95, 159), width: 2), // Border of the box
//                     ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(
//                       0), // Adjust border radius if needed
//                   child: Image.asset(
//                     'lib/assets/images/shoe1.jpg', // Replace 'image.jpg' with your image path
//                     fit: BoxFit.cover, // Cover the entire box with the image
//                   ),
//                 ),
//               ),
//             ),
//             Card(
//               margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Detail',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Name:            phone',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Quantity:       10',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       'Price:       100',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     // Add more details as needed
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Add decline button logic
//                   },
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(120, 50), // Set button width and height
//                     primary: Colors.red, // Set button color
//                   ),
//                   child: Text(
//                     'Decline',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Add approve button logic
//                   },
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(120, 50), // Set button width and height
//                     primary:
//                         Color.fromARGB(255, 3, 94, 147), // Set button color
//                   ),
//                   child: Text(
//                     'Approve',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class detailscreen extends StatefulWidget {
//   @override
//   _detailscreenState createState() => _detailscreenState();
// }

// class _detailscreenState extends State<detailscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product Details'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(10.0),
//             height: 220,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.fromLTRB(15, 15, 20, 20),
//                   child: Image.asset(
//                     'lib/assets/images/shoe1.jpg',
//                     width: 150,
//                     height: 150,
//                     fit: BoxFit.cover,
//                   ),
//                   width: 150,
//                   height: 150,
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20.0),
//                       Text(
//                         'Name:  Phone',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10.0),
//                       Text('Price: 100000'),
//                       SizedBox(height: 10.0),
//                       Text('Quantity: 10'),
//                       SizedBox(height: 10.0),
//                       SizedBox(height: 30.0),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20.0),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     _approveRequest(); // Implement approval logic
//                   },
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.green,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text('Approve'),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _rejectRequest(); // Implement rejection logic
//                   },
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.red,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text('Reject'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _approveRequest() async {
//     // Implement approval logic here
    
//     print('Request Approved');
//   }

//   Future<void> _rejectRequest() async {
//     // Implement rejection logic here
//     print('Request Rejected');
//   }
// }


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

      // Get product details
      final productId = request['productId'];
      final quantity = request['quantity'];

      // Fetch current product details from Firestore
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      // Calculate new quantity
      final currentQuantity = productDoc['quantity'];
      final newQuantity = currentQuantity - quantity;

      // Update product quantity in Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'quantity': newQuantity});

      // Perform additional actions if needed
      // For example: Send notifications, log transaction, etc.
      // Additional actions here...

      print('Approval request for $productId approved. Product quantity updated.');
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
                  child: Image.asset(
                    'lib/assets/images/shoe1.jpg',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  width: 150,
                  height: 150,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'Name:  Phone',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      Text('Price: 100000'),
                      SizedBox(height: 10.0),
                      Text('Quantity: 10'),
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
