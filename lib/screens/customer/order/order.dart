import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/controller/view_my_order.dart';
import 'package:app_food_2023/model/order_model.dart';
import 'package:app_food_2023/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cart.dart';

class OrdersScreen extends StatelessWidget {
  // final List<Map<String, dynamic>> orders = [
  //   {
  //     'UserID': 'user1',
  //     'DeliverID': 'deliver1',
  //     'VoucherID': 'voucher1',
  //     'PaymentStatus': true,
  //     'OrderStatus': 'Delivered',
  //     'OrderDate': DateTime.now(),
  //     'Total': 99.99,
  //     'Amount': 1,
  //     'PaymentMethod': 'Credit Card',
  //     'DeliveryAddress': '123 Main St, Anytown, USA',
  //   },
  //   {
  //     'UserID': 'user2',
  //     'DeliverID': 'deliver2',
  //     'VoucherID': 'voucher2',
  //     'PaymentStatus': false,
  //     'OrderStatus': 'Pending',
  //     'OrderDate': DateTime.now().subtract(Duration(days: 1)),
  //     'Total': 49.99,
  //     'Amount': 2,
  //     'PaymentMethod': 'PayPal',
  //     'DeliveryAddress': '456 Elm St, Anytown, USA',
  //   },
  // ];
  final ordercontroller = Get.find<MyOrderController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Đơn hàng của tôi'),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: ordercontroller.loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return ListTile(
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            Image.asset('assets/images/burger.png').image,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Đơn hàng :${order.id}'),
                    ],
                  ),
                  subtitle: Container(
                    height: 55,
                    child: Row(
                      children: [
                        Text('Tổng tiền: ${formatCurrency(order['Total'])}'),
                        Spacer(),
                        Text(order['OrderStatus']),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Navigate to order details screen
                    showModalBottomSheet<dynamic>(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return OrderDetailsBottomSheet();
                      },
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: Text('Không tìm thấy dơn hàng!'),
          );
        },
      ),
    );
  }
}
