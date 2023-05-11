import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/UserModel.dart';

class EmployeeController extends GetxController {
  Rx<UserModel?> currentEmployee = Rx<UserModel?>(null);
  @override
  void onInit() {
    super.onInit();
    ever(currentEmployee, (_) => print(currentEmployee.value));
    fetchCurrentEmployee();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchCurrentEmployee() async {
    User? getUser = await FirebaseAuth.instance.currentUser;
    //Lấy tất cả dữ liệu của nhân viên
    // await FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
    //   getUser = currentUser;
    // });

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(getUser?.uid)
        .get();

    if (userSnapshot.exists) {
      UserModel employee = UserModel.fromMap(userSnapshot.data());
      currentEmployee.value = employee;
    } else {
      return;
    }
  }
}
