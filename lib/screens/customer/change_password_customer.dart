import 'package:app_food_2023/appstyle/error_messages/error_style.dart';
import 'package:app_food_2023/appstyle/succes_messages/success_style.dart';
import 'package:app_food_2023/controller/user.dart';

import 'package:app_food_2023/screens/customer/setting_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/UserModel.dart';

class ChangePasswordCustomerScreen extends StatefulWidget {
  @override
  ChangePasswordCustomerScreenState createState() =>
      ChangePasswordCustomerScreenState();
}

class ChangePasswordCustomerScreenState
    extends State<ChangePasswordCustomerScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = new TextEditingController();
  TextEditingController oldPassController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  TextEditingController reenterPassController = new TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    getCurrentUser();
  }

  bool passwordVisible = false,
      validatePass = false,
      validatePassConfirm = false;
  String phoneNumber = '';
  String email = '', passInput = '', confirmPassInput = '';

  bool checkImage() {
    if (loggedInUser?.Avatar == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = loggedInUser?.Email.toString() ?? "";
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Thay đổi mật khẩu',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingProfileScreen(),
                ),
              );
            },
          ),
        ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Stack(fit: StackFit.loose, children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 140.0,
                                  height: 140.0,
                                  child: checkImage()
                                      ? CircularProgressIndicator()
                                      : CircleAvatar(
                                          radius: 100,
                                          backgroundImage: NetworkImage(
                                              loggedInUser!.Avatar.toString())),
                                ),
                              ],
                            ),
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
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 5.0),
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
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: "Nhập email",
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
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
                                        'Mật khẩu cũ',
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
                                    controller: oldPassController,
                                    obscureText: passwordVisible,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: "Nhập mật khẩu cũ",
                                      helperStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 24, 179, 0)),
                                      suffixIcon: IconButton(
                                        icon: Icon(passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(
                                            () {
                                              passwordVisible =
                                                  !passwordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
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
                                        'Mật khẩu mới',
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
                                    controller: passwordController,
                                    obscureText: passwordVisible,
                                    onChanged: (value) {
                                      setState(() {
                                        passInput = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: "Nhập mật khẩu mới",
                                      helperText: validatePassword(passInput),
                                      helperStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 24, 179, 0)),
                                      suffixIcon: IconButton(
                                        icon: Icon(passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(
                                            () {
                                              passwordVisible =
                                                  !passwordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
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
                                        'Xác nhận mật khẩu mới',
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
                                    controller: reenterPassController,
                                    obscureText: passwordVisible,
                                    onChanged: (value) {
                                      setState(() {
                                        confirmPassInput = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: "Nhập lại mật khẩu mới",
                                      helperText: checkMatchPassword(),
                                      helperStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 24, 179, 0)),
                                      suffixIcon: IconButton(
                                        icon: Icon(passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(
                                            () {
                                              passwordVisible =
                                                  !passwordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 45.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      child: ElevatedButton(
                                        child: Text("Lưu",
                                            style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                color: Colors.black)),
                                        onPressed: () async {
                                          if (!validatePass ||
                                              !validatePassConfirm) {
                                            passWordError();
                                            return;
                                          }
                                          if (await changePassword(
                                                  oldPassController.text,
                                                  passwordController.text) ==
                                              false) {
                                            resetPassword(emailController.text);
                                          } else {
                                            await changePassword(
                                                oldPassController.text,
                                                passwordController.text);
                                          }
                                          Navigator.pushAndRemoveUntil<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  SettingProfileScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Color.fromARGB(255, 14, 215, 24),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
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
                                        child: Text(
                                          "Thoát",
                                          style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  String? validatePassword(String passInput) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (passInput.isEmpty) {
      return 'Mật khẩu không được trống';
    } else {
      if (!regex.hasMatch(passInput)) {
        return 'Mật khẩu phải chứa 1 chữ hoa, 1 chữ thường,ký tự đặc biệt ,ký tự số và độ dài trên 8 ký tự';
      } else {
        validatePass = true;
        return "Mật khẩu hợp lệ";
      }
    }
  }

  String? checkMatchPassword() {
    if (passInput != confirmPassInput) {
      return "Mật khẩu không khớp";
    } else if (confirmPassInput == "")
      return "Vui lòng nhập lại mật khẩu";
    else {
      validatePassConfirm = true;
      return "Mật khẩu hợp lệ";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: emailController.text, password: oldPassword);

    Map<String, String?> codeResponses = {
      // Re-auth responses
      "user-mismatch": "1",
      "user-not-found": "2",
      "invalid-credential": "3",
      "invalid-email": "4",
      "wrong-password": "5",
      "invalid-verification-code": "6",
      "invalid-verification-id": "7",
      // Update password error codes
      "weak-password": "8",
      "requires-recent-login": "9"
    };

    try {
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword);
      updateSucceed();
      return true;
    } on FirebaseAuthException catch (error) {
      print(codeResponses[error.code] ?? "Unknown");
      return false;
    }
  }
  // Future<bool> changePassword(String newPassword) async {
  //   try {
  //     AuthCredential credential = EmailAuthProvider.credential(
  //         email: emailController.text, password: newPassword);
  //     await user?.reauthenticateWithCredential(credential);
  //     await user?.updatePassword(newPassword);
  //     print("Password changed successfully!");
  //     return true;
  //   } catch (e) {
  //     print("Failed to change password: $e");
  //     return false;
  //   }
  // }

  Future<void> resetPassword(String Email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: Email);
      print("Password changed successfully!");
    } catch (e) {
      print("Failed to change password: $e");
      return;
    }
  }
}
