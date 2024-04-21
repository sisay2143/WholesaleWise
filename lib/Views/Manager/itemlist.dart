import 'package:flutter/material.dart';
import 'ItemsCard.dart';
import 'package:untitled/models/products.dart';
import 'package:untitled/Services/database.dart';

<<<<<<< HEAD


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

=======
>>>>>>> 7397c3478fc1fed4dfa796408f1e0cbf46ef832b
class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  State<ItemsList> createState() => _itemListState();
}

class _itemListState extends State<ItemsList> {
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

    // Sort products by timestamp in descending order
    products.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    


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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Item List",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white),
            ),
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
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            _filteredProducts.isEmpty
                ? const Center(
                    child: Text("Product list is Empty"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(
                      12,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _filteredProducts.length,
                      itemBuilder: (ctx, index) {
                        Product singleProduct = _filteredProducts[index];
                        return ItmeCard(singleProduct);
                      },
                    ),
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
