import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(SalesRecords());
}

class SalesRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApprovalList(),
    );
  }
}

class ApprovalList extends StatefulWidget {
  @override
  State<ApprovalList> createState() => _ApprovalListState();
}

class _ApprovalListState extends State<ApprovalList> {
  String selectedStatus = 'Records'; // Initially no status selected
  List<String> statusOptions = ['Records', 'Customers']; // Dummy status options

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Records')),
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0), // Adjust top padding for spacing
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey),
                color: Colors.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: statusOptions.map((status) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStatus = status;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: selectedStatus == status ? Color.fromARGB(255, 3, 94, 147) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: TextStyle(
                            color: selectedStatus == status ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (selectedStatus == 'Records') // Conditional rendering of transaction table
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.only(top: 30),
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.all(20),
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
                                  'Price',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              SizedBox(width: 8),
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
            ),
          if (selectedStatus == 'Customers') // Conditional rendering of customer list
  Expanded(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('sales_transaction').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder while loading data
        }
        final documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final customerName = documents[index]['customerName']; // Assuming name is a field in your document
            final productName = documents[index]['productName'];
            final quantity = documents[index]['quantity'];
            return Card(
              margin: EdgeInsets.all(5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5), // Vertical spacing between texts
                    Text( 'Item purchased: $productName'
                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5), // Vertical spacing between texts
                    Text('Quantity purchased: $quantity'),
                  ],
                ),
                onTap: () {
                  setState(() {
                    selectedStatus = 'Customers';
                  });
                },
              ),
            );
          },
        );
      },
    ),
  ),
        ],
      ),
    );
  }
}
