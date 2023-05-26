import 'package:app_food_2023/controller/customercontrollers/cart.dart';
import 'package:app_food_2023/controller/delivercontrollers/list_order_controller.dart';
import 'package:app_food_2023/controller/delivercontrollers/order_details_controller.dart';
import 'package:app_food_2023/widgets/deliver/delivery_order_details_list_dish.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../appstyle/screensize_aspectratio/mediaquery.dart';
import '../../../admin/order_manager/order_class.dart';

class DeliverOrderDetailsScreen extends StatelessWidget {
  final OrderData orderData;

  DeliverOrderDetailsScreen({required this.orderData});
  final controller = Get.find<DeliveryOrderDetailsController>();
  @override
  Widget build(BuildContext context) {
    // controller.getOrderDetails();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Thông Tin Đơn Hàng",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.delete<DeliveryOrderDetailsController>();
            Get.put(DeliveryOrdersController());
            Navigator.pop(context);

            // controller.dispose();
            // controller.disposeData();
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24.0,
            color: Colors.black,
          ),
        ),
        actions: [
          SizedBox(
            child: Stack(
              children: [
                Positioned(
                  top: 15,
                  right: 17,
                  child: Icon(
                    CupertinoIcons.cart,
                    size: 25.0,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 17,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${controller.orderdetails.value?.length}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            width: 40.0,
          ),
        ],
      ),
      body: Container(
        height: MediaHeight(context, 1),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              'Danh sách sản phẩm:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            //-------------------------------------------------------------------------------------
            // OrderDetailsInfor(),
            Container(
                width: MediaQuery.of(context).size.width - 10,
                height: 450,
                child: DeliveryOrderDetailsDishes()),
            const SizedBox(
              height: 10,
            ),
            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tổng tiền:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '${formatCurrency(orderData.total)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              'Ngày đặt hàng: ${orderData.orderDate}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Tên khách hàng: ${orderData.userName}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Địa chỉ giao hàng: ${orderData.deliveryAddress}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                controller.selectOrder(context);
              },
              child: Text('Nhận đơn hàng'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(400, 50)),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
