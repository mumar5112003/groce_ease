// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late TextEditingController nameController;
  late TextEditingController detailsController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController discountController;
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    detailsController = TextEditingController();
    priceController = TextEditingController();
    quantityController = TextEditingController();
    discountController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    priceController.dispose();
    quantityController.dispose();
    discountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus galleryStatus = await Permission.storage.request();

    if (cameraStatus.isGranted && galleryStatus.isGranted) {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _pickedImage = File(pickedImage.path);
        });
      }
    } else {
      // Handle permission denied or restricted
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_pickedImage != null) {
      try {
        showLoadingIndicator(context);
        final Reference ref = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child('${DateTime.now()}.jpg');
        final UploadTask uploadTask = ref.putFile(_pickedImage!);
        final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

        if (snapshot.state == TaskState.success) {
          final String imageUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            _uploadedImageUrl = imageUrl;
            hideLoadingIndicator(context);
          });
        } else {
          hideLoadingIndicator(context);
          // Handle unsuccessful upload
       
        }
      } catch (error) {
        // Handle error
        hideLoadingIndicator(context);
       
      }
    }
  }

  void _addProduct() async {
    final String imageUrl = _uploadedImageUrl ?? '';
    final String name = nameController.text;
    final double price = double.parse(priceController.text);
    final double discount = double.parse(discountController.text);
    final int quantity = int.parse(quantityController.text);
    final String details = detailsController.text;

    final Product product = Product(
      imageUrl: imageUrl,
      name: name,
      price: price,
      discount: discount,
      quantity: quantity,
      details: details,
    );

    try {
      showLoadingIndicator(context);

      await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap());

      // Clear the text fields and reset the picked image
      nameController.clear();
      detailsController.clear();
      priceController.clear();
      quantityController.clear();
      discountController.clear();

      setState(() {
        _pickedImage = null;
        _uploadedImageUrl = null;
        hideLoadingIndicator(context);
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Product added successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      hideLoadingIndicator(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Product'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_pickedImage != null)
                  Image.file(
                    _pickedImage!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Pick Image from Gallery'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Take Image with Camera'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.length < 3) {
                      return 'Name is too short';
                    }
                    return null; // Validation passed
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Should not be empty.';
                    }
                    return null; // Validation passed
                  },
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Should not be empty.';
                    } else if (int.parse(value) > 100000) {
                      return 'Price Not Valid';
                    }
                    return null; // Validation passed
                  },
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Should not be empty.';
                    } else if (int.parse(value) > 1000) {
                      return 'Quantity Not Valid';
                    }
                    return null; // Validation passed
                  },
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Should not be empty.';
                    } else if (int.parse(value) > 100) {
                      return 'Cannot be greater than 100.';
                    }
                    return null; // Validation passed
                  },
                  controller: discountController,
                  decoration: const InputDecoration(
                    labelText: 'Discount',
                  ),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Perform validation before adding the product
                    if (_formKey.currentState!.validate() &&
                        _pickedImage != null) {
                      _uploadImageToFirebase().then((_) {
                        _addProduct();
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('No immage selected!'),
                          content: const Text('Please select an image!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    ),
  );
}

void hideLoadingIndicator(BuildContext context) {
  Navigator.pop(context);
}
