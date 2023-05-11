import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/controller/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String? categoryName = "";
int rateCount = 0;
double tongDiem = 0.0, trungBinh = 0.0;

Widget foodViewCard(
    BuildContext context, Function()? onTap, QueryDocumentSnapshot doc) {
  Future<String> getCategoryName() async {
    String category = "";
    final documentReference = await FirebaseFirestore.instance
        .collection("categories")
        .doc(doc["CategoryID"]);
    await documentReference.get().then((snapshot) {
      category = snapshot.data()!['name'].toString();
    });
    categoryName = category;
    return category;
  }

  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: doc["Image"] != null
                  ? Image.network(
                      doc["Image"],
                      height: MediaHeight(context, 5.05),
                      width: MediaWidth(context, 1),
                      fit: BoxFit.cover,
                    )
                  : CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 200,
                      child: Text(
                        doc["DishName"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    FutureBuilder(
                      future: getCategoryName(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "${categoryName}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          );
                        }
                        return Text(
                          "",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('ratings')
                            .where('DishID', isEqualTo: doc.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            tongDiem = snapshot.data!.docs
                                .fold(0.0, (sum, doc) => sum + doc["Score"]);
                            rateCount = snapshot.data!.docs.length;
                            if (rateCount != 0) {
                              trungBinh = double.parse(
                                  (tongDiem / rateCount).toStringAsFixed(1));
                            }

                            return Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xFFFF2F08),
                                  size: 20,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "${trungBinh}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "(${rateCount} đánh giá)",
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Text("");
                        }),
                  ],
                ),
                Spacer(),
                Container(
                  height: 89,
                  width: 90,
                  padding: EdgeInsets.only(top: 6, left: 2),
                  child: Column(
                    children: [
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_fire_department_outlined,
                            color: Color(0xFFFF2F08),
                            size: 20,
                          ),
                          Text(
                            "Còn: ${doc["InStock"].toString()}",
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 41,
                        width: 102,
                        decoration: BoxDecoration(
                            color: Color(0xFFFF2F08),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        child: Center(
                          child: Text(
                            formatCurrency(doc["Price"]),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
