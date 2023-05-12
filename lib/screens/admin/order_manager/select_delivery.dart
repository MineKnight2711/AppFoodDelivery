import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách món ăn đã đặt'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Lắng nghe thay đổi dữ liệu từ Firebase Firestore
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Có lỗi xảy ra: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Dữ liệu đã lấy về từ Firebase Firestore
          final orders = snapshot.data!.docs;

          // Hiển thị danh sách các món ăn
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              // Lấy danh sách các món ăn đã đặt từ bảng order_details
              final items = order.reference.collection('order_details').get();

              return Card(
                child: ListTile(
                  title: Text('Đơn hàng: ${order['OrderID']}'),
                  subtitle: FutureBuilder<QuerySnapshot>(
                    // Lắng nghe thay đổi dữ liệu từ Firebase Firestore
                    future: items,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Có lỗi xảy ra: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      // Dữ liệu đã lấy về từ Firebase Firestore
                      final docs = snapshot.data!.docs;

                      // Hiển thị danh sách các món ăn
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          return Text(doc['item_name']);
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
