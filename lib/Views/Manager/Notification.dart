import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:untitled/models/products.dart';
import 'package:untitled/Services/database.dart';
import 'package:intl/intl.dart';

class NotificationItem {
  final String title;
  final String details;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.details,
    this.isRead = false,
  });
}

class NotificationPage extends StatefulWidget {
   final List<NotificationItem> notifications;
  final Function(List<NotificationItem>) onBackButtonPressed;
  final Function(int) onNotificationUpdated; 
const NotificationPage({
    Key? key,
    required this.notifications,
    required this.onBackButtonPressed,
    required this.onNotificationUpdated,
  }) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<NotificationItem> notifications = [];
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

 Future<void> _fetchProducts() async {
  try {
    List<Product> products = await _firestoreService.getProducts();
    setState(() {
      _products = products;
      notifications = generateNotificationItems();
    });
  } catch (e) {
    print("Error fetching products: $e");
  }
}


  List<NotificationItem> generateNotificationItems() {
    List<NotificationItem> generatedItems = [];

    for (var product in _products) {
      if (product.quantity <= 500) {
        generatedItems.add(NotificationItem(
          title: 'Running Low on ${product.name}',
          details: 'Only ${product.quantity} left',
          isRead: false,
        ));
      }

      if (product.expiredate.isBefore(DateTime.now())) {
        final formattedDate = DateFormat.yMMMMd().format(product.expiredate);
        generatedItems.add(NotificationItem(
          title: 'Expired Product: ${product.name}',
          details: 'Expired on $formattedDate',
          isRead: false,
        ));
      }
    }

    return generatedItems;
  }

 void _markAsRead(int index) {
  setState(() {
    notifications[index].isRead = true;
    widget.onNotificationUpdated(
        notifications.where((item) => !item.isRead).length); // Corrected
    widget.onBackButtonPressed(notifications);
  });
}

void _clearNotification(int index) {
  setState(() {
    notifications.removeAt(index);
    widget.onNotificationUpdated(
        notifications.where((item) => !item.isRead).length); // Corrected
    widget.onBackButtonPressed(notifications);
  });
}



  int getUnreadCount() {
    return notifications.where((item) => !item.isRead).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.onBackButtonPressed(notifications);
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Padding(
                  padding: (index == 0)
                      ? const EdgeInsets.symmetric(vertical: 3.0)
                      : const EdgeInsets.only(bottom: 0.0),
                  child: Slidable(
                    key: Key('$item'),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Color(0xffb6B3BE1),
                          icon: Icons.cancel,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              notifications.removeAt(index);
                            });
                          },
                          backgroundColor: Color(0xffb6B3BE1),
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Color(0xffb6B3BE1),
                          icon: Icons.cancel,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              notifications.removeAt(index);
                            });
                          },
                          backgroundColor: Color(0xffb6B3BE1),
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .95,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(107, 59, 225, 1),
                          ),
                          color:
                              item.isRead ? Colors.grey.shade300 : Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              item.details,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            if (!item.isRead)
                              TextButton(
                                onPressed: () => _markAsRead(index),
                                child: const Text(
                                  'Mark as Read ',
                                  style: TextStyle(
                                      color: Color.fromRGBO(107, 59, 225, 1)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 3, 94, 147)),
                  ),
                  onPressed: () {
                    setState(() {
                      notifications.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
                // Text('Unread Count: ${getUnreadCount()}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
