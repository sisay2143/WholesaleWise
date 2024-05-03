// import 'package:flutter/material.dart';

// class ItmeCardss extends StatelessWidget {
//   // final String imageUrl;
//   final String name;
//   final double price;
//   final int quantity;

//   const ItmeCardss({
//     // required this.imageUrl,
//     required this.name,
//     required this.price,
//     required this.quantity,
//     required Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * .18,
//       width: MediaQuery.of(context).size.width * .95,
//       child: GestureDetector(
//         onTap: () {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder: (context) => ProductDetailPage(currentProduct),
//           //   ),
//           // );
//         },
//         child: Card(
//           margin: const EdgeInsets.all(7),
//           color: true ? Colors.white : const Color.fromRGBO(107, 59, 225, 1),
//           shape: RoundedRectangleBorder(
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//             side: true
//                 ? const BorderSide(
//                     width: 2, color: Color.fromRGBO(107, 59, 225, 1))
//                 : BorderSide.none,
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(
//                 height: 250,
//                 width: 200,
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     topLeft: Radius.circular(10),
//                   ),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, right: 20),
//                       child: Text(
//                         name,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 8, right: 20),
//                       child: Text(
//                         "Price: $price",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 8, right: 20),
//                       child: Text(
//                         "Quantity: $quantity",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProductList extends StatelessWidget {
//   final List<Map<String, dynamic>> products;
//   final Key? key;

//   ProductList(this.products, {this.key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: products.map((product) {
//         return ItmeCardss(
//           // imageUrl: product['imageUrl'],
//           name: product['name'],
//           price: product['price'],
//           quantity: product['quantity'],
//           key: ValueKey(product['name']), // Providing a key
//         );
//       }).toList(),
//     );
//   }
// }
