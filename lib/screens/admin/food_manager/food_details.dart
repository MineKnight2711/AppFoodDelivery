import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app_food_2023/appstyle/category_card_style.dart';
import 'package:app_food_2023/appstyle/error_messages/error_style.dart';
import 'package:app_food_2023/appstyle/food_card_style.dart';
import 'package:app_food_2023/appstyle/succes_messages/success_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class FoodDetailScreen extends StatefulWidget {
  FoodDetailScreen(this.doc, {Key? key}) : super(key: key);

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
  QueryDocumentSnapshot doc;
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int color_id = Random().nextInt(CategoryStyle.cardsColor.length);
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _numberController = new TextEditingController();

  Timer? _timer;
  int sl = 1;
  String? imageUrl = "", _selectedCategory = "", _selectedCategoryID = "";

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    Reference ref =
        FirebaseStorage.instance.ref().child('foods/${widget.doc.id}');
    if (image != null) {
      await ref.putFile(File(image.path));
      ref.getDownloadURL().then((value) {
        print(value);
        setState(() {
          imageUrl = value;
        });
      });
    } else {
      return;
    }
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
      setState(() {
        sl = 1;
      });
    }
  }

  getCategoryName() async {
    final documentReference = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.doc["CategoryID"]);
    String categoryName = "";
    await documentReference.get().then((snapshot) {
      categoryName = snapshot.data()!['name'].toString();
    });
    setState(() {
      _selectedCategory = categoryName;
    });
  }

  void initState() {
    super.initState();
    getCategoryName();
    sl = widget.doc["InStock"];
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.doc["DishName"];
    _priceController.text = widget.doc["Price"].toStringAsFixed(0);
    _descriptionController.text = widget.doc["Description"];
    _numberController.text = sl.toString();
    return Scaffold(
      backgroundColor: CategoryStyle.cardsColor[color_id],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Chi tiết danh mục",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: CategoryStyle.cardsColor[color_id],
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 4.0,
              ),
              Stack(fit: StackFit.loose, children: [
                Center(child: showCategoryImage()),
                Padding(
                  padding: EdgeInsets.only(top: 100, right: 120.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          pickUploadImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 19, 123, 38),
                          radius: 25.0,
                          child: new Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox(height: 40),
              Center(
                child: Text(
                  "Tên món",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Tên món...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.label),
                ),
                style: Foodtyle.name,
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Giá",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _priceController,
                style: Foodtyle.price,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Nhập giá...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              Center(
                child: Text(
                  "Mô tả",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _descriptionController,
                style: Foodtyle.descripts,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Nhập mô tả...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.label),
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
                      style: Foodtyle.instock,
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
                            _timer = Timer.periodic(Duration(milliseconds: 100),
                                (t) {
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
                            _timer = Timer.periodic(Duration(milliseconds: 100),
                                (t) {
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
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                  heroTag: "btnDelete",
                  label: Text('Xoá'),
                  backgroundColor: CategoryStyle.accentColor,
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final collection =
                        FirebaseFirestore.instance.collection("dishes");
                    collection.doc(widget.doc.id).delete().then((value) {
                      Navigator.pop(context);
                    }).catchError((error) {
                      print("Thất bại vì lỗi $error");
                    });
                    FirebaseStorage.instance
                        .refFromURL(widget.doc['Image'])
                        .delete();
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                  heroTag: "btnUpdate",
                  label: Text('Sửa'),
                  backgroundColor: CategoryStyle.accentColor,
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    if (imageUrl == "") {
                      imageUrl = widget.doc["Image"];
                    }
                    if (_selectedCategoryID == "") {
                      _selectedCategoryID = widget.doc["CategoryID"];
                    }

                    final collection =
                        FirebaseFirestore.instance.collection("dishes");
                    collection.doc(widget.doc.id).update({
                      "Name": _nameController.text,
                      "Price": double.parse(_priceController.text),
                      "InStock": sl,
                      "CategoryID": _selectedCategoryID,
                      "Description": _descriptionController.text,
                      "Image": imageUrl,
                    }).then((value) {
                      updateSucceed();
                      Navigator.pop(context);
                    }).catchError((error) {
                      print("Thất bại vì lỗi $error");
                      updateFail();
                    });
                  }),
            ),
          )
        ],
      ),
    );
  }

  showCategoryImage() {
    if (imageUrl != "") {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: widget.doc["Image"],
        imageBuilder: (context, imageProvider) => Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }
}
