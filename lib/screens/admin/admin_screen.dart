import 'package:app_food_2023/screens/admin/category_manager/category_screen.dart';
import 'package:app_food_2023/screens/admin/employee_manager/edit_current_employees.dart';
import 'package:app_food_2023/screens/admin/employee_manager/managent_screen.dart';
import 'package:app_food_2023/screens/home_screen.dart';

import 'package:app_food_2023/widgets/appbar.dart';
import 'package:app_food_2023/widgets/transitions_animations.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/employee.dart';
import '../../controller/logout.dart';

import 'employee_manager/change_password_employees.dart';
import 'food_manager/food_list.dart';
import 'order_manager/list_orders.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          slideinTransition(context, AppHomeScreen());
        },
        showLeading: true,
        title: "Quản lý",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            GetX<EmployeeController>(
              init: EmployeeController(),
              builder: (controller) {
                return Container(
                  width: 100.0,
                  height: 100.0,
                  child: controller.currentEmployee.value == null
                      ? CircularProgressIndicator()
                      : CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(
                              controller.currentEmployee.value!.Avatar ?? ''),
                        ),
                );
              },
            ),
            SizedBox(height: 20.0),
            GetX<EmployeeController>(
              init: EmployeeController(),
              builder: (controller) {
                return Text(
                  '${controller.currentEmployee.value?.LastName} ${controller.currentEmployee.value?.FirstName}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            GetX<EmployeeController>(
              init: EmployeeController(),
              builder: (controller) {
                return Text(
                  '${controller.currentEmployee.value?.Email}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                );
              },
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      'Tài khoản',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Cập nhật thông tin'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEmployees(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Đổi mật khẩu'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordEmployeesScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Quản lý',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Quản lý nhân viên'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManagementEmployees(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Quản lý danh mục'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Quản lý món ăn'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FoodListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delivery_dining),
                    title: Text('Delivery'),
                    onTap: () {
                      // Xử lý đi đạt
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.receipt_long),
                    title: Text('Quản lý đơn hàng'),
                    onTap: () {
                      slideinTransition(context, ListOrderPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Đăng xuất'),
                    onTap: () {
                      logOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
