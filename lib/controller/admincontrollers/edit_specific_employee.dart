import 'dart:io';

import 'package:app_food_2023/model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../../widgets/message.dart';

class EditSpecificEmployeeController extends GetxController {
  RxString docId = RxString('');

  EditSpecificEmployeeController(String docId) {
    this.docId.value = docId;
  }

  Rx<String?> new_firstname = Rx<String?>(null);
  Rx<String?> new_lastname = Rx<String?>(null);
  Rx<String?> new_phonenumber = Rx<String?>(null);
  Rx<String?> new_address = Rx<String?>(null);

  Rx<String?> new_role = Rx<String?>(null);

  Rx<UserModel?> specificEmployee = Rx<UserModel?>(null);

  Rx<File?> imageFile = Rx<File?>(null);

  Rx<DateTime?> birthDay = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchSpecificEmployee(docId.value);
  }

  @override
  void onClose() {
    super.onClose();
    specificEmployee.value = null;
  }

  @override
  void dispose() {
    super.dispose();
    specificEmployee.value = null;
  }

  Future<void> fetchSpecificEmployee(String? employeeId) async {
    if (employeeId != "" || employeeId != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(employeeId)
          .get();
      if (userSnapshot.exists) {
        specificEmployee.value = UserModel.fromMap(userSnapshot.data());
      } else {
        return;
      }
    }
  }

  Future<void> uploadImageToFirebaseStorage(String? userID) async {
    if (imageFile.value != null) {
      final fileName = 'user_${userID}.jpg';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('userAvatar/$fileName');
      final UploadTask uploadTask = storageReference.putFile(imageFile.value!);
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'Avatar': url,
      });
    }
  }

  Future<void> updateEmployee(String? userID) async {
    if (specificEmployee.value != null) {
      specificEmployee.update((user) {
        if (imageFile.value != null) {
          user?.Avatar = "";
        } else {
          user?.Avatar = specificEmployee.value?.Avatar;
        }
        if (birthDay.value != null) {
          user?.BirthDay = birthDay.value;
        } else {
          user?.BirthDay = specificEmployee.value?.BirthDay;
        }
        user?.FirstName = specificEmployee.value?.FirstName ?? "";
        user?.LastName = specificEmployee.value?.LastName ?? "";
        user?.Address = specificEmployee.value?.Address ?? "";
        user?.PhoneNumber = specificEmployee.value?.PhoneNumber ?? "";
      });
      // Update
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update(specificEmployee.value!.toMap());
      await uploadImageToFirebaseStorage(userID).then((value) {
        CustomSuccessMessage.showMessage('Cập nhật thành công!');
      });
    }
  }

  Future<void> updateEmployeeRole() async {
    if (specificEmployee.value != null) {
      specificEmployee.update((user) {
        if (new_role.value != null) {
          user?.Role = specificEmployee.value?.Role;
        }
      });
      // Update
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId.value)
          .update(specificEmployee.value!.toMap());
    }
  }
}
// if (loggedInUser != null) {
//   loggedInUser = null;
// }
// final collection = FirebaseFirestore
//     .instance
//     .collection("employee");
// collection.doc(user?.uid).update({
//   "FirstName":
//       _firstNameController.text,
//   "LastName":
//       _lastNameController.text,
//   "BirthDay": dateTime,
//   "PhoneNumber":
//       _phoneController.text,
//   "Address": _addressController.text,
//   "Avatar": imageUrl,
// }).then((value) {
//   phoneNumber = "";

//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               ManagementEmployees()));

//   FirebaseFirestore.instance
//       .collection("employee")
//       .doc(user?.uid)
//       .get()
//       .then((value) {
//     this.loggedInUser =
//         UserModel.fromMap(
//             value.data());
//     setState(() {});
//   });
// }).catchError((error) {
//   print("Thất bại vì lỗi $error");
// });
