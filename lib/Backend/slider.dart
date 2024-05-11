import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchStockData() async {
  // Reference to the Firestore collection
  CollectionReference stockDataRef =
      FirebaseFirestore.instance.collection('products');

  // Query the collection to get all documents
  QuerySnapshot querySnapshot = await stockDataRef.get();

  // Initialize a list to store the fetched data
  List<Map<String, dynamic>> stockDataList = [];

  // Iterate through the documents and extract the data
  querySnapshot.docs.forEach((DocumentSnapshot document) {
    // Extract the data from the document
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    
    // Print the data for debugging
    print(data);

    // Extract the date field and handle null value
    DateTime? date;
    if (data['date'] != null) {
      Timestamp timestamp = data['date'];
      date = timestamp.toDate();
    }

    // Add the data to the list
    stockDataList.add({...data, 'date': date});
  });

  // Return the list of stock data
  return stockDataList;
}
