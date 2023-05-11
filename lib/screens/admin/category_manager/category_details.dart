import 'dart:io';
import 'dart:math';

import 'package:app_food_2023/appstyle/category_card_style.dart';
import 'package:app_food_2023/appstyle/error_messages/error_style.dart';
import 'package:app_food_2023/appstyle/succes_messages/success_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class CategoryDetailScreen extends StatefulWidget {
  CategoryDetailScreen(this.doc, {Key? key}) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
  QueryDocumentSnapshot doc;
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  int color_id = Random().nextInt(CategoryStyle.cardsColor.length);
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();

  String? imageUrl = "";

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    Reference ref =
        FirebaseStorage.instance.ref().child('categories/${widget.doc.id}');
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

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.doc["name"];
    _mainController.text = widget.doc["description"];

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                "Tên danh mục",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Tên món...",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.label),
              ),
              style: CategoryStyle.mainTitle,
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Mô tả",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _mainController,
              style: CategoryStyle.mainContent,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Mô tả...",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.label),
              ),
            ),
          ],
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
                        FirebaseFirestore.instance.collection("categories");
                    collection.doc(widget.doc.id).delete().then((value) {
                      Navigator.pop(context);
                    }).catchError((error) {
                      print("Thất bại vì lỗi $error");
                    });
                    FirebaseStorage.instance
                        .refFromURL(widget.doc['imageURL'])
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
                    if (_mainController.text.length < 3 ||
                        _mainController.text.length > 40) {
                      descriptionTooLong();
                      return;
                    }
                    if (imageUrl == "") {
                      imageUrl = widget.doc["imageURL"];
                    }
                    final collection =
                        FirebaseFirestore.instance.collection("categories");
                    collection.doc(widget.doc.id).update({
                      "name": _titleController.text,
                      "description": _mainController.text,
                      "imageURL": imageUrl,
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
        imageUrl: widget.doc["imageURL"],
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
