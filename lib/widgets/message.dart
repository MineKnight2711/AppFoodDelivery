import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomErrorMessage {
  static void showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 255, 0, 0),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class CustomSuccessMessage {
  static void showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 0, 255, 55),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class CustomSnackBar {
  static void showCustomSnackBar(
      BuildContext context, String message, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        duration: Duration(seconds: duration),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
