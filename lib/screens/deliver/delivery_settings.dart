import 'package:app_food_2023/controller/admincontrollers/edit_customer.dart';
import 'package:app_food_2023/controller/delivercontrollers/list_order_controller.dart';
import 'package:app_food_2023/controller/logout.dart';
import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/screens/customer/change_password_customer.dart';
import 'package:app_food_2023/screens/customer/setting_profile/babstrap_settings_screen.dart';
import 'package:app_food_2023/screens/deliver/delivery_order/on_delivery.dart';
import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admin/employee_manager/edit_current_employees.dart';
import 'delivery_order/delivery_succes.dart';
import 'delivery_order/list_order.dart';

class DeliverySetting extends StatelessWidget {
  const DeliverySetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.94),
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        title: "Thông tin tài khoản",
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // User card
            BigUserCard(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              userName: "${loggedInUser?.LastName} ${loggedInUser?.FirstName}",
              email: "${loggedInUser?.Email}",
              userProfilePic: loggedInUser != null
                  ? Image.network(loggedInUser!.Avatar.toString()).image
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
                  slideinTransition(context, EditEmployees());
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
              ],
            ),

            SettingsGroup(
              settingsGroupTitle: "Vận Đơn",
              items: [
                SettingsItem(
                  onTap: () {
                    Get.put(DeliveryOrdersController());
                    slideinTransition(context, DeliverListOrder());
                  },
                  icons: CupertinoIcons.text_badge_checkmark,
                  iconStyle: IconStyle(),
                  title: 'Đơn hàng',
                  subtitle: "Danh sách các đơn cần vận chuyển",
                ),
                SettingsItem(
                  onTap: () {
                    Get.put(DeliveryOrdersController());
                    slideinTransition(context, OnDeliverListOrder());
                  },
                  icons: Icons.pedal_bike_outlined,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 203, 21, 176),
                  ),
                  title: 'Đang vận chuyển',
                  subtitle: "Xem đơn hàng đang vận chuyển",
                ),
                SettingsItem(
                  onTap: () {
                    Get.put(DeliveryOrdersController());
                    slideinTransition(context, SuccessDeliverListOrder());
                  },
                  icons: Icons.check_circle_outline_outlined,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 8, 188, 152),
                  ),
                  title: 'Đã vận chuyển',
                  subtitle: "Xem đơn hàng đã vận chuyển",
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
      ),
    );
  }
}
