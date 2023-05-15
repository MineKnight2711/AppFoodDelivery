import 'package:app_food_2023/controller/order_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/cart.dart';
import '../../model/dishes_model.dart';

class OrderDetailsInfor extends StatelessWidget {
  final controller = Get.find<OrderDetailsController>();
  @override
  Widget build(BuildContext context) {
    controller.getOrderDetails();
    return Obx(() {
      if (controller.orderdetails.value != null &&
          controller.dishes.value != null) {
        var listOrderDetails = controller.orderdetails.value!;
        var listDishes = controller.dishes.value!;
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: listOrderDetails.length,
          itemBuilder: (context, index) {
            var item = listOrderDetails[index];
            double? itemTotal =
                item.Price! * double.parse(item.Amount.toString());
            DishModel? dish =
                listDishes.firstWhereOrNull((d) => d.id == item.DishID);
            if (dish == null) {
              //Xử lý trường hợp không tìm thấy món dựa trên index của listCheckedItems
              return SizedBox.shrink();
            }
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: Image.network(dish.Image ?? '').image,
              ),
              title: Text(dish.Name ?? ''),
              subtitle: Text('Số lượng: ${item.Amount}'),
              trailing: Text('${formatCurrency(itemTotal)}'),
            );
          },
        );
      } else {
        controller.getOrderDetails();
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
