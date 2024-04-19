class Product {
  final String name;
  final String pid;
  final int quantity;
  final double price;
  // final String distributor;
  final String category;
  // final String category;
  final String imageUrl;
  final String expiredate;

  Product({
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.pid,
    required this.expiredate,
  });
}
