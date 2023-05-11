import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

updateSucceed() {
  Fluttertoast.showToast(
    msg: "Cập nhật thành công!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 30, 255, 0),
    textColor: Color.fromARGB(255, 0, 0, 0),
    fontSize: 16.0,
  );
}

removeFromCartSucceed() {
  Fluttertoast.showToast(
    msg: "Đã xoá món!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 30, 255, 0),
    textColor: Color.fromARGB(255, 0, 0, 0),
    fontSize: 16.0,
  );
}

removeSucceed() {
  Fluttertoast.showToast(
    msg: "Xoá thành công!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 30, 255, 0),
    textColor: Color.fromARGB(255, 0, 0, 0),
    fontSize: 16.0,
  );
}
