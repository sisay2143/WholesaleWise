import 'package:cloud_firestore/cloud_firestore.dart';

class SalesService {
  final CollectionReference salesRef =
      FirebaseFirestore.instance.collection('sales_transaction');

  Future<List<DocumentSnapshot>> fetchTopSellingProducts() async {
    try {
      QuerySnapshot querySnapshot = await salesRef.orderBy('quantity', descending: true).limit(3).get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching top selling products: $e');
      return [];
    }
  }
}


