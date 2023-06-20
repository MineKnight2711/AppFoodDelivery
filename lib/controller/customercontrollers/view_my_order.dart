import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/model/dishes_model.dart';
import 'package:app_food_2023/model/order_details_model.dart';
import 'package:app_food_2023/model/voucher_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MyOrderController extends GetxController {
  Rx<List<OrderDetailsModel>> listorderdetails =
      Rx<List<OrderDetailsModel>>([]);

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

    return orderSnapshot.docs;
  }

  Future<Voucher> loadVoucher(String? voucherID) async {
    final voucherSnapshot = await FirebaseFirestore.instance
        .collection('coupons')
        .doc(voucherID)
        .get();
    return Voucher.fromSnapshot(voucherSnapshot);
  }

  Future<List<DishModel>> loadOrderDetails(String orderID) async {
    final orderdetailsSnapshot = await FirebaseFirestore.instance
        .collection('order_details')
        .where('OrderID', isEqualTo: orderID)
        .get();
    listorderdetails.value = orderdetailsSnapshot.docs
        .map((doc) => OrderDetailsModel.fromSnapshotOrder(doc))
        .toList();
    final dishIDs = orderdetailsSnapshot.docs
        .map((doc) => doc['DishID'] as String)
        .toList();

    final refDishes = FirebaseFirestore.instance.collection('dishes');
    List<List<String?>> idChunks = [];
    for (int i = 0; i < dishIDs.length; i += 10) {
      idChunks.add(dishIDs.sublist(
          i, i + 10 < dishIDs.length ? i + 10 : dishIDs.length));
    }

    List<DishModel> dishList = [];
    for (final chunk in idChunks) {
      final dishRef =
          await refDishes.where(FieldPath.documentId, whereIn: chunk).get();
      dishList.addAll(
          dishRef.docs.map((doc) => DishModel.fromSnapshot(doc)).toList());
    }

    return dishList;
  }
}
