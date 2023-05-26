import 'package:app_food_2023/widgets/order_manament/assigned_to_deliver.dart';
import 'package:app_food_2023/widgets/order_manament/delivered.dart';
import 'package:app_food_2023/widgets/order_manament/on_delivery.dart';

import 'package:flutter/material.dart';

import '../../../widgets/order_manament/unconfirm_orders.dart';

class ListOrderPage extends StatefulWidget {
  const ListOrderPage({Key? key}) : super(key: key);

  @override
  _ListOrderPageState createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                    "",
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
          // Tab chưa xác nhận
          UnconfirmedTab(),
          // Tab đã giao cho shipper
          AssignedToDeliver(),
          //Tab các đơn hàng đang giao
          OnDelivery(),
          //Tab các đơn đã giao
          Delivered(),
        ],
      ),
    );
  }
}
