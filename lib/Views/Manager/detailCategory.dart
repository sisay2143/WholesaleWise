import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class detaiCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Total Categories'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('sales_transaction').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!.docs;
            final categoryCounts = <String, int>{};

            for (final item in items) {
              final categoryName = item['category'] as String;
              categoryCounts[categoryName] =
                  (categoryCounts[categoryName] ?? 0) + 1;
            }

            return ListView.builder(
              itemCount: categoryCounts.length,
              itemBuilder: (context, index) {
                final category = categoryCounts.keys.elementAt(index);
                final count = categoryCounts[category];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: ListTile(
                      title: Text('$category - $count'),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}



class AllItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Total Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('sales_transaction').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var product = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.blueAccent), // Custom border color
                    ),
                    child: ListTile(
                      title: Text(product['productName']),
                      subtitle: Text('Quantity: ${product['quantity']}'),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
