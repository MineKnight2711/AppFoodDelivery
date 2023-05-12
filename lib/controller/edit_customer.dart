import 'dart:io';

import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/message.dart';

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
}
