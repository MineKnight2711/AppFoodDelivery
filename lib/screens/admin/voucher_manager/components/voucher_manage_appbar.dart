import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/admincontrollers/voucher_controller.dart';
import '../../../../widgets/custom_widgets/custom_input_textbox.dart';

class VoucherManageAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  VoucherManageAppbar({super.key});
  final controller = Get.find<VoucherController>();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Quản lý voucher',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     const Text('Xếp theo'),
        //     PopupMenuButton<SortBy>(
        //       icon: Image.asset(
        //         'assets/icon/menu_icon.png',
        //         color: Colors.black,
        //         scale: 4,
        //       ),
        //       onSelected: (SortBy value) {
        //         setState(() {
        //           _sortBy = value;
        //           // sortDishes();
        //         });
        //       },
        //       itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
        //         const PopupMenuItem<SortBy>(
        //           value: SortBy.priceLowToHigh,
        //           child: Text('Giá: Thấp đến cao'),
        //         ),
        //         const PopupMenuItem<SortBy>(
        //           value: SortBy.priceHighToLow,
        //           child: Text('Giá: Cao đến thấp'),
        //         ),
        //       ],
        //     )
        //   ],
        // ),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CustomInputTextField(
            prefixIcon: Icon(Icons.search),
            controller: controller.searchCotroller,
            onChanged: controller.searchVouchers,
            labelText: 'Tìm voucher',
            hintText: 'Nhập mã voucher...',
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2);
}
