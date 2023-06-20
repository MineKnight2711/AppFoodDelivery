import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../screens/admin/order_manager/order_class.dart';

class DeliveryOrdersController extends GetxController {
  Rx<List<DocumentSnapshot>?> assignToDeliverOrders =
      Rx<List<DocumentSnapshot>?>(null);
  Rx<List<DocumentSnapshot>?> onDeliveryOrders =
      Rx<List<DocumentSnapshot>?>(null);
  Rx<List<DocumentSnapshot>?> successDeliveryOrders =
      Rx<List<DocumentSnapshot>?>(null);
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

  Future<String> formattedOrderDate(DocumentSnapshot orderDoc) async {
    DateTime orderDate = orderDoc['OrderDate'].toDate();

    String amPm = orderDate.hour < 12 ? "AM" : "PM  ";
    // int hour =
    //     orderDate.hour < 12 ? orderDate.hour : orderDate.hour - 12;
    return DateFormat("dd-MM-yyyy 'lúc' h:mm '$amPm' ", 'vi_VN')
        .format(orderDate);
  }

  Future<String> getCustomerName(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return '${userSnapshot['LastName']} ${userSnapshot['FirstName']} - ${userSnapshot['PhoneNumber']} ';
  }

  Future<OrderData> getOrderData(DocumentSnapshot orderDoc) async {
    String date = await formattedOrderDate(orderDoc);
    String userName = await getCustomerName(orderDoc['UserID']);
    return OrderData(
      orderId: orderDoc.id,
      orderDate: date,
      userName: userName,
      total: orderDoc['Total'],
      deliveryAddress: orderDoc['DeliveryAddress'],
    );
  }

  Future<void> assignedToDeliverQuery() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('OrderStatus', isEqualTo: 'Đã giao cho Delivery')
        .orderBy('OrderDate', descending: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      assignToDeliverOrders.value = querySnapshot.docs;
    }
  }

  Future<void> successDeliverQuery() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('OrderStatus', isEqualTo: 'Đã giao')
        .orderBy('OrderDate', descending: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      successDeliveryOrders.value = querySnapshot.docs;
    }
  }

  Future<void> onDeliveryQuery() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('OrderStatus', isEqualTo: 'Đang giao')
        .orderBy('OrderDate', descending: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      onDeliveryOrders.value = querySnapshot.docs;
    }
  }
}
