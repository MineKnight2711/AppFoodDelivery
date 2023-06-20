import 'package:app_food_2023/widgets/custom_widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/dishes_model.dart';
import '../../model/order_details_model.dart';

class DeliveryOrderDetailsController extends GetxController {
  Rx<List<OrderDetailsModel>?> orderdetails =
      Rx<List<OrderDetailsModel>?>(null);

  Rx<List<DishModel>?> dishes = Rx<List<DishModel>?>(null);
  Rx<String?> orderID = Rx<String?>('');
  Rx<double?> orderTotal = Rx<double?>(0.0);
  DeliveryOrderDetailsController(String? orderID) {
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

  Future<void> selectOrder(BuildContext context) async {
    if (orderID.value != null) {
      final orderRef = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderID.value);
      await orderRef.update({
        'OrderStatus': 'Đang giao',
      }).whenComplete(() {
        CustomSnackBar.showCustomSnackBar(context, 'Nhận đơn thành công', 1,
            backgroundColor: Colors.green);
      }).catchError(
          (error) => CustomErrorMessage.showMessage('Có lỗi xảy ra ${error}'));
    }
  }

  Future<void> confirmDeliverySuceedOrder() async {
    if (orderID.value != null) {
      final orderRef = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderID.value);
      await orderRef
          .update({
            'OrderStatus': 'Đã giao',
          })
          .whenComplete(() {})
          .catchError((error) =>
              CustomErrorMessage.showMessage('Có lỗi xảy ra ${error}'));
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
