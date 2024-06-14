import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/voucher_model.dart';

class VoucherController extends GetxController {
  var voucherList = <Voucher>[].obs;
  var filteredVoucherList = <Voucher>[].obs;

  var isValidVoucherCode = false.obs;
  var isValidPrice = false.obs;
  var isValidContent = false.obs;

  var isValidUpdateVoucherCode = true.obs;
  var isValidUpdatePrice = true.obs;
  var isValidUpdateContent = true.obs;

  DateTime? date;
  DateTime? updateDate;
  @override
  void onInit() {
    super.onInit();
    getAllVoucher();
  }

  TextEditingController searchCotroller = TextEditingController();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final contentController = TextEditingController();

  final updateNameController = TextEditingController();
  final updatePriceController = TextEditingController();
  final updateContentController = TextEditingController();

  Future<void> onRefresh() async {
    await getAllVoucher();
  }

  Future<void> removeVoucher(String voucherId) async {
    await FirebaseFirestore.instance
        .collection('coupons')
        .doc(voucherId)
        .delete();
    getAllVoucher();
  }

  Future<void> addVoucher(Voucher voucher) async {
    await FirebaseFirestore.instance.collection('coupons').add(voucher.toMap());
    getAllVoucher();
  }

  Future<void> updateVoucher(Voucher voucher) async {
    await FirebaseFirestore.instance
        .collection('coupons')
        .doc(voucher.id)
        .update(voucher.toMap());
    getAllVoucher();
  }

  Future<void> getAllVoucher() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('coupons').get();
    final vouchers = querySnapshot.docs
        .map((document) => Voucher.fromSnapshot(document))
        .toList();
    voucherList.value = vouchers;
    filteredVoucherList.value = vouchers;
  }

  String? searchVouchers(String? voucherCode) {
    if (voucherCode == null || voucherCode == '') {
      filteredVoucherList.value = voucherList;
      return null;
    }
    final filteredVouchers = voucherList
        .where((voucher) =>
            voucher.code.toLowerCase().contains(voucherCode.toLowerCase()))
        .toList();
    if (filteredVouchers.isEmpty) {
      return "Không tìm thấy!";
    }
    filteredVoucherList.value = filteredVouchers;
    return "Đã tìm thấy ${filteredVoucherList.value.length}!";
  }

  void resetInputAdd() {
    date = null;
    nameController.clear();
    priceController.clear();
    contentController.clear();
    isValidVoucherCode.value =
        isValidPrice.value = isValidContent.value = false;
  }

  void fetchInputEdit(Voucher voucher) {
    updateDate = voucher.expirationDate;
    updateNameController.text = voucher.code;
    updateContentController.text = voucher.description;
    updatePriceController.text = voucher.amount.toString();
    isValidUpdateVoucherCode.value =
        isValidUpdatePrice.value = isValidUpdateContent.value = true;
  }

  String? validateVoucherCode(String? code) {
    if (code == null || code.isEmpty) {
      isValidVoucherCode.value = false;
      return 'Mã voucher không được trống!';
    }

    isValidVoucherCode.value = true;
    return null;
  }

  String? validateContent(String? content) {
    if (content == null || content.isEmpty) {
      isValidContent.value = false;
      return 'Vui lòng nhập mô tả!';
    }

    isValidContent.value = true;
    return null;
  }

  String? validatePrice(String? price) {
    if (price == null || price.isEmpty) {
      isValidPrice.value = false;
      return 'Giá không được trống!';
    }
    final RegExp numberRegex = RegExp(r'^(?:0|[1-9]\d{0,5}|1000000)$');
    if (!numberRegex.hasMatch(price)) {
      return 'Mã giảm chỉ cho phép từ 0-1000000 VNĐ!';
    }
    isValidPrice.value = true;
    return null;
  }

  String? validateUpdateVoucherCode(String? code) {
    if (code == null || code.isEmpty) {
      isValidVoucherCode.value = false;
      return 'Mã voucher không được trống!';
    }

    isValidVoucherCode.value = true;
    return null;
  }

  String? validateUpdatePrice(String? price) {
    if (price == null || price.isEmpty) {
      isValidPrice.value = false;
      return 'Giá không được trống!';
    }
    final RegExp numberRegex = RegExp(r'^(?:0|[1-9]\d{0,5}|1000000)$');
    if (!numberRegex.hasMatch(price)) {
      return 'Mã giảm chỉ cho phép từ 0-1000000 VNĐ!';
    }
    isValidPrice.value = true;
    return null;
  }

  String? validateUpdateContent(String? content) {
    if (content == null || content.isEmpty) {
      isValidContent.value = false;
      return 'Vui lòng nhập mô tả!';
    }
    isValidContent.value = true;
    return null;
  }
}
