import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:app_food_2023/screens/admin/order_manager/order_class.dart';

class OrderController extends GetxController {
  Rx<List<DocumentSnapshot>?> unconfirmedOrders =
      Rx<List<DocumentSnapshot>?>(null);
  Rx<List<DocumentSnapshot>?> assignToDeliverOrders =
      Rx<List<DocumentSnapshot>?>(null);
  Rx<List<DocumentSnapshot>?> onDeliveryOrders =
      Rx<List<DocumentSnapshot>?>(null);
  Rx<List<DocumentSnapshot>?> deliveredOrders =
      Rx<List<DocumentSnapshot>?>(null);

  Future<String> getUserName(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return '${userSnapshot['LastName']} ${userSnapshot['FirstName']} - ${userSnapshot['PhoneNumber']} ';
  }

  disposeData() {
    unconfirmedOrders.value = assignToDeliverOrders.value =
        onDeliveryOrders.value = deliveredOrders.value = null;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getunconfirmedOrders() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('OrderStatus', isEqualTo: 'Chưa xác nhận')
        .orderBy('OrderDate', descending: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      unconfirmedOrders.value = querySnapshot.docs;
    }
  }

  void assignedToDeliverQuery() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('OrderStatus', isEqualTo: 'Đã giao cho Delivery')
        .orderBy('OrderDate', descending: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      assignToDeliverOrders.value = querySnapshot.docs;
    }
  }

  void onDeliveryQuery() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('OrderStatus', isEqualTo: 'Đang giao')
        .orderBy('OrderDate', descending: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      onDeliveryOrders.value = querySnapshot.docs;
    }
  }

  void deliveredQuery() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('OrderStatus', isEqualTo: 'Đã giao')
        .orderBy('OrderDate', descending: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      deliveredOrders.value = querySnapshot.docs;
    }
  }

  Future<String> formattedOrderDate(DocumentSnapshot orderDoc) async {
    DateTime orderDate = orderDoc['OrderDate'].toDate();

    String amPm = orderDate.hour < 12 ? "AM" : "PM  ";
    // int hour =
    //     orderDate.hour < 12 ? orderDate.hour : orderDate.hour - 12;
    return DateFormat("dd-MM-yyyy 'lúc' h:mm '$amPm' ", 'vi_VN')
        .format(orderDate);
  }

  Future<OrderData> getOrderData(DocumentSnapshot orderDoc) async {
    String date = await formattedOrderDate(orderDoc);
    String userName = await getUserName(orderDoc['UserID']);
    return OrderData(
      orderId: orderDoc.id,
      orderDate: date,
      userName: userName,
      total: orderDoc['Total'],
      deliveryAddress: orderDoc['DeliveryAddress'],
    );
  }
}
