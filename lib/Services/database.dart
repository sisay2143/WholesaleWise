import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/models/products.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

//  Future<void> updateProductQuantity(
//   String productId, int newQuantity) async {
//   try {
//     await _firestore
//         .collection('users')
//         .doc(user!.uid)
//         .collection('products')
//         .doc('productId')
//         .update({'quantity': newQuantity}); // Correct field name is 'quantity'
//     print('DONE updating product quantity:');

//   } catch (error) {
//     print('Error updating product quantity: $error');
//     throw error;
//   }
// }

// Future<void> updateProductQuantity(String productId, int newQuantity) async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           // .collection('users')
//           // .doc(user!.uid)
//           .collection('products')
//           .where('productId', isEqualTo: productId)
//           .get();
//       if (querySnapshot.docs.isNotEmpty) {
//         await querySnapshot.docs.first.reference..update({'quantity': newQuantity});
//       }
//     } catch (error) {
//       print("not update");
//       throw error;
//     }
//   }

  Future<void> updateProduct(String pid, Map<String, dynamic> data) async {
  try {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(pid)
        .update(data);
    print('Product updated successfully.');
  } catch (error) {
    print('Error updating product: $error');
    throw error;
  }
}



Future<void> deleteProduct(String pid) async {
    try {
      final productsCollection =
          _firestore.collection('products');
      final snapshot =
          await productsCollection.where('pid', isEqualTo: pid).get();

      if (snapshot.docs.isNotEmpty) {
        final productDoc = snapshot.docs.first;
        await productDoc.reference.delete();
        print("Product deleted successfully");
      } else {
        print("Product not found");
      }
    } catch (e) {
      print("Error deleting product: $e");
      throw Exception("Error deleting product");
    }
  }

  Future<Product?> getProductByPidOrName(String pidOrName) async {
    try {
      final querySnapshot = await _firestore
          // .collection('users')
          // .doc(user!.uid)
          .collection('products')
          .where('pid', isEqualTo: pidOrName)
          .get();

      // If no documents found by PID, attempt to fetch by name
      if (querySnapshot.docs.isEmpty) {
        final querySnapshotByName = await _firestore
            // .collection('users')
            // .doc(user!.uid)
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
            expiredate: DateTime.now(),
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
          expiredate: DateTime.now(),
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
        // .collection('users')
        // .doc(user!.uid)
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
        // Convert 'expiredate' to DateTime
        expiredate: (data['expiredate'] is Timestamp)
            ? (data['expiredate'] as Timestamp).toDate()
            : DateTime.parse(data['expiredate']),
        timestamp: data['timestamp'].toDate(),
      );
    }).toList();
    return products;
  } catch (e) {
    print('Error fetching products: $e');
    return [];
  }
}
 Future<List<Product>> getProductsforSale() async {
  try {
    QuerySnapshot snapshot = await _firestore
        // .collection('users')
        // .doc(user!.uid)
        .collection('products for sale')
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
        // Convert 'expiredate' to DateTime
        expiredate: (data['expiredate'] is Timestamp)
            ? (data['expiredate'] as Timestamp).toDate()
            : DateTime.parse(data['expiredate']),
        timestamp: data['timestamp'].toDate(),
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
        // .collection('users')
        // .doc(user!.uid)
        .collection('transactions');

    await transactionsRef.add({
      'productId': productId,
      'quantitySold': quantitySold,
      'saleDate': FieldValue.serverTimestamp(),
    });

    // Update product status or other necessary actions
  }
}
