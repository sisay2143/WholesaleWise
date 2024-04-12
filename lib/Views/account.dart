import 'dart:ui';
import 'package:flutter/material.dart';
import 'CreateUser.dart';
import 'login.dart';
import 'profilescreen.dart';
import 'HomeManager.dart';
class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomepageManager()), // Navigate to accounts screen
        );;
          },
        ),
        title: Center(child: Text('Accounts')),
        actions: [
  PopupMenuButton<String>(
  
    
    onSelected: (String result) {
      if (result == 'settings') {
        
        // Navigate to settings page
      } else if (result == 'logout') {
        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
        // Implement logout functionality
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'settings',
        child: ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ),
      PopupMenuItem<String>(
        value: 'logout',
        child: ListTile(
          leading: Icon(Icons.logout),
          title: Text('Log Out'),
        ),
         height: 20,
          // Adjust the height of the menu item
      
      ),
     
    ],
  ),
],

        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue, // Set the background color to blue
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 140,
                      height: 190,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 223, 211, 211), // Blue background color
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileEditPage()),
                );
                        
                        // Implement manage account functionality
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                        ),
                       primary: Color.fromARGB(255, 223, 211, 211),
 // Set the button color to blue
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15), // Adjust padding as needed
                        child: Text(
                        
                          'Manage My Account',
                          style: TextStyle(fontSize: 16,color:Colors.black ), // Adjust font size as needed
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateUser()), // Replace NextPage() with the page you want to navigate to
  );
},

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                        ),
                       primary: Color.fromARGB(255, 223, 211, 211),
 // Set the button color to blue
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Adjust padding as needed
                        child: Text(
                          'Add a User',
                          style: TextStyle(fontSize: 16,color:Colors.black), // Adjust font size as needed
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Users',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildUserContainer(context, 'User 1', 'user1@example.com', '+1234567890'),
                  SizedBox(height: 10),
                  _buildUserContainer(context, 'User 2', 'user2@example.com', '+9876543210'),
                  SizedBox(height: 10),
                  _buildUserContainer(context, 'User 3', 'user3@example.com', '+1122334455'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserContainer(BuildContext context, String name, String email, String phone) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue, // Blue background color
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                email,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                phone,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AccountPage(),
  ));
}
