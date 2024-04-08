import 'package:flutter/material.dart';

class HomepageSales extends StatefulWidget {
  const HomepageSales({super.key});

  @override
  State<HomepageSales> createState() => _HomepageSalesState();
}

class _HomepageSalesState extends State<HomepageSales> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: Text('Sales Personnel'),
      ),

    );
  }
}
