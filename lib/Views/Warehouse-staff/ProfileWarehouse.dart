import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:untitled/Views/login.dart';

class ProfileData {
  String fullname;
  String email;
  String phone;
  String address;
  String imagePath;

  ProfileData({
    required this.fullname,
    required this.email,
    required this.phone,
    required this.address,
    required this.imagePath,
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
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _profileData = ProfileData(
      fullname: '',
      email: '',
      phone: '',
      address: '',
      imagePath: '',
    );
    _fetchUserData(); // Fetch user data when the profile page is initialized
  }

  Future<void> _fetchUserData() async {
  try {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;
        print('Fetched user data: $userData');
        setState(() {
          _profileData.fullname = userData['name'] ?? '';
          _profileData.email = userData['email'] ?? '';
          _profileData.phone = userData['phone'] ?? '';
          _profileData.address = userData['address'] ?? '';
          _profileData.imagePath = userData['profileImg']?.toString() ?? ''; // Cast to String or use default value if null
        });
        // Update text controllers with fetched data
        fullnameController.text = _profileData.fullname;
        emailController.text = _profileData.email;
        phoneController.text = _profileData.phone;
        addressController.text = _profileData.address;
      }
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}


  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      User? user = _auth.currentUser;

      if (_image != null && user != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        await ref.putFile(_image!);

        String downloadURL = await ref.getDownloadURL();

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
              FirebaseAuth.instance.signOut();
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
            children:
                _isEditMode ? _buildEditState() : _buildSavedState(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSavedState() {
    return [
      _buildProfileImage(),
      const SizedBox(height: 16.0),
      _buildInfoRow('Full Name', _profileData.fullname),
      const SizedBox(height: 8.0),
      _buildInfoRow('Email', _profileData.email),
      const SizedBox(height: 8.0),
      _buildInfoRow('Phone', _profileData.phone),
      const SizedBox(height: 8.0),
      _buildInfoRow('Address', _profileData.address),
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
      await _getImage();
      if (_image != null) {
        await _uploadImage();
      }
    },
    child: CircleAvatar(
      radius: 80,
      backgroundColor: Colors.grey[200],
      backgroundImage: _image != null ? FileImage(_image!) : _profileData.imagePath.isNotEmpty ? NetworkImage(_profileData.imagePath) as ImageProvider : null, // Cast NetworkImage to ImageProvider
      child: _image == null && _profileData.imagePath.isEmpty // Check if both _image and _profileData.imagePath are empty
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
  return [
    _buildProfileImage(),
    const SizedBox(height: 16.0),
    TextFormField(
      controller: fullnameController,
      decoration: InputDecoration(labelText: 'Full Name'),
    ),
    const SizedBox(height: 8.0),
    TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      maxLength: 10, // Maximum length of the phone number
      decoration: InputDecoration(labelText: 'Phone Number'),
    ),
    const SizedBox(height: 8.0),
    TextFormField(
      controller: addressController,
      decoration: InputDecoration(labelText: 'Address'),
    ),
    const SizedBox(height: 16.0),
    ElevatedButton(
      onPressed: _saveChanges,
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


  Future<void> _saveChanges() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': fullnameController.text,
          'phone': phoneController.text,
          'address': addressController.text,
        });
        setState(() {
          _profileData.fullname = fullnameController.text;
          _profileData.phone = phoneController.text;
          _profileData.address = addressController.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
          ),
        );
        setState(() {
          _isEditMode = false;
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
  }
}
