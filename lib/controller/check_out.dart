import 'package:app_food_2023/model/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/dishes_model.dart';
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

  Future<void> passVocherValue(double? value) async {
    vouchervalue.value = value ?? 0.0;
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
  // Future<void> _getCheckedItem() async {
  //   getaddress.value = location;
  // }
}
