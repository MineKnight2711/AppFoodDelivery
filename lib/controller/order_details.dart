import 'package:app_food_2023/model/dishes_model.dart';
import 'package:app_food_2023/model/order_details_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  var customerInfor = ''.obs;
  getUserName(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    customerInfor.value =
        '${userSnapshot['LastName']} ${userSnapshot['FirstName']} - ${userSnapshot['PhoneNumber']} ';
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
                SpinKitFadingCircle(
                  color: Colors.blue,
                  size: 50.0,
                ),
                SizedBox(height: 20),
                Text('Loading...', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
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
        final dishSnapshot = await refDishes
            .where(FieldPath.documentId, whereIn: checkedDishIDs)
            .get();
        dishes.value = dishSnapshot.docs
            .map((doc) => DishModel.fromSnapshot(doc))
            .toList();
        print(dishes.value!.length);
      }
    }
  }
}
