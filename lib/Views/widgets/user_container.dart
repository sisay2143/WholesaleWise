import 'package:flutter/material.dart';

Widget buildUserContainer(
  BuildContext context,
  String name,
  String email,
  String phone,
  String profileImg,
  String role,
) {
  return Container(
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blue, width: 2),
    ),
    child: Row(
      children: [
        profileImg.isNotEmpty
            ? Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(profileImg),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue, // Use same background color as icon
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
              role,
              style: TextStyle(fontSize: 16),
            ),
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
