import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(Approval());
}

class Approval extends StatelessWidget {
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
  String selectedStatus = ''; // Initially no status selected
  List<String> statusOptions = []; // List to hold status options fetched from Firestore

  @override
  void initState() {
    super.initState();
    // Fetch status options from Firestore
    fetchStatusOptions();
  }

  // Method to fetch status options from Firestore
  Future<void> fetchStatusOptions() async {
    final snapshot = await FirebaseFirestore.instance.collection('approval_requests').get();
    final List<String> fetchedStatusOptions = snapshot.docs.map((doc) => doc['status'] as String).toSet().toList();
    setState(() {
      statusOptions = fetchedStatusOptions;
      // Set default selected status to the first option if available
      selectedStatus = statusOptions.isNotEmpty ? statusOptions.first : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Approval')),
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
          Expanded(
            child: StreamBuilder(
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

                // Filter requests based on selected status
                final filteredRequests = requests.where((request) {
                  final status = request['status'] as String;
                  return status == selectedStatus;
                }).toList();

                return ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = filteredRequests[index];
                    final productId = request['productId'] as String;
                    final quantity = request['quantity'] as int;
                    final name = request['productName'] as String;
                    final price = 100000; // Replace with dynamic data if available
                    final imageUrl = 'lib/assets/images/shoe1.jpg'; // Replace with dynamic data if available

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detailscreen(request: request),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          height: 200,
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
                                width: 170,
                                height: 120,
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
                                            builder: (context) => detailscreen(request: request),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromARGB(255, 3, 94, 147),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusOption(String status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = status;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
          color: selectedStatus == status ? Color.fromARGB(255, 3, 94, 147) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: selectedStatus == status ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
