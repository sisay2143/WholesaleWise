import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import "package:untitled/models/products.dart";
import "package:untitled/Services/database.dart";
import 'package:firebase_storage/firebase_storage.dart';

class EditScreen extends StatefulWidget {
  final Product cuProduct;
  EditScreen(this.cuProduct, {super.key});
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _distributorController;
  late TextEditingController _categoryController;
  late TextEditingController _pidController;
  late TextEditingController _expiredateController;
  late File _pickedImage;
  final FirestoreService _firestoreService = FirestoreService();

  late ImagePicker _imagePicker;
  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.cuProduct.name);
    _quantityController =
        TextEditingController(text: widget.cuProduct.quantity.toString());
    _priceController =
        TextEditingController(text: widget.cuProduct.price.toString());
    // _distributorController =
        // TextEditingController(text: widget.cuProduct.distributor.toString());
    _categoryController =
        TextEditingController(text: widget.cuProduct.category.toString());
    _pidController =
        TextEditingController(text: widget.cuProduct.pid.toString());
    _expiredateController =
        TextEditingController(text: widget.cuProduct.expiredate.toString());

    _imagePicker = ImagePicker();
    _pickedImage = File(widget.cuProduct.imageUrl);
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

  @override
  void dispose() {
    
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _pidController.dispose();
    _categoryController.dispose();
    _expiredateController.dispose();
    // _distributorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(107, 59, 225, 1),
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.23,
            ),
            Text(
              "Edit Item",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
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
                          _pickedImage, // Use the File object here
                          fit: BoxFit.cover,
                        ),
                        
                        
                ),
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                controller: _nameController,
                cursorColor: Color.fromRGBO(107, 59, 225, 1),
                decoration: const InputDecoration(
                    labelText: "Name",
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
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
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
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
                decoration: const InputDecoration(
                    labelText: "Expire Date",
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(107, 59, 225, 1)))),
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
                decoration: const InputDecoration(
                    labelText: "Quantity",
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
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
                decoration: const InputDecoration(
                    labelText: "Price",
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
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
              // TextFormField(
              //   controller: _distributorController,
              //   decoration: const InputDecoration(
              //       labelText: "Distributer",
              //       labelStyle:
              //           TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //               color: Color.fromRGBO(107, 59, 225, 1)))),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a distributor';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                    labelText: "Category",
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(107, 59, 225, 1)))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> updatedProductData = {};
                    // {
                    //   'name': _nameController.text,
                    //   'quantity': int.parse(_quantityController.text),
                    //   'price': double.parse(_priceController.text),
                    //   'distributor': _distributorController.text,
                    //   'category': _categoryController.text,
                    //   'expiredate': _expiredateController.text,
                    //   'pid': _pidController.text,
                    // };
                    if (_nameController.text != widget.cuProduct.name) {
                      updatedProductData['name'] = _nameController.text;
                    }
                    if (_quantityController.text !=
                        widget.cuProduct.quantity.toString()) {
                      updatedProductData['quantity'] =
                          int.parse(_quantityController.text);
                    }
                    if (_priceController.text !=
                        widget.cuProduct.price.toString()) {
                      updatedProductData['price'] =
                          double.parse(_priceController.text);
                    }
                    // if (_distributorController.text !=
                    //     widget.cuProduct.distributor) {
                    //   updatedProductData['distributor'] =
                    //       _distributorController.text;
                    // }
                    if (_categoryController.text != widget.cuProduct.category) {
                      updatedProductData['category'] = _categoryController.text;
                    }
                    if (_expiredateController.text !=
                        widget.cuProduct.expiredate) {
                      updatedProductData['expiredate'] =
                          _expiredateController.text;
                    }
                    if (_pidController.text != widget.cuProduct.pid) {
                      updatedProductData['pid'] = _pidController.text;
                    }

                    // Upload the new image if selected
                    if (_pickedImage.path != widget.cuProduct.imageUrl) {
                      final String fileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      final Reference storageReference = FirebaseStorage
                          .instance
                          .ref()
                          .child('product_images/$fileName.jpg');
                      final UploadTask uploadTask =
                          storageReference.putFile(_pickedImage);

                      TaskSnapshot taskSnapshot = await uploadTask;
                      String imageUrl = await taskSnapshot.ref.getDownloadURL();
                      updatedProductData['imageUrl'] =
                          imageUrl; // Update the image URL
                    }

                    try {
                      // await _firestoreService.updateProduct(
                      //     widget.cuProduct.pid, updatedProductData);
                      // Product updatedProduct = Product(
                      //   name: _nameController.text,
                      //   quantity: int.parse(_quantityController.text),
                      //   price: double.parse(_priceController.text),
                      //   // distributor: _distributorController.text,
                      //   category: _categoryController.text,
                      //   imageUrl: _pickedImage.path,
                      //   expiredate: _expiredateController.text,
                      //   pid: _pidController.text,
                      //    timestamp: DateTime.now(), 
                      // );
                      await ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product updated successfully'),
                        ),
                      );
                      // Navigator.pop(context, updatedProduct);
                    } catch (error) {
                      print('Error updating product: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error updating product'),
                        ),
                      );
                    }

                    _nameController.clear();
                    _quantityController.clear();
                    _priceController.clear();
                    _distributorController.clear();
                    _categoryController.clear();
                    setState(() {
                      _pickedImage = File(''); // Clear the picked image
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(107, 59, 225, 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
