import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StockService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getTotalStockInForDate(DateTime date) async {
    var dateString = DateFormat('yyyy-MM-dd').format(date); // Format the date as 'yyyy-MM-dd'
    
    var querySnapshot = await _firestore
        .collection('products')
        .where('quantityAddedByDate.$dateString', isGreaterThan: 0)
        .get();

    int totalStockIn = 0;
    querySnapshot.docs.forEach((doc) {
      var addedQuantity = doc['quantityAddedByDate'][dateString];
      totalStockIn += addedQuantity is int ? addedQuantity : 0;
    });

    return totalStockIn;
  }

  Future<int> getTotalStockOutForDate(DateTime date) async {
    var startOfDay = DateTime(date.year, date.month, date.day);
    var endOfDay = startOfDay.add(Duration(days: 1));

    var querySnapshot = await _firestore
        .collection('products for sale')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .get();

    int totalStockOut = 0;
    querySnapshot.docs.forEach((doc) {
      var quantity = doc['quantity'] as int?;
      totalStockOut += quantity ?? 0;
    });

    return totalStockOut;
  }

  Future<Map<String, int>> getStockDataForSlider() async {
    var currentDate = DateTime.now();
    var yesterday = currentDate.subtract(Duration(days: 1));

    var totalStockInToday = await getTotalStockInForDate(currentDate);
    var totalStockOutToday = await getTotalStockOutForDate(currentDate);

    var totalStockInYesterday = await getTotalStockInForDate(yesterday);
    var totalStockOutYesterday = await getTotalStockOutForDate(yesterday);

    return {
      'totalStockInToday': totalStockInToday,
      'totalStockOutToday': totalStockOutToday,
      'totalStockInYesterday': totalStockInYesterday,
      'totalStockOutYesterday': totalStockOutYesterday,
    };
  }
}
