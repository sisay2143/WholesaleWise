import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bargraphprofit.dart';
void main() {
  runApp(MaterialApp(
    home: totalprofit(),
  ));
}

class totalprofit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Total Profit'),
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
                  'Your total Profit is',
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
  builder: (context, productsSnapshot) {
    if (productsSnapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    Map<String, double> itemProfits = {};

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('sales_transaction').snapshots(),
      builder: (context, salesSnapshot) {
        if (salesSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (salesSnapshot.hasData && productsSnapshot.hasData) {
          final salesDocs = salesSnapshot.data!.docs;
          final productDocs = productsSnapshot.data!.docs;

          // Iterate through products to calculate profits
          for (var productDoc in productDocs) {
            final productName = (productDoc.data() as Map<String, dynamic>)['name'] as String?;
            final productPrice = (productDoc.data() as Map<String, dynamic>)['price'] as num?;
            if (productName != null && productPrice != null) {
              itemProfits[productName] = 0.0; // Initialize profit for each product
            }
          }

          // Iterate through sales transactions to calculate profits
          for (var saleDoc in salesDocs) {
            final productName = (saleDoc.data() as Map<String, dynamic>)['productName'] as String?;
            final sellingPrice = double.tryParse((saleDoc.data() as Map<String, dynamic>)['sellingPrice'] as String? ?? '') ?? 0.0;
            final saleQuantity = (saleDoc.data() as Map<String, dynamic>)['quantity'] as num?;
            if (productName != null && itemProfits.containsKey(productName) && saleQuantity != null) {
              final productPrice = (productsSnapshot.data!.docs.firstWhere((doc) => doc['name'] == productName)['price']) as num?;
              if (productPrice != null) {
                itemProfits[productName] = itemProfits[productName]! + ((sellingPrice - productPrice) * saleQuantity.toDouble());
              }
            }
          }
        }

        double totalProfit = 0.0;
        itemProfits.forEach((key, value) {
          totalProfit += value;
        });

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '$totalProfit\ birr !',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
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
                    title: Text('Profit Overview'),
                  ),
                  Container(
                    height: 220,
                    child: buildBarChartCardsss(), // Real bar chart
                  ),
                ],
              ),
            ),


             
SizedBox(height: 20),
 // Add space between widgets
              SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Card(
    margin: EdgeInsets.only(top: 30),
    elevation: 2,
    child: Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 1.9, // Adjust width as needed
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
                    'Purchased',
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
                    'Quan_sold',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Revenue',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                 Expanded(
                  child: Text(
                    'Profit',
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
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance.collection('products').where('name', isEqualTo: documents[i]['productName']).get(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Text('N/A');
                                  }
                                  return Text(snapshot.data!.docs[0]['price'].toString());
                                },
                              ),
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
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance.collection('products').where('name', isEqualTo: documents[i]['productName']).get(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Text('N/A');
                                  }
                                  // Calculate profit: (sold at - purchased) * quantity sold
                                  final purchased = double.parse(snapshot.data!.docs[0]['price'].toString());
                                  final soldAt = double.parse(documents[i]['sellingPrice'].toString());
                                  final quantitySold = int.parse(documents[i]['quantity'].toString());
                                  final profit = (soldAt - purchased) * quantitySold;
                                  return Text(profit.toString());
                                },
                              ),
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
