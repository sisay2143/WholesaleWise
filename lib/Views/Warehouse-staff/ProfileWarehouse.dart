// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/Views/login.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

// void main() {
//   runApp(MaterialApp(
//     home: Profile(),
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class ProfileData {
  String fullname;
  // String lastName;
  String email;
  String imagePath; // New field for storing image path

  ProfileData({
    required this.fullname,
    // required this.lastName,
    required this.email,
    required this.imagePath, // Initialize with empty string
  });
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  File? _image;
  late ProfileData _profileData;
  bool _isEditMode = false;

  TextEditingController fullnameController = TextEditingController();
  // TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _profileData = ProfileData(
      fullname: '',
      // lastName: '',
      email: '',
      imagePath: '',
    );
    _fetchUserData(); // Fetch user data when the profile page is initialized
    fullnameController.text =
        _profileData.fullname; // Set text controller value
  }

  // Function to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            _profileData.fullname =
                userDoc['name']; // Fetch 'name' field from Firestore
            _profileData.email =
                userDoc['email']; // Fetch 'email' field from Firestore
            _profileData.imagePath = userDoc['profileImg'];
            // You can fetch additional fields here and set them to _profileData
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Function to handle image selection from local file
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Set the selected image file
      });
    }
  }

  // Function to upload image to Firebase Storage and update Firestore
  Future<void> _uploadImage() async {
    try {
      // Get current user
      User? user = _auth.currentUser;

      // Upload image to Firebase Storage
      if (_image != null && user != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        await ref.putFile(_image!);

        // Get download URL for the uploaded image
        String downloadURL = await ref.getDownloadURL();

        // Update profile image URL in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'profileImg': downloadURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile image updated successfully!'),
          ),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        actions: [
          TextButton(
            onPressed: () {
              // Perform logout operation
              FirebaseAuth.instance.signOut();

              // Navigate back to login view
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _isEditMode ? _buildEditState() : _buildSavedState(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSavedState() {
    return [
      _buildProfileImage(), // Display profile image
      const SizedBox(height: 16.0),
      _buildInfoRow('Full Name', _profileData.fullname),
      const SizedBox(height: 8.0),
      // _buildInfoRow('Last Name', _profileData.lastName),
      // const SizedBox(height: 16.0),
      Divider(
          // height: 20,
          // thickness: 2,
          // color: Colors.grey[300],
          ),
      // const SizedBox(height: 16.0),
      _buildInfoRow('Email', ' ${_profileData.email}'),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () {
          setState(() {
            _isEditMode = true;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 3, 94, 147),
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        ),
        child: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ];
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () async {
        await _getImage(); // Call function to select image from local file
        if (_image != null) {
          await _uploadImage(); // Call function to upload and update image in Firestore
        }
      },
      child: CircleAvatar(
        radius: 80,
        backgroundColor: Colors.grey[200],
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? Icon(
                Icons.person,
                size: 80,
                color: Colors.grey[600],
              )
            : null,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  List<Widget> _buildEditState() {
    // Set the initial value of the fullnameController to the current fullname
    fullnameController.text = _profileData.fullname;

    return [
      _buildProfileImage(), // Display profile image
      const SizedBox(height: 16.0),
      TextFormField(
        controller: fullnameController,
        decoration: InputDecoration(labelText: 'Full Name'),
      ),
      const SizedBox(height: 8.0),
      // TextFormField(
      //   // controller: lastNameController,
      //   decoration: InputDecoration(labelText: 'Last Name'),
      // ),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () async {
          try {
            User? user = _auth.currentUser;
            if (user != null) {
              await _firestore.collection('users').doc(user.uid).update({
                'name': '${fullnameController.text} ${fullnameController.text}',
              });
              setState(() {
                _profileData.fullname = fullnameController.text;
                // _profileData.lastName = lastNameController.text;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile updated successfully!'),
                ),
              );
              setState(() {
                _isEditMode = false; // Exit edit mode
              });
            }
          } catch (e) {
            print('Error updating profile: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error updating profile'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 3, 94, 147),
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        ),
        child: Text(
          'Save Profile',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ];
  }
}
