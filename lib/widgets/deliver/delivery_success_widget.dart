import 'package:app_food_2023/controller/delivercontrollers/list_order_controller.dart';
import 'package:app_food_2023/controller/delivercontrollers/order_details_controller.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controller/customercontrollers/cart.dart';

import '../../screens/admin/order_manager/order_class.dart';
import '../../screens/deliver/delivery_order/success_delivery_order_details.dart';

class SuccessDelivery extends StatelessWidget {
  SuccessDelivery({super.key});
  final _controller = Get.find<DeliveryOrdersController>();
  @override
  Widget build(BuildContext context) {
    _controller.successDeliverQuery();
    return Obx(() {
      if (_controller.successDeliveryOrders.value != null) {
        return Center(
          child: ListView.builder(
            itemCount: _controller.successDeliveryOrders.value!.length,
            itemBuilder: (context, index) {
              DocumentSnapshot order =
                  _controller.successDeliveryOrders.value![index];

              return InkWell(
                onTap: () async {
                  Get.put(DeliveryOrderDetailsController(order.id));
                  OrderData orderData = await _controller.getOrderData(order);
                  slideinTransition(
                    context,
                    SuccessDeliverOrderDetailsScreen(orderData: orderData),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã đơn hàng: ${order.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      FutureBuilder<String>(
                        future: _controller.formattedOrderDate(order),
                        builder: (context, snapshot) {
                          return Text(
                            'Ngày đặt hàng: ${snapshot.data}',
                            style: TextStyle(fontSize: 14.0),
                          );
                        },
                      ),
                      SizedBox(height: 8.0),
                      FutureBuilder<String>(
                        future: _controller.getCustomerName(order['UserID']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              'Tên khách hàng: ${snapshot.data}',
                              style: TextStyle(fontSize: 14.0),
                            );
                          }
                          return Center(
                            child: LinearProgressIndicator(),
                          );
                        },
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Tổng tiền: ${formatCurrency(order['Total'])}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Địa chỉ giao hàng: ${order['DeliveryAddress']}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
      return Center(
        child: Text("Chưa có đơn hàng"),
      );
    });
  }
}
