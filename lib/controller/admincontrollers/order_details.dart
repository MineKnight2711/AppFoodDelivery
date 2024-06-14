import 'package:app_food_2023/model/deliver_model.dart';
import 'package:app_food_2023/model/dishes_model.dart';
import 'package:app_food_2023/model/order_details_model.dart';
import 'package:app_food_2023/widgets/custom_widgets/message.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  Rx<List<OrderDetailsModel>?> orderdetails =
      Rx<List<OrderDetailsModel>?>(null);

  Rx<List<DishModel>?> dishes = Rx<List<DishModel>?>(null);
  Rx<String?> orderID = Rx<String?>('');
  Rx<double?> orderTotal = Rx<double?>(0.0);
  OrderDetailsController(String? orderID) {
    this.orderID.value = orderID;
  }

  @override
  void onInit() {
    super.onInit();
    getOrderDetails();
  }

  disposeData() {
    dishes.value = null;
    orderdetails.value = null;
    orderID.value = null;
    orderTotal.value = null;
  }

  @override
  void onClose() {
    super.onClose();
    disposeData();
  }

  @override
  void dispose() {
    super.dispose();
    disposeData();
  }

  Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        // Hiển thị popup loading
        return AlertDialog(
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text('Loading...', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<DeliverModel>> loadDeliver() async {
    final deliverSnapshot =
        await FirebaseFirestore.instance.collection('users');

    final deliverRef =
        await deliverSnapshot.where('Role', isEqualTo: 'Delivery').get();
    return deliverRef.docs
        .map((doc) => DeliverModel.fromSnapshot(doc))
        .toList();
  }

  Future<void> choseDeliver(BuildContext context, DeliverModel deliver) async {
    if (orderID.value != null) {
      final orderRef = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderID.value);
      await orderRef.update({
        'DeliverID': deliver.id,
        'OrderStatus': 'Đã giao cho Delivery',
      }).whenComplete(() {
        CustomSnackBar.showCustomSnackBar(
            context, "Bạn đã chọn ${deliver.LastName} ${deliver.FirstName}", 1,
            backgroundColor: Colors.green);
        Navigator.pop(context);
      });
    }
  }

  Future<void> getOrderDetails() async {
    if (orderID.value != null) {
      final orderDetailsRef = await FirebaseFirestore.instance
          .collection('order_details')
          .where("OrderID", isEqualTo: orderID.value)
          .get();
      orderdetails.value = orderDetailsRef.docs
          .map((doc) => OrderDetailsModel.fromSnapshotOrder(doc))
          .toList();

      if (orderdetails.value != null) {
        List<String?> checkedDishIDs =
            orderdetails.value!.map((item) => item.DishID).toList();
        final refDishes = FirebaseFirestore.instance.collection('dishes');
        List<DishModel> allDishes = [];

        List<List<String?>> idChunks = [];
        for (var i = 0; i < checkedDishIDs.length; i += 10) {
          idChunks.add(checkedDishIDs.sublist(i,
              i + 10 > checkedDishIDs.length ? checkedDishIDs.length : i + 10));
        }

        for (var chunk in idChunks) {
          QuerySnapshot dishSnapshot =
              await refDishes.where(FieldPath.documentId, whereIn: chunk).get();
          List<DishModel> dishes = dishSnapshot.docs
              .map((doc) => DishModel.fromSnapshot(doc))
              .toList();
          allDishes.addAll(dishes);
        }

        dishes.value = allDishes;
        print(dishes.value!.length);
      }
    }
  }
}
