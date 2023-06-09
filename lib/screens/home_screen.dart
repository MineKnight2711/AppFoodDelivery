import 'dart:async';

import 'package:app_food_2023/controller/customercontrollers/check_out.dart';
import 'package:app_food_2023/screens/customer/cart_view.dart';
import 'package:app_food_2023/screens/customer/food_details.dart';
import 'package:app_food_2023/screens/customer/viewdish_by_category.dart';

import 'package:app_food_2023/screens/login_register/login_screen.dart';

import 'package:app_food_2023/widgets/list_view_cards/category_view_card.dart';
import 'package:app_food_2023/widgets/list_view_cards/food_view_card.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/user.dart' as u;
import 'package:rxdart/rxdart.dart' as rx;

import '../widgets/custom_widgets/popups.dart';
import '../widgets/custom_widgets/transitions_animations.dart';

class HomeScreenController extends GetxController {
  Rx<double> topcontainer = Rx<double>(0.0);
  Rx<int> selectedindex = Rx<int>(0);
  Rx<Stream<QuerySnapshot>?> categories = Rx<Stream<QuerySnapshot>?>(null);
  Rx<Stream<QuerySnapshot>?> dishes = Rx<Stream<QuerySnapshot>?>(null);
  @override
  void onInit() {
    super.onInit();
    getCategorySnapshots();
    getDishesSnapshots();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getCategorySnapshots() async {
    categories.value =
        await FirebaseFirestore.instance.collection('categories').snapshots();
  }

  Future<void> getDishesSnapshots() async {
    dishes.value = await FirebaseFirestore.instance
        .collection("dishes")
        .limit(10)
        .snapshots();
  }

  void onItemTapped(BuildContext context, int index) {
    selectedindex.value = index;
    if (selectedindex.value == 1) {
      if (u.user == null) {
        slideinTransition(context, LoginScreen());
        pleaseLoginPopup(context);
      } else {
        slideinTransition(context, CardScreenView());
      }
    } else if (selectedindex.value == 0) {
      slideinTransitionNoBack(context, AppHomeScreen());
    }
  }

  Future<void> refresh() async {
    await getCategorySnapshots();
    await getDishesSnapshots();
  }
}

class AppHomeScreen extends StatelessWidget {
  final controller = Get.find<HomeScreenController>();
  final checkoutcontroller = Get.find<CheckOutController>();

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    final _scrollOffset = rx.BehaviorSubject<double>.seeded(0.0);

    _scrollController.addListener(() {
      _scrollOffset.add(_scrollController.offset);
    });

    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height / 7;
    controller.onInit();
    checkoutcontroller.getLocation();
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Obx(() {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: size.height / 24,
              ),
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
                              border: Border.all(color: Colors.white, width: 3),
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
              Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                  ],
                ),
              ),
              CatorigesViewStreamBuilder(
                  scrollOffset: _scrollOffset,
                  categoryHeight: categoryHeight,
                  stream: controller.categories.value),
              DishesViewStreamBuilder(
                  stream: controller.dishes.value,
                  onRefresh: controller.refresh,
                  scrollController: _scrollController),
            ],
          ),
          bottomNavigationBar: MyBottomNavigationBar(
            onItemTapped: (index) => controller.onItemTapped(context, index),
            selectedIndex: controller.selectedindex.value,
          ),
        );
      }),
    );
  }
}

class CatorigesViewStreamBuilder extends StatelessWidget {
  final rx.BehaviorSubject<double> scrollOffset;
  final double categoryHeight;
  final Stream<QuerySnapshot>? stream;
  const CatorigesViewStreamBuilder(
      {required this.scrollOffset,
      required this.categoryHeight,
      required this.stream,
      super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<double>(
      stream: scrollOffset,
      builder: (context, snapshot) {
        final scrollOffset = snapshot.data ?? 0.0;
        final shouldCloseContainer = scrollOffset > (categoryHeight - 50);
        return AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: shouldCloseContainer ? 0.0 : 1.0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: size.width,
            alignment: Alignment.topCenter,
            height: shouldCloseContainer ? 0 : categoryHeight,
            child: FittedBox(
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
              child: Column(children: [
                Container(
                  width: size.width,
                  height: categoryHeight,
                  decoration: BoxDecoration(color: Colors.white),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemExtent: 150,
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final category = snapshot.data!.docs[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: categoryViewCard(() {
                                  slideupTransition(
                                      context, DishByCategory(category));
                                }, category),
                              );
                            });
                      }
                      return Text("Không tìm thấy danh mục",
                          style: GoogleFonts.nunito(color: Colors.white));
                    },
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class DishesViewStreamBuilder extends StatelessWidget {
  final Stream<QuerySnapshot>? stream;
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  const DishesViewStreamBuilder(
      {required this.stream,
      required this.onRefresh,
      required this.scrollController,
      super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          final Orientation orientation = MediaQuery.of(context).orientation;
          return Expanded(
            child: RefreshIndicator(
              color: Colors.green,
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                controller: scrollController,
                scrollDirection: (orientation == Orientation.portrait)
                    ? Axis.vertical
                    : Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final dish = snapshot.data!.docs[index];

                  return Align(
                    heightFactor: 1,
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(
                          (orientation == Orientation.portrait) ? 10 : 8),
                      child: foodViewCard(context, () {
                        slideupTransition(context, FoodViewDetails(dish));
                      }, dish),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return Text("Chưa có món :((",
            style: GoogleFonts.nunito(color: Colors.white));
      },
    );
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
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
