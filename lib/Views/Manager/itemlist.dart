import 'dart:ui';
import 'package:flutter/material.dart';
import 'CreateUser.dart';
import '../login.dart';
import 'profilescreen.dart';
import 'HomeManager.dart';


// class ItemsList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomepageManager()), // Navigate to accounts screen
//         );;
//           },
//         ),
//         title: Center(child: Text('Items')),
//         actions: [
//   PopupMenuButton<String>(
  
    
//     onSelected: (String result) {
//       if (result == 'settings') {
        
//         // Navigate to settings page
//       } else if (result == 'logout') {
//         Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginView()),
//                 );
//         // Implement logout functionality
//       }
//     },
//     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//       PopupMenuItem<String>(
//         value: 'settings',
//         child: ListTile(
//           leading: Icon(Icons.settings),
//           title: Text('Settings'),
//         ),
//       ),
//       PopupMenuItem<String>(
//         value: 'logout',
//         child: ListTile(
//           leading: Icon(Icons.logout),
//           title: Text('Log Out'),
//         ),
//          height: 20,
//           // Adjust the height of the menu item
      
//       ),
     
//     ],
//   ),
// ],

//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
            
//             SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Text(
//                       'Users',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   _buildUserContainer(context, 'User 1', 'user1@example.com', '+1234567890'),
//                   SizedBox(height: 10),
//                   _buildUserContainer(context, 'User 2', 'user2@example.com', '+9876543210'),
//                   SizedBox(height: 10),
//                   _buildUserContainer(context, 'User 3', 'user3@example.com', '+1122334455'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUserContainer(BuildContext context, String name, String email, String phone) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.blue, width: 2),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.blue, // Blue background color
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               Icons.person,
//               size: 50,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(width: 20),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 email,
//                 style: TextStyle(fontSize: 16),
//               ),
//               Text(
//                 phone,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: ItemsList(),
//   ));
// }




import 'ItemsCard.dart';
// import 'package:go_router/go_router.dart';
import 'package:untitled/models/products.dart';
import 'package:untitled/Services/database.dart';
class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ItemsList(),
      ),
    );
  }
}

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  State<ItemsList> createState() => ItemsListState();
}

class ItemsListState extends State<ItemsList> {
  final FirestoreService _firestoreService = FirestoreService();

  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    print("fetching..");
    try {
      List<Product> products = await _firestoreService.getProducts();
      print("Fetched products: $products");
      setState(() {
        _products = products;
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  bool isLoading = false;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(107, 59, 225, 1),
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .20,
            ),
            const Text(
              "All Items",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // automaticallyImplyLeading: false, // Disable default back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  _products.isEmpty
                      ? const Center(
                          child: Text(" product is Empty"),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(
                            12,
                          ),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _products.length,
                              itemBuilder: (ctx, index) {
                                Product singleProduct = _products[index];
                                return ItmeCard(singleProduct);
                              }),
                        ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
    );
  }
}
