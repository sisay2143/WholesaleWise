import 'package:flutter/material.dart';

void main() {
  runApp(ProfileScreen());
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          
          title: Text('Professional Profile'),
        ),
        body: ProfileBody(),
      ),
    );
  }
}

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'John Doe',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Software Engineer',
            style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 16.0),
          Text(
            'Email: johndoe@example.com',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Phone: +1 123-456-7890',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'LinkedIn: John Doe',
            style: TextStyle(fontSize: 16.0, decoration: TextDecoration.underline, color: Colors.blue),
          ),
          Text(
            'GitHub: johndoe',
            style: TextStyle(fontSize: 16.0, decoration: TextDecoration.underline, color: Colors.blue),
          ),
          SizedBox(height: 16.0),
          Divider(),
          SizedBox(height: 16.0),
          Text(
            'Summary:',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Experienced software engineer with expertise in Flutter app development. Passionate about creating efficient, scalable, and visually appealing mobile applications.',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
