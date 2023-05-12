import 'dart:io';

import 'package:app_food_2023/controller/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/UserModel.dart';
import '../screens/admin/admin_screen.dart';
import '../widgets/transitions_animations.dart';
import 'employee.dart';

File? current_image;
DateTime? dateTimeEmpolyee;
UserModel? loggedInEmployee;
String? firstname = '',
    lastname = '',
    email = '',
    selectedgender = '',
    phonenumber = '',
    address = '',
    selectedrole = '',
    imageUrl = "";

Future<UserModel?> convertEmployeeToUserModel() async {
  UserModel user = await getCurrentUser();
  loggedInEmployee = user;
  return loggedInEmployee;
  //Lấy tất cả dữ liệu của nhân viên
}

bindingInput() async {
  await convertEmployeeToUserModel();
  address = loggedInEmployee!.Address;
  firstname = loggedInEmployee!.FirstName;
  lastname = loggedInEmployee!.LastName;
  phonenumber = loggedInEmployee!.PhoneNumber;

  dateTimeEmpolyee = loggedInEmployee!.BirthDay;
  imageUrl = loggedInEmployee!.Avatar;
}

bool checkGender() {
  if (loggedInEmployee?.Gender == "Nam") {
    selectedgender = "Nam";
    return true;
  } else {
    selectedgender = "Nữ";
    return false;
  }
}

Future<void> uploadImageToFirebaseStorage(String? userID) async {
  if (current_image != null) {
    final fileName = 'user_${userID}.jpg';
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('userAvatar/$fileName');
    final UploadTask uploadTask = storageReference.putFile(current_image!);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'Avatar': url,
    });
  }
}

// bool validateInputOnAddNew() {
//   return firstname != null &&
//       firstname != "" &&
//       lastname != null &&
//       lastname != "" &&
//       email != null &&
//       email != "" &&
//       selectedgender != null &&
//       selectedgender != "" &&
//       phonenumber != null &&
//       phonenumber != "" &&
//       address != null &&
//       address != "" &&
//       selectedrole != null &&
//       selectedrole != "" &&
//       dateTimeEmpolyee != null &&
//       dateTimeEmpolyee.toString().isNotEmpty;
// }

// showEmployeeAvatar() {
//   if (imageUrl == "") {
//     if (loggedInEmployee?.Avatar.toString() == "" ||
//         loggedInEmployee?.Avatar.toString() == "images/userAvatar/user.png" ||
//         loggedInEmployee?.Avatar == null) {
//       return CircleAvatar(
//         radius: 140.0,
//         backgroundImage: AssetImage("assets/images/profile.png"),
//         backgroundColor: Colors.transparent,
//       );
//     } else {
//       return CircleAvatar(
//         radius: 140.0,
//         backgroundImage: NetworkImage(loggedInEmployee?.Avatar.toString() ??
//             "" "assets/images/profile.png"),
//         backgroundColor: Colors.transparent,
//       );
//     }
//   } else {
//     return CachedNetworkImage(
//       imageUrl: imageUrl!,
//       imageBuilder: (context, imageProvider) => Container(
//         width: 140.0,
//         height: 140.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//         ),
//       ),
//       placeholder: (context, url) => CircularProgressIndicator(),
//       errorWidget: (context, url, error) => Icon(Icons.error),
//     );
//   }
// }

void UpdateEmployee(BuildContext context) async {
  loggedInEmployee!.Address = address ?? loggedInEmployee!.Address;
  loggedInEmployee!.FirstName = firstname ?? loggedInEmployee!.FirstName;
  loggedInEmployee!.LastName = lastname ?? loggedInEmployee!.LastName;
  loggedInEmployee!.PhoneNumber = phonenumber ?? loggedInEmployee!.PhoneNumber;
  loggedInEmployee!.Gender = selectedgender ?? loggedInEmployee!.Gender;
  loggedInEmployee!.BirthDay = dateTimeEmpolyee ?? loggedInEmployee!.BirthDay;
  loggedInEmployee!.Avatar = imageUrl ?? loggedInEmployee!.Address;

  final collection = FirebaseFirestore.instance.collection("users");
  await collection
      .doc(user?.uid)
      .update(loggedInEmployee!.toMap())
      .then((value) {
    Get.put(EmployeeController());
    Navigator.of(context).pop();
  }).catchError((error) {
    print("Thất bại vì lỗi $error");
  });
  await uploadImageToFirebaseStorage(user?.uid);
}
