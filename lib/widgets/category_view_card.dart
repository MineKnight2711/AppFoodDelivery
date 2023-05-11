import 'dart:math';

import 'package:app_food_2023/appstyle/category_card_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget categoryViewCard(Function()? onTap, QueryDocumentSnapshot doc) {
  int color_id = Random().nextInt(CategoryStyle.cardsColor.length);

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: CategoryStyle.cardsColor[color_id],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          doc["imageURL"] != null
              ? CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: Image.network(doc["imageURL"]).image,
                )
              : CircularProgressIndicator(),
          Text(
            doc["name"],
            style: GoogleFonts.roboto(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
