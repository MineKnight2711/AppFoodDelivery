import 'package:app_food_2023/controller/admincontrollers/edit_customer.dart';

import 'package:app_food_2023/widgets/appbar.dart';
import 'package:app_food_2023/widgets/customer/image_showing.dart';
import 'package:app_food_2023/widgets/employee_manament/employee_widgets.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/employee_manament/change_password.dart';

class ChangePasswordCustomer extends StatelessWidget {
  ChangePasswordCustomer({Key? key}) : super(key: key);
  final controller = Get.find<EditCustomerController>();
  @override
  Widget build(BuildContext context) {
    controller.fetchCurrentCustomer();
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          controller.clearData();
          Navigator.pop(context);
        },
        title: 'Thay đổi mật khẩu',
      ),
      body: Obx(() {
        if (controller.currentCustomer.value != null) {
          return Container(
              color: Colors.white,
              child: ListView(children: <Widget>[
                NetworkImageWidget(
                    networkImageUrl: controller.currentCustomer.value!.Avatar!,
                    size: 120),
                Row(
                  children: [
                    MyTitleTextFieldWidget(title: "Email:"),
                    Center(
                      child: Text(
                        controller.currentCustomer.value?.Email ?? '',
                        style: GoogleFonts.roboto(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Divider(
                    indent: 100,
                    endIndent: 100,
                    color: Colors.black,
                    thickness: 2),
                Visibility(
                  visible: !controller.checkUserAuthencation(),
                  child: Column(
                    children: [
                      MyTitleTextFieldWidget(title: 'Mật khẩu cũ'),
                      PasswordTextField(
                        onChanged: (value) {
                          controller.oldpassword.update((val) {
                            val = value;
                          });
                        },
                        hintText: 'Nhập mật khẩu cũ',
                        helperText: controller.checkMatchPassword(),
                      ),
                      MyTitleTextFieldWidget(title: 'Mật khẩu mới'),
                      PasswordTextField(
                        onChanged: (value) {
                          controller.newpassword.update((val) {
                            val = value;
                          });
                        },
                        hintText: 'Nhập mật khẩu mới',
                        helperText: controller.checkMatchPassword(),
                      ),
                      MyTitleTextFieldWidget(title: 'Xác nhận mật khẩu mới'),
                      PasswordTextField(
                        onChanged: (value) {
                          controller.reenterpasswrod.update((val) {
                            val = value;
                          });
                        },
                        hintText: 'Nhập lại mật khẩu ',
                        helperText: controller.checkMatchPassword(),
                      ),
                      SaveCancelButtonsWidget(onSavePressed: () async {
                        await controller.changePassword(
                            controller.currentCustomer.value!.Email,
                            controller.oldpassword.value,
                            controller.newpassword.value);
                      }, onCancelPressed: () {
                        controller.clearData();
                        Navigator.pop(context);
                      })
                    ],
                  ),
                ),
                Visibility(
                  visible: controller.checkUserAuthencation(),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.resetPasswordForGoogleAuthencation(
                            controller.currentCustomer.value!.Email!);
                      },
                      icon: Icon(CupertinoIcons.envelope),
                      label: Text("Gửi mail xác nhận"),
                    ),
                  ),
                ),
              ]));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
