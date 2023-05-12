import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/model/UserModel.dart';
import 'package:get/get.dart';

class EditCustomerController extends GetxController {
  Rx<UserModel?> currentCustomer = Rx<UserModel?>(null);
  @override
  void onInit() {
    super.onInit();
    fetchCurrentCustomer();
  }

  @override
  void onClose() {
    super.onClose();
    currentCustomer.value = null;
  }

  @override
  void dispose() {
    super.dispose();
    currentCustomer.value = null;
  }

  Future<void> fetchCurrentCustomer() async {
    await getCurrentUser();
    await convertToUserModel();
    currentCustomer.value = loggedInUser;
  }
}
