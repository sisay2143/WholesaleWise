// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/Manager/ItemsCard.dart';
import 'package:untitled/Views/Warehouse-staff/Notification.dart';
import 'package:untitled/Views/login.dart';
import 'FCard.dart';
import 'Myslider.dart';
import 'package:camera/camera.dart';
import 'package:untitled/models/products.dart';
import 'package:untitled/Services/database.dart';

class HomePageWarehouse extends StatefulWidget {
  const HomePageWarehouse({super.key});

  @override
  State<HomePageWarehouse> createState() => _HomePageWarehouseState();
}

class _HomePageWarehouseState extends State<HomePageWarehouse> {

 final FirestoreService _firestoreService = FirestoreService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];

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
        _filteredProducts = List.from(products);
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchQuery = '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            color: Color.fromARGB(255, 3, 94, 147),
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Implement your notification logic here

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       // Perform logout operation
        //       FirebaseAuth.instance.signOut();

        //       // Navigate back to login view
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => LoginView()),
        //       );
        //     },
        //     child: Text(
        //       'Logout',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              child: Column(
                children: [
                  Stack(
                    children: [
                      MySlider(),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.white,
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: DataSearch(_filteredProducts),
                            );
                          },
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    // Implement the action to open the user's camera here
                    openCamera(context);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 238, 238, 238),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.qr_code),
                  ),
                ),
              ]),
            ),
            DisplayCard(),
          ],
        ),
      ),
    );
  }
}

Future<void> openCamera(BuildContext context) async {
  // Initialize the camera
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  // Initialize the camera controller
  final CameraController cameraController = CameraController(
    firstCamera,
    ResolutionPreset.medium,
  );

  // Initialize the camera controller
  await cameraController.initialize();

  // Show the camera preview in a dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: AspectRatio(
          aspectRatio: cameraController.value.aspectRatio,
          child: CameraPreview(cameraController),
        ),
      );
    },
  );
}


class DataSearch extends SearchDelegate<String> {
  final List<Product> products;

  DataSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // If the search query is empty, display an empty container
    if (query.isEmpty) {
      return Container();
    }

    final List<Product> matchedProducts = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // If there's a matched product, return ItemCard with its original appearance
    if (matchedProducts.isNotEmpty) {
      return ItmeCard(matchedProducts[
          0]); // Assuming you only want to display the first matched product
    } else {
      // If no matched product found, display a message
      return Center(
        child: Text("No results found"),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> suggestionList = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].name),
          onTap: () {
            query = suggestionList[index].name;
            showResults(context);
          },
        );
      },
    );
  }

  static of(BuildContext context) {}
}
