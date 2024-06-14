import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/model/dishes_model.dart';
import 'package:app_food_2023/model/order_details_model.dart';
import 'package:app_food_2023/model/voucher_model.dart';
import 'package:app_food_2023/widgets/custom_widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';

import '../../controller/customercontrollers/cart.dart';
import '../../controller/customercontrollers/check_out.dart';
import '../../controller/customercontrollers/view_my_order.dart';
import '../../screens/customer/check_out.dart';
import '../custom_widgets/transitions_animations.dart';

class OrderDetailsBottomSheet extends StatelessWidget {
  final DocumentSnapshot doc;
  OrderDetailsBottomSheet({required this.doc, Key? key}) : super(key: key);
  final ordercontroller = Get.find<MyOrderController>();
  final checkoutController = Get.find<CheckOutController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ordercontroller.caculateTotal();
    return Container(
      height: size.height * 0.91,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.aspectRatio * 20),
                  child: Center(
                    child: Text(
                      'Chi tiết đơn hàng',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollEdgeListener(
              edge: ScrollEdge.start,
              continuous: false,
              dispatch: true,
              listener: () {
                // ordercontroller.total.value = 0;
                // Navigator.pop(context);
              },
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset('assets/images/foodsbanner.jpg'),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: size.height / 18,
                        width: size.width,
                        child: (doc["OrderStatus"] == 'Đã giao' ||
                                doc["OrderStatus"] == 'Đã huỷ')
                            ? ElevatedButton(
                                onPressed: () async {
                                  checkoutController.getAllCheckedItems.value =
                                      checkedItems = ordercontroller.reOrder(
                                          ordercontroller
                                              .listorderdetails.value);

                                  await checkoutController
                                      .getAllDishInfo()
                                      .whenComplete(() => slideupTransition(
                                          context, CheckoutScreenView()));
                                },
                                child: Text(
                                  "Đặt lại",
                                  style: GoogleFonts.nunito(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              )
                            : (doc["OrderStatus"] == 'Chưa xác nhận'
                                ? ElevatedButton(
                                    onPressed: () async {
                                      return await showDialog(
                                        context: context,
                                        builder: (context1) {
                                          return AlertDialog(
                                            title: Text('Xác nhận'),
                                            content: Text(
                                                'Bạn có chắc muốn huỷ đơn này?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context1)
                                                      .pop(false);
                                                },
                                                child: Text(
                                                  'Thôi',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await ordercontroller
                                                      .cancelOrder(doc.id);
                                                  Navigator.of(context1)
                                                      .pop(true);
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                                  CustomSuccessMessage
                                                      .showMessage(
                                                          'Đã huỷ thành công');
                                                },
                                                child: Text(
                                                  'Huỷ',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Huỷ đơn",
                                      style: GoogleFonts.nunito(fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                    'Đơn hàng đang được thực hiện...',
                                    style: GoogleFonts.nunito(fontSize: 16),
                                  ))),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Thông tin đơn hàng',
                                  style: GoogleFonts.nunito(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Tên người nhận',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                      Text(
                                        '${loggedInUser?.LastName} ${loggedInUser?.FirstName}',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 40,
                                    width: 0.8,
                                    color: Colors.black,
                                  ),
                                ),
                                Positioned(
                                  right: 90,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Số điện thoại',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                      Text(
                                        '${loggedInUser?.PhoneNumber}',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Trạng thái thanh toán: ',
                                  style: GoogleFonts.nunito(fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                doc['PaymentStatus'] == false
                                    ? Icon(
                                        CupertinoIcons.xmark_circle_fill,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        CupertinoIcons.check_mark_circled_solid,
                                        color: Colors.green,
                                      ),
                                Text(
                                  doc['PaymentStatus'] == false
                                      ? 'Chưa thanh toán'
                                      : 'Đã thanh toán',
                                  style: GoogleFonts.nunito(fontSize: 13),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Voucher đã sử dụng: ',
                                  style: GoogleFonts.nunito(fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Mã đơn hàng: ',
                                  style: GoogleFonts.nunito(fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${doc.id}',
                                  style: GoogleFonts.nunito(fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Sản phẩm đã chọn',
                                  style: GoogleFonts.nunito(fontSize: 16),
                                ),
                              ],
                            ),
                            FutureBuilder<List<DishModel>>(
                              future: ordercontroller.loadOrderDetails(doc.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    padding: EdgeInsets.only(top: 8),
                                    height: (size.height / 21) *
                                        snapshot.data!.length,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        DishModel? dish = snapshot.data![index];
                                        OrderDetailsModel? orderdetail =
                                            ordercontroller
                                                .listorderdetails.value
                                                .firstWhereOrNull(
                                                    (d) => d.DishID == dish.id);

                                        double totalPrice = 0;
                                        if (orderdetail == null) {
                                          //Xử lý trường hợp không tìm thấy món dựa trên index của orderdetailquantity
                                          return SizedBox.shrink();
                                        } else {
                                          totalPrice =
                                              orderdetail.Amount! * dish.Price!;
                                        }

                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('${orderdetail.Amount}'),
                                                Expanded(
                                                    child: Text('${dish.Name}',
                                                        textAlign:
                                                            TextAlign.center)),
                                                Text(
                                                  '${formatCurrency(totalPrice.toDouble())}',
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 20,
                                              thickness: 1.5,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }
                                return Center(
                                  child: Text('Đang tải...'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: FutureBuilder<Voucher>(
                          future: ordercontroller.loadVoucher(doc['VoucherID']),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Tổng cộng',
                                        style: GoogleFonts.nunito(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Thành tiền',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                      Obx(() => Text(
                                            '${formatCurrency(ordercontroller.total.value)}',
                                            style: GoogleFonts.nunito(
                                                fontSize: 13),
                                          )),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Voucher đã sử dụng',
                                        style: GoogleFonts.nunito(
                                            fontSize: 14, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${snapshot.data!.code}',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                      Text(
                                        '-${snapshot.data!.amount}',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Số tiền thanh toán',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                      Obx(() => Text(
                                            '${ordercontroller.total.value - snapshot.data!.amount}',
                                            style: GoogleFonts.nunito(
                                                fontSize: 13),
                                          )),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Phương thức thanh toán',
                                        style: GoogleFonts.nunito(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      doc['PaymentMethod'] == "Tiền mặt"
                                          ? Image.asset(
                                              'assets/images/money.png',
                                              scale: 2.5,
                                            )
                                          : Image.asset(
                                              'assets/images/momo.png',
                                              scale: 2.5,
                                            ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        '${doc['PaymentMethod']}',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Tổng cộng',
                                      style: GoogleFonts.nunito(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Thành tiền',
                                      style: GoogleFonts.nunito(fontSize: 13),
                                    ),
                                    Obx(() => Text(
                                          '${formatCurrency(ordercontroller.total.value)}',
                                          style:
                                              GoogleFonts.nunito(fontSize: 13),
                                        )),
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Voucher đã sử dụng',
                                      style: GoogleFonts.nunito(
                                          fontSize: 14, color: Colors.green),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Không có',
                                      style: GoogleFonts.nunito(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 20,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Số tiền thanh toán',
                                      style: GoogleFonts.nunito(fontSize: 13),
                                    ),
                                    Obx(
                                      () => Text(
                                        '${formatCurrency(ordercontroller.total.value)}',
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Phương thức thanh toán',
                                      style: GoogleFonts.nunito(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    doc['PaymentMethod'] == "Tiền mặt"
                                        ? Image.asset(
                                            'assets/images/money.png',
                                            scale: 2.5,
                                          )
                                        : Image.asset(
                                            'assets/images/momo.png',
                                            scale: 5,
                                          ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      '${doc['PaymentMethod']}',
                                      style: GoogleFonts.nunito(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
