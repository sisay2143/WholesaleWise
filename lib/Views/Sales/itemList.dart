import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProductDetail.dart';
import 'package:intl/intl.dart';

class itemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('list of items for sale'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products for sale')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final item = documents[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.fromLTRB(25, 15, 25, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                      color: Color.fromARGB(255, 3, 94, 147), width: 2.0),
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
                            image: NetworkImage(item['imageUrl']),
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
                              item['name'],
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Selling Price: ${item['selling price']}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Expire Date: ${DateFormat('MMMM dd, yyyy').format(item['expiredate'].toDate())}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
