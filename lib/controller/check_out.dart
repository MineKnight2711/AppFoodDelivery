import 'package:app_food_2023/model/cart_model.dart';
import 'package:app_food_2023/model/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/dishes_model.dart';
import '../model/order_details_model.dart';
import '../screens/customer/payment_method.dart';
import '../widgets/message.dart';
import 'cart.dart';

class CheckOutController extends GetxController {
  Rx<Set<CartItem>?> getAllCheckedItems = Rx<Set<CartItem>?>(null);
  Rx<List<DishModel>?> dishes = Rx<List<DishModel>?>(null);
  Rx<bool> isLoading = Rx<bool>(false);

  CheckOutController(Set<CartItem> getAllCheckedItems) {
    this.getAllCheckedItems.value = getAllCheckedItems;
  }

  Rx<String?> getaddress = Rx<String?>('');
  Rx<CartItem?> buycheckitem = Rx<CartItem?>(null);

  Rx<double?> initialTotal = Rx<double?>(0.0);
  Rx<double?> vouchervalue = Rx<double?>(0.0);
  Rx<double?> finalTotal = Rx<double?>(0.0);

  Rx<String?> voucherID = Rx<String?>('');
  Rx<String?> selectedPaymentMethod = Rx<String?>('Tiền mặt');

  @override
  void onInit() {
    super.onInit();
    getLocation();
    loadDishes();
  }

  disposeValue() {
    getaddress.value = null;
  }

  @override
  void onClose() {
    super.onClose();
    disposeValue();
  }

  @override
  void dispose() {
    super.dispose();
    disposeValue();
  }

  Future<void> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getString("diachiHienTai");

    getaddress.value = location;
  }

  void loadDishes() async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      dishes.value = await getAllDishInfo();
    }
  }

  void resetData() {
    getAllCheckedItems.value = null;
    dishes.value = null;
  }

  Future<void> passVocherValue(double? value, String? voucherId) async {
    vouchervalue.value = value ?? 0.0;
    voucherID.value = voucherId;
    await caculteFinalTotal();
  }

  Future<List<DishModel>?> getAllDishInfo() async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      List<String?> checkedDishIDs =
          getAllCheckedItems.value!.map((item) => item.dishID).toList();
      final refDishes = FirebaseFirestore.instance.collection('dishes');
      final dishSnapshot = await refDishes
          .where(FieldPath.documentId, whereIn: checkedDishIDs)
          .get();
      await caculteFinalTotal();
      return dishSnapshot.docs
          .map((doc) => DishModel.fromSnapshot(doc))
          .toList();
    }
    return Future.value(null);
  }

  Future<void> caculteFinalTotal() async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      initialTotal.value = getAllCheckedItems.value!.fold(
        0,
        (previousValue, item) => previousValue! + item.total,
      );
      double total = initialTotal.value ?? 0.0;
      double voucher = vouchervalue.value ?? 0.0;
      finalTotal.value = total - voucher;
    }
  }

  Future<void> showPaymentDialog(BuildContext context) async {
    final selectedMethod = await showDialog(
      context: context,
      builder: (context) => PaymentDialog(),
    );

    selectedPaymentMethod.value = selectedMethod;
  }

  Future<void> deleteOrderedDishes() async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      List<String?> checkedDishIDs =
          getAllCheckedItems.value!.map((item) => item.dishID).toList();
      final refCarts = FirebaseFirestore.instance.collection('cart');
      final cartSnapshot = await refCarts
          .where('DishID', whereIn: checkedDishIDs)
          .where('UserID', isEqualTo: user?.uid)
          .get();
      if (cartSnapshot.docs.isNotEmpty) {
        for (final doc in cartSnapshot.docs) {
          await doc.reference.delete();
        }
      }
    }
  }

  Future<void> saveOrderDetails(String? orderId) async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      final orderDetailsRef =
          await FirebaseFirestore.instance.collection('order_details');
      for (var item in getAllCheckedItems.value!) {
        OrderDetailsModel orderDetails = OrderDetailsModel();
        orderDetails.DishID = item.dishID;
        orderDetails.OrderID = orderId;
        orderDetails.Amount = item.quantity;
        orderDetails.Price = item.total / item.quantity;
        await orderDetailsRef.add(orderDetails.toMap());
      }
    }
  }

  Future<void> saveOrder(BuildContext context) async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      CustomSnackBar.showCustomSnackBar(context, "Đang thực hiện...", 3);
      final orderRef = await FirebaseFirestore.instance.collection('orders');
      OrderModel order = OrderModel();
      order.UserID = user?.uid;
      order.VoucherID = voucherID.value;
      order.DeliveryAddress = getaddress.value;
      order.OrderDate = DateTime.now();

      order.PaymentMethod = selectedPaymentMethod.value;

      order.PaymentStatus = false;
      order.Total = finalTotal.value;
      order.Amount = getAllCheckedItems.value!.length;
      order.OrderStatus = "Chưa xác nhận";
      final afterAdding = await orderRef.add(order.toMap());

      await saveOrderDetails(afterAdding.id).then((value) {
        CustomSnackBar.showCustomSnackBar(context, "Đã đặt hàng ☑", 1);
      }).whenComplete(() async {
        await deleteOrderedDishes();
      });
      ;
    }
  }
}
