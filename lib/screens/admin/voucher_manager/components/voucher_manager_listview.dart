import 'package:app_food_2023/screens/admin/voucher_manager/edit_voucher.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controller/admincontrollers/voucher_controller.dart';
import '../../../../controller/customercontrollers/cart.dart';

class VoucherListView extends StatelessWidget {
  VoucherListView({super.key});
  final controller = Get.find<VoucherController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.filteredVoucherList.length,
        itemBuilder: (context, index) {
          final voucher = controller.filteredVoucherList[index];
          return Dismissible(
            key: ValueKey(voucher.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              controller.removeVoucher(voucher.id.toString());
            },
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.endToStart) {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Xác nhận'),
                      content: Text('Bạn có muốn xóa voucher này?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            'Hủy',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await controller.removeVoucher(voucher.id ?? '');
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            'Xóa',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return false;
              }
            },
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                controller.fetchInputEdit(voucher);
                slideinTransition(context, EditVoucher(updateVoucher: voucher));
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                elevation: 3,
                shadowColor: Colors.amber,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 78, 75, 75)),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Mã voucher: ${voucher.code}',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text('${voucher.description}')),
                          ],
                        )
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Số tiền giảm: ${formatCurrency(voucher.amount)}'),
                        Text(
                            'Ngày hết hạn: ${formatDatetime(voucher.expirationDate)}'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String formatDatetime(DateTime datetime) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(datetime);
  }
}
