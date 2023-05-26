import 'package:app_food_2023/controller/customercontrollers/cart.dart';
import 'package:app_food_2023/model/deliver_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../appstyle/screensize_aspectratio/mediaquery.dart';
import '../../../controller/admincontrollers/order.dart';

import '../../../controller/admincontrollers/order_details.dart';
import '../../../widgets/order_manament/order_details.dart';
import 'list_deliver.dart';

import 'order_class.dart';

class OrderListScreen extends StatelessWidget {
  final OrderData orderData;

  OrderListScreen({required this.orderData});
  final controller = Get.find<OrderDetailsController>();
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
            Get.delete<OrderDetailsController>();
            Get.put(OrderController());
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
          const SizedBox(
            width: 23.0,
          ),
          Stack(
            children: const [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  CupertinoIcons.cart,
                  size: 30.0,
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
                child: OrderDetailsInfor()),
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
                List<DeliverModel> deliveryPersons =
                    await controller.loadDeliver();

                // DeliverModel? selectedDeliveryPerson =
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeliveryPersonDialog(
                        deliveryPersons: deliveryPersons);
                  },
                );
              },
              child: Text('Chọn nhân viên giao hàng'),
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
