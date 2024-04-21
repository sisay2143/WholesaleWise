import 'package:flutter/material.dart';
import 'detail.dart';
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
        body: ListView.builder(
          itemCount: 3, // Set the number of cards you want
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                height: 220,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 20, 20),
                      child: Image.asset(
                        'lib/assets/images/shoe1.jpg',
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
                            'Name:  Phone',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0),
                          Text('Price: 100000'),
                          SizedBox(height: 10.0),
                          Text('Quantity: 10'),
                          SizedBox(height: 10.0),
                          SizedBox(height: 30.0),
                          ElevatedButton(
                            onPressed: () {
                             Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApp()),
                        ); // Add your functionality here
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
            );
          },
        ),
      ),
    );
  }
}
