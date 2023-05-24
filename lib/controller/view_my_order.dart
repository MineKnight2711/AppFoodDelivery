import 'package:app_food_2023/controller/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<List<QueryDocumentSnapshot>> loadOrders() async {
    final orderRef = await FirebaseFirestore.instance.collection('orders');

    final orderSnapshot = await orderRef
        .where('UserID', isEqualTo: user?.uid)
        .orderBy('OrderDate')
        .orderBy('Total', descending: false)
        .get();
    return orderSnapshot.docs;
  }
}

class OrderDetailsBottomSheet extends StatelessWidget {
  const OrderDetailsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.91,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Bottom Sheet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Center(
              child: Text(
                'This is the content of my bottom sheet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
