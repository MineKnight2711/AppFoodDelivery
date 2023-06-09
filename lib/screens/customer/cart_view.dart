import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/controller/user.dart' as u;
import 'package:app_food_2023/model/dishes_model.dart';
import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';
import 'package:app_food_2023/widgets/custom_widgets/message.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/customercontrollers/cart.dart';
import '../../controller/customercontrollers/check_out.dart';
import '../../model/cart_model.dart';
import '../../widgets/customer/cart_view/cart_screen.dart';
import '../../widgets/custom_widgets/popups.dart';
import 'check_out.dart';

class CardScreenView extends StatefulWidget {
  const CardScreenView({Key? key}) : super(key: key);

  @override
  State<CardScreenView> createState() => _CardScreenViewState();
}

class _CardScreenViewState extends State<CardScreenView> {
  final homecontroller = Get.find<HomeScreenController>();
  final checkoutController = Get.find<CheckOutController>();
  @override
  void initState() {
    super.initState();
    resetCartTotalStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          resetCartTotalStream();

          slideinTransitionNoBack(context, AppHomeScreen());
        },
        title: 'Giỏ hàng của tôi',
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 19.0),

                child: Row(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: cartListStream(),
                      builder: (context, snapshot) {
                        if (snapshot.data?.docs.isNotEmpty == true) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Visibility(
                              visible: true,
                              child: Row(
                                children: [
                                  FutureBuilder<bool>(
                                      future: compareCart(),
                                      builder: (context, snapshot) {
                                        bool checkboxValue =
                                            snapshot.data ?? false;
                                        return Checkbox(
                                          value: checkboxValue
                                              ? checkedItems.isNotEmpty
                                              : isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked = value ?? false;
                                              checkedAll();
                                            });
                                          },
                                        );
                                      }),
                                  Text(
                                    "Chọn tất cả",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          width: 1,
                        );
                      },
                    ),
                    Spacer(),
                    FutureBuilder<bool>(
                        future: compareCart(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == true) {
                              return Visibility(
                                visible: snapshot.data!,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFDA4453),
                                        Color(0xFF89216B)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      confirmDelete(context);
                                    },
                                    splashColor:
                                        Colors.red, // Set the splash color
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Xoá giỏ hàng',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return FutureBuilder<bool>(
                                future: getCurrentCheckedItems(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data == true) {
                                      return Visibility(
                                        visible: snapshot.data!,
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFDA4453),
                                                Color(0xFF89216B)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                isChecked = false;

                                                removeChosenItems();
                                                checkedItems.clear();
                                                // getCurrentCheckedItems();
                                                // compareCart();
                                              });
                                            },
                                            splashColor: Colors
                                                .red, // Set the splash color
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Xoá ${checkedItems.length} món',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  return Spacer();
                                },
                              );
                            }
                          }
                          return Spacer();
                        }),
                    SizedBox(
                      width: MediaWidth(context, 8 * 2),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: cartListStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      cartItems = snapshot.data!.docs
                          .map((doc) => CartItem.fromSnapshotCart(doc))
                          .toList();

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data?.docs[index];
                          CartItem cartItem = cartItems![index];

                          return Column(
                            children: [
                              Container(
                                height: MediaHeight(context, 120),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[100]!,
                                      Colors.blue[300]!
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              Stack(children: [
                                Dismissible(
                                  key: Key(cartItems![index].dishID.toString()),
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                    ),
                                    child: Row(
                                      children: const [
                                        Spacer(),
                                        Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) async {
                                    await removeFromCart(item?['DishID']);
                                    setState(() {
                                      cartItems!.remove(cartItem);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: ScreenRotate(context)
                                            ? MediaAspectRatio(context, 0.07)
                                            : MediaAspectRatio(context, 0.15)),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 191, 216, 109),
                                    ),
                                    height: ScreenRotate(context)
                                        ? MediaHeight(context, 7)
                                        : MediaHeight(context, 3),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(children: [
                                      Checkbox(
                                        value: isChecked!
                                            ? true
                                            : checkedItems.any((element) =>
                                                element.dishID ==
                                                item?["DishID"]),
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked = false;

                                            toggleChecked(cartItem);
                                          });
                                        },
                                      ),
                                      Stack(
                                        children: [
                                          FutureBuilder<DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('dishes')
                                                .doc(cartItems?[index].dishID)
                                                .get(),
                                            builder: (context, d_snapshot) {
                                              if (d_snapshot.hasData) {
                                                var dish =
                                                    DishModel.fromSnapshot(
                                                        d_snapshot.data!);
                                                return Wrap(
                                                  children: [
                                                    CartViewDishImage(
                                                      imageUrl: '${dish.Image}',
                                                    ),
                                                    CartViewDishName(
                                                        name: '${dish.Name}')
                                                  ],
                                                );
                                              }
                                              return CircularProgressIndicator();
                                            },
                                          ),
                                          CartItemQuantity(
                                              initialQuantity:
                                                  cartItem.quantity,
                                              price: cartItem.total,
                                              itemId: item?['DishID'])
                                        ],
                                      ),
                                    ]),
                                  ),
                                ),
                              ]),
                              Container(
                                height: MediaHeight(context, 120),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[300]!,
                                      Colors.blue[100]!,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Image.asset('assets/gifs/emptycart.gif'),
                          Text(
                            "Giỏ hàng trống không :((",
                            style: GoogleFonts.roboto(fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 116.44,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Thành tiền",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      CartTotal(),
                    ],
                  ),
                  SizedBox(
                    width:
                        ScreenRotate(context) ? 23.0 : MediaWidth(context, 2.3),
                  ),
                  SizedBox(
                    width: 185.29,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFFB039),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(62), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          if (checkedItems.isEmpty) {
                            CustomErrorMessage.showMessage(
                                'Chọn ít nhất 1 sản phẩm để đặt hàng!');
                            return;
                          }
                          if (u.loggedInUser?.PhoneNumber == null) {
                            Future.delayed(Duration(seconds: 3), () {
                              CustomSnackBar.showCustomSnackBar(
                                context,
                                'Vui lòng kiểm tra số điện thoại hoặc địa chỉ để chúng tôi có thể giao hàng đến bạn!',
                                2,
                                backgroundColor: Colors.red,
                              );
                            });

                            CustomErrorMessage.showMessage(
                              'Bạn chưa cập nhật thông tin nên không thể đặt hàng!',
                            );
                            return;
                          }
                          // checkoutController.getAllCheckedItems.value =
                          //     checkedItems;
                          // checkoutController.getAllDishInfo();
                          // Get.put(CheckOutController(checkedItems));

                          slideupTransition(context, CheckoutScreenView());
                        },
                        child: Text(
                          'Đặt mua ${checkedItems.length} ',
                          style: GoogleFonts.roboto(
                              fontSize: 16, color: Colors.black),
                        )),
                  ),
                ],
              ),
            ),
            MyBottomNavigationBar(
              onItemTapped: (index) =>
                  homecontroller.onItemTapped(context, index),
              selectedIndex: homecontroller.selectedindex.value,
            ),
          ],
        ),
      ),
    );
  }
}
