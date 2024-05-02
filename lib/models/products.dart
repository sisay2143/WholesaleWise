class Product {
  final String name;
  final String pid;
  final int quantity;
  final double price;
  final String category;
  final String imageUrl;
  final DateTime expiredate; // Change the type to DateTime
  final DateTime timestamp; // Add timestamp field

  Product({
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.pid,
    required this.expiredate,
    required this.timestamp, // Add timestamp parameter
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      pid: map['pid'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      expiredate: map['expiredate'].toDate(),
      timestamp: map['timestamp'].toDate(),
      
    );
  }
}
