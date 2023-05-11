import 'package:app_food_2023/screens/admin/coupon_manager/add_coupon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CouponsListPage extends StatelessWidget {
  const CouponsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupons List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
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
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Handle edit coupon action
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCouponPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
