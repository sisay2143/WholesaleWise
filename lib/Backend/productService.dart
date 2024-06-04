import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/models/products.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProductToFirestore(BuildContext context, Product newProduct, String selectedCategory, File pickedImage) async {
    try {
      // Check if the product with the same PID already exists
      QuerySnapshot existingProducts = await _firestore.collection('products').where('pid', isEqualTo: newProduct.pid).get();
      if (existingProducts.docs.isNotEmpty) {
        // Product already exists, update the quantity and quantityAddedByDate
        final DocumentSnapshot productSnapshot = existingProducts.docs.first;
        int currentQuantity = 0;
        Map<String, dynamic>? quantityAddedByDate = {};
        final productData = productSnapshot.data() as Map<String, dynamic>?;

        if (productData != null && productData.containsKey('quantity')) {
          currentQuantity = productData['quantity'] as int;
        }

        if (productData != null && productData.containsKey('quantityAddedByDate')) {
          quantityAddedByDate = Map<String, dynamic>.from(productData['quantityAddedByDate']);
        }

        // Update quantity
        int newQuantity = currentQuantity + newProduct.quantity;
        await _firestore.collection('products').doc(productSnapshot.id).update({
          'quantity': newQuantity,
          // Optionally, update other fields if needed
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update quantityAddedByDate for the current date
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        quantityAddedByDate![currentDate] = newProduct.quantity; // Set quantity directly
        await _firestore.collection('products').doc(productSnapshot.id).update({
          'quantityAddedByDate': quantityAddedByDate,
        });



        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity updated for existing product')),
        );
      } else {
        // Product does not exist, add a new document
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final Reference storageReference = FirebaseStorage.instance.ref().child('product_images/$fileName.jpg');
        final UploadTask uploadTask = storageReference.putFile(pickedImage);

        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        final String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Add the new product to Firestore
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        await _firestore.collection('products').add({
          'name': newProduct.name,
          'pid': newProduct.pid,
          'quantity': newProduct.quantity, // Set quantity directly
          'price': newProduct.price,
          'category': selectedCategory,
          'expiredate': newProduct.expiredate,
          'imageUrl': imageUrl,
          'quantityAddedByDate': {currentDate: newProduct.quantity}, // Initialize quantityAddedByDate for the current date
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' product added to Firestore')),
        );
      }
    } catch (e) {
      print('Error adding product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    }
  }
}
