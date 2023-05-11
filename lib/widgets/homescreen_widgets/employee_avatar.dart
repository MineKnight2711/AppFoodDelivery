import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/employee.dart';
import '../../controller/user.dart';
import '../../model/UserModel.dart';
import '../../screens/admin/admin_screen.dart';
import '../transitions_animations.dart';

Widget adminInfor(BuildContext context, UserModel userModel) {
  return Column(
    children: [
      Center(
        child: Text(
          "Xin chào: ${userModel.LastName} ${userModel.FirstName}",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ),
    ],
  );
}

Widget adminAvatar(BuildContext context) {
  return InkWell(
    onTap: () {
      Get.put(EmployeeController());
      slideinTransition(context, AdminScreen(), true);
    },
    child: userImage(),
  );
}

Widget shipperInfor(BuildContext context, UserModel userModel) {
  return Column(
    children: [
      Center(
        child: Text(
          "Xin chào: ${userModel.LastName} ${userModel.FirstName}",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ),
      Center(
        child: Text(
          "Chúc bạn 1 ngày làm việc tốt lành",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ),
    ],
  );
}
