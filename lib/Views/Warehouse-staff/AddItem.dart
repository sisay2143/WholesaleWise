import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/models/products.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  String? selectedCategory; // Declare selectedCategory here
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  // final _distributorController = TextEditingController();
  final _pidController = TextEditingController();
  final _expiredateController = TextEditingController();
  late File _pickedImage;
  late ImagePicker _imagePicker;
  late FirebaseFirestore _firestore;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _pickedImage = File('');
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }
Future<void> _addProductToFirestore(Product newProduct, String selectedCategory) async {
  try {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference = FirebaseStorage.instance.ref().child('product_images/$fileName.jpg');
    final UploadTask uploadTask = storageReference.putFile(_pickedImage);

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    final String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Add the new product to Firestore
    await _firestore.collection('products').add({
      'name': newProduct.name,
      'pid': newProduct.pid,
      'quantity': newProduct.quantity,
      'price': newProduct.price,
      'category': selectedCategory,
      'expiredate': newProduct.expiredate,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product added to Firestore')),
    );
  } catch (e) {
    print('Error adding product: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding product: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 94, 147),
        title: Text(
          "Add Items",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  alignment: Alignment.center,
                  height: 150.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(107, 59, 225, 1)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _pickedImage.path.isEmpty
                      ? Icon(Icons.camera_alt,
                          size: 60.0, color: Color.fromRGBO(107, 59, 225, 1))
                      : Image.file(
                          _pickedImage,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 30.0),
              SingleChildScrollView(
                  child: Column(children: [
                TextFormField(
                  controller: _nameController,
                  cursorColor: Color.fromRGBO(107, 59, 225, 1),
                  decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1)))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _pidController,
                  cursorColor: Color.fromRGBO(107, 59, 225, 1),
                  decoration: const InputDecoration(
                      labelText: "Product Id",
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1)))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product Id';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _expiredateController,
                  cursorColor: Color.fromRGBO(107, 59, 225, 1),
                  decoration: InputDecoration(
                    labelText: "Expire Date",
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 10),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _expiredateController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expire date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _quantityController,
                  cursorColor: const Color.fromRGBO(107, 59, 225, 1),
                  decoration: const InputDecoration(
                      labelText: "Quantity",
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1)))),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  cursorColor: const Color.fromRGBO(107, 59, 225, 1),
                  decoration: const InputDecoration(
                      labelText: "Price",
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1)))),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                SizedBox(height: 16.0),
                // Define _selectedCategory here

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: <String>[
                    'Electronics ',
                    'Food Products',
                    'Household and Cleaning Supplies',
                    'Home Deco',
                    // Add more categories as needed
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(107, 59, 225, 1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(107, 59, 225, 1)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
              ])),
              SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String expireDateText = _expiredateController.text;
                      DateTime expireDate =
                          DateFormat('yyyy-MM-dd').parse(expireDateText);
                      
                      Product newProduct = Product(
                        name: _nameController.text,
                        pid: _pidController.text,
                        quantity: int.parse(_quantityController.text),
                        price: double.parse(_priceController.text),
                        category: selectedCategory ?? 'Default Category',
                        expiredate: expireDate,
                        imageUrl: _pickedImage.path,
                        timestamp: DateTime.now(),
                      );

                      _addProductToFirestore(newProduct, selectedCategory ?? '');
                      _nameController.clear();
                      _pidController.clear();
                      _quantityController.clear();
                      _priceController.clear();
                      // _distributorController.clear();
                      // selectedCategory = null; // No need to set it to null
                      _expiredateController.clear();
                      setState(() {
                        _pickedImage = File('');
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product added successfully'),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 3, 94, 147),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Add',
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
