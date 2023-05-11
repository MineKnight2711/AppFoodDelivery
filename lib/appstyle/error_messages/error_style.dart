import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

existAccount() {
  Fluttertoast.showToast(
    msg: "Tài khoản đã tồn tại!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

notLoggin() {
  Fluttertoast.showToast(
    msg: "Bạn phải đăng nhập để đánh giá!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

cannotAddToCart() {
  Fluttertoast.showToast(
    msg: "Bạn phải đăng nhập để thêm vào giỏ hàng!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

dishNotFound() {
  Fluttertoast.showToast(
    msg: "Không tìm thấy sản phẩm!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

passWordError() {
  Fluttertoast.showToast(
    msg: "Vui lòng kiểm tra thông tin!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

cantRate() {
  Fluttertoast.showToast(
    msg: "Nhân viên không được đánh giá !",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

existRating() {
  Fluttertoast.showToast(
    msg: "Bạn đã đánh giá sản phẩm này rồi!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

nullInfor() {
  Fluttertoast.showToast(
    msg: "Bạn chưa chọn danh mục!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

nullName() {
  Fluttertoast.showToast(
    msg: "Bạn chưa nhập tên!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

nullBirthDay() {
  Fluttertoast.showToast(
    msg: "Chưa chọn ngày tháng năm sinh!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

nullDescription() {
  Fluttertoast.showToast(
    msg: "Bạn chưa nhập mô tả!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

nullPrice() {
  Fluttertoast.showToast(
    msg: "Bạn chưa nhập giá!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

nullCategory() {
  Fluttertoast.showToast(
    msg: "Bạn chưa chọn danh mục!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

noImage() {
  Fluttertoast.showToast(
    msg: "Bạn chưa chọn hình!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

descriptionTooLong() {
  Fluttertoast.showToast(
    msg: "Mô tả phải từ 3 - 40 ký tự!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

updateFail() {
  Fluttertoast.showToast(
    msg: "Cập nhật thất bại!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(255, 255, 0, 0),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

QuantityRange(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple],
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Số lượng phải từ 1-100',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
