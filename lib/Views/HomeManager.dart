// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:untitled/Views/CreateUser.dart';
// import 'package:untitled/firebase_options.dart';
// import '../Views/login.dart';

// class HomepageManager extends StatelessWidget {
//   const HomepageManager({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manager Home'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Perform logout operation
//               FirebaseAuth.instance.signOut();

//               // Navigate back to login view
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginView()),
//               );
//             },
//             child: Text(
//               'Logout',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate to the RegisterUserForm page
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CreateUser()),
//             );
//           },
//           child: Text('Register New User'),
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/CreateUser.dart';
import 'package:untitled/Views/AddItem.dart'; // Import the AddItem class

import '../firebase_options.dart';
import '../Views/login.dart';

class HomepageManager extends StatelessWidget {
  const HomepageManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Home'),
        actions: [
          TextButton(
            onPressed: () {
              // Perform logout operation
              FirebaseAuth.instance.signOut();

              // Navigate back to login view
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the RegisterUserForm page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateUser()),
                );
              },
              child: Text('Register New User'),
            ),
            SizedBox(height: 20), // Add some space between buttons
            ElevatedButton(
              onPressed: () {
                // Navigate to the AddItem page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductForm()),
                );
              },
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
