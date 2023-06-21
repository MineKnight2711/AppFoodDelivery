import 'package:app_food_2023/controller/admincontrollers/voucher_controller.dart';
import 'package:app_food_2023/screens/admin/voucher_manager/add_voucher.dart';

import 'package:app_food_2023/screens/admin/voucher_manager/components/voucher_manage_appbar.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/voucher_manager_listview.dart';

class VoucherListScreen extends StatelessWidget {
  final controller = Get.find<VoucherController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoucherManageAppbar(),
      body: RefreshIndicator(
          onRefresh: controller.onRefresh, child: VoucherListView()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          slideinTransition(context, AddVoucher());
        },
        label: Text("Thêm voucher"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
