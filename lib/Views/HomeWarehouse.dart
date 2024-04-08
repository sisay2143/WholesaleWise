import 'package:flutter/material.dart';


class HomePageWarehouse extends StatefulWidget {
  const HomePageWarehouse({super.key});

  @override
  State<HomePageWarehouse> createState() => _HomePageWarehouseState();
}

class _HomePageWarehouseState extends State<HomePageWarehouse> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: Text('warehouse'),
      ),
    );
  }
}