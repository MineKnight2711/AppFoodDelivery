import 'package:app_food_2023/controller/customercontrollers/view_my_order.dart';
import 'package:app_food_2023/controller/user.dart' as u;
import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/customercontrollers/cart.dart';
import '../../../widgets/customer/customer_orderdetails.dart';

//enum theo sau là một tập hợp các giá trị hằng số được đặt trong dấu ngoặc nhọn {}
enum SortByPrice { highToLow, lowToHigh }

enum SortByOrderStatus {
  order_status_unconfirmed,
  order_status_in_progress,
  order_status_completed,
  order_status_canceled
}

class OrdersScreen extends StatefulWidget {
  OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ordercontroller = Get.find<MyOrderController>();
  SortByPrice? _sortByPriceController = null;
  SortByOrderStatus? _sortByOrderStatusController = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.of(context).pop();
        },
        title: 'Đơn hàng của tôi',
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Xếp theo'),
              PopupMenuButton(
                icon: Image.asset(
                  'assets/icon/menu_icon.png',
                  color: Colors.black,
                  scale: 4,
                ),
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: PopupMenuButton<SortByPrice>(
                      child: Text('Xếp theo giá'),
                      onSelected: (sortByPrice) {
                        setState(() {
                          _sortByPriceController = sortByPrice;
                        });
                      },
                      itemBuilder: (context) => <PopupMenuEntry<SortByPrice>>[
                        PopupMenuItem<SortByPrice>(
                          value: SortByPrice.lowToHigh,
                          child: Text('Giá: Thấp đến cao'),
                        ),
                        PopupMenuItem<SortByPrice>(
                          value: SortByPrice.highToLow,
                          child: Text('Giá: Cao đến thấp'),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    child: PopupMenuButton<SortByOrderStatus>(
                      child: Text('Xếp theo tình trạng đơn'),
                      onSelected: (sortByOrderStatus) {
                        setState(() {
                          _sortByOrderStatusController = sortByOrderStatus;
                        });
                      },
                      itemBuilder: (context) =>
                          <PopupMenuEntry<SortByOrderStatus>>[
                        PopupMenuItem<SortByOrderStatus>(
                          value: SortByOrderStatus.order_status_unconfirmed,
                          child: Text('Chưa xác nhận'),
                        ),
                        PopupMenuItem<SortByOrderStatus>(
                          value: SortByOrderStatus.order_status_in_progress,
                          child: Text('Đang giao'),
                        ),
                        PopupMenuItem<SortByOrderStatus>(
                          value: SortByOrderStatus.order_status_completed,
                          child: Text('Đã giao'),
                        ),
                        PopupMenuItem<SortByOrderStatus>(
                          value: SortByOrderStatus.order_status_canceled,
                          child: Text('Đã huỷ'),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    child: Text('Tất cả đơn hàng'),
                    onTap: () {
                      setState(() {
                        _sortByPriceController =
                            _sortByOrderStatusController = null;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                ordercontroller.loadOrderDetails(order.id);
                return ListTile(
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            Image.asset('assets/images/burger.png').image,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Đơn hàng :${order.id}'),
                    ],
                  ),
                  subtitle: Container(
                    height: 55,
                    child: Row(
                      children: [
                        Text('Tổng tiền: ${formatCurrency(order['Total'])}'),
                        Spacer(),
                        Text(order['OrderStatus']),
                      ],
                    ),
                  ),
                  onTap: () async {
                    // Navigate to order details screen

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return OrderDetailsBottomSheet(
                          doc: order,
                        );
                      },
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: Text('Không tìm thấy dơn hàng!'),
          );
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> loadOrders() async {
    final orderRef = await FirebaseFirestore.instance.collection('orders');

    Query query = orderRef.where('UserID', isEqualTo: u.user?.uid);
    if (_sortByPriceController != null) {
      switch (_sortByPriceController) {
        case SortByPrice.highToLow:
          query = query.orderBy('Total', descending: true);
          break;
        case SortByPrice.lowToHigh:
          query = query.orderBy('Total', descending: false);
          break;
        case null:
          break;
      }
    }
    if (_sortByOrderStatusController != null) {
      switch (_sortByOrderStatusController) {
        case SortByOrderStatus.order_status_unconfirmed:
          query = query.where('OrderStatus', isEqualTo: 'Chưa xác nhận');
          break;
        case SortByOrderStatus.order_status_in_progress:
          query = query.where('OrderStatus', isEqualTo: 'Đang giao');
          break;
        case SortByOrderStatus.order_status_completed:
          query = query.where('OrderStatus', isEqualTo: 'Đã giao');
          break;
        case SortByOrderStatus.order_status_canceled:
          query = query.where('OrderStatus', isEqualTo: 'Đã huỷ');
          break;
        case null:
          break;
      }
    } else if (_sortByPriceController == null ||
        _sortByOrderStatusController == null) {
      final orderSnapshot = await query.get();
      return orderSnapshot.docs;
    }
    final orderSnapshot = await query.get();

    return orderSnapshot.docs;
  }
}
