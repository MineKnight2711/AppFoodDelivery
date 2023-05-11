import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../model/UserModel.dart';
import '../home_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser;

  String? imageUrl = "";
  String? selectedGender = "";
  String? radioVal = "";
  DateTime? dateTime, currentBirthDay;

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    Reference ref =
        FirebaseStorage.instance.ref().child('userAvatar/user_${user!.uid}');
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
  void initState() {
    super.initState();
  }

  String phoneNumber = '';
  // String email = '';
  bool checkGender() {
    if (loggedInUser?.Gender == "Nam") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstNameController.text = loggedInUser?.FirstName.toString() ?? "";
    _lastNameController.text = loggedInUser?.LastName.toString() ?? "";
    _emailController.text = loggedInUser?.Email.toString() ?? "";
    phoneNumber =
        _phoneController.text = loggedInUser?.PhoneNumber?.toString() ?? "";
    _addressController.text = loggedInUser?.Address?.toString() ?? "";

    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: new Row(children: <Widget>[
            new Text('PROFILE',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'sans-serif-light',
                    color: Colors.black)),
          ])),
      body: new Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 180.0,
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(70)),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: showUserAvatar(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      pickUploadImage();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Color.fromARGB(255, 19, 123, 38),
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Thông tin tài khoản',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Ngày tháng năm sinh',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Center(
                            child: SizedBox(
                              width: 250,
                              height: 40,
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.calendar_today),
                                    Text(
                                      "${dateTime?.day ?? "Ngày"}/${dateTime?.month ?? "Tháng"}/${dateTime?.year ?? "Năm"}",
                                      style: TextStyle(
                                        color: Colors.yellow[400],
                                        fontSize: 23.0,
                                      ),
                                    )
                                  ],
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  final date = await pickDate();
                                  if (date == null) return;
                                  setState(() {
                                    dateTime = date;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Họ và tên lót',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: _lastNameController,
                                    decoration: const InputDecoration(
                                      hintText: "Nhập họ và tên lót",
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Tên',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                      hintText: "Nhập tên",
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Giới tính',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(children: <Widget>[
                                      Container(
                                        width: 130,
                                        child: Transform.scale(
                                          scale: 1.4,
                                          child: RadioListTile<String>(
                                            value: checkGender() ? "" : "Nam",
                                            groupValue: radioVal,
                                            title: Text(
                                              "Nam",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onChanged: (value) => setState(() {
                                              selectedGender = "Nam";
                                              radioVal = value;
                                            }),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 80),
                                      Container(
                                          width: 130,
                                          child: Transform.scale(
                                            scale: 1.4,
                                            child: RadioListTile<String>(
                                              value: checkGender() ? "Nữ" : "",
                                              groupValue: radioVal,
                                              title: Text(
                                                "Nữ",
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onChanged: (value) =>
                                                  setState(() {
                                                selectedGender = "Nữ";
                                                radioVal = value;
                                              }),
                                            ),
                                          )),
                                    ])
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: "Nhập Email",
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                  keyboardType: TextInputType.emailAddress,
                                  // onChanged: (value) {
                                  //   email = value;
                                  // },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Số điện thoại',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    hintText: "Nhập số điện thoại",
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.]')),
                                  ],
                                  onChanged: (value) {
                                    phoneNumber = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Địa chỉ',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: _addressController,
                                    decoration: const InputDecoration(
                                        hintText: "Nhập địa chỉ"),
                                    enabled: !_status,
                                    autofocus: !_status,
                                  ),
                                ),
                              ],
                            )),
                        !_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        selectedItemColor: Colors.amber[800],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b$');
    return regex.hasMatch(phoneNumber);
  }

  // bool isValidEmail(String email) {
  //   final RegExp regex =
  //       RegExp(r'^[a-z][a-z0-9_\.]{5,32}@[a-z0-9]{2,}(\.[a-z0-9]{2,4}){1,2}$');
  //   return regex.hasMatch(email);
  // }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                child: ElevatedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    if (!isValidPhoneNumber(phoneNumber)) {
                      Fluttertoast.showToast(
                        msg:
                            "Số điện thoại không hợp lệ. Vui lòng kiểm tra lại",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 238, 65, 13),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                    // else if (!isValidEmail(email)) {
                    //   Fluttertoast.showToast(
                    //     msg: "Email không hợp lệ. Vui lòng kiểm tra lại",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.BOTTOM,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Color.fromARGB(255, 238, 65, 13),
                    //     textColor: Colors.white,
                    //     fontSize: 16.0,
                    //   );
                    // }
                    else {
                      if (imageUrl == "") {
                        imageUrl = loggedInUser?.Avatar.toString();
                      }
                      if (loggedInUser != null) {
                        loggedInUser = null;
                      }
                      final collection =
                          FirebaseFirestore.instance.collection("users");
                      collection.doc(user?.uid).update({
                        "firstName": _firstNameController.text,
                        "secondName": _lastNameController.text,
                        "email": _emailController.text,
                        "PhoneNumber": _phoneController.text,
                        "Address": _addressController.text,
                        "Images": imageUrl,
                        "Gender": selectedGender,
                        "birthDay": dateTime,
                      }).then((value) {
                        phoneNumber = "";

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppHomeScreen()));

                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(user?.uid)
                            .get()
                            .then((value) {
                          this.loggedInUser = UserModel.fromMap(value.data());
                          setState(() {});
                        });
                      }).catchError((error) {
                        print("Thất bại vì lỗi $error");
                      });
                    }

                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 14, 215, 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: ElevatedButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  showUserAvatar() {
    if (imageUrl == "") {
      if (loggedInUser?.Avatar.toString() == "" ||
          loggedInUser?.Avatar.toString() == "images/userAvatar/user.png" ||
          loggedInUser?.Avatar == null) {
        return CircleAvatar(
          radius: 140.0,
          backgroundImage: AssetImage("assets/images/profile.png"),
          backgroundColor: Colors.transparent,
        );
      } else {
        return CircleAvatar(
          radius: 140.0,
          backgroundImage: NetworkImage(loggedInUser?.Avatar.toString() ??
              "" "assets/images/profile.png"),
          backgroundColor: Colors.transparent,
        );
      }
    } else {
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
    }
  }

  showUserBirthDay() {
    if (loggedInUser?.BirthDay != "null" || loggedInUser?.BirthDay != null) {
      currentBirthDay = loggedInUser?.BirthDay;
      String? day = dateTime?.day.toString() ?? "Ngày";
      String? month = dateTime?.month.toString() ?? "Tháng";
      String? year = dateTime?.year.toString() ?? "Năm";
      return "$day/$month/$year";
    } else {
      currentBirthDay = DateTime.now();
      String? day = dateTime?.day.toString() ?? "Ngày";
      String? month = dateTime?.month.toString() ?? "Tháng";
      String? year = dateTime?.year.toString() ?? "Năm";
      return "$day/$month/$year";
    }
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
}
