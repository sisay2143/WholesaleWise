import 'package:flutter/material.dart';

class ApprovalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approval Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align messages to start
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'You have a confirmation message:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Message content goes here.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement approval logic here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you sure you want to approve?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Implement approval action here
                                // For example, send approval to backend
                                // Then close the dialog and show success message
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Confirmation approved successfully!'),
                                  ),
                                );
                              },
                              child: Text('Approve'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Approve'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement reject logic here
                    // For example, navigate back without approval
                    Navigator.of(context).pop();
                  },
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: ApprovalScreen(),
//   ));
// }
