import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/models/products.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateProductQuantity(
      String productId, int newQuantity) async {
    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('products')
          .doc(productId)
          .update({'quantity': newQuantity});
    } catch (error) {
      print('Error updating product quantity: $error');
      throw error;
    }
  }

  Future<Product?> getProductByPidOrName(String pidOrName) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('products')
          .where('pid', isEqualTo: pidOrName)
          .get();

      // If no documents found by PID, attempt to fetch by name
      if (querySnapshot.docs.isEmpty) {
        final querySnapshotByName = await _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('products')
            .where('name', isEqualTo: pidOrName)
            .get();

        if (querySnapshotByName.docs.isNotEmpty) {
          final documentSnapshot = querySnapshotByName.docs[0];
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          return Product(
            pid: data['pid'] as String,
            name: data['name'] as String,
            quantity: data['quantity'] as int,
            price: data['price'] as double,
            // distributor: data['distributor'] as String,
            category: data['category'] as String,
            imageUrl: data['imageUrl'] as String,
            expiredate: data['expiredate'] as String,
            timestamp: DateTime.now(),
          );
        }
      } else {
        final documentSnapshot = querySnapshot.docs[0];
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return Product(
          pid: data['pid'] as String,
          name: data['name'] as String,
          quantity: data['quantity'] as int,
          price: data['price'] as double,
          // distributor: data['distributor'] as String,
          category: data['category'] as String,
          imageUrl: data['imageUrl'] as String,
          expiredate: data['expiredate'] as String,
          timestamp: DateTime.now(),
        );
      }

      // If no documents found by PID or name, return null
      return null;
    } catch (e) {
      print("Error fetching product: $e");
      throw Exception("Error fetching product: $e");
    }
  }
  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('products')
          .get();
      List<Product> products = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product(
          name: data['name'],
          quantity: data['quantity'],
          price: data['price'],
          // distributor: data['distributor'],
          category: data['category'],
          imageUrl: data['imageUrl'],
          pid: data['pid'],
          timestamp: DateTime.now(),
          expiredate: data['expiredate'],
        );
      }).toList();
      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }


  Future<void> registerTransaction(
      String productId, int quantitySold) async {
    final transactionsRef = _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('transactions');

    await transactionsRef.add({
      'productId': productId,
      'quantitySold': quantitySold,
      'saleDate': FieldValue.serverTimestamp(),
    });

    // Update product status or other necessary actions
  }
}
