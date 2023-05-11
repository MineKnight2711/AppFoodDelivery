import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/seach_place.dart';
import '../../controller/user.dart';
import '../../model/UserModel.dart';
import '../../screens/customer/setting_profile.dart';
import '../transitions_animations.dart';

Future<String?> _getLocation() async {
  final prefs = await SharedPreferences.getInstance();
  final location = prefs.getString("diachiHienTai");
  return location;
}

Widget customerAvatar(BuildContext context) {
  return InkWell(
    onTap: () {
      slideinTransition(context, SettingProfileScreen(), true);
    },
    child: userImage(),
  );
}

Widget userInfor(BuildContext context, UserModel userModel) {
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
            child: FutureBuilder(
              future: _getLocation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GestureDetector(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      slideinTransition(context, AddressPage(), true);
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
                    slideinTransition(context, AddressPage(), true);
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
