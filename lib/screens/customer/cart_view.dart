import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/model/dishes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/cart.dart';
import '../../model/cart_model.dart';
import '../../widgets/cart_view/cart_screen.dart';
import '../../widgets/popups.dart';

class CardScreenView extends StatefulWidget {
  const CardScreenView({Key? key}) : super(key: key);

  @override
  State<CardScreenView> createState() => _CardScreenViewState();
}

class _CardScreenViewState extends State<CardScreenView> {
  @override
  void initState() {
    super.initState();
    resetCartTotalStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Giỏ hàng của tôi",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            resetCartTotalStream();

            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24.0,
            color: Colors.black,
          ),
        ),
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
                    if (user == null) {
                      return Center(
                        child: Text(
                          "Giỏ hàng trống không :((",
                          style: GoogleFonts.roboto(fontSize: 20),
                        ),
                      );
                    }
                    if (snapshot.data?.docs.length == 0) {
                      return Center(
                        child: Text(
                          "Giỏ hàng trống không :((",
                          style: GoogleFonts.roboto(fontSize: 20),
                        ),
                      );
                    }
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
                      child: Text(
                        "Giỏ hàng trống không :((",
                        style: GoogleFonts.roboto(fontSize: 20),
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
        child: Container(
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
                width: ScreenRotate(context) ? 23.0 : MediaWidth(context, 2.3),
              ),
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
                      // Navigator.push(
                      // context,
                      // MaterialPageRoute(builder: (context) => const CheckoutScreenView()),
                      // );
                    },
                    child: Text('Thanh toán ${checkedItems.length}')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
