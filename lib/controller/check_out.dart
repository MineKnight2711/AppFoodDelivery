import 'package:app_food_2023/model/cart_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutController extends GetxController {
  Rx<Set<CartItem>?> setofcheckeditem = Rx<Set<CartItem>?>(null);

  CheckOutController(Set<CartItem> setofcheckeditem) {
    this.setofcheckeditem.value = setofcheckeditem;
  }

  Rx<String?> getaddress = Rx<String?>('');
  Rx<CartItem?> buycheckitem = Rx<CartItem?>(null);
  @override
  void onInit() {
    super.onInit();
    getLocation();
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

  // Future<void> _getCheckedItem() async {
  //   getaddress.value = location;
  // }
}
