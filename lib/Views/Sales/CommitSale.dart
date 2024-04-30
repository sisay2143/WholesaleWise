import 'package:flutter/material.dart';
import 'ProductDetail.dart';

void main() {
  runApp(CommitSale());
}

class CommitSale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rectangular Box List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Item> items = [
    Item(
      name: 'Item 1',
      imageUrl: 'lib/assets/images/car.png',
      details: 'Details about item 1',
      quantityAvailable: 5,
      price: '\$10',
    ),
    Item(
      name: 'Item 2',
      imageUrl: 'lib/assets/images/laptop-screen.png',
      details: 'Details about item 2',
      quantityAvailable: 3,
      price: '\$15',
    ),
    Item(
      name: 'Item 3',
      imageUrl: 'lib/assets/images/shoe1.jpg',
      details: 'Details about item 3',
      quantityAvailable: 7,
      price: '\$20',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Commit Sale'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              // showSearch(
              //   context: context,
              //   // delegate: DataSearch(_filteredProducts),
              // );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
             Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailss()), // Replace ProductDetailScreen() with your details screen
    );
              print('Item ${index + 1} pressed');
            },
            child: Card(
              margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Color.fromARGB(255, 3, 94, 147), width: 2.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 140,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(items[index].imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            items[index].name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            items[index].details,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Quantity Available: ${items[index].quantityAvailable}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Price: ${items[index].price}',
                            style: TextStyle(fontSize: 16.0),
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
      ),
    );
  }
}

class Item {
  final String name;
  final String imageUrl;
  final String details;
  final int quantityAvailable;
  final String price;

  Item({
    required this.name,
    required this.imageUrl,
    required this.details,
    required this.quantityAvailable,
    required this.price,
  });
}
