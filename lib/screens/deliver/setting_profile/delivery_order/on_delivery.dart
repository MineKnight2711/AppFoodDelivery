import 'package:app_food_2023/widgets/deliver/on_delivery_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/delivercontrollers/list_order_controller.dart';
import '../../../../widgets/custom_widgets/appbar.dart';

class OnDeliverListOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            Get.delete<DeliveryOrdersController>();
            Navigator.pop(context);
          },
          title: 'Đơn hàng cần thực hiện'),
      body: OnDeliveryOrders(),
    );
  }
}
