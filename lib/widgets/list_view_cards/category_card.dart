import 'package:app_food_2023/appstyle/category_card_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget categoryCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return SingleChildScrollView(
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 234, 225, 139),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 4.0,
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(doc["imageURL"]),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              doc["name"],
              style: CategoryStyle.mainTitle,
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              doc["description"],
              style: CategoryStyle.mainContent,
            ),
          ],
        ),
      ),
    ),
  );
}
