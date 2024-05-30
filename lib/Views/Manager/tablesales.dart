import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.only(top: 30),
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height * 1.6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableHeader(),
                SizedBox(height: 10),
                Divider(), // Horizontal line between header and rows
                SizedBox(height: 10),
                Expanded(
                  child: _buildTableRows(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildHeaderCell('Pname'),
        _buildHeaderCell('Price'),
        _buildHeaderCell('Quantity'),
        _buildHeaderCell('Category'),
        _buildHeaderCell('Customer'),
        _buildHeaderCell('Date'),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildTableRows() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('sales_transaction').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Placeholder while loading data
        }
        final documents = snapshot.data!.docs;
        return ListView.separated(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return _buildTableRow(documents[index]);
          },
          separatorBuilder: (context, index) {
            return Divider(); // Horizontal line between rows
          },
        );
      },
    );
  }

  Widget _buildTableRow(QueryDocumentSnapshot<Object?> document) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTableCell(document['productName']),
        _buildTableCell('${document['sellingPrice']}'),
        _buildTableCell('${document['quantity']}'),
        _buildTableCell('${document['category']}'),
        _buildTableCell('${document['customerName']}'),
        _buildTableCell(DateFormat('yyyy-MM-dd').format(document['timestamp'].toDate())),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      child: Text(text),
    );
  }
}