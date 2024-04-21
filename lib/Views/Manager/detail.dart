import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rectangular Box with Image',
      home: Scaffold(
        appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
          title: Center(child: Text('Detail')),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: 200, // Width of the box
                height: 200, // Height of the box
                decoration: BoxDecoration(
                    // border: Border.all(color: Color.fromARGB(255, 4, 95, 159), width: 2), // Border of the box
                    ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      0), // Adjust border radius if needed
                  child: Image.asset(
                    'lib/assets/images/shoe1.jpg', // Replace 'image.jpg' with your image path
                    fit: BoxFit.cover, // Cover the entire box with the image
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Name:            phone',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Quantity:       10',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Price:       100',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    // Add more details as needed
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add decline button logic
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(120, 50), // Set button width and height
                    primary: Colors.red, // Set button color
                  ),
                  child: Text(
                    'Decline',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add approve button logic
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(120, 50), // Set button width and height
                    primary: Color.fromARGB(255, 3, 94, 147),// Set button color
                  ),
                  child: Text(
                    'Approve',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
