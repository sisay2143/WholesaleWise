class Product {
  final String name;
  final String pid;
  final int quantity;
  final double price;
  final String category;
  final String imageUrl;
  final String expiredate;
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
}
