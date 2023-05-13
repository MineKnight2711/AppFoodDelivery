import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/controller/check_out.dart';
import 'package:app_food_2023/screens/customer/cart_view.dart';
import 'package:app_food_2023/screens/customer/coupons_list.dart';
import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/widgets/message.dart';
import 'package:app_food_2023/widgets/transitions_animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../../api/seach_place.dart';
import '../../controller/cart.dart';

import '../../widgets/check_out/check_out_list_dish.dart';
import '../../widgets/check_out/order_sucess.dart';

class CheckoutScreenView extends StatelessWidget {
  final controller = Get.find<CheckOutController>();

  @override
  Widget build(BuildContext context) {
    controller.loadDishes();
    controller.getLocation();
    return Obx(() {
      return Scaffold(
        backgroundColor: const Color(0xffE9F1F5),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Thanh Toán",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              slideinTransitionNoBack(context, CardScreenView());
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 24.0,
              color: Colors.black,
            ),
          ),
          actions: [
            Container(
              width: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.trolley,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 30,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        "${checkedItems.length}",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 23.0,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 24.0,
                ),
                Container(
                  height: 130.99,
                  width: 335,
                  decoration: const BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Địa chỉ giao",
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 100.0,
                        width: 335,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              16.0,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => Text(
                                      '${controller.getaddress.value}',
                                      style: GoogleFonts.roboto(
                                          fontSize:
                                              MediaAspectRatio(context, 0.03)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      slideinTransition(context, AddressPage());
                                    },
                                    child: Text(
                                      'Thay đổi',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 209.75,
                  width: 335,
                  decoration: BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sản phẩm",
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 180.0,
                        width: 335,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              16.0,
                            ),
                          ),
                        ),
                        child: CheckedItemsWidget(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 300,
                  width: 335,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tóm tắt thanh toán",
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 150,
                        width: 335,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              16.0,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text("Tổng:",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xff516971),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                                const Spacer(),
                                Text(
                                    "${formatCurrency(controller.initialTotal.value)}",
                                    style: GoogleFonts.poppins(
                                        color: Color.fromARGB(255, 0, 7, 10),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Text("Mã giảm giá: ",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xff516971),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                                const Spacer(),
                                Text(
                                    "- ${formatCurrency(controller.vouchervalue.value ?? 0.0)}",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xff516971),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Text("Tạm tính:",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xff516971),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                                const Spacer(),
                                Text(
                                    "${formatCurrency(controller.finalTotal.value)}",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xff516971),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: MediaHeight(context, 6),
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                32.0,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Thực hiện hành động khi người dùng nhấn vào chữ "Collect Coupon"
                      controller.showPaymentDialog(context);
                    },
                    child: Text(
                        "${controller.selectedPaymentMethod.value ?? "Phương thức thanh toán"}",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 90, 95, 97),
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    CupertinoIcons.arrowtriangle_up_circle,
                    size: 18,
                    color: const Color(0xff516971),
                  ),
                  SizedBox(
                    width: 10.5,
                  ),
                  Spacer(),
                  Text("|",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 123, 133, 136),
                      )),
                  SizedBox(
                    width: 7,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Thực hiện hành động khi người dùng nhấn vào chữ "Collect Coupon"
                      slideinTransition(context, CouponsListCustomer());
                    },
                    child: Text(
                      "THÊM VOUCHER",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff01A688),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text("${formatCurrency(controller.initialTotal.value)}",
                          style: GoogleFonts.poppins(
                              decoration: TextDecoration.lineThrough,
                              color: const Color(0xff516971),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      Text("${formatCurrency(controller.finalTotal.value)}",
                          style: GoogleFonts.poppins(
                              color: const Color(0xff02A88A),
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: 250.29,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFFB039),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(62), // <-- Radius
                          // ),
                        ),
                        onPressed: () async {
                          controller.isLoading.value = true;
                          Future.delayed(
                            const Duration(seconds: 3),
                            () async {
                              controller.isLoading.value = false;
                              await controller
                                  .saveOrder(context)
                                  .whenComplete(() {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return OrderSuccesDialog(
                                      imagePath:
                                          'assets/images/icon-succes-transaction.png',
                                      buttonText: 'OK',
                                      message:
                                          'Đơn hàng đã được đặt thành công!',
                                      onButtonPressed: () {
                                        slideinTransitionNoBack(
                                            context, AppHomeScreen());
                                        Get.delete<CheckOutController>();
                                      },
                                    );
                                  },
                                );
                              }).catchError((e) {
                                CustomErrorMessage.showMessage(
                                    'Có lỗi xảy ra: \n' + "$e");
                              });
                            },
                          );
                        },
                        child: (controller.isLoading.value != false)
                            ? const CircularProgressIndicator()
                            : const Text("Thanh Toán")),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
