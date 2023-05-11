import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/model/UserModel.dart';
import 'package:app_food_2023/widgets/employee_manament/employee_widgets.dart';
import 'package:app_food_2023/widgets/select_image/image_select.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/edit_employee.dart';

import '../../../controller/employee.dart';
import '../../../widgets/employee_manament/datetime_picker.dart';
import '../../../widgets/employee_manament/gender_chose.dart';
import '../admin_screen.dart';

class EditEmployees extends StatefulWidget {
  @override
  EditEmployeesScreenState createState() => EditEmployeesScreenState();
}

class EditEmployeesScreenState extends State<EditEmployees> {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  final _phoneNumberFocusNode = FocusNode();
  // final _savebuttonFocus = FocusNode();
  String? radioVal = "";
  bindingData() async {
    await convertEmployeeToUserModel();
    _firstNameController.text = loggedInEmployee?.FirstName ?? "";
    _lastNameController.text = loggedInEmployee?.LastName ?? "";
    _phoneController.text = loggedInEmployee?.PhoneNumber ?? "";
    _addressController.text = loggedInEmployee?.Address ?? "";
    selectedgender = loggedInEmployee?.Gender ?? "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    bindingInput();
    bindingData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Thông tin tài khoản',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminScreen(),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<UserModel?>(
        future: convertEmployeeToUserModel(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Colors.white,
              child: new ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GetX<EmployeeController>(
                          init: EmployeeController(),
                          builder: (controller) {
                            return Container(
                              height: ScreenRotate(context)
                                  ? MediaHeight(context, 4)
                                  : MediaHeight(context, 2.7),
                              child: ImagePickerWidget(
                                onImageSelected: (image) {
                                  current_image = image;
                                },
                                currentImageUrl:
                                    controller.currentEmployee.value!.Avatar,
                              ),
                            );
                          }),
                      Container(
                        color: Color(0xffFFFFFF),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            MyTitleTextFieldWidget(
                              title: 'Ngày tháng năm sinh',
                            ),
                            BirthdayDatePickerWidget(
                              initialDate: dateTimeEmpolyee, // User's birthday
                              onChanged: (value) {
                                // Do something with the selected date value
                              },
                            ),
                            MyTitleTextFieldWidget(
                              title: 'Họ và tên',
                            ),
                            TextInputWidget(
                              hintText: "Nhập họ và tên đệm",
                              controller: _lastNameController,
                              onChanged: (value) {
                                lastname = value;
                              },
                              focusNode: _lastNameFocusNode,
                              nextFocusNode: _firstNameFocusNode,
                            ),
                            MyTitleTextFieldWidget(
                              title: 'Tên',
                            ),
                            TextInputWidget(
                              hintText: "Nhập tên",
                              controller: _firstNameController,
                              onChanged: (value) {
                                firstname = value;
                              },
                              focusNode: _firstNameFocusNode,
                              nextFocusNode: _phoneNumberFocusNode,
                            ),
                            GenderSelectionWidget(
                              gender: selectedgender,
                              size: 1.5,
                              onChanged: (value) {
                                setState(() {
                                  selectedgender = value;
                                });
                              },
                            ),
                            MyTitleTextFieldWidget(
                              title: 'Số điện thoại',
                            ),
                            TextInputWidget(
                              hintText: "Nhập số điện thoại",
                              controller: _phoneController,
                              onChanged: (value) {
                                phonenumber = value;
                              },
                              focusNode: _phoneNumberFocusNode,
                              nextFocusNode: _addressFocusNode,
                            ),
                            MyTitleTextFieldWidget(
                              title: 'Địa chỉ',
                            ),
                            TextInputWidget(
                              hintText: "Nhập địa chỉ",
                              controller: _addressController,
                              onChanged: (value) {
                                address = value;
                              },
                              focusNode: _addressFocusNode,
                              nextFocusNode: null,
                            ),
                            SaveCancelButtonsWidget(onSavePressed: () {
                              UpdateEmployee(context);
                            }, onCancelPressed: () {
                              setState(() {
                                bindingData();
                                bindingInput();
                              });
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  // bool isValidPhoneNumber(String phoneNumber) {
  //   final RegExp regex = RegExp(r'^\+?[0-9]{10,}$');
  //   return regex.hasMatch(phoneNumber);
  // }

  // bool isValidEmail(String email) {
  //   final RegExp regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  //   return regex.hasMatch(email);
  // }
}
