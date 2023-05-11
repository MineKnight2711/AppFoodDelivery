import 'package:app_food_2023/screens/admin/employee_manager/managent_screen.dart';
import 'package:app_food_2023/widgets/appbar.dart';
import 'package:app_food_2023/widgets/employee_manament/employee_widgets.dart';
import 'package:app_food_2023/widgets/transitions_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/edit_specific_employee.dart';

class ChangeRoleEmployees extends StatelessWidget {
  final DocumentSnapshot doc;

  ChangeRoleEmployees({Key? key, required this.doc}) : super(key: key);
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
          showLeading: true,
          title: 'Sửa chức vụ'),
      body: Obx(
        () {
          if (controller.specificEmployee.value != null) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: Image.network(
                                controller.specificEmployee.value!.Avatar!)
                            .image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    '${controller.specificEmployee.value?.Email}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chức Vụ:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  MyRoleDropdownWidget(
                    onRoleSelected: (value) {
                      controller.specificEmployee.update((val) {
                        val?.Role = value;
                      });
                    },
                    selectedRole: controller.specificEmployee.value?.Role,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      child: Text('Lưu'),
                      onPressed: () {
                        controller.updateEmployeeRole();
                      },
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
  }
}
