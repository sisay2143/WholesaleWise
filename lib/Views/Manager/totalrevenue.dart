import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bargraphrevenue.dart';
void main() {
  runApp(MaterialApp(
    home: totalrevenue(),
  ));
}

class totalrevenue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Total Revenue'),
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
                              boxShadow: [],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Text(
                                'Your total Revenue is',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sales_transaction')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  double totalRevenue = 0.0;
                  if (snapshot.hasData) {
                    snapshot.data?.docs.forEach((doc) {
                      final sellingPrice = double.tryParse((doc.data() as Map<String, dynamic>?)?['sellingPrice'] ?? '0');
                      final quantity = (doc.data() as Map<String, dynamic>?)?['quantity'];
                      if (sellingPrice != null && quantity is num) {
                        totalRevenue += (sellingPrice * quantity);
                      }
                    });
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '$totalRevenue\ birr !',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                    title: Text('Revenue Overview'),
                  ),
                  Container(
                    height: 220,
                    child: buildBarChartCards(), // Real bar chart
                  ),
                ],
              ),
            ),


              SizedBox(height: 20), // Add space between widgets
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
                                  'sold at',
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
                                  'Trevenue',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Date_sold',
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
                          stream: FirebaseFirestore.instance.collection('sales_transaction').snapshots(),
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
                                            child: Text(documents[i]['productName']),
                                          ),
                                          Expanded(
                                            child: Text('${documents[i]['sellingPrice']}'),
                                          ),
                                          Expanded(
                                            child: Text('${documents[i]['quantity']}'),
                                          ),
                                          Expanded(
                                            child: Text('${int.parse(documents[i]['sellingPrice'].toString()) * int.parse(documents[i]['quantity'].toString())}'),
                                          ),
                                        Expanded(
  child: Text(
    documents[i]['timestamp'].toDate().toString().split(' ')[0],
  ),
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
      ),
    );
  }
}
