import 'dart:async';

import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/screens/customer/cart_view.dart';
import 'package:app_food_2023/screens/customer/food_details.dart';
import 'package:app_food_2023/screens/customer/viewdish_by_category.dart';
import 'package:app_food_2023/screens/login_register/login_screen.dart';

import 'package:app_food_2023/widgets/category_view_card.dart';
import 'package:app_food_2023/widgets/food_view_card.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/cart.dart';
import '../controller/user.dart' as u;

import '../widgets/popups.dart';
import '../widgets/transitions_animations.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  String? name;
  final ScrollController _scrollController = ScrollController();
  List<String> recentAddresses = [];
  Stream<QuerySnapshot> getCategorySnapshots() async* {
    yield* FirebaseFirestore.instance.collection('categories').snapshots();
  }

  Stream<QuerySnapshot> getDishesSnapshots() async* {
    yield* FirebaseFirestore.instance
        .collection("dishes")
        .limit(10)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();

    resetCartTotalStream();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    fadeinTransition(context, AppHomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: Material(
              color: Colors.white,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                u.showUserInfor(context),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              u.userAvatar(context),
                              Positioned(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    color: Color(0xFFFF2F08),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset("images/banner.jpg"),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hôm nay ăn gì ?",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Xem tất cả",
                                style: TextStyle(
                                  color: Color(0xFFFF2F08),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      height: 120,
                      decoration:
                          BoxDecoration(color: Color.fromARGB(255, 48, 71, 71)),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: getCategorySnapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView(
                              itemExtent: 130,
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              children: snapshot.data!.docs
                                  .map((category) => categoryViewCard(() {
                                        fadeinTransition(
                                            context, DishByCategory(category));
                                      }, category))
                                  .toList(),
                            );
                          }
                          return Text("Không tìm thấy danh mục",
                              style: GoogleFonts.nunito(color: Colors.white));
                        },
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: getDishesSnapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            final Orientation orientation =
                                MediaQuery.of(context).orientation;
                            return SizedBox(
                              height: MediaHeight(context, 2),
                              child:
                                  NotificationListener<ScrollEndNotification>(
                                onNotification: (notification) {
                                  if (notification.metrics.pixels ==
                                      notification.metrics.maxScrollExtent) {
                                    _scrollController.animateTo(0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  }
                                  return true;
                                },
                                child: GridView.count(
                                  scrollDirection:
                                      (orientation == Orientation.portrait)
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                  physics: ClampingScrollPhysics(),
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 10,
                                  childAspectRatio:
                                      (orientation == Orientation.portrait)
                                          ? MediaAspectRatio(context, 0.321)
                                          : MediaAspectRatio(context, 3.5),
                                  children: snapshot.data!.docs
                                      .map((dish) => Padding(
                                            padding: EdgeInsets.all(
                                                (orientation ==
                                                        Orientation.portrait)
                                                    ? 0
                                                    : 8),
                                            child: foodViewCard(context, () {
                                              slideupTransition(context,
                                                  FoodViewDetails(dish));
                                            }, dish),
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          }
                          return Text("Lỗi",
                              style: GoogleFonts.nunito(color: Colors.white));
                        }),

                    // SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: MyBottomNavigationBar(
            onItemTapped: _onItemTapped,
            selectedIndex: _selectedIndex,
          )),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      if (u.user == null) {
        slideinTransition(context, LoginScreen());
        pleaseLoginPopup(context);
      } else {
        slideinTransition(context, CardScreenView());
      }
    }
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  MyBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Giỏ hàng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.discount_rounded),
          label: 'Voucher của tôi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Cài đặt',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
