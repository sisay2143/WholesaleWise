import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: Profile(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class ProfileData {
  String firstName;
  String lastName;
  String email;
  String imagePath; // New field for storing image path

  ProfileData({
    required this.firstName,
    required this.lastName,
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

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileData = ProfileData(
      firstName: '',
      lastName: '',
      email: '',
      imagePath: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Profile')),
        backgroundColor: Color.fromARGB(255, 6, 116, 219),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
            Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()), // Navigate to accounts screen
        );;
          },
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
      _buildProfileImage(), // Display profile image
      const SizedBox(height: 16.0),
      _buildInfoRow('First Name', _profileData.firstName),
      const SizedBox(height: 8.0),
      _buildInfoRow('Last Name', _profileData.lastName),
      const SizedBox(height: 16.0),
      Divider(
        height: 20,
        thickness: 2,
        color: Colors.grey[300],
      ),
      const SizedBox(height: 16.0),
      _buildInfoRow('Email', 'Email: ${_profileData.email}'),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () {
          setState(() {
            _isEditMode = true;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 6, 116, 219),
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        ),
        child: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ];
  }

  List<Widget> _buildEditState() {
    firstNameController.text = _profileData.firstName;
    lastNameController.text = _profileData.lastName;
    emailController.text = _profileData.email;

    return [
      _buildProfileImage(), // Display profile image
      const SizedBox(height: 16.0),
      _buildEditableRow('First Name', firstNameController),
      const SizedBox(height: 8.0),
      _buildEditableRow('Last Name', lastNameController),
      const SizedBox(height: 16.0),
      Divider(
        height: 20,
        thickness: 2,
        color: Colors.grey[300],
      ),
      const SizedBox(height: 16.0),
      _buildEditableRow('Email', emailController),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () {
          _saveChanges();
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 6, 116, 219),
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        ),
        child: Text(
          'Save Changes',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ];
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _isEditMode ? _pickImage : null, // Allow image picking only in edit mode
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70.0,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : (_profileData.imagePath.isNotEmpty
                    ? FileImage(File(_profileData.imagePath))
                    : null), // Load image from profile data
          ),
          if (_isEditMode &&
              (_image == null && _profileData.imagePath.isEmpty))
            Positioned.fill(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (_isEditMode &&
              (_image != null || _profileData.imagePath.isNotEmpty))
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(
              fontSize: 16.0, color: Colors.black), // Set text color to black
        ),
      ],
    );
  }

  Widget _buildEditableRow(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  void _saveChanges() async {
    setState(() {
      _profileData = ProfileData(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        imagePath: _image != null
            ? _image!.path
            : _profileData.imagePath, // Update image path
      );
      _isEditMode = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
}
