import 'dart:async';
import 'dart:io';
import 'package:app_food_2023/appstyle/error_messages/error_style.dart';
import 'package:app_food_2023/screens/admin/food_manager/food_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _numberController = new TextEditingController();

  File? _imageFile;
  Timer? _timer;
  String? _imageUrl = "";
  String? _selectedCategory = "", _selectedCategoryID = "";
  bool _uploading = false;
  int sl = 1;
  @override
  void initState() {
    super.initState();
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

  Future<void> _uploadImage(String dishID) async {
    if (_imageFile == null) {
      return;
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('foods/$dishID.jpg');
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
        .collection('dishes')
        .doc(dishID)
        .update({'Image': _imageUrl});

    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => FoodListScreen(),
      ),
      (route) => false,
    );
  }

  bool getSelectedCategory() {
    if (_selectedCategory == "")
      return false;
    else
      return true;
  }

  checkSl() {
    if (sl < 1 || sl > 100) {
      QuantityRange(context);
      if (sl < 1)
        setState(() {
          sl = 1;
        });
      if (sl > 100)
        setState(() {
          sl = 100;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    _numberController.text = sl.toString();
    return SingleChildScrollView(
      child: Container(
        height: 800,
        width: double.infinity,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Thêm món'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodListScreen(),
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
                Center(
                  child: SizedBox(
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
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Tên món ăn..',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: 'Giá..',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                  ],
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Mô tả..',
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Số lượng :",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 70.0),
                      ClipOval(
                        child: Material(
                          color: Color.fromARGB(255, 241, 7, 7),
                          // Button color
                          child: InkWell(
                            splashColor: Colors.white, // Splash color
                            onTap: () {
                              setState(() {
                                sl -= 1;
                              });
                              checkSl();
                            },
                            onTapDown: (TapDownDetails details) {
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 100), (t) {
                                setState(() {
                                  sl--;
                                });
                                checkSl();
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              _timer?.cancel();
                            },
                            onTapCancel: () {
                              _timer?.cancel();
                            },
                            child: SizedBox(
                                width: 35,
                                height: 35,
                                child: Icon(color: Colors.white, Icons.remove)),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.0),
                      SizedBox(
                        height: 50,
                        width: 50.0,
                        child: TextField(
                          controller: _numberController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              sl = int.parse(value);
                            });
                            checkSl();
                          },
                        ),
                      ),
                      SizedBox(width: 40.0),
                      ClipOval(
                        child: Material(
                          color: Color.fromARGB(255, 11, 122, 41),
                          // Button color
                          child: InkWell(
                            splashColor: Colors.white, // Splash color
                            onTap: () {
                              setState(() {
                                sl += 1;
                              });
                              checkSl();
                            },
                            onTapDown: (TapDownDetails details) {
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 100), (t) {
                                setState(() {
                                  sl++;
                                });
                                checkSl();
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              _timer?.cancel();
                            },
                            onTapCancel: () {
                              _timer?.cancel();
                            },
                            child: SizedBox(
                                width: 35,
                                height: 35,
                                child: Icon(color: Colors.white, Icons.add)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('categories')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return DropdownButton(
                          isExpanded: true,
                          hint: getSelectedCategory()
                              ? Text(
                                  '$_selectedCategory',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 6, 62, 9)),
                                )
                              : Text(
                                  'Chọn danh mục',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 6, 62, 9)),
                                ),
                          items: snapshot.data?.docs
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value.get('name'),
                                  child: Text('${value.get('name')}'),
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryID = value.id.toString();
                                    });
                                    print(_selectedCategoryID);
                                  },
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value.toString();
                            });
                            print(_selectedCategory);
                          },
                        );
                      }),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(width: 20.0),
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
                            if (_priceController.text == "") {
                              nullPrice();
                              return;
                            }
                            if (_selectedCategory == "" ||
                                _selectedCategoryID == "") {
                              nullCategory();
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
                                FirebaseFirestore.instance.collection('dishes');
                            final doc = await ref.add({
                              'DishName': _nameController.text,
                              'Description': _descriptionController.text,
                              'CategoryID': _selectedCategoryID,
                              'Price': double.parse(_priceController.text),
                              'InStock': sl,
                              'Image': "",
                            });

                            _uploadImage(doc.id);
                          },
                          child: Wrap(
                            children: [
                              Icon(
                                Icons.save,
                                color: Color.fromARGB(255, 74, 73, 129),
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
        ),
      ),
    );
  }
}
