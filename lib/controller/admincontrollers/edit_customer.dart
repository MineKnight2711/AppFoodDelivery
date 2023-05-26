import 'dart:io';

import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/message.dart';

class EditCustomerController extends GetxController {
  Rx<UserModel?> currentCustomer = Rx<UserModel?>(null);
  Rx<File?> new_image = Rx<File?>(null);
  Rx<String?> new_gender = Rx<String?>(null);
  Rx<DateTime?> birthDay = Rx<DateTime?>(null);
  @override
  void onInit() {
    super.onInit();
    fetchCurrentCustomer();
  }

  @override
  void onClose() {
    super.onClose();
    currentCustomer.value = null;
  }

  @override
  void dispose() {
    super.dispose();
    currentCustomer.value = null;
  }

  Future<void> clearData() async {
    currentCustomer.value = null;
    new_image.value = null;
    new_gender.value = null;
    newpassword.value = oldpassword.value = reenterpasswrod.value = null;
  }

  Future<void> fetchCurrentCustomer() async {
    await getCurrentUser();
    await convertToUserModel();
    currentCustomer.value = loggedInUser;
  }

  Future<void> uploadImageToFirebaseStorage(String? userID) async {
    if (new_image.value != null) {
      final fileName = 'user_${userID}.jpg';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('userAvatar/$fileName');
      final UploadTask uploadTask = storageReference.putFile(new_image.value!);
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'Avatar': url,
      });
    }
  }

  Future<void> updateCustomer(BuildContext context, String? userID) async {
    if (currentCustomer.value != null) {
      currentCustomer.update((user) {
        if (new_image.value != null) {
          user?.Avatar = "";
        } else {
          user?.Avatar = currentCustomer.value?.Avatar;
        }
        if (birthDay.value != null) {
          user?.BirthDay = birthDay.value;
        } else {
          user?.BirthDay = currentCustomer.value?.BirthDay;
        }
        if (new_gender.value != null) {
          user?.Gender = new_gender.value;
        } else {
          user?.Gender = currentCustomer.value?.Gender;
        }
        user?.FirstName = currentCustomer.value?.FirstName ?? "";
        user?.LastName = currentCustomer.value?.LastName ?? "";
        user?.Address = currentCustomer.value?.Address ?? "";
        user?.PhoneNumber = currentCustomer.value?.PhoneNumber ?? "";
      });
      // Update
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update(currentCustomer.value!.toMap());
      await uploadImageToFirebaseStorage(userID).then((value) {
        CustomSuccessMessage.showMessage('Cập nhật thành công!');
        Navigator.of(context).pop();
      });
    }
  }

  bool checkUserAuthencation() {
    if (user != null) {
      for (final userInfo in user!.providerData) {
        if (userInfo.providerId == "google.com") {
          print("Đây là người dùng google");
          return true;
        }
      }
    }
    return false;
  }

  Rx<String?> oldpassword = Rx<String?>(null);
  Rx<String?> newpassword = Rx<String?>(null);
  Rx<String?> reenterpasswrod = Rx<String?>(null);
  Rx<bool> validatePassConfirm = Rx<bool>(false);
  String? checkMatchPassword() {
    if (!checkUserAuthencation()) {
      if (newpassword.value != reenterpasswrod.value) {
        return "Mật khẩu không khớp";
      } else if ((oldpassword.value == "" ||
              newpassword.value == "" ||
              reenterpasswrod.value == "") ||
          (oldpassword.value == null ||
              newpassword.value == null ||
              reenterpasswrod.value == null))
        return "Vui lòng nhập đầy đủ thông tin!!";
      else {
        validatePassConfirm.value = true;
        return "Mật khẩu hợp lệ";
      }
    }
    return "";
  }

  Future<void> changePassword(
      String? email, String? oldPassword, String? newPassword) async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: email ?? "", password: oldPassword ?? "");

    Map<String, String?> codeResponses = {
      //Các lỗi authencation
      "user-mismatch": "Tài khoản không đúng!",
      "user-not-found": "Không tìm thấy tài khoản!",
      "invalid-credential": "Phiên đăng nhập không hợp lệ!",
      "invalid-email": "Email không đúng!",
      "wrong-password": "Mật khẩu cũ sai!",
      "invalid-verification-code": "",
      "invalid-verification-id": "",
      // Các lỗi khi cập nhật
      "weak-password": "Mật khẩu yếu!",
      "requires-recent-login": "Yêu càu đăng nhập!"
    };

    try {
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword ?? "");
      CustomSuccessMessage.showMessage('Cập nhật thành công');
    } on FirebaseAuthException catch (error) {
      CustomErrorMessage.showMessage("Lỗi:${codeResponses[error.code]} ");
    }
  }

  Future<void> resetPasswordForGoogleAuthencation(String? email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email ?? "")
          .then((value) {
        CustomSuccessMessage.showMessage(
            'Đã gửi một mail đổi mật khẩu tới bạn\n Vui lòng kiểm tra email của bạn');
      });
    } catch (e) {
      print("Có lỗi xảy ra: $e");
      return;
    }
  }
}
