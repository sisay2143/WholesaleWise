import 'dart:ui';
import 'package:flutter/material.dart';
// import 'CreateUser.dart';
import '../login.dart';
// import 'profilescreen.dart';
// import 'HomeManager.dart';


import 'ItemsCard.dart';
// import 'package:go_router/go_router.dart';
import 'package:untitled/models/products.dart';
import 'package:untitled/Services/database.dart';

class itemList extends StatefulWidget {
  const itemList({super.key});

  @override
  State<itemList> createState() => _itemListState();
}

class _itemListState extends State<itemList> {
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
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .20,
            ),
            const Text(
              "All Items",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        // automaticallyImplyLeading: false, // Disable default back button
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop(); // Navigate back
        //   },
        // ),
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
