import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/customercontrollers/check_out.dart';

class CouponsListCustomer extends StatelessWidget {
  final controller = Get.find<CheckOutController>();

  @override
  Widget build(BuildContext context) {
    controller.loadDishes();
    return Scaffold(
        appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          title: 'Danh sách voucher',
        ),
        body: Obx(() {
          if (controller.getAllCheckedItems.value != null) {
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('coupons').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong!'));
                }
                final coupons = snapshot.data!.docs;
                if (coupons.isEmpty) {
                  return Center(child: Text('No coupons found!'));
                }
                return ListView.builder(
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = coupons[index];
                    final code = coupon['code'];
                    final description = coupon['description'];
                    final amount = coupon['amount'];
                    final isPercent = coupon['isPercent'];

                    return Card(
                      child: ListTile(
                        title: Text('Code: $code'),
                        subtitle: Text(
                            'Description: $description\nAmount: ${isPercent ? '$amount%' : '\n$amount vnđ'}'),
                        onTap: () async {
                          // Chuyển sang màn hình view khác và truyền giá trị amount

                          await controller.passVocherValue(amount, coupon.id);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: Text('Có lỗi xảy ra :(('),
          );
        }));
  }
}
