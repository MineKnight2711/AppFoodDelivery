import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../appstyle/screensize_aspectratio/mediaquery.dart';
import '../../../controller/admincontrollers/voucher_controller.dart';
import '../../../model/voucher_model.dart';
import '../../../widgets/custom_widgets/appbar.dart';
import '../../../widgets/custom_widgets/custom_button.dart';
import '../../../widgets/custom_widgets/custom_input_textbox.dart';
import '../../../widgets/custom_widgets/message.dart';
import 'components/voucher_date_picker.dart';

class EditVoucher extends StatelessWidget {
  final Voucher updateVoucher;
  EditVoucher({Key? key, required this.updateVoucher}) : super(key: key);
  final controller = Get.find<VoucherController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            controller.fetchInputEdit(updateVoucher);
            Navigator.pop(context);
          },
          title: "Thêm mới voucher"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VoucherDatePickerWidget(
              initialDate: controller.updateDate,
              onChanged: (value) {
                controller.updateDate = value;
              },
            ),
            const SizedBox(height: 16.0),
            CustomInputTextField(
              controller: controller.updateNameController,
              labelText: 'Mã voucher',
              hintText: 'Nhập mã voucher...',
              onChanged: controller.validateUpdateVoucherCode,
            ),
            const SizedBox(height: 16.0),
            CustomInputTextField(
              controller: controller.updatePriceController,
              labelText: 'Số tiền giảm',
              hintText: 'Nhập số tiền...',
              onChanged: controller.validateUpdatePrice,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            CustomInputTextField(
              controller: controller.updateContentController,
              labelText: 'Chi tiết',
              hintText: 'Nhập mô tả...',
              onChanged: controller.validateUpdateContent,
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: MediaWidth(context, 1.5),
              height: MediaHeight(context, 18),
              child: Obx(
                () => CustomButton(
                  enabled: controller.isValidUpdateVoucherCode.value &&
                      controller.isValidUpdateContent.value &&
                      controller.isValidUpdatePrice.value,
                  text: 'Lưu',
                  press: () async {
                    Voucher voucher = Voucher(
                        id: updateVoucher.id,
                        amount:
                            double.parse(controller.updatePriceController.text),
                        code: controller.updateNameController.text,
                        description: controller.updateContentController.text,
                        expirationDate: controller.updateDate ??
                            updateVoucher.expirationDate,
                        isPercent: false);
                    await controller.updateVoucher(voucher).whenComplete(() {
                      controller.fetchInputEdit(voucher);
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
