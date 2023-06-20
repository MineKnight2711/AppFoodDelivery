import 'package:app_food_2023/controller/customercontrollers/view_my_order.dart';

import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/customercontrollers/cart.dart';
import '../../../widgets/customer/customer_orderdetails.dart';

class OrdersScreen extends StatelessWidget {
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
                ordercontroller.loadOrderDetails(order.id);
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
                  onTap: () async {
                    // Navigate to order details screen

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return OrderDetailsBottomSheet(
                          doc: order,
                        );
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
