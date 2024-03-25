import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widgets/transitions_animations.dart';
import 'select_delivery.dart';

class ListOrderPage extends StatefulWidget {
  const ListOrderPage({Key? key}) : super(key: key);

  @override
  _ListOrderPageState createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<DocumentSnapshot> paidOrders = [];

  Future<String> getUserName(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return '${userSnapshot['LastName']} ${userSnapshot['FirstName']} - ${userSnapshot['PhoneNumber']} ';
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _getPaidOrders(); // gọi phương thức để lấy danh sách đơn hàng từ Firebase Firestore
  }

  void _getPaidOrders() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('Status', isEqualTo: 'Đợi xác nhận')
        .get();

    setState(() {
      paidOrders = querySnapshot.docs;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Đơn Hàng",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24.0,
            color: Colors.black,
          ),
        ),
        actions: [
          const SizedBox(
            width: 23.0,
          ),
          Stack(
            children: const [
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.notifications_outlined,
                  size: 30.0,
                  color: Colors.black,
                ),
              ),
              Positioned(
                top: 8,
                right: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    "2",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 23.0,
          ),
          const SizedBox(
            width: 23.0,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color.fromARGB(255, 0, 82, 164),
          isScrollable: true, //
          tabs: [
            Tab(text: 'Đợi xác nhận'),
            Tab(text: 'Giao cho Delivery'),
            Tab(text: 'Đang vận đơn'),
            Tab(text: 'Đã giao đơn hàng'),
          ],
          indicatorColor: Color.fromARGB(255, 21, 122, 223),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab Paid Out
          Center(
            child: ListView.builder(
              itemCount: paidOrders.length,
              itemBuilder: (context, index) {
                DocumentSnapshot order = paidOrders[index];
                DateTime orderDate = order['OrderDate'].toDate();
                String formattedDate =
                    DateFormat("dd 'tháng' M yyyy", 'vi_VN').format(orderDate);
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text('Bạn đã nhấn vào container'),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                slideinTransition(context, OrderListScreen());
                              },
                              child: Text('Đóng'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mã đơn hàng: ${order['OrderID']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Ngày đặt hàng: $formattedDate',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 8.0),
                        FutureBuilder(
                          future: getUserName(order['UserID']),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'Tên khách hàng: ${snapshot.data}',
                                style: TextStyle(fontSize: 14.0),
                              );
                            }
                            return Center(
                              child: LinearProgressIndicator(),
                            );
                          },
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Địa chỉ giao hàng: ${order['AddressShip']}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Tab Dispatched
          Center(child: Text('Giao cho Delivery')),
          // Tab On Way
          Center(child: Text('Đang vận đơn')),
          // Tab Delivery
          Center(child: Text('Đã giao đơn hàng')),
        ],
      ),
    );
  }
}
