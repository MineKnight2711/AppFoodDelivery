import 'package:app_food_2023/controller/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../appstyle/screensize_aspectratio/mediaquery.dart';
import '../../../controller/order.dart';

import '../../../controller/order_details.dart';
import '../../../widgets/order_manament/order_details.dart';
import 'list_orders.dart';
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
                List<Map<String, dynamic>> deliveryPersons = [];
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('Role', isEqualTo: 'Delivery')
                    .get();

                querySnapshot.docs.forEach((doc) {
                  Map<String, dynamic> deliveryPerson = {
                    'avatar': doc['Avatar'],
                    'fullName': doc['LastName'] + ' ' + doc['FirstName'],
                    'phoneNumber': doc['PhoneNumber'],
                    'isSelected': false, // Thêm trạng thái cho nhân viên
                  };
                  deliveryPersons.add(deliveryPerson);
                });

                Map<String, dynamic> selectedDeliveryPerson =
                    {}; // Biến để lưu trữ thông tin của nhân viên giao hàng được chọn

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          title: Text(
                            'DATFOOD | SELECT DELIVERY',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (Map<String, dynamic> deliveryPerson
                                  in deliveryPersons)
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(deliveryPerson['avatar']),
                                  ),
                                  title: Text(deliveryPerson['fullName']),
                                  subtitle: Text(deliveryPerson['phoneNumber']),
                                  trailing: deliveryPerson['isSelected']
                                      ? Icon(Icons.check_box,
                                          color: Colors.green)
                                      : null, // Hiển thị biểu tượng tick nếu nhân viên đó được chọn
                                  onTap: () {
                                    setState(() {
                                      // Cập nhật trạng thái của nhân viên được chọn và bỏ chọn các nhân viên khác
                                      deliveryPersons.forEach((person) {
                                        person['isSelected'] = false;
                                      });
                                      deliveryPerson['isSelected'] = true;
                                      selectedDeliveryPerson = deliveryPerson;
                                    });
                                  },
                                ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                if (selectedDeliveryPerson.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'DATFOOD | NOTIFICATION',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        actions: [
                                          Text(
                                            'Vui lòng chọn nhân viên giao hàng...',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                            textAlign: TextAlign
                                                .center, // Căn giữa Text
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Đóng'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // Thông báo khi đã chọn nhân viên giao hàng
                                  controller.showLoadingDialog(context);

                                  Future.delayed(Duration(seconds: 1), () {
                                    // Đóng tất cả các popup đang hiển thị
                                    Navigator.of(context).popUntil((route) =>
                                        route.isFirst); // Đóng tất cả các popup

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ListOrderPage()),
                                      (Route<dynamic> route) => false,
                                    );

                                    // Hiển thị popup success
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Container(
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 50,
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  'Thành công!',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Đóng popup success và quay lại trang ListOrder
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                              },
                                              child: Text(
                                                'Done',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  });
                                }
                              },
                              child: Text('Chọn nhân viên'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Đóng'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 46, 46),
                                ),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: Text('SELECT DELIVERY'),
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
