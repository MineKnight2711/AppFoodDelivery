import 'package:app_food_2023/appstyle/error_messages/error_style.dart';

import 'package:app_food_2023/widgets/show_rating.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_food_2023/controller/cart.dart';
import '../../controller/user.dart';
import '../../model/UserModel.dart';
import '../../model/dishes_model.dart';
import '../../widgets/feedback_dialogs.dart';
import '../../widgets/rating_card.dart';

// ignore: must_be_immutable
class FoodViewDetails extends StatefulWidget {
  FoodViewDetails(this.doc, {Key? key}) : super(key: key);

  @override
  State<FoodViewDetails> createState() => _FoodViewDetailsState();
  QueryDocumentSnapshot doc;
}

class _FoodViewDetailsState extends State<FoodViewDetails> {
  User? user = FirebaseAuth.instance.currentUser;
  String? category = "";
  double? tongDiem = 0.0, trungBinh = 0.0;

  UserModel? loggedInUser;

  Future<void> _getCurrentUser() async {
    UserModel user = await getCurrentUser();
    setState(() {
      loggedInUser = user;
    });
  }

  bool checkNV = false;
  int rateCount = 0, sl = 1;
  final currentcy = new NumberFormat('#,##0', 'ID');
  String selectedColor = "";
  var selected = 0;
  getCategoryName() async {
    final documentReference = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.doc["CategoryID"]);
    String categoryName = "";
    await documentReference.get().then((snapshot) {
      categoryName = snapshot.data()!['name'].toString();
    });
    setState(() {
      category = categoryName;
    });
  }

  bool CheckRating() {
    if (trungBinh == 0.0 || tongDiem == 0.0 || rateCount == 0) {
      return false;
    } else
      return true;
  }

  bool checkEmployee() {
    if (loggedInUser?.Role.toString() != "Customer") {
      print("Đây là tài khoản nhân viên");
      return true;
    } else {
      print("Đây là tài khoản khách hàng");
      return false;
    }
  }

  void initState() {
    super.initState();
    getCategoryName();
    _getCurrentUser();
    checkEmployee();
  }

  @override
  Widget build(BuildContext context) {
    var menu = ["Mô tả", "Nhận xét"];

    double discount =
        (double.parse(widget.doc['Price'].toStringAsFixed(0)) * 10) / 100;
    //double totalDiscount = widget.item!['price'] - discount;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Dashboard"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 265.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "${widget.doc['Image']}",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 25.0,
              ),
              child: Text(
                "${widget.doc['DishName']}",
                style: GoogleFonts.roboto(
                    fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 24.0,
                ),
                Text(
                  "${category}",
                  style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 50,
                  width: 120,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('${trungBinh} (${rateCount} đánh giá)'),
                      ],
                    ),
                    CheckRating()
                        ? ShowRatingBar(
                            rating: trungBinh!,
                            size: 17,
                          )
                        : ShowRatingBar(
                            rating: 0,
                            size: 17,
                          )
                  ]),
                ),
                const Spacer(),
                Text(
                  formatCurrency(discount),
                  style: GoogleFonts.poppins(
                      color: const Color(0xff02A88A),
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 28.0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: SizedBox(
                    width: 120,
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFB039),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(62), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        if (user == null) {
                          notLoggin();
                          return;
                        }
                        if (checkEmployee()) {
                          cantRate();
                          return;
                        }
                        await FirebaseFirestore.instance
                            .collection('ratings')
                            .where("UserID", isEqualTo: user?.uid)
                            .where("DishID", isEqualTo: widget.doc.id)
                            .get()
                            .then(
                          (value) {
                            if (!value.docs.isEmpty) {
                              existRating();
                              return null;
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ProductRatingDialog(
                                    productName: widget.doc['DishName'],
                                    productID: widget.doc.id,
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                      child: Text(
                        "Đánh giá",
                        style: GoogleFonts.roboto(
                            fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  formatCurrency(widget.doc["Price"]),
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xffF25822),
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.lineThrough),
                ),
                const SizedBox(
                  width: 28.0,
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Container(
              height: 40,
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(menu.length, (index) {
                  var item = menu[index];
                  return InkWell(
                    onTap: () {
                      selected = index;

                      setState(() {});
                    },
                    child: Container(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: const BoxDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(item,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const Spacer(),
                          (selected == index)
                              ? Container(
                                  height: 2.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff01A688),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        16.0,
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Container(
              height: 250.0,
              margin: const EdgeInsets.symmetric(horizontal: 25.0),
              decoration: const BoxDecoration(),
              child: IndexedStack(index: selected, children: [
                Container(
                  decoration: const BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 22.0,
                      ),
                      SizedBox(
                        height: 128,
                        child: Text("${widget.doc["Description"]}"),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('ratings')
                        .where('DishID', isEqualTo: widget.doc.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        tongDiem = snapshot.data!.docs
                            .fold(0.0, (sum, doc) => sum! + doc["Score"]);
                        rateCount = snapshot.data!.docs.length;
                        trungBinh = double.parse(
                            (tongDiem! / rateCount).toStringAsFixed(1));

                        return Center(
                          child: ListView(
                            itemExtent: 90,
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            children: snapshot.data!.docs
                                .map((ratings) => ratingCard(() {
                                      //Nhấn vào một bình luận
                                    }, ratings))
                                .toList(),
                          ),
                        );
                      }
                      return Text("Not Found");
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 62,
        width: 200,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Visibility(
          visible: loggedInUser?.Role.toString() == 'Customer',
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [
                Container(
                  height: 36,
                  width: 120,
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Color.fromARGB(255, 11, 122, 41),
                          // Button color
                          child: InkWell(
                            splashColor: Colors.white, // Splash color
                            onTap: () {
                              setState(() {
                                sl -= 1;
                              });
                              sl = checkSl(context, sl);
                            },
                            child: SizedBox(
                                width: 35,
                                height: 35,
                                child: Icon(color: Colors.white, Icons.remove)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 27.51,
                        child: Center(
                          child: Text(
                            "${sl}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          color: Color.fromARGB(255, 11, 122, 41),
                          // Button color
                          child: InkWell(
                            splashColor: Colors.white, // Splash color
                            onTap: () {
                              setState(() {
                                sl += 1;
                              });
                              sl = checkSl(context, sl);
                            },

                            child: SizedBox(
                              width: 35,
                              height: 35,
                              child: Icon(color: Colors.white, Icons.add),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 185.29,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFB039),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(62), // <-- Radius
                      ),
                    ),
                    onPressed: () {
                      DishModel dish = DishModel.fromSnapshot(widget.doc);

                      addToCart(context, dish, sl);
                    },
                    child: const Text("Add to cart"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
