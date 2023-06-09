import 'package:app_food_2023/controller/admincontrollers/edit_customer.dart';

import 'package:app_food_2023/controller/customercontrollers/view_my_order.dart';
import 'package:app_food_2023/screens/customer/customer_profile.dart';
import 'package:app_food_2023/screens/customer/order/order.dart';
import 'package:app_food_2023/screens/customer/setting_profile/babstrap_settings_screen.dart';
import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/logout.dart';
import '../../../widgets/custom_widgets/transitions_animations.dart';
import '../change_password_customer.dart';

class CustomerSetting extends StatelessWidget {
  CustomerSetting({Key? key}) : super(key: key);
  final controller = Get.find<EditCustomerController>();
  final homecontroller = Get.find<HomeScreenController>();
  @override
  Widget build(BuildContext context) {
    controller.fetchCurrentCustomer();
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.94),
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        title: "Thông tin tài khoản",
      ),
      body: Obx(() {
        if (controller.currentCustomer.value != null) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                // User card
                BigUserCard(
                  backgroundColor: Colors.white,
                  userName:
                      "${controller.currentCustomer.value?.LastName} ${controller.currentCustomer.value?.FirstName}",
                  email: "${controller.currentCustomer.value?.Email}",
                  userProfilePic: controller.currentCustomer.value?.Avatar !=
                          null
                      ? Image.network(controller.currentCustomer.value!.Avatar!)
                          .image
                      : AssetImage("assets/images/profile.png"),
                  cardActionWidget: SettingsItem(
                    icons: Icons.edit,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.yellow[600],
                    ),
                    title: "Cập nhật thông tin",
                    subtitle: "Nhấn vào để chỉnh sửa thông tin",
                    onTap: () {
                      Get.put(EditCustomerController());
                      slideinTransition(context, ProfileScreen());
                    },
                  ),
                ),
                SettingsGroup(
                  items: [
                    SettingsItem(
                      onTap: () {
                        Get.put(EditCustomerController());
                        slideinTransition(context, ChangePasswordCustomer());
                      },
                      icons: Icons.lock_person_outlined,
                      iconStyle: IconStyle(
                        backgroundColor: Color.fromARGB(255, 215, 34, 34),
                      ),
                      title: 'Đổi mật khẩu',
                      subtitle: "Thay đổi mật khẩu người dùng",
                    ),
                    SettingsItem(
                      onTap: () {
                        Get.put(MyOrderController());
                        slideinTransition(context, OrdersScreen());
                      },
                      icons: CupertinoIcons.cart,
                      iconStyle: IconStyle(),
                      title: 'Đơn hàng',
                      subtitle: "Xem chi tiết danh sách các đơn hàng",
                    ),
                  ],
                ),

                SettingsGroup(
                  settingsGroupTitle: "Tài khoản",
                  items: [
                    SettingsItem(
                      onTap: () {
                        logOut(context);
                      },
                      icons: Icons.exit_to_app_rounded,
                      iconStyle: IconStyle(),
                      title: "Đăng xuất",
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          controller.fetchCurrentCustomer();
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
      bottomNavigationBar: MyBottomNavigationBar(
        onItemTapped: (index) => homecontroller.onItemTapped(context, index),
        selectedIndex: homecontroller.selectedindex.value,
      ),
    );
  }
}
