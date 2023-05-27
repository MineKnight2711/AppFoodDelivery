import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/screens/customer/food_details.dart';
import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class DishByCategory extends StatefulWidget {
  DishByCategory(this.doc, {Key? key}) : super(key: key);
  @override
  _DishByCategoryState createState() => _DishByCategoryState();
  QueryDocumentSnapshot? doc;
}

class _DishByCategoryState extends State<DishByCategory> {
  int check = 0;
  int rateCount = 0;
  double tongDiem = 0.0;
  bool checkData() {
    FirebaseFirestore.instance
        .collection('dishes')
        .where('CategoryID', isEqualTo: widget.doc?.id)
        .get()
        .then((value) {
      setState(() {
        check = value.docs.length;
      });
    });
    if (check == 0) {
      return false;
    } else {
      return true;
    }
  }

  final currentcy = new NumberFormat('#,##0', 'ID');

  void initState() {
    super.initState();
    if (!checkData()) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Các món ${widget.doc?['name']}',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppHomeScreen(),
              ),
            );
          },
        ),
      ),
      body: checkData()
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('dishes')
                  .where('CategoryID', isEqualTo: widget.doc?.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ScreenRotate(context) ? 2 : 3,
                      mainAxisSpacing: ScreenRotate(context) ? 15 : 30,
                      crossAxisSpacing: ScreenRotate(context) ? 2 : 30,
                      childAspectRatio: ScreenRotate(context)
                          ? MediaQuery.of(context).size.aspectRatio * 1.7
                          : MediaQuery.of(context).size.aspectRatio * 0.5),
                  itemCount: snapshot.data?.docs.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var item = snapshot.data?.docs[index];

                    double discount =
                        (double.parse(item?['Price'].toStringAsFixed(0)) * 10) /
                            100;
                    double totalDiscount =
                        double.parse(item?['Price'].toStringAsFixed(0)) -
                            discount;
                    return InkWell(
                      onTap: () {
                        slideupTransition(context, FoodViewDetails(item!));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 234, 228, 201),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: ScreenRotate(context)
                                  ? MediaHeight(context, 5.5)
                                  : MediaHeight(context, 2.5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "${item?['Image']}",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(
                                    16.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 11.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 10,
                                        child: Text("${item?['DishName']}",
                                            textAlign: TextAlign.justify,
                                            style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ),
                                      Spacer(),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('ratings')
                                              .where('DishID',
                                                  isEqualTo: item?.id)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              double trungBinh = 0;
                                              tongDiem = snapshot.data!.docs
                                                  .fold(
                                                      0.0,
                                                      (sum, doc) =>
                                                          sum + doc["Score"]);

                                              rateCount =
                                                  snapshot.data!.docs.length;
                                              if (rateCount != 0) {
                                                trungBinh = double.parse(
                                                    (tongDiem / rateCount)
                                                        .toStringAsFixed(1));
                                              }

                                              return Text("${trungBinh}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ));
                                            }
                                            return Spacer();
                                          }),
                                      Icon(
                                        Icons.star,
                                        size: 14.0,
                                        color: Colors.orange,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 11,
                                ),
                                Text(
                                  "Còn lại: ${item?['InStock']}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff02A88A),
                                  ),
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      "${currentcy.format(double.parse(item?['Price'].toStringAsFixed(0)))} đ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.lineThrough,
                                        color: const Color(0xffF25822),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6.66,
                                    ),
                                    Text(
                                      "${currentcy.format(totalDiscount)} đ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff02A88A),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Column(
              children: [
                Image.network(
                    "https://i.pinimg.com/originals/2a/c5/94/2ac59480bdaeeda7e4456a455954945c.gif"),
                SizedBox(height: 50),
                Text(
                  "Chưa có món trong danh mục này",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  ),
                ),
              ],
            )),
    );
  }
}
