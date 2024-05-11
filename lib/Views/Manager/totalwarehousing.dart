import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'totalrevenue.dart';
import 'bargraphwarehousing.dart';

void main() {
  runApp(MaterialApp(
    home: Totalwarehousing(),
  ));
}

class Totalwarehousing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Total Warehousing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
Container(
  height: 170, // Adjust the height as needed
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    color: Color.fromARGB(255, 3, 94, 147),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
               
                ),
                
              ),
            ),
            
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Your Total Warehousing',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('products').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    double totalWarehousing = 0.0;
                    if (snapshot.hasData) {
                      snapshot.data?.docs.forEach((doc) {
                        final price = doc['price'] as num?;
                        final quantity = doc['quantity'] as num?;
                        if (price != null && quantity != null) {
                          totalWarehousing += price.toDouble() * quantity.toDouble();
                        }
                      });
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          '$totalWarehousing birr !',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
SizedBox(height: 20),



              Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Warehousing Overview'),
                  ),
                  Container(
                    height: 220,
                    child: buildBarChartCardss(), // Real bar chart
                  ),
                ],
              ),
            ),


              SizedBox(height: 20),
SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  margin: EdgeInsets.only(top: 30),
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 1.5, // Adjust width as needed
                    child: Column(
                      children: [
                        // Placeholder for transaction table columns
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  'Pname',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Bought',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(), // Horizontal line between header and rows
                        SizedBox(height: 10),
                        // Placeholder for transaction table rows
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('products').snapshots(),
                          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Placeholder while loading data
                            }
                            final documents = snapshot.data!.docs;
                            return Column(
                              children: [
                                for (int i = 0; i < documents.length; i++)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Text(documents[i]['name']),
                                          ),
                                          Expanded(
                                            child: Text('${documents[i]['price']}'),
                                          ),
                                          Expanded(
                                            child: Text('${documents[i]['quantity']}'),
                                          ),
                                          Expanded(
                                           child: Text('${(documents[i]['price'] as num) * (documents[i]['quantity'] as num)}'),

                                          ),
                                          Expanded(
                                            child: Text(documents[i]['timestamp'].toDate().toString()),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10), // Spacing between rows
                                      Divider(), // Horizontal line between rows
                                      SizedBox(height: 10), // Spacing between rows
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

    ],
      ),
    ),
      )
  );
  }
  }