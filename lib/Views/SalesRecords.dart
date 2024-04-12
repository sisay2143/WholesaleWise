import 'package:flutter/material.dart';

class SalesRecords extends StatefulWidget {
  const SalesRecords({super.key});

  @override
  State<SalesRecords> createState() => _SalesRecordsState();
}

class _SalesRecordsState extends State<SalesRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sales Record')),
    );
  }
}
