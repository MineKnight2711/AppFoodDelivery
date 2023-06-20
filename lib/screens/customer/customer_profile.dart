import 'package:app_food_2023/controller/admincontrollers/edit_customer.dart';
import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';
import 'package:app_food_2023/widgets/admin/employee_manament/gender_chose.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controller/user.dart';
import '../../widgets/admin/employee_manament/datetime_picker.dart';
import '../../widgets/admin/employee_manament/employee_widgets.dart';
import '../../widgets/custom_widgets/message.dart';
import '../../widgets/select_image_constant/image_select.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final controller = Get.find<EditCustomerController>();
  @override
  Widget build(BuildContext context) {
    controller.fetchCurrentCustomer();
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          controller.clearData();

          Navigator.of(context).pop();
        },
        title: 'Thông tin tài khoản',
      ),
      body: Obx(() {
        if (controller.currentCustomer.value != null) {
          return Container(
              color: Colors.white,
              child: ListView(children: <Widget>[
                ImagePickerWidget(
                  onImageSelected: (newimage) {
                    controller.new_image.value = newimage;
                  },
                  currentImageUrl: controller.currentCustomer.value!.Avatar,
                ),

                MyTitleTextFieldWidget(title: 'Ngày tháng năm sinh'),
                BirthdayDatePickerWidget(
                  initialDate: controller.currentCustomer.value!.BirthDay,
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
                        controller.currentCustomer.value!.LastName ?? '',
                    onChanged: (value) {
                      controller.currentCustomer.update((val) {
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
                    initialValue:
                        controller.currentCustomer.value!.FirstName ?? '',
                    onChanged: (value) {
                      controller.currentCustomer.update((val) {
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
                    initialValue:
                        controller.currentCustomer.value!.PhoneNumber ?? '',
                    onChanged: (value) {
                      controller.currentCustomer.update((val) {
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
                        controller.currentCustomer.value!.Address ?? '',
                    onChanged: (value) {
                      controller.currentCustomer.update((val) {
                        val!.Address = value;
                      });
                    },
                  ),
                ),
                MyTitleTextFieldWidget(title: 'Giới tính'),
                GenderSelectionWidget(
                  gender: controller.currentCustomer.value!.Gender,
                  size: 1.5,
                  onChanged: (value) {
                    controller.new_gender.value = value;
                  },
                ),
                SaveCancelButtonsWidget(onSavePressed: () {
                  CustomSnackBar.showCustomSnackBar(
                      context, 'Đang cập nhật...', 4);
                  controller.updateCustomer(context, user?.uid);
                }, onCancelPressed: () {
                  controller.clearData();
                  Navigator.of(context).pop();
                })
              ]));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
