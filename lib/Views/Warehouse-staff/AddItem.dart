import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:untitled/models/products.dart';
import '../../Backend/productService.dart';

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  String? selectedCategory;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _pidController = TextEditingController();
  final _expiredateController = TextEditingController();
  late File _pickedImage;
  late ImagePicker _imagePicker;
  late ProductService _productService;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _pickedImage = File('');
    _productService = ProductService();
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
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      cursorColor: Color.fromRGBO(107, 59, 225, 1),
                      decoration: const InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(107, 59, 225, 1)),
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
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(107, 59, 225, 1)),
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
                            borderSide: BorderSide(
                                color: Color.fromRGBO(107, 59, 225, 1))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(107, 59, 225, 1))),
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
                                _expiredateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        try {
                          DateFormat('yyyy-MM-dd').parse(value);
                          return null;
                        } catch (e) {
                          return 'Invalid date format';
                        }
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _quantityController,
                      cursorColor: const Color.fromRGBO(107, 59, 225, 1),
                      decoration: const InputDecoration(
                          labelText: "Quantity",
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(107, 59, 225, 1)),
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
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(107, 59, 225, 1)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(107, 59, 225, 1))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(107, 59, 225, 1)))),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),

                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: <String>[
                        'Electronics ',
                        'Food Products',
                        'Cleaning Supplies',
                        'Home Decoration',
                        'Other',
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
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(107, 59, 225, 1)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    DateTime? expireDate;
                    if (_expiredateController.text.isNotEmpty) {
                      expireDate = DateFormat('yyyy-MM-dd')
                          .parse(_expiredateController.text);
                    }

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

                    try {
                      await _productService.addProductToFirestore(
                          context,
                          newProduct,
                          selectedCategory ?? '',
                          _pickedImage);

                      _nameController.clear();
                      _pidController.clear();
                      _quantityController.clear();
                      _priceController.clear();
                      _expiredateController.clear();
                      setState(() {
                        _pickedImage = File('');
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add product: $e'),
                        ),
                      );
                    }
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
