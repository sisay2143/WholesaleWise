import 'package:flutter/material.dart';
import 'CommitSale.dart';

void main() {
  runApp(detailss());
}

class detailss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Detail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('          Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
           Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommitSale()),
              );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity, // Adjust the width as needed
                height: 200, // Adjust the height as needed
                child: Card(
                  elevation: 4.0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 200, // Maximum height for the image
                    ),
                    child: SizedBox(
                      width: 150, // Adjust the width of the image as needed
                      height: 150, // Adjust the height of the image as needed
                      child: Padding(
                        padding: EdgeInsets.all(15.0), // Adjust the padding as needed
                        child: Image.asset(
                          'lib/assets/images/car.png', // Replace with the actual image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Car',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Quantity Available: 5',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Selling Price: \$10',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Quantity:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Quantity',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Sold By:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Sold By',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Customer Name:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Customer Name',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Action to perform on button press (e.g., commit sale)
                  print('Commit button pressed');
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 3, 94, 147),
                  ), // Set color here
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Commit',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
