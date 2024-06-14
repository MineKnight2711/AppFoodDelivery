import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/controller/admincontrollers/voucher_controller.dart';
import 'package:app_food_2023/screens/admin/voucher_manager/components/voucher_date_picker.dart';
import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';
import 'package:app_food_2023/widgets/custom_widgets/custom_button.dart';
import 'package:app_food_2023/widgets/custom_widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/voucher_model.dart';
import '../../../widgets/custom_widgets/custom_input_textbox.dart';

class AddVoucher extends StatelessWidget {
  AddVoucher({Key? key}) : super(key: key);
  final controller = Get.find<VoucherController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            controller.resetInputAdd();
            Navigator.pop(context);
          },
          title: "Thêm mới voucher"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VoucherDatePickerWidget(
              initialDate: DateTime.now(),
              onChanged: (value) {
                controller.date = value;
              },
            ),
            const SizedBox(height: 16.0),
            CustomInputTextField(
              controller: controller.nameController,
              labelText: 'Mã voucher',
              hintText: 'Nhập mã voucher...',
              onChanged: controller.validateVoucherCode,
            ),
            const SizedBox(height: 16.0),
            CustomInputTextField(
              controller: controller.priceController,
              labelText: 'Số tiền giảm',
              hintText: 'Nhập số tiền...',
              onChanged: controller.validatePrice,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            CustomInputTextField(
              controller: controller.contentController,
              labelText: 'Chi tiết',
              hintText: 'Nhập mô tả...',
              onChanged: controller.validateContent,
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: MediaWidth(context, 1.5),
              height: MediaHeight(context, 18),
              child: Obx(
                () => CustomButton(
                  enabled: controller.isValidVoucherCode.value &&
                      controller.isValidContent.value &&
                      controller.isValidPrice.value,
                  text: 'Lưu',
                  press: () async {
                    Voucher voucher = Voucher(
                        amount: double.parse(controller.priceController.text),
                        code: controller.nameController.text,
                        description: controller.contentController.text,
                        expirationDate: controller.date ?? DateTime.now(),
                        isPercent: false);
                    await controller.addVoucher(voucher).whenComplete(() {
                      controller.resetInputAdd();
                      Navigator.pop(context);
                    }).catchError((e) {
                      CustomErrorMessage.showMessage('Có lỗi xảy ra $e');
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
