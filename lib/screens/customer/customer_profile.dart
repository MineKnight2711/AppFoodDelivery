import 'package:app_food_2023/controller/edit_customer.dart';
import 'package:app_food_2023/widgets/appbar.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final controller = Get.find<EditCustomerController>();
  @override
  Widget build(BuildContext context) {
    controller.fetchCurrentCustomer();
    return Scaffold(
      appBar: CustomAppBar(onPressed: () {
        controller.currentCustomer.value = null;

        Navigator.of(context).pop();
      }),
      body: Obx(() {
        if (controller.currentCustomer.value != null) {
          return Container(
              color: Colors.white, child: ListView(children: <Widget>[]));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
