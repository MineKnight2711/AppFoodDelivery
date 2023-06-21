import 'package:app_food_2023/model/dishes_model.dart';
import 'package:app_food_2023/model/order_details_model.dart';
import 'package:app_food_2023/model/voucher_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/cart_model.dart';

class DataConverter {
  static Set<CartItem> convertOrderDetailsListToCartItemSet(
      List<OrderDetailsModel> orderDetailsList) {
    return orderDetailsList
        .map((orderDetails) => CartItem(
              dishID: orderDetails.DishID,
              quantity: orderDetails.Amount ?? 1,
              total: (orderDetails.Price ?? 0.0) *
                  double.parse(orderDetails.Amount.toString()),
            ))
        .toSet();
  }
}

class MyOrderController extends GetxController {
  Rx<List<OrderDetailsModel>> listorderdetails =
      Rx<List<OrderDetailsModel>>([]);
  RxDouble total = 0.0.obs;

  void caculateTotal() {
    total.value = listorderdetails.value.fold(
        0.0,
        (previousValue, element) =>
            previousValue +
            (double.parse(element.Price.toString()) *
                double.parse(element.Amount.toString())));
  }

  Future<void> cancelOrder(String orderId) async {
    if (orderId != '') {
      final orderRef =
          await FirebaseFirestore.instance.collection('orders').doc(orderId);
      await orderRef.update({
        'OrderStatus': 'Đã huỷ',
      });
    }
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
    caculateTotal();
    return dishList;
  }

  Set<CartItem> reOrder(List<OrderDetailsModel> listOfOrderItems) {
    return DataConverter.convertOrderDetailsListToCartItemSet(listOfOrderItems);
  }
}
