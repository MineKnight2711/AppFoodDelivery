import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/login_register/login_screen.dart';
import '../transitions_animations.dart';

Widget notLogin(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 7,
          ),
          Text(
            "App food Delivery",
            style:
                GoogleFonts.nunito(fontSize: MediaAspectRatio(context, 0.026)),
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
            child: Text(
              "Đăng nhập để chọn vị trí",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            Icons.login,
            color: Color(0xFFFF2F08),
          )
        ],
      ),
    ],
  );
}

Widget notLoginAvatar(BuildContext context) {
  return InkWell(
    onTap: () {
      slideupTransition(context, LoginScreen());
    },
    child: Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage("images/user.png"),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
