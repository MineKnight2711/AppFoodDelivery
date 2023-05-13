import 'package:app_food_2023/controller/cart.dart';

import 'package:app_food_2023/model/dishes_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/check_out.dart';

class CheckedItemsWidget extends StatelessWidget {
  final controller = Get.find<CheckOutController>();
  @override
  Widget build(BuildContext context) {
    controller.loadDishes();
    return Obx(() {
      if (controller.getAllCheckedItems.value != null &&
          controller.dishes.value != null) {
        var listCheckedItems = controller.getAllCheckedItems.value!.toList();
        var listDishes = controller.dishes.value!;
        return ListView.builder(
          itemCount: listCheckedItems.length,
          itemBuilder: (context, index) {
            var item = listCheckedItems[index];
            DishModel? dish =
                listDishes.firstWhereOrNull((d) => d.id == item.dishID);
            if (dish == null) {
              //Xử lý trường hợp không tìm thấy món dựa trên index của listCheckedItems
              return SizedBox.shrink();
            }
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: Image.network(dish.Image ?? '').image,
              ),
              title: Text(dish.Name ?? ''),
              subtitle: Text('Số lượng: ${item.quantity}'),
              trailing: Text('${formatCurrency(item.total)}'),
            );
          },
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
