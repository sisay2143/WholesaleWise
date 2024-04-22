import 'package:flutter/material.dart';
import 'package:untitled/Views/Warehouse-staff/AddItem.dart';
// import "package:inventory/AddItemScreen.dart";
// import 'package:inventory/BottomNavigationBar.dart';
// import 'package:inventory/HomeScreen.dart';
// import 'package:inventory/ItemsList.dart';
// import 'package:inventory/reporScreen.dart';
// import 'package:inventory/stockout.dart';
import 'stock-out.dart';

class ImageTextCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isTrue;

  const ImageTextCard({
    super.key,
    required this.imagePath,
    required this.text,
    this.isTrue = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .22,
      width: MediaQuery.of(context).size.width * .44,
      child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              if (text == "Add Items") {
                return AddProductForm();
              } else if (text == "Inventory Count") {
                return AddProductForm();
              } else if (text == "Inventory") {
                return AddProductForm();
              } else {
                return StockOutPage();
              }
            }));
          },
          child: Card(
            margin: const EdgeInsets.all(7),
            color:
                isTrue ? Colors.white : const Color.fromARGB(255, 3, 94, 147),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                side: isTrue
                    ? const BorderSide(
                        width: 4, color: Color.fromARGB(255, 3, 94, 147),)
                    : BorderSide.none),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  width: 150,
                  child: Image.asset(
                    imagePath,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isTrue
                              ? Color.fromARGB(255, 3, 94, 147)
                              : Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class DisplayCard extends StatelessWidget {
  const DisplayCard({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ImageTextCard(
                imagePath: 'lib/assets/images/box.png',
                text: 'Add Items',
                isTrue: false,
              ),
              ImageTextCard(
                imagePath: 'lib/assets/images/shopping-bag.png',
                text: 'Stock        Out',
                isTrue: true,
              )
            ],
          ),
          Row(
            children: [
              ImageTextCard(
                imagePath: 'lib/assets/images/report.png',
                text: 'Inventory Count',
                isTrue: true,
              ),
              ImageTextCard(
                imagePath: 'lib/assets/images/list.png',
                text: 'Inventory',
                isTrue: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
