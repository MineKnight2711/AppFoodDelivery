import 'package:app_food_2023/model/cart_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/dishes_model.dart';
import '../../model/order_details_model.dart';
import '../../model/order_model.dart';
import '../../screens/customer/payment_method.dart';
import '../../screens/home_screen.dart';
import '../../widgets/customer/check_out/order_sucess.dart';
import '../../widgets/custom_widgets/message.dart';
import '../../widgets/custom_widgets/transitions_animations.dart';
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
  Rx<int> totalQuantity = Rx<int>(0);
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

      //Chia nhỏ các id trong getAllCheckedItems ra để query dể tránh giới hạn query của Firebase
      List<List<String?>> idChunks = [];
      for (int i = 0; i < checkedDishIDs.length; i += 10) {
        idChunks.add(checkedDishIDs.sublist(i,
            i + 10 < checkedDishIDs.length ? i + 10 : checkedDishIDs.length));
      }

      List<DishModel> dishes = [];
      for (List<String?> idChunk in idChunks) {
        QuerySnapshot dishSnapshot =
            await refDishes.where(FieldPath.documentId, whereIn: idChunk).get();
        List<DishModel> chunkDishes = dishSnapshot.docs
            .map((doc) => DishModel.fromSnapshot(doc))
            .toList();
        dishes.addAll(chunkDishes);
      }

      await caculteFinalTotal();
      return dishes;
    }
    return Future.value(null);
  }

  Future<void> caculteFinalTotal() async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      initialTotal.value = getAllCheckedItems.value!.fold(
        0.0,
        (previousValue, item) => previousValue != null
            ? previousValue + (item.total * item.quantity).toDouble()
            : (item.total * item.quantity).toDouble(),
      );
      totalQuantity.value = getAllCheckedItems.value!.fold(
        0,
        (previousValue, item) => previousValue + item.quantity,
      );
      double total = initialTotal.value ?? 0.0;
      double voucher = vouchervalue.value ?? 0.0;
      finalTotal.value = total - voucher;
    }
  }

  Future<void> showPaymentDialog(BuildContext context) async {
    final selectedMethod = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PaymentDialog(),
    );

    selectedPaymentMethod.value = selectedMethod;
  }

  Future<bool> checkQuantity(BuildContext context) async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      List<String?> checkedDishIDs =
          getAllCheckedItems.value!.map((item) => item.dishID).toList();

      final refDishes = FirebaseFirestore.instance.collection('dishes');
      List<List<String?>> idChunks = [];
      for (int i = 0; i < checkedDishIDs.length; i += 10) {
        idChunks.add(checkedDishIDs.sublist(i,
            i + 10 < checkedDishIDs.length ? i + 10 : checkedDishIDs.length));
      }

      List<DishModel> checkDishes = [];
      for (final chunk in idChunks) {
        final dishSnapshot =
            await refDishes.where(FieldPath.documentId, whereIn: chunk).get();

        if (dishSnapshot.docs.isNotEmpty) {
          for (final doc in dishSnapshot.docs) {
            final dish = DishModel.fromSnapshot(doc);

            final checkedItem = getAllCheckedItems.value!
                .firstWhere((item) => item.dishID == doc.id);
            if (dish.Quantity != null) {
              if (dish.Quantity! < checkedItem.quantity) {
                checkDishes.add(dish);
              }
            }
          }
        }

        if (checkDishes.isNotEmpty) {
          await showInsufficientQuantityPopup(context, checkDishes);
          return false;
        }
      }
    }
    return true;
  }

  Future<void> showInsufficientQuantityPopup(
      BuildContext context, List<DishModel>? dishes) async {
    await showDialog(
      context: context,
      builder: (context) => showInsufficientQuantityWidget(
        context,
        dishes,
      ),
    );
  }

  Future<void> decreaseDishesQuantity() async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      List<String?> checkedDishIDs =
          getAllCheckedItems.value!.map((item) => item.dishID).toList();

      final refDishes = FirebaseFirestore.instance.collection('dishes');
      List<List<String?>> idChunks = [];
      for (int i = 0; i < checkedDishIDs.length; i += 10) {
        idChunks.add(checkedDishIDs.sublist(i,
            i + 10 < checkedDishIDs.length ? i + 10 : checkedDishIDs.length));
      }

      for (final chunk in idChunks) {
        final cartSnapshot =
            await refDishes.where(FieldPath.documentId, whereIn: chunk).get();

        if (cartSnapshot.docs.isNotEmpty) {
          for (final doc in cartSnapshot.docs) {
            final quantity = getAllCheckedItems.value!
                .firstWhere((item) => item.dishID == doc.id)
                .quantity;
            doc.reference.update({'InStock': FieldValue.increment(-quantity)});
          }
        }
      }
    }
  }

  Future<void> deleteOrderedDishes() async {
    if (getAllCheckedItems.value != null && checkedItems.isNotEmpty) {
      List<String?> checkedDishIDs =
          getAllCheckedItems.value!.map((item) => item.dishID).toList();

      final refCarts = FirebaseFirestore.instance.collection('cart');

      // Chia checkedDishIDs thành 10 mảnh để query
      List<List<String?>> idChunks = [];
      for (int i = 0; i < checkedDishIDs.length; i += 10) {
        idChunks.add(checkedDishIDs.sublist(i,
            i + 10 < checkedDishIDs.length ? i + 10 : checkedDishIDs.length));
      }

      //Query và xoá các món có trong giỏ hàng khi đã đặt hàng
      for (final chunk in idChunks) {
        final cartsToDelete = await refCarts
            .where('DishID', whereIn: chunk)
            .where('UserID', isEqualTo: user?.uid)
            .get();

        if (cartsToDelete.docs.isNotEmpty) {
          for (final doc in cartsToDelete.docs) {
            await doc.reference.delete();
          }
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
      CustomSnackBar.showCustomSnackBar(context, "Đang kiểm tra...", 3);
      bool resultQuantity = await checkQuantity(context);

      if (!resultQuantity) {
        isLoading.value = false;
        return;
      }
      if (getaddress.value == null) {
        isLoading.value = false;
        CustomSnackBar.showCustomSnackBar(
            context, "Bạn chưa chọn địa chỉ...", 2,
            backgroundColor: Colors.red);
        return;
      }
      final orderRef = await FirebaseFirestore.instance.collection('orders');
      OrderModel order = OrderModel();
      order.UserID = user?.uid;
      order.VoucherID = voucherID.value;
      order.DeliveryAddress = getaddress.value;
      order.OrderDate = DateTime.now();
      order.DeliverID = "";
      order.PaymentMethod = selectedPaymentMethod.value;

      order.PaymentStatus = false;
      order.Total = finalTotal.value;
      order.Amount = getAllCheckedItems.value!.length;
      order.OrderStatus = "Chưa xác nhận";
      final afterAdding = await orderRef.add(order.toMap());

      await saveOrderDetails(afterAdding.id).then((value) async {
        CustomSnackBar.showCustomSnackBar(
            context, 'Đang kiểm tra số lượng..', 1);
        await decreaseDishesQuantity();
      }).whenComplete(() async {
        await deleteOrderedDishes();
        isLoading.value = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return OrderSuccessDialogWidget();
          },
        );
      });
    }
  }
}

class OrderSuccessDialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        slideinTransitionNoBack(context, AppHomeScreen());
        Get.delete<CheckOutController>();
        Get.put(CheckOutController(checkedItems));
        return false;
      },
      child: OrderSuccesDialog(
        imagePath: 'assets/images/icon-succes-transaction.png',
        buttonText: 'OK',
        message: 'Đơn hàng đã được đặt thành công!',
        onButtonPressed: () {
          slideinTransitionNoBack(context, AppHomeScreen());
          Get.delete<CheckOutController>();
          Get.put(CheckOutController(checkedItems));
        },
      ),
    );
  }
}
