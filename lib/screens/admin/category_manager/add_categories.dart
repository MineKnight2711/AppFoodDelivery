import 'dart:io';
import 'package:app_food_2023/appstyle/error_messages/error_style.dart';
import 'package:app_food_2023/screens/admin/category_manager/category_screen.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  File? _imageFile;
  String? _imageUrl = "";
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      print(_imageFile);
    }
  }

  Future<void> _uploadImage(String categoryID) async {
    if (_imageFile == null) {
      return;
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('categories/$categoryID.jpg');
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );

    setState(() {
      _uploading = true;
    });

    await ref.putFile(_imageFile!, metadata);
    final url = await ref.getDownloadURL();

    setState(() {
      _uploading = false;
      _imageUrl = url;
    });

    await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryID)
        .update({
      'imageURL': _imageUrl,
    });

    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CategoryListScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Thêm danh mục'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryListScreen(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 16.0),
            if (_imageFile != null)
              Center(
                child: Image.file(
                  _imageFile!,
                  height: 200.0,
                  width: 200,
                ),
              ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Tên danh mục',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Mô tả',
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  SizedBox(width: 20.0),
                  SizedBox(
                    height: 45,
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Wrap(children: [
                        Icon(
                          Icons.image_search,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 25.0,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Chọn ảnh',
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 46.0),
                  SizedBox(
                    height: 45,
                    width: 125,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_imageFile == null) {
                          noImage();
                          return;
                        }

                        if (_nameController.text == "") {
                          nullName();
                          return;
                        }
                        if (_descriptionController.text == "") {
                          nullDescription();
                          return;
                        }
                        setState(() {
                          _uploading = true;
                        });

                        final ref =
                            FirebaseFirestore.instance.collection('categories');
                        final doc = await ref.add({
                          'name': _nameController.text,
                          'description': _descriptionController.text,
                          'imageURL': "",
                        });

                        _uploadImage(doc.id);
                      },
                      child: Wrap(
                        children: [
                          Icon(
                            Icons.save,
                            color: Color.fromARGB(255, 11, 8, 243),
                            size: 27.0,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          _uploading
                              ? CircularProgressIndicator()
                              : Text(
                                  'Lưu',
                                  style: TextStyle(fontSize: 25),
                                ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 14, 215, 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
