import 'package:app_food_2023/controller/cart.dart';
import 'package:app_food_2023/controller/check_out.dart';
import 'package:app_food_2023/controller/edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/seach_place.dart';
import '../../controller/user.dart';
import '../../model/UserModel.dart';

import '../../screens/customer/setting_profile/customer_settings.dart';
import '../transitions_animations.dart';

Widget customerAvatar(BuildContext context) {
  return InkWell(
    onTap: () {
      Get.put(EditCustomerController());
      slideinTransition(context, CustomerSetting());
    },
    child: userImage(),
  );
}

Widget userInfor(BuildContext context, UserModel userModel) {
  final controller = Get.find<CheckOutController>();
  controller.getLocation();
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 7,
          ),
          Text(
            "Giao tới: ${userModel.FirstName}",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Icon(
            Icons.location_on,
            color: Color(0xFFFF2F08),
          ),
          Expanded(
            child: GetX<CheckOutController>(
              init: controller,
              builder: (controller) {
                if (controller.getaddress.value != null) {
                  return GestureDetector(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      '${controller.getaddress.value}',
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Get.put(CheckOutController(checkedItems));
                      slideinTransition(context, AddressPage());
                    },
                  );
                }
                return GestureDetector(
                  child: Text(
                    "Chọn địa chỉ để đặt hàng!",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    slideinTransition(context, AddressPage());
                  },
                );
              },
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Color(0xFFFF2F08),
          )
        ],
      ),
    ],
  );
}
