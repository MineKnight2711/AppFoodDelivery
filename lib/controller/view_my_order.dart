import 'package:app_food_2023/controller/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../model/UserModel.dart';

class MyOrderController extends GetxController {
  Rx<List<UserModel>> userModel = Rx<List<UserModel>>([]);
  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<List<QueryDocumentSnapshot>> loadOrders() async {
    final orderRef = await FirebaseFirestore.instance.collection('orders');

    final orderSnapshot = await orderRef
        .where('UserID', isEqualTo: user?.uid)
        .orderBy('OrderDate')
        .orderBy('Total', descending: false)
        .get();
    // await loadOrders();
    return orderSnapshot.docs;
  }

  Future<void> loadOrdersWithUserModel(String orderID) async {}
}
