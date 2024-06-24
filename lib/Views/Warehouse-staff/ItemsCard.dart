import "package:flutter/material.dart";
// import 'package:untitled/Views/ware/productDetail.dart';
// import 'package:untitled/EditScreen.dart';
// import 'package:untitled/productDetail.dart';
// import 'productDetail.dart';
import 'package:untitled/models/products.dart' as pmodel;
import 'productDetail.dart';

class ItmeCard extends StatelessWidget {
  // final String imagePath;
  // final String name;
  // final num price;
  // final num quntity;
  // final bool isTrue;
  // final String pid;
  final pmodel.Product currentProduct;

  const ItmeCard(this.currentProduct, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * .18,
        width: MediaQuery.of(context).size.width * .95,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(currentProduct),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(7),
              color:
                  true ? Colors.white : const Color.fromRGBO(107, 59, 225, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  side: true
                      ? const BorderSide(
                          width: 2, color: Color.fromRGBO(107, 59, 225, 1))
                      : BorderSide.none),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 250,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      child: Image.network(
                        currentProduct.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 10, right: 20),
                            child: Text(
                              currentProduct.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 8, right: 20),
                          child: Text(
                            "price:${currentProduct.price}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 8, right: 20),
                          child: Text(
                            "Quantity:${currentProduct.quantity}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
