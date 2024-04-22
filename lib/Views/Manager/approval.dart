


import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(Approval());
}
// 
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
        body: ApprovalList(),
      ),
    );
  }
}

class ApprovalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('approval_requests')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final requests = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final productId = request['productId'];
            final quantity = request['quantity'];
            final name = request['name'];
            final price = 100000;       // Replace with dynamic data if available
            final imageUrl = 'lib/assets/images/shoe1.jpg'; // Replace with dynamic data if available

            return Card(
              elevation: 4,
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => detailscreen(request: request)),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 20, 20),
                        child: Image.asset(
                          imageUrl,
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
                              'Name: $name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Text('Price: $price'),
                            SizedBox(height: 10.0),
                            Text('Quantity: $quantity'),
                            SizedBox(height: 10.0),
                            SizedBox(height: 30.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          detailscreen(request: request,)),
                                );
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
              ),
            );
          },
        );
      },
    );
  }
}


