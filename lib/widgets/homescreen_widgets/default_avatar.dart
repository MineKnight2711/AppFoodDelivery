import 'package:flutter/material.dart';

Widget defaultAvatar() {
  return Container(
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
  );
}
