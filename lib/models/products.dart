import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late String name;
  late String pid;
  late int quantity;
  late double price;
  late String category;
  late DateTime? expiredate; // Make it nullable
  late String imageUrl;
  late DateTime timestamp;

  // Constructor
  Product({
    required this.name,
    required this.pid,
    required this.quantity,
    required this.price,
    required this.category,
    this.expiredate, // Make it nullable
    required this.imageUrl,
    required this.timestamp,
  });

  // Factory constructor to convert Firestore DocumentSnapshot to Product
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      name: data['name'] ?? '',
      pid: data['pid'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: data['price'] ?? 0.0,
      category: data['category'] ?? '',
      expiredate: data['expiredate'] != null
          ? (data['expiredate'] as Timestamp).toDate()
          : null, // Convert Timestamp to DateTime if not null
      imageUrl: data['imageUrl'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Method to convert Product to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pid': pid,
      'quantity': quantity,
      'price': price,
      'category': category,
      'expiredate': expiredate, // Keep it as DateTime
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
