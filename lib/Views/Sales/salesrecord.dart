import 'package:flutter/material.dart';

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
                  return buildStatusOption(status);
                }).toList(),
              ),
            ),
          ),
          if (selectedStatus == 'Records') // Conditional rendering of transaction table
            // if (selectedStatus == 'records') // Conditional rendering of transaction table
  Expanded(
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
                    // flex: 3,
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
                  SizedBox(width: 8,),
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
            for (int i = 0; i < 5; i++)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        // flex: 4,
                        child: Text('car ${i + 1}'),
                      ),
                      Expanded(
                        child: Text('\$${100 + i * 20}'),
                      ),
                      Expanded(
                        child: Text(' ${i + 1}'),
                      ),
                      Expanded(
                        child: Text('2022-05-0${i + 1}'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Spacing between rows
                  Divider(), // Horizontal line between rows
                  SizedBox(height: 10), // Spacing between rows
                ],
              ),
          ],
        ),
      ),
    ),
  ),

          if (selectedStatus == 'Customers') // Conditional rendering of customer list
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Placeholder for 5 customers
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      leading: CircleAvatar(
                        // Placeholder for customer image
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person),
                      ),
                      title: Text('Name  ${index + 1}'), // Placeholder for customer name
                      subtitle: Text('Location'), // Placeholder for customer details
                      onTap: () {
                        // Handle customer tap
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildStatusOption(String status) {
    return Expanded(
      child: GestureDetector(
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
      ),
    );
  }
}
