// import 'package:flutter/material.dart';

// // void main() {
// //   runApp(SRequests());
// // }

// class SRequests extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Text Status Selection',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: TextStatusSelection(),
//     );
//   }
// }

// class TextStatusSelection extends StatefulWidget {
//   @override
//   _TextStatusSelectionState createState() => _TextStatusSelectionState();
// }

// class _TextStatusSelectionState extends State<TextStatusSelection> {
//   String selectedStatus = ''; // Initially no status selected
//   List<String> approvedItems = ['Car 1', 'Car 2', 'Car 3'];
//   List<String> pendingItems = ['Laptop 1', 'Laptop 2', 'Tablet 3'];
//   List<String> rejectedItems = ['Shoe 1', 'Shoe 2', 'Shoe 3'];
//   List<String> displayedItems = []; // List to display based on selected status

//   @override
//   void initState() {
//     super.initState();
//     // Set default displayed items to approved items
//     displayedItems = approvedItems;
//     // Set default selected status to Approved
//     selectedStatus = 'Approved';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 3, 94, 147),
//         title: Center(child: Text('Requests')),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 15, 40, 20),
//             child: Text(
//               'Please select one status',
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.grey),
//               color: Colors.grey,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 buildStatusOption('Approved', approvedItems),
//                 buildStatusOption('Pending', pendingItems),
//                 buildStatusOption('Rejected', rejectedItems),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: displayedItems.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   elevation: 4,
//                   margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                   child: Container(
//                     padding: EdgeInsets.all(10.0),
//                     height: 220,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.fromLTRB(15, 15, 20, 20),
//                           child: Image.asset(
//                             getItemImagePath(displayedItems[index]),
//                             height: 150,
//                             width: 400, // Adjusted height
//                             // fit: BoxFit.cover,
//                           ),
//                           width: 150,
//                           height: 150,
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 20.0),
//                               Text(
//                                 'Name:  Phone',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10.0),
//                               Text('Price: 100000'),
//                               SizedBox(height: 10.0),
//                               Text('Quantity: 10'),
//                               SizedBox(height: 10.0),
//                               SizedBox(height: 30.0),
//                               // ElevatedButton(
//                               //   onPressed: () {
//                               //     Navigator.push(
//                               //       context,
//                               //       MaterialPageRoute(
//                               //         builder: (context) => MyApp(),
//                               //       ),
//                               //     ); // Add your functionality here
//                               //   },
//                               //   style: ElevatedButton.styleFrom(
//                               //     primary: Color.fromARGB(255, 3, 94, 147),
//                               //   ),
//                               //   child: Padding(
//                               //     padding: const EdgeInsets.all(10.0),
//                               //     child: Text('More'),
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildStatusOption(String status, List<String> items) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedStatus = status;
//           displayedItems =
//               items; // Update displayed items based on selected status
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//         decoration: BoxDecoration(
//           color: selectedStatus == status
//               ? Color.fromARGB(255, 3, 94, 147)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           status,
//           style: TextStyle(
//             color: selectedStatus == status ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   String getItemImagePath(String item) {
//     if (approvedItems.contains(item)) {
//       return 'lib/assets/images/car.png';
//     } else if (pendingItems.contains(item)) {
//       return 'lib/assets/images/laptop-screen.png';
//     } else if (rejectedItems.contains(item)) {
//       return 'lib/assets/images/shoe1.jpg';
//     } else {
//       return ''; // Default image path if item not found
//     }
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Details'),
//       ),
//       body: Center(
//         child: Text('Details Page'),
//       ),
//     );
//   }
// }
