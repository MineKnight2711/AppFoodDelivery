import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? UserID;
  String? DeliverID;
  String? VoucherID;
  bool? PaymentStatus;
  String? OrderStatus;
  DateTime? OrderDate;
  double? Total;
  int? Amount;
  String? PaymentMethod;
  String? DeliveryAddress;

  OrderModel({
    this.UserID,
    this.DeliverID,
    this.VoucherID,
    this.PaymentStatus = false,
    this.OrderStatus,
    this.OrderDate,
    this.Total,
    this.Amount,
    this.PaymentMethod,
    this.DeliveryAddress,
  });

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      VoucherID: data['VoucherID'],
      // PaymentStatus: data['PaymentStatus'],
      OrderStatus: data['OrderStatus'],
      // OrderDate: data['OrderDate'],
      Total: data['Total'],
      // Amount: data['Amount'],
      // PaymentMethod: data['PaymentMethod'],
      // DeliveryAddress: data['DeliveryAddress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'UserID': UserID,
      'DeliverID': DeliverID,
      'VoucherID': VoucherID,
      'PaymentStatus': PaymentStatus,
      'OrderStatus': OrderStatus,
      'OrderDate': OrderDate,
      'Total': Total,
      'Amount': Amount,
      'PaymentMethod': PaymentMethod,
      'DeliveryAddress': DeliveryAddress,
    };
  }
}
