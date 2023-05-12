import 'package:app_food_2023/widgets/appbar.dart';
import 'package:app_food_2023/widgets/employee_manament/datetime_picker.dart';
import 'package:app_food_2023/widgets/employee_manament/employee_widgets.dart';
import 'package:app_food_2023/widgets/message.dart';
import 'package:app_food_2023/widgets/select_image/image_select.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/edit_specific_employee.dart';

class EditSpecificEmployees extends StatelessWidget {
  final DocumentSnapshot doc;

  EditSpecificEmployees({Key? key, required this.doc}) : super(key: key);
  final controller = Get.find<EditSpecificEmployeeController>();

  @override
  Widget build(BuildContext context) {
    controller.fetchSpecificEmployee(doc.id);
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          controller.specificEmployee.value = null;
          Navigator.of(context).pop();
        },
        title: 'Thông tin nhân viên',
      ),
      body: Obx(
        () {
          if (controller.specificEmployee.value != null) {
            return Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  ImagePickerWidget(
                    onImageSelected: (newimage) {
                      controller.imageFile.value = newimage;
                    },
                    currentImageUrl: controller.specificEmployee.value!.Avatar,
                  ),
                  Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          MyTitleTextFieldWidget(title: 'Ngày tháng năm sinh'),

                          BirthdayDatePickerWidget(
                            initialDate:
                                controller.specificEmployee.value!.BirthDay,
                            onChanged: (value) {
                              controller.birthDay.value = value;
                            },
                          ),

                          MyTitleTextFieldWidget(title: 'Họ và tên đệm'),
                          // TextInputWidget(
                          //     hintText: 'Nhập họ và tên đệm',
                          //     controller: _lastNameController),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              initialValue:
                                  controller.specificEmployee.value!.LastName ??
                                      '',
                              onChanged: (value) {
                                controller.specificEmployee.update((val) {
                                  val!.LastName = value;
                                });
                              },
                            ),
                          ),
                          MyTitleTextFieldWidget(title: 'Tên'),
                          // TextInputWidget(
                          //     hintText: 'Nhập tên',
                          //     controller: _firstNameController),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              initialValue: controller
                                      .specificEmployee.value!.FirstName ??
                                  '',
                              onChanged: (value) {
                                controller.specificEmployee.update((val) {
                                  val!.FirstName = value;
                                });
                              },
                            ),
                          ),
                          MyTitleTextFieldWidget(title: 'Số điện thoại'),
                          // TextInputWidget(
                          //     hintText: 'Nhập số điện thoại',
                          //     controller: _phoneController),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              initialValue: controller
                                      .specificEmployee.value!.PhoneNumber ??
                                  '',
                              onChanged: (value) {
                                controller.specificEmployee.update((val) {
                                  val!.PhoneNumber = value;
                                });
                              },
                            ),
                          ),
                          MyTitleTextFieldWidget(title: 'Địa chỉ'),
                          // TextInputWidget(
                          //     hintText: 'Nhập địa chỉ',
                          //     controller: _addressController),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              initialValue:
                                  controller.specificEmployee.value!.Address ??
                                      '',
                              onChanged: (value) {
                                controller.specificEmployee.update((val) {
                                  val!.Address = value;
                                });
                              },
                            ),
                          ),
                          SaveCancelButtonsWidget(
                            onSavePressed: () {
                              CustomSnackBar.showCustomSnackBar(
                                  context, 'Đang cập nhật...', 4);
                              controller.updateEmployee(doc.id);
                            },
                            onCancelPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );

    // bool isValidPhoneNumber(String phoneNumber) {
    //   final RegExp regex = RegExp(r'^\+?[0-9]{10,}$');
    //   return regex.hasMatch(phoneNumber);
    // }

    // bool isValidEmail(String email) {
    //   final RegExp regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    //   return regex.hasMatch(email);
    // }

    // showUserAvatar() {
    //   if (imageUrl == "") {
    //     if (loggedInUser?.Avatar.toString() == "" ||
    //         loggedInUser?.Avatar.toString() == "images/userAvatar/user.png" ||
    //         loggedInUser?.Avatar == null) {
    //       return CircleAvatar(
    //         radius: 140.0,
    //         backgroundImage: AssetImage("assets/images/profile.png"),
    //         backgroundColor: Colors.transparent,
    //       );
    //     } else {
    //       return CircleAvatar(
    //         radius: 140.0,
    //         backgroundImage: NetworkImage(widget.doc['Avatar']),
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

    // showUserBirthDay() {
    //   if (loggedInUser?.BirthDay != "null" || loggedInUser?.BirthDay != null) {
    //     currentBirthDay = loggedInUser?.BirthDay;
    //     String? day = dateTime?.day.toString() ?? "Ngày";
    //     String? month = dateTime?.month.toString() ?? "Tháng";
    //     String? year = dateTime?.year.toString() ?? "Năm";
    //     return "$day/$month/$year";
    //   } else {
    //     currentBirthDay = DateTime.now();
    //     String? day = dateTime?.day.toString() ?? "Ngày";
    //     String? month = dateTime?.month.toString() ?? "Tháng";
    //     String? year = dateTime?.year.toString() ?? "Năm";
    //     return "$day/$month/$year";
    //   }
    // }

    // Future<DateTime?> pickDate() => showDatePicker(
    //     context: context,
    //     initialDate: dateTime ?? DateTime.now(),
    //     firstDate: DateTime(1900),
    //     lastDate: DateTime(2100));
  }
}
