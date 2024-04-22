// ignore_for_file: prefer_const_constructors



// import 'package:flutter/material.dart';
// import 'detail.dart';

// void main() {
//   runApp(Approval());
// }

// class Approval extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Center(child: Text('Approval')),
//           backgroundColor: Color.fromARGB(255, 3, 94, 147),
//         ),
//         body: ListView.builder(
//           itemCount: 3, // Set the number of cards you want
//           itemBuilder: (context, index) {
//             return Card(
//               elevation: 4,
//               margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//               child: Container(
//                 padding: EdgeInsets.all(10.0),
//                 height: 220,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.fromLTRB(15, 15, 20, 20),
//                       child: Image.asset(
//                         'lib/assets/images/shoe1.jpg',
//                         width: 150,
//                         height: 150,
//                         fit: BoxFit.cover,
//                       ),
//                       width: 150,
//                       height: 150,
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 20.0),
//                           Text(
//                             'Name:  Phone',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 10.0),
//                           Text('Price: 100000'),
//                           SizedBox(height: 10.0),
//                           Text('Quantity: 10'),
//                           SizedBox(height: 10.0),
//                           SizedBox(height: 30.0),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => detailscreen()),
//                               ); // Add your functionality here
//                             },
//                             style: ElevatedButton.styleFrom(
//                               primary: Color.fromARGB(255, 3, 94, 147),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Text('More'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(Approval());
}

class Approval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Approval')),
          backgroundColor: Color.fromARGB(255, 3, 94, 147),
        ),
        body: ApprovalList(),
      ),
    );
  }
}

class ApprovalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('approval_requests')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final requests = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final productId = request['productId'];
            final quantity = request['quantity'];
            final name = 'Phone'; // Replace with dynamic data if available
            final price = 100000; // Replace with dynamic data if available
            final imageUrl = 'lib/assets/images/shoe1.jpg'; // Replace with dynamic data if available

            return Card(
              elevation: 4,
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => detailscreen(request: request)),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 20, 20),
                        child: Image.asset(
                          imageUrl,
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
                              'Name: $name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Text('Price: $price'),
                            SizedBox(height: 10.0),
                            Text('Quantity: $quantity'),
                            SizedBox(height: 10.0),
                            SizedBox(height: 30.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          detailscreen(request: request,)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 3, 94, 147),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('More'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ManagerScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Approval Requests'),
//       ),
//       body: Approval(),
//     );
//   }
// }

// class Approval extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('approval_requests')
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         final requests = snapshot.data?.docs ?? [];

//         return ListView.builder(
//           itemCount: requests.length,
//           itemBuilder: (context, index) {
//             final request = requests[index];
//             final productId = request['productId'];
//             final quantity = request['quantity'];
//             final requestedBy = request['requestedBy'];

//             return ListTile(
//               title: Text('Product ID: $productId'),
//               subtitle: Text('Quantity: $quantity\nRequested By: $requestedBy'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.check),
//                     onPressed: () => _approveRequest(request),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () => _rejectRequest(request),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _approveRequest(DocumentSnapshot request) async {
//   try {
//     // Update Firestore document to mark request as approved
//     await request.reference.update({'status': 'approved'});

//     // Get product details
//     final productId = request['productId'];
//     final quantity = request['quantity'];

//     // Fetch current product details from Firestore
//     final productDoc = await FirebaseFirestore.instance
//         .collection('products')
//         .doc(productId)
//         .get();

//     // Calculate new quantity
//     final currentQuantity = productDoc['quantity'];
//     final newQuantity = currentQuantity - quantity;

//     // Update product quantity in Firestore
//     await FirebaseFirestore.instance
//         .collection('products')
//         .doc(productId)
//         .update({'quantity': newQuantity});

//     // Perform additional actions if needed
//     // For example: Send notifications, log transaction, etc.
//     // Additional actions here...

//     print('Approval request for $productId approved. Product quantity updated.');
//   } catch (error) {
//     print('Error approving request: $error');
//     // Handle error appropriately
//   }
// }

//   Future<void> _rejectRequest(DocumentSnapshot request) async {
//     // Update Firestore document to mark request as rejected
//     await request.reference.update({'status': 'rejected'});
//   }
// }

